import 'package:faceapp/core/services/baseurl_service.dart';

import '../../../../core/networking/api_provider.dart';
import '../../../search/data/model/user.dart';
import '../model/delete.dart';

class CollectionRepository {
  final ApiProvider apiProvider =
      ApiProvider(baseURL: BaseURLService().baseURL);

  Future<List<Collection>> getCollection() async {
    int mini = 0;
    int max = 100;
    List<Collection> finalCollection = [];
    apiProvider.baseURL = BaseURLService().baseURL;
    while (true) {
      final response =
          await apiProvider.get('collections?skip=$mini&take=$max&order=DESC');
      List<Collection> collection = response['collections']
          .map<Collection>((person) => Collection.fromJson(person))
          .toList();
      finalCollection.addAll(collection);

      if (collection.length < 100) {
        break;
      }
      mini += max;
    }
    return finalCollection;
  }

  Future<Collection> addCategory(String categoryName) async {
    Map<String, dynamic> body = {"name": categoryName};
    apiProvider.baseURL = BaseURLService().baseURL;

    final responseJson = await apiProvider.post("collection", body: body);
    final collection =
        Collection.fromJson(responseJson as Map<String, dynamic>);
    return collection;
  }

  Future<Collection> updateCategory({String? categoryName, String? id}) async {
    Map<String, dynamic> body = {
      "name": categoryName,
      "id": id,
    };
    apiProvider.baseURL = BaseURLService().baseURL;
    final responseJson =
        await apiProvider.patch('collection', body: body, params: null);
    final collection =
        Collection.fromJson(responseJson as Map<String, dynamic>);
    return collection;
  }

  Future<bool> deleteCategory(String categoryID) async {
    try {
      apiProvider.baseURL = BaseURLService().baseURL;
      final DeleteCollection response =
          await apiProvider.delete('collection/$categoryID');
      return response.id == categoryID;
    } catch (e) {
      return false;
    }
  }

  Future<Person> getPerson(String id) async {
    apiProvider.baseURL = BaseURLService().baseURL;
    final response = await apiProvider.get('person/$id');
    return Person.fromJson(response);
  }
}
