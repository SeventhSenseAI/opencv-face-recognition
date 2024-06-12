import 'dart:async';
import 'dart:developer';

import 'package:faceapp/core/networking/api_exception.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/error_codes.dart';
import '../../../core/constants/error_messages.dart';
import '../../../core/utils/image_size_calculator.dart';
import '../../search/data/model/user.dart';
import '../data/repository/person_repository.dart';
import 'person_event.dart';
import 'person_state.dart';

class PersonBloc extends Bloc<PersonEvent, PersonState> {
  PersonBloc()
      : super(
          PersonState.initial(),
        ) {
    on<PersonEvent>(
      (event, emit) async => switch (event) {
        AddPersonEvent() => _addPerson(event, emit),
        SetNationalityEvent() => _setNationality(event, emit),
        FetchAllPersonsEvent() => _fetchAllPersons(event, emit),
        UpdatePersonEvent() => _updatePerson(event, emit),
        DeletePersonEvent() => _deletePerson(event, emit),
        ResetStateEvent() => _resetState(event, emit),
        UpdateRepositories() => _updateRepositories(event, emit),
        DeletePersonImageEvent() => _deletePersonImage(event, emit),
        UpdatePersonImageEvent() => _updatePersonImage(event, emit),
        GetPersonEvent() => _fetchPersonDetail(event, emit),
        AddMultiPersonEvent() => _addMultiPerson(event, emit),
        AddCollectionToPersonEvent() => _addCollectionToPerson(event, emit),
        RemoveCollectionFromPersonEvent() =>
          _removeCollectionFromPerson(event, emit),
        UpdateFilterPersonTextEvent() => _updateFilterText(event, emit),
        ManagePersonCategoryEvent() => _managePersonCategory(event, emit),
        ManageImageUpload() => _ManageImageUpload(event, emit),
        ForceLogOutPersonEvent() => _forceLogOutPerson(event, emit),
                fetchNextBatchOfPersons() => _fetchNextBatchOfPersons(event, emit),

      },
    );
  }

  final PersonRepository personRepository = PersonRepository();

