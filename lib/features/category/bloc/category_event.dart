import '../../search/data/model/user.dart';

sealed class CategoryEvent {}

class GetAllCategoryEvent extends CategoryEvent {
  GetAllCategoryEvent();
}

class AddCategoryEvent extends CategoryEvent {
  final String collectionName;

  AddCategoryEvent({
    required this.collectionName,
  });
}

class SetCurrentCategoryEvent extends CategoryEvent {
  final Collection collection;
  SetCurrentCategoryEvent({
    required this.collection,
  });
}

class UpdateCategoryEvent extends CategoryEvent {
  final String collectionID;
  final String collectionName;

  UpdateCategoryEvent({
    required this.collectionID,
    required this.collectionName,
  });
}

class DeleteCategoryEvent extends CategoryEvent {
  final String collectionID;

  DeleteCategoryEvent({
    required this.collectionID,
  });
}

class ResetCategoryStatus extends CategoryEvent {}

class UpdateRepositories extends CategoryEvent {
  final String apiKey;
  final String token;

  UpdateRepositories({
    required this.apiKey,
    required this.token,
  });
}

class UpdateSelectedCollectionsPopup extends CategoryEvent {
  final List<Collection> selectedCollections;

  UpdateSelectedCollectionsPopup({
    required this.selectedCollections,
  });
}

class UpdateSelectedCollections extends CategoryEvent {
  final List<Collection> selectedCollections;

  UpdateSelectedCollections({
    required this.selectedCollections,
  });
}

class UpdateFilterText extends CategoryEvent {
  final String text;

  UpdateFilterText({
    required this.text,
  });
}

class ResetSelectedCollections extends CategoryEvent {
  final String personID;

  ResetSelectedCollections({
    required this.personID,
  });
}

class SetIsOpenDropdownEvent extends CategoryEvent {
  final bool isOpen;

  SetIsOpenDropdownEvent({
    required this.isOpen,
  });
}

class SetIsColUpdatedEvent extends CategoryEvent {
  final bool isColUpdated;

  SetIsColUpdatedEvent({
    required this.isColUpdated,
  });
}

class ForceLogOutCollectionEvent extends CategoryEvent {
  ForceLogOutCollectionEvent();
}