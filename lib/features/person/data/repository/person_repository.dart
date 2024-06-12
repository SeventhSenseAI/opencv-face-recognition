import 'dart:async';

import 'package:faceapp/core/services/baseurl_service.dart';
import 'package:intl/intl.dart';

import '../../../../core/networking/api_provider.dart';
import '../../../search/data/model/user.dart';

class PersonRepository {
  final apiProvider = ApiProvider(baseURL: BaseURLService().baseURL);

Future<List<Person>> getAllPersons(String id) async {
  apiProvider.baseURL = BaseURLService().baseURL;
    final response = await apiProvider.get('persons/$id?skip=0&take=50&order=DESC&order_by=name');
    List<Person> persons = response['persons'].map<Person>((person) => Person.fromJson(person)).toList();
    return persons;
  }

Future<List<Person>> getNextBatchPersons(String id) async {
  int mini = 50;
  int max = 100;
  List<Person> finalPerson = [];
  apiProvider.baseURL = BaseURLService().baseURL;
  while (true) {
    final response = await apiProvider.get('persons/$id?skip=$mini&take=$max&order=DESC&order_by=name');
    List<Person> persons = response['persons'].map<Person>((person) => Person.fromJson(person)).toList();
    finalPerson.addAll(persons);

    if (persons.length < 100) {
      break;
    }
    mini += max;
  }
  return finalPerson;
}



  Future<Person> getPerson(String id) async {
    apiProvider.baseURL = BaseURLService().baseURL;
    final response = await apiProvider.get('person/$id');
    return Person.fromJson(response);
  }

  Future<Map<String, dynamic>> createPerson(
    Person body,
    String? collectionID,
  ) async {
    apiProvider.baseURL = BaseURLService().baseURL;

    final List<String> images = [];
    for (Thumbnail thumbnail in body.thumbnails ?? []) {
      if (thumbnail.thumbnail != null) {
        images.add(thumbnail.thumbnail!);
      }
    }
    Map<String, dynamic> json = {
      if (collectionID != null) "collections": [collectionID],
      "date_of_birth": body.dateOfBirth != null
          ? DateFormat('yyyy-MM-dd').format(body.dateOfBirth!)
          : null,
      "images": images,
      "name": body.name,
      "nationality": body.nationality,
      "notes": body.notes,
    };
    return await apiProvider.post(
      'person',
      body: json,
    );
  }

  Future<Map<String, dynamic>> createCropPerson(
    Person body,
    String? collectionID,
  ) async {
    apiProvider.baseURL = BaseURLService().baseURL;

    final List<String> images = [];
    for (Thumbnail thumbnail in body.thumbnails ?? []) {
      if (thumbnail.thumbnail != null) {
        images.add(thumbnail.thumbnail!);
      }
    }
    Map<String, dynamic> json = {
      if (collectionID != null) "collections": [collectionID],
      "date_of_birth": body.dateOfBirth != null
          ? DateFormat('yyyy-MM-dd').format(body.dateOfBirth!)
          : null,
      "images": images,
      "name": body.name,
      "nationality": body.nationality,
      "notes": body.notes,
    };
    return await apiProvider.post(
      'person/crops',
      body: json,
    );
  }

  Future<Map<String, dynamic>> updatePersonImage(
    List<String> imageArray,
    String personID,
  ) async {
    apiProvider.baseURL = BaseURLService().baseURL;

    Map<String, dynamic> json = {
      "images": imageArray,
      "person_id": personID,
    };
    List<dynamic> jsonResponse = await apiProvider.post(
      'person/images',
      body: json,
    );
    if (jsonResponse.isNotEmpty && jsonResponse[0] is Map<String, dynamic>) {
      final Map<String, dynamic> detail = jsonResponse[0];
      return detail;
    }
    return jsonResponse[0];
  }

  Future<Map<String, dynamic>> deletePersonImage(
    String personId,
    String thumbnailId,
  ) async {
    apiProvider.baseURL = BaseURLService().baseURL;

    return await apiProvider.delete('person/image/$personId/$thumbnailId');
  }

  Future<Map<String, dynamic>> addCollectionToPerson(
    String personId,
    String collectionId,
  ) async {
    apiProvider.baseURL = BaseURLService().baseURL;

    return await apiProvider.post(
      'collection/person',
      body: {
        "collection_id": collectionId,
        "person_id": personId,
      },
    );
  }

  Future<Map<String, dynamic>> removeCollectionFromPerson(
    String personId,
    String collectionId,
  ) async {
    apiProvider.baseURL = BaseURLService().baseURL;

    return await apiProvider
        .delete('collection/person/$collectionId/$personId');
  }

  Future<Map<String, dynamic>> updatePerson(
    Person body,
  ) async {
    apiProvider.baseURL = BaseURLService().baseURL;

    Map<String, dynamic> json = {
      "id": body.id,
      "date_of_birth": body.dateOfBirth != null
          ? DateFormat('yyyy-MM-dd').format(body.dateOfBirth!)
          : null,
      // "images": images,
      "name": body.name,
      "nationality": body.nationality,
      "notes": body.notes,
    };
    return await apiProvider.patch(
      'person',
      body: json,
    );
  }

  Future<bool> deletePerson(String personId) async {
    try {
      apiProvider.baseURL = BaseURLService().baseURL;

      return await apiProvider.delete('person/$personId');
    } catch (e) {
      return false;
    }
  }

 Future<Person> managePersonCategories(
    String personId,
    List<Collection> collections,
  ) async {
    apiProvider.baseURL = BaseURLService().baseURL;
    Person person = await getPerson(personId);
    final personName = person.name;

    final List<String> images = [];
    for (Thumbnail thumbnail in person.thumbnails ?? []) {
      if (thumbnail.thumbnail != null) {
        images.add(thumbnail.thumbnail!);
      }
    }
    Map<String, dynamic> json = {
      "id": personId,
      "collections": collections.map((e) => e.id).toList(),
      "date_of_birth": person.dateOfBirth != null
          ? DateFormat('yyyy-MM-dd').format(person.dateOfBirth!)
          : null,
      "images": images,
      "name": personName,
      "nationality": person.nationality,
      "notes": person.notes,
    };
    final response = await apiProvider.patch(
      'person/images',
      body: json,
    );

    return Person.fromJson(response);
  }
}