  FutureOr<void> _addPerson(
    AddPersonEvent event,
    Emitter<PersonState> emit,
  ) async {
    try {
      emit(state.clone(saveStatus: PersonSaveStatus.submitting));
      await personRepository.createPerson(event.person, event.collectionID);
      emit(
        state.clone(
          saveStatus: PersonSaveStatus.success,
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
              saveStatus: PersonSaveStatus.error,
              errorMessage: e.errorCode == ErrorCodes.expiredSubscription
                  ? ErrorMessage.expiredSubscriptionError
                  : ErrorMessage.accountDeletedError,
            ),
          );
          return;
        }

        emit(
          state.clone(
            saveStatus: PersonSaveStatus.error,
            errorMessage: e.message,
          ),
        );
      } else {
        emit(
          state.clone(
            saveStatus: PersonSaveStatus.error,
            errorMessage: ErrorMessage.somethingWentWrongError,
          ),
        );
      }
    }
  }

  FutureOr<void> _addMultiPerson(
    AddMultiPersonEvent event,
    Emitter<PersonState> emit,
  ) async {
    try {
      emit(state.clone(saveStatus: PersonSaveStatus.submitting));
      await personRepository.createCropPerson(event.person, event.collectionID);
      emit(
        state.clone(
          saveStatus: PersonSaveStatus.success,
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
              saveStatus: PersonSaveStatus.error,
              errorMessage: e.errorCode == ErrorCodes.expiredSubscription
                  ? ErrorMessage.expiredSubscriptionError
                  : ErrorMessage.accountDeletedError,
            ),
          );
          return;
        }

        emit(
          state.clone(
            saveStatus: PersonSaveStatus.error,
            errorMessage: e.message,
          ),
        );
      } else {
        emit(
          state.clone(
            saveStatus: PersonSaveStatus.error,
            errorMessage: ErrorMessage.somethingWentWrongError,
          ),
        );
      }
    }
  }

  FutureOr<void> _updatePerson(
    UpdatePersonEvent event,
    Emitter<PersonState> emit,
  ) async {
    try {
      emit(
        state.clone(
          updateStatus: PersonUpdateStatus.submitting,
        ),
      );
      await personRepository.updatePerson(event.person);
      emit(
        state.clone(
          updateStatus: PersonUpdateStatus.success,
        ),
      );
      add(
        FetchAllPersonsEvent(
          collectionId: state.collectionID,
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
              updateStatus: PersonUpdateStatus.error,
              errorMessage: e.errorCode == ErrorCodes.expiredSubscription
                  ? ErrorMessage.expiredSubscriptionError
                  : ErrorMessage.accountDeletedError,
            ),
          );
          return;
        }

        emit(
          state.clone(
            updateStatus: PersonUpdateStatus.error,
            errorMessage: e.message,
          ),
        );
      } else {
        emit(
          state.clone(
            updateStatus: PersonUpdateStatus.error,
            errorMessage: ErrorMessage.somethingWentWrongError,
          ),
        );
      }
    }
  }

  FutureOr<void> _setNationality(
    SetNationalityEvent event,
    Emitter<PersonState> emit,
  ) {
    emit(
      state.clone(
        nationality: event.nationality,
      ),
    );
  }

  FutureOr<void> _fetchPersonDetail(
    GetPersonEvent event,
    Emitter<PersonState> emit,
  ) async {
    try {
      emit(
        state.clone(
          personStatus: FetchPersonStatus.submitting,
        ),
      );
      Person persons = await personRepository.getPerson(
        event.personID,
      );
      emit(
        state.clone(
          personStatus: FetchPersonStatus.success,
          personDetail: persons,
        ),
      );
    } catch (e) {
      log("$e");
      if (e is ApiException) {
        if (e.errorCode == ErrorCodes.invalidAPIKey ||
            e.errorCode == ErrorCodes.invalidBearToken ||
            e.errorCode == ErrorCodes.expiredSubscription ||
            e.errorCode == ErrorCodes.customerNotFound) {
          emit(
            state.clone(
              isAPITokenError: true,
              personStatus: FetchPersonStatus.error,
              errorMessage: e.errorCode == ErrorCodes.expiredSubscription
                  ? ErrorMessage.expiredSubscriptionError
                  : ErrorMessage.accountDeletedError,
            ),
          );
          return;
        }

        emit(
          state.clone(
            personStatus: FetchPersonStatus.error,
            errorMessage: e.message,
          ),
        );
      } else {
        emit(
          state.clone(
            personStatus: FetchPersonStatus.error,
            errorMessage: ErrorMessage.somethingWentWrongError,
          ),
        );
      }
    }
  }

  FutureOr<void> _fetchNextBatchOfPersons(
    fetchNextBatchOfPersons event,
    Emitter<PersonState> emit,
  ) async {
    try {
      emit(
        state.clone(
          status: PersonStatus.next,
        ),
      );
    List<Person> persons =
        await personRepository.getNextBatchPersons(event.collectionId);

    Iterable<Person> newPersons = persons.where((person) =>
        !state.personList.any((existingPerson) => existingPerson.id == person.id),);

    List<Person> updatedPersonList = [...state.personList, ...newPersons];

    emit(
      state.clone(
        status: PersonStatus.success,
        personList: updatedPersonList,
        collectionID: event.collectionId,
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
              status: PersonStatus.error,
              errorMessage: e.errorCode == ErrorCodes.expiredSubscription
                  ? ErrorMessage.expiredSubscriptionError
                  : ErrorMessage.accountDeletedError,
            ),
          );
          return;
        }

        emit(
          state.clone(
            status: PersonStatus.error,
            errorMessage: e.message,
          ),
        );
      } else {
        emit(
          state.clone(
            status: PersonStatus.error,
            errorMessage: ErrorMessage.somethingWentWrongError,
          ),
        );
      }
    }
  }



  FutureOr<void> _fetchAllPersons(
    FetchAllPersonsEvent event,
    Emitter<PersonState> emit,
  ) async {
    try {
      emit(
        state.clone(
          status: PersonStatus.loading,
        ),
      );
      List<Person> persons =
          await personRepository.getAllPersons(event.collectionId);
      emit(
        state.clone(
          status: PersonStatus.success,
          personList: persons,
          collectionID: event.collectionId,
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
              status: PersonStatus.error,
              errorMessage: e.errorCode == ErrorCodes.expiredSubscription
                  ? ErrorMessage.expiredSubscriptionError
                  : ErrorMessage.accountDeletedError,
            ),
          );
          return;
        }

        emit(
          state.clone(
            status: PersonStatus.error,
            errorMessage: e.message,
          ),
        );
      } else {
        emit(
          state.clone(
            status: PersonStatus.error,
            errorMessage: ErrorMessage.somethingWentWrongError,
          ),
        );
      }
    }
  }

  FutureOr<void> _deletePersonImage(
    DeletePersonImageEvent event,
    Emitter<PersonState> emit,
  ) async {
    try {
      emit(
        state.clone(
          deleteimageStatus: PersonImageDeleteStatus.submitting,
          deleteImageId: event.thumnailID,
        ),
      );

      await personRepository.deletePersonImage(
        event.personId,
        event.thumnailID,
      );
      emit(state.clone(deleteimageStatus: PersonImageDeleteStatus.success));
    } catch (e) {
      if (e is ApiException) {
        if (e.errorCode == ErrorCodes.invalidAPIKey ||
            e.errorCode == ErrorCodes.invalidBearToken ||
            e.errorCode == ErrorCodes.expiredSubscription ||
            e.errorCode == ErrorCodes.customerNotFound) {
          emit(
            state.clone(
              isAPITokenError: true,
              deleteimageStatus: PersonImageDeleteStatus.error,
              errorMessage: e.errorCode == ErrorCodes.expiredSubscription
                  ? ErrorMessage.expiredSubscriptionError
                  : ErrorMessage.accountDeletedError,
            ),
          );
          return;
        }

        emit(
          state.clone(
            deleteimageStatus: PersonImageDeleteStatus.error,
            errorMessage: e.message,
          ),
        );
      } else {
        emit(
          state.clone(
            deleteimageStatus: PersonImageDeleteStatus.error,
            errorMessage: ErrorMessage.somethingWentWrongError,
          ),
        );
      }
    }
  }

  FutureOr<void> _updatePersonImage(
    UpdatePersonImageEvent event,
    Emitter<PersonState> emit,
  ) async {
    try {
      emit(
        state.clone(
          uploadImageStatus: PersonImageUploadStatus.submitting,
        ),
      );
      Map<String, dynamic> result = await personRepository.updatePersonImage(
        event.images,
        event.personId,
      );
      emit(
        state.clone(
          imageId: result["id"],
          updateImageIndex: event.imageIndex,
          uploadImageStatus: PersonImageUploadStatus.success,
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
              uploadImageStatus: PersonImageUploadStatus.error,
              errorMessage: e.errorCode == ErrorCodes.expiredSubscription
                  ? ErrorMessage.expiredSubscriptionError
                  : ErrorMessage.accountDeletedError,
            ),
          );
          return;
        }

        emit(
          state.clone(
            uploadImageStatus: PersonImageUploadStatus.error,
            errorMessage: e.message,
          ),
        );
      } else {
        emit(
          state.clone(
            uploadImageStatus: PersonImageUploadStatus.error,
            errorMessage: ErrorMessage.somethingWentWrongError,
          ),
        );
      }
    }
  }

  FutureOr<void> _managePersonCategory(
    ManagePersonCategoryEvent event,
    Emitter<PersonState> emit,
  ) async {
    try {
      emit(
        state.clone(
          updateStatus: PersonUpdateStatus.submitting,
        ),
      );
    var person =  await personRepository.managePersonCategories(
        event.personId,
        event.collections,
      );
      add(FetchAllPersonsEvent(collectionId: event.collectionId));
        emit(
          state.clone(
            updateStatus: PersonUpdateStatus.success,
            personDetail: person,
          ),
        );
      
    } catch (e) {
      if (e is ApiException) {
        emit(
          state.clone(
            updateStatus: PersonUpdateStatus.error,
            errorMessage: e.message,
          ),
        );
      } else {
        emit(
          state.clone(
            updateStatus: PersonUpdateStatus.error,
            errorMessage: 'Something went wrong..!',
          ),
        );
      }
    }
  }

