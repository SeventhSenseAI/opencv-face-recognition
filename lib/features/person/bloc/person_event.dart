import '../../search/data/model/user.dart';

sealed class PersonEvent {}

class FetchAllPersonsEvent extends PersonEvent {
  final String collectionId;
  FetchAllPersonsEvent({
    required this.collectionId,
  });
}

class fetchNextBatchOfPersons extends PersonEvent {
  final String collectionId;
  fetchNextBatchOfPersons({
    required this.collectionId,
  });
}

class AddPersonEvent extends PersonEvent {
  final Person person;
  final bool isWithCategory;
  final String? collectionID;
  AddPersonEvent({
    required this.person,
    required this.isWithCategory,
    this.collectionID,
  });
}

class AddMultiPersonEvent extends PersonEvent {
  final Person person;
  final bool isWithCategory;
  final String? collectionID;
  AddMultiPersonEvent({
    required this.person,
    required this.isWithCategory,
    this.collectionID,
  });
}

class UpdatePersonEvent extends PersonEvent {
  final Person person;
  UpdatePersonEvent({
    required this.person,
  });
}

class SetNationalityEvent extends PersonEvent {
  final String? nationality;

  SetNationalityEvent({
    this.nationality,
  });
}

class DeletePersonEvent extends PersonEvent {
  final String personId;

  DeletePersonEvent({
    required this.personId,
  });
}

class DeletePersonImageEvent extends PersonEvent {
  final String personId;
  final String thumnailID;

  DeletePersonImageEvent({
    required this.personId,
    required this.thumnailID,
  });
}

class UpdatePersonImageEvent extends PersonEvent {
  final List<String> images;
  final String personId;
  final int imageIndex;
  UpdatePersonImageEvent({
    required this.images,
    required this.personId,
    required this.imageIndex,
  });
}

class ResetStateEvent extends PersonEvent {}

class UpdateRepositories extends PersonEvent {
  final String apiKey;
  final String token;

  UpdateRepositories({
    required this.apiKey,
    required this.token,
  });
}

class GetPersonEvent extends PersonEvent {
  final String personID;

  GetPersonEvent({
    required this.personID,
  });
}

class AddCollectionToPersonEvent extends PersonEvent {
  final String personId;
  final String collectionId;

  AddCollectionToPersonEvent({
    required this.personId,
    required this.collectionId,
  });
}

class RemoveCollectionFromPersonEvent extends PersonEvent {
  final String personId;
  final String collectionId;

  RemoveCollectionFromPersonEvent({
    required this.personId,
    required this.collectionId,
  });
}

class UpdateFilterPersonTextEvent extends PersonEvent {
  final String filterText;

  UpdateFilterPersonTextEvent({
    required this.filterText,
  });
}

class ManagePersonCategoryEvent extends PersonEvent {
  final String personId;
  final List<Collection> collections;
  final String collectionId;

  ManagePersonCategoryEvent({
    required this.personId,
    required this.collections,
    required this.collectionId,
  });
}
  class ManageImageUpload extends PersonEvent {
  final String image;

  ManageImageUpload({
    required this.image,
  });
}

class ForceLogOutPersonEvent extends PersonEvent {
  ForceLogOutPersonEvent();
}