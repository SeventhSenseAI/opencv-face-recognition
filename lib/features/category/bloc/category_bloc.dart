import 'dart:async';

import 'package:faceapp/core/constants/error_messages.dart';
import 'package:faceapp/core/networking/api_exception.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/error_codes.dart';
import '../../search/data/model/user.dart';
import '../data/repository/collection_repository.dart';
import 'category_event.dart';
import 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  CollectionRepository collectionRepository = CollectionRepository();

  CategoryBloc() : super(CategoryState.initial()) {
    on<CategoryEvent>(
      (event, emit) async => switch (event) {
        GetAllCategoryEvent() => _getAllCategory(event, emit),
        AddCategoryEvent() => _addCategory(event, emit),
        SetCurrentCategoryEvent() => _setCurrentCategory(event, emit),
        UpdateCategoryEvent() => _updateCategory(event, emit),
        DeleteCategoryEvent() => _deleteCategory(event, emit),
        ResetCategoryStatus() => _resetCategoryStatus(event, emit),
        UpdateRepositories() => _updateRepositories(event, emit),
        UpdateSelectedCollections() => _updateSelectedCollections(event, emit),
        UpdateFilterText() => _updateFilterText(event, emit),
        ResetSelectedCollections() => _resetSelectedCollections(event, emit),
        SetIsOpenDropdownEvent() => _setIsOpenDropdown(event, emit),
        SetIsColUpdatedEvent() => _setIsColUpdated(event, emit),
        UpdateSelectedCollectionsPopup() =>
          _updateSelectedCollectionsPopup(event, emit),
        ForceLogOutCollectionEvent() => _forceLogOutCollection(event, emit),
      },
    );
  }

  FutureOr<void> _getAllCategory(
    GetAllCategoryEvent event,
    Emitter<CategoryState> emit,
  ) async {
    try {
      emit(state.clone(status: CategoryStatus.loading));
      List<Collection> categoryList =
          await collectionRepository.getCollection();
      emit(
        state.clone(
          categoryList: categoryList,
          status: CategoryStatus.success,
        ),
      );
    } catch (e) {
      if (e is ApiException) {
        if (e.errorCode == ErrorCodes.invalidAPIKey ||
            e.errorCode == ErrorCodes.invalidBearToken ||
            e.errorCode == ErrorCodes.expiredSubscription ||
            e.errorCode == ErrorCodes.customerNotFound) {
          emit(
            state.clone(
              isAPITokenError: true,
              status: CategoryStatus.error,
              errorMessage: e.errorCode == ErrorCodes.expiredSubscription
                  ? ErrorMessage.expiredSubscriptionError
                  : ErrorMessage.accountDeletedError,
            ),
          );
          return;
        }

        emit(
          state.clone(
            status: CategoryStatus.error,
            errorMessage: e.message,
          ),
        );
      } else {
        emit(
          state.clone(
            status: CategoryStatus.error,
            errorMessage: ErrorMessage.somethingWentWrongError,
          ),
        );
      }
    }
  }

  FutureOr<void> _updateCollection(
    Collection newCollection,
    Emitter<CategoryState> emit,
  ) {
    // Copy the existing category list
    List<Collection> updatedList = List.of(state.categoryList);

    // Iterate through the category list to find and update the collection
    for (int i = 0; i < updatedList.length; i++) {
      if (updatedList[i].id == newCollection.id) {
        // Update the collection if found
        updatedList[i] = newCollection;
        break; // Exit the loop once updated
      }
    }
    emit(
      state.clone(
        categoryList: updatedList,
      ),
    );
  }

  FutureOr<void> _deleteCollection(
    String collectionId,
    Emitter<CategoryState> emit,
  ) {
    List<Collection> updatedList = List.of(state.categoryList);
    for (int i = 0; i < updatedList.length; i++) {
      if (updatedList[i].id == collectionId) {
        updatedList.removeAt(i);
        break; // Exit the loop once removed
      }
    }
    emit(
      state.clone(
        categoryList: updatedList,
      ),
    );
  }

  FutureOr<void> _addCategory(
    AddCategoryEvent event,
    Emitter<CategoryState> emit,
  ) async {
    try {
      emit(state.clone(saveStatus: CategorySaveStatus.submitting));
      final collection =
          await collectionRepository.addCategory(event.collectionName);
      add(SetCurrentCategoryEvent(collection: collection));
      emit(state.clone(categoryList: [...state.categoryList, collection]));
      emit(state.clone(saveStatus: CategorySaveStatus.success));
    } catch (e) {
      if (e is ApiException) {
        if (e.errorCode == ErrorCodes.invalidAPIKey ||
            e.errorCode == ErrorCodes.invalidBearToken ||
            e.errorCode == ErrorCodes.expiredSubscription ||
            e.errorCode == ErrorCodes.customerNotFound) {
          emit(
            state.clone(
              isAPITokenError: true,
              saveStatus: CategorySaveStatus.error,
              errorMessage: e.errorCode == ErrorCodes.expiredSubscription
                  ? ErrorMessage.expiredSubscriptionError
                  : ErrorMessage.accountDeletedError,
            ),
          );
          return;
        }
        emit(
          state.clone(
            saveStatus: CategorySaveStatus.error,
            errorMessage: e.message,
          ),
        );
      } else {
        emit(
          state.clone(
            saveStatus: CategorySaveStatus.error,
            errorMessage: ErrorMessage.somethingWentWrongError,
          ),
        );
      }
    }
  }

  FutureOr<void> _setCurrentCategory(
    SetCurrentCategoryEvent event,
    Emitter<CategoryState> emit,
  ) {
    emit(
      state.clone(
        currentCategory: event.collection,
      ),
    );
  }

  FutureOr<void> _updateCategory(
    UpdateCategoryEvent event,
    Emitter<CategoryState> emit,
  ) async {
    try {
      emit(state.clone(updateStatus: CategoryUpdateStatus.submitting));
      final collection = await collectionRepository.updateCategory(
        categoryName: event.collectionName,
        id: event.collectionID,
      );
      emit(state.clone(updateStatus: CategoryUpdateStatus.success));
      add(SetCurrentCategoryEvent(collection: collection));
      // add(GetAllCategoryEvent());
      _updateCollection(collection, emit);
    } catch (e) {
      if (e is ApiException) {
        if (e.errorCode == ErrorCodes.invalidAPIKey ||
            e.errorCode == ErrorCodes.invalidBearToken ||
            e.errorCode == ErrorCodes.expiredSubscription ||
            e.errorCode == ErrorCodes.customerNotFound) {
          emit(
            state.clone(
              isAPITokenError: true,
              updateStatus: CategoryUpdateStatus.error,
              errorMessage: e.errorCode == ErrorCodes.expiredSubscription
                  ? ErrorMessage.expiredSubscriptionError
                  : ErrorMessage.accountDeletedError,
            ),
          );
          return;
        }
        emit(
          state.clone(
            updateStatus: CategoryUpdateStatus.error,
            errorMessage: e.message,
          ),
        );
      } else {
        emit(
          state.clone(
            updateStatus: CategoryUpdateStatus.error,
            errorMessage: ErrorMessage.somethingWentWrongError,
          ),
        );
      }
    }
  }

  FutureOr<void> _deleteCategory(
    DeleteCategoryEvent event,
    Emitter<CategoryState> emit,
  ) async {
    try {
      emit(state.clone(deleteStatus: CategoryDeleteStatus.submitting));
      await collectionRepository.deleteCategory(event.collectionID);
      emit(state.clone(deleteStatus: CategoryDeleteStatus.success));
      // add(GetAllCategoryEvent());
      _deleteCollection(event.collectionID, emit);
    } catch (e) {
      if (e is ApiException) {
        if (e.errorCode == ErrorCodes.invalidAPIKey ||
            e.errorCode == ErrorCodes.invalidBearToken ||
            e.errorCode == ErrorCodes.expiredSubscription ||
            e.errorCode == ErrorCodes.customerNotFound) {
          emit(
            state.clone(
              isAPITokenError: true,
              deleteStatus: CategoryDeleteStatus.error,
              errorMessage: e.errorCode == ErrorCodes.expiredSubscription
                  ? ErrorMessage.expiredSubscriptionError
                  : ErrorMessage.accountDeletedError,
            ),
          );
          return;
        }
        emit(
          state.clone(
            deleteStatus: CategoryDeleteStatus.error,
            errorMessage: e.toString(),
          ),
        );
      } else {
        emit(
          state.clone(
            deleteStatus: CategoryDeleteStatus.error,
            errorMessage: ErrorMessage.somethingWentWrongError,
          ),
        );
      }
    }
  }

  FutureOr<void> _forceLogOutCollection(
    ForceLogOutCollectionEvent event,
    Emitter<CategoryState> emit,
  ) {
    emit(CategoryState.initial());
  }

  FutureOr<void> _updateSelectedCollectionsPopup(
    UpdateSelectedCollectionsPopup event,
    Emitter<CategoryState> emit,
  ) {
    emit(
      state.clone(
        selectCollections: event.selectedCollections,
      ),
    );
  }

  FutureOr<void> _updateSelectedCollections(
    UpdateSelectedCollections event,
    Emitter<CategoryState> emit,
  ) {
    emit(
      state.clone(
        selectedCollections: event.selectedCollections,
      ),
    );
  }

  FutureOr<void> _updateFilterText(
    UpdateFilterText event,
    Emitter<CategoryState> emit,
  ) {
    emit(
      state.clone(
        filterText: event.text,
      ),
    );
  }

  FutureOr<void> _resetSelectedCollections(
    ResetSelectedCollections event,
    Emitter<CategoryState> emit,
  ) async {
    try {
      Person person = await collectionRepository.getPerson(event.personID);
      emit(
        state.clone(
          selectedCollections: person.collections,
        ),
      );
    } catch (e) {
      if (e is ApiException) {
        emit(
          state.clone(
            errorMessage: e.message,
          ),
        );
      } else {
        emit(
          state.clone(
            errorMessage: ErrorMessage.somethingWentWrongError,
          ),
        );
      }
    }
  }

  FutureOr<void> _resetCategoryStatus(
    ResetCategoryStatus event,
    Emitter<CategoryState> emit,
  ) {
    emit(
      state.clone(
        status: CategoryStatus.initial,
        saveStatus: CategorySaveStatus.initial,
        updateStatus: CategoryUpdateStatus.initial,
        deleteStatus: CategoryDeleteStatus.initial,
        errorMessage: '',
      ),
    );
  }

  FutureOr<void> _setIsOpenDropdown(
    SetIsOpenDropdownEvent event,
    Emitter<CategoryState> emit,
  ) {
    emit(
      state.clone(
        isDropdownOpen: event.isOpen,
      ),
    );
  }

  FutureOr<void> _setIsColUpdated(
    SetIsColUpdatedEvent event,
    Emitter<CategoryState> emit,
  ) {
    emit(
      state.clone(
        isColUpdated: event.isColUpdated,
      ),
    );
  }

  FutureOr<void> _updateRepositories(
    UpdateRepositories event,
    Emitter<CategoryState> emit,
  ) {
    collectionRepository.apiProvider.updateApiKey(event.apiKey, event.token);
    add(GetAllCategoryEvent());
  }
}