Future<bool> fetchPersonCollectionDetails(String personID, Emitter<PersonState> emit,) async {
  try {
    Person person = await personRepository.getPerson(personID);
    emit(state.clone(personDetail: person));
    return true;
  } catch (e) {
    log("$e");
    return false;
  }
}

  FutureOr<void> _deletePerson(
    DeletePersonEvent event,
    Emitter<PersonState> emit,
  ) async {
    try {
      emit(
        state.clone(
          deleteStatus: PersonDeleteStatus.submitting,
        ),
      );
      await personRepository.deletePerson(event.personId);
      emit(state.clone(deleteStatus: PersonDeleteStatus.success));
      add(
        FetchAllPersonsEvent(
          collectionId: state.collectionID,
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
              deleteStatus: PersonDeleteStatus.error,
              errorMessage: e.errorCode == ErrorCodes.expiredSubscription
                  ? ErrorMessage.expiredSubscriptionError
                  : ErrorMessage.accountDeletedError,
            ),
          );
          return;
        }

        emit(
          state.clone(
            deleteStatus: PersonDeleteStatus.error,
            errorMessage: e.message,
          ),
        );
      } else {
        emit(
          state.clone(
            deleteStatus: PersonDeleteStatus.error,
            errorMessage: ErrorMessage.somethingWentWrongError,
          ),
        );
      }
    }
  }

  FutureOr<void> _addCollectionToPerson(
    AddCollectionToPersonEvent event,
    Emitter<PersonState> emit,
  ) async {
    try {
      emit(
        state.clone(
          saveStatus: PersonSaveStatus.submitting,
        ),
      );
      await personRepository.addCollectionToPerson(
        event.personId,
        event.collectionId,
      );
      emit(
        state.clone(
          saveStatus: PersonSaveStatus.success,
        ),
      );
      add(
        FetchAllPersonsEvent(
          collectionId: state.collectionID,
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
              saveStatus: PersonSaveStatus.error,
              errorMessage: e.errorCode == ErrorCodes.expiredSubscription
                  ? ErrorMessage.expiredSubscriptionError
                  : ErrorMessage.accountDeletedError,
            ),
          );
          return;
        }

        emit(
          state.clone(
            saveStatus: PersonSaveStatus.error,
            errorMessage: e.message,
          ),
        );
      } else {
        emit(
          state.clone(
            saveStatus: PersonSaveStatus.error,
            errorMessage: ErrorMessage.somethingWentWrongError,
          ),
        );
      }
    }
  }

  FutureOr<void> _removeCollectionFromPerson(
    RemoveCollectionFromPersonEvent event,
    Emitter<PersonState> emit,
  ) async {
    try {
      emit(
        state.clone(
          saveStatus: PersonSaveStatus.submitting,
        ),
      );
      await personRepository.removeCollectionFromPerson(
        event.personId,
        event.collectionId,
      );
      emit(
        state.clone(
          saveStatus: PersonSaveStatus.success,
        ),
      );
      add(
        FetchAllPersonsEvent(
          collectionId: state.collectionID,
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
              saveStatus: PersonSaveStatus.error,
              errorMessage: e.errorCode == ErrorCodes.expiredSubscription
                  ? ErrorMessage.expiredSubscriptionError
                  : ErrorMessage.accountDeletedError,
            ),
          );
          return;
        }

        emit(
          state.clone(
            deleteStatus: PersonDeleteStatus.error,
            errorMessage: e.message,
          ),
        );
      } else {
        emit(
          state.clone(
            saveStatus: PersonSaveStatus.error,
            errorMessage: ErrorMessage.somethingWentWrongError,
          ),
        );
      }
    }
  }

  FutureOr<void> _updateFilterText(
    UpdateFilterPersonTextEvent event,
    Emitter<PersonState> emit,
  ) {
    emit(
      state.clone(
        filterPersonText: event.filterText,
      ),
    );
  }

  FutureOr<void> _resetState(
    ResetStateEvent event,
    Emitter<PersonState> emit,
  ) async {
    emit(
      state.clone(
        status: PersonStatus.initial,
        saveStatus: PersonSaveStatus.initial,
        updateStatus: PersonUpdateStatus.initial,
        deleteStatus: PersonDeleteStatus.initial,
        uploadImageStatus: PersonImageUploadStatus.initial,
        deleteimageStatus: PersonImageDeleteStatus.initial,
        imageUploadStatus: ImageUploadStatus.initial,
        errorMessage: '',
      ),
    );
  }

  FutureOr<void> _updateRepositories(
    UpdateRepositories event,
    Emitter<PersonState> emit,
  ) {
    personRepository.apiProvider.updateApiKey(event.apiKey, event.token);
  }

  FutureOr<void> _ManageImageUpload(
    ManageImageUpload event,
    Emitter<PersonState> emit,
  ) {
    try {
      final imageSize = imageSizeCalculator(event.image);

      if (imageSize > 4) {
        emit(
          state.clone(
            imageUploadStatus: ImageUploadStatus.failure,
            errorMessage: 'Maximum allowed image size for upload is 4MB',
          ),
        );
      } else {
        emit(
          state.clone(
            imageUploadStatus: ImageUploadStatus.success,
          ),
        );
      }
    } catch (e) {
      emit(
        state.clone(
          imageUploadStatus: ImageUploadStatus.failure,
          errorMessage: 'Maximum allowed image size for upload is 4MB',
        ),
      );
    }
  }

  FutureOr<void> _forceLogOutPerson(
    ForceLogOutPersonEvent event,
    Emitter<PersonState> emit,
  ) {
    emit(PersonState.initial());
  }
}
