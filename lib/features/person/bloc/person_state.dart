// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:faceapp/features/search/data/model/user.dart';

enum PersonStatus {
  initial,
  loading,
  success,
  error,
  next,
}

enum PersonSaveStatus {
  initial,
  submitting,
  success,
  error,
}

enum PersonUpdateStatus {
  initial,
  submitting,
  success,
  error,
}

enum PersonDeleteStatus {
  initial,
  submitting,
  success,
  error,
}

enum PersonImageDeleteStatus {
  initial,
  submitting,
  success,
  error,
}

enum PersonImageUploadStatus {
  initial,
  submitting,
  success,
  error,
}

enum FetchPersonStatus {
  initial,
  submitting,
  success,
  error,
}

enum ImageUploadStatus {
  initial,
  loading,
  success,
  failure,
}

@immutable
class PersonState {
  final List<Person> personList;
  final String? nationality;
  final Collection currentCategory;
  final PersonStatus status;
  final String errorMessage;
  final List<Thumbnail> thumbnails;
  final PersonSaveStatus saveStatus;
  final PersonUpdateStatus updateStatus;
  final PersonDeleteStatus deleteStatus;
  final String collectionID;
  final PersonImageUploadStatus uploadImageStatus;
  final PersonImageDeleteStatus deleteimageStatus;
  final String imageId;
  final String deleteImageId;
  final Person? personDetail;
  final FetchPersonStatus? personStatus;
  final int? updateImageIndex;
  final String filterPersonText;
  final bool? isAPITokenError;
  final ImageUploadStatus? imageUploadStatus;

  const PersonState({
    required this.personList,
    this.nationality,
    required this.currentCategory,
    required this.status,
    required this.errorMessage,
    required this.thumbnails,
    required this.saveStatus,
    required this.updateStatus,
    required this.deleteStatus,
    required this.collectionID,
    required this.uploadImageStatus,
    required this.deleteimageStatus,
    required this.imageId,
    required this.deleteImageId,
    this.personDetail,
    this.personStatus,
    this.updateImageIndex,
    required this.filterPersonText,
    this.isAPITokenError,
    this.imageUploadStatus,
  });

  static PersonState initial() => PersonState(
        personList: const [],
        nationality: null,
        currentCategory: Collection(
          id: '',
          name: '',
          description: '',
          createDate: DateTime.now(),
          modifiedDate: DateTime.now(),
        ),
        status: PersonStatus.initial,
        errorMessage: '',
        thumbnails: const [],
        saveStatus: PersonSaveStatus.initial,
        updateStatus: PersonUpdateStatus.initial,
        deleteStatus: PersonDeleteStatus.initial,
        collectionID: "",
        uploadImageStatus: PersonImageUploadStatus.initial,
        deleteimageStatus: PersonImageDeleteStatus.initial,
        imageId: "",
        deleteImageId: "",
        personDetail: null,
        personStatus: null,
        updateImageIndex: null,
        filterPersonText: "",
        isAPITokenError: false,
        imageUploadStatus: ImageUploadStatus.initial,
      );

  PersonState clone({
    List<Person>? personList,
    String? nationality,
    Collection? currentCategory,
    PersonStatus? status,
    String? errorMessage,
    List<Thumbnail>? thumbnails,
    PersonSaveStatus? saveStatus,
    PersonUpdateStatus? updateStatus,
    PersonDeleteStatus? deleteStatus,
    String? collectionID,
    PersonImageUploadStatus? uploadImageStatus,
    PersonImageDeleteStatus? deleteimageStatus,
    String? imageId,
    String? deleteImageId,
    Person? personDetail,
    FetchPersonStatus? personStatus,
    int? updateImageIndex,
    String? filterPersonText,
    bool? isAPITokenError,
    ImageUploadStatus? imageUploadStatus,
  }) {
    return PersonState(
      personList: personList ?? this.personList,
      nationality: nationality ?? this.nationality,
      currentCategory: currentCategory ?? this.currentCategory,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      thumbnails: thumbnails ?? this.thumbnails,
      saveStatus: saveStatus ?? this.saveStatus,
      updateStatus: updateStatus ?? this.updateStatus,
      deleteStatus: deleteStatus ?? this.deleteStatus,
      collectionID: collectionID ?? this.collectionID,
      uploadImageStatus: uploadImageStatus ?? this.uploadImageStatus,
      deleteimageStatus: deleteimageStatus ?? this.deleteimageStatus,
      imageId: imageId ?? this.imageId,
      deleteImageId: deleteImageId ?? this.deleteImageId,
      personDetail: personDetail ?? this.personDetail,
      personStatus: personStatus ?? this.personStatus,
      updateImageIndex: updateImageIndex ?? this.updateImageIndex,
      filterPersonText: filterPersonText ?? this.filterPersonText,
      isAPITokenError: isAPITokenError ?? this.isAPITokenError,
      imageUploadStatus: imageUploadStatus ?? this.imageUploadStatus,
    );
  }

  @override
  bool operator ==(covariant PersonState other) {
    if (identical(this, other)) return true;

    return listEquals(other.personList, personList) &&
        other.nationality == nationality &&
        other.currentCategory == currentCategory &&
        other.status == status &&
        other.errorMessage == errorMessage &&
        listEquals(other.thumbnails, thumbnails) &&
        other.saveStatus == saveStatus &&
        other.updateStatus == updateStatus &&
        other.deleteStatus == deleteStatus &&
        other.collectionID == collectionID &&
        other.uploadImageStatus == uploadImageStatus &&
        other.deleteimageStatus == deleteimageStatus &&
        other.imageId == imageId &&
        other.deleteImageId == deleteImageId &&
        other.personDetail == personDetail &&
        other.personStatus == personStatus &&
        other.updateImageIndex == updateImageIndex &&
        other.filterPersonText == filterPersonText &&
        other.isAPITokenError == isAPITokenError &&
        other.imageUploadStatus == imageUploadStatus;
  }

  @override
  int get hashCode {
    return personList.hashCode ^
        nationality.hashCode ^
        currentCategory.hashCode ^
        status.hashCode ^
        errorMessage.hashCode ^
        thumbnails.hashCode ^
        saveStatus.hashCode ^
        updateStatus.hashCode ^
        deleteStatus.hashCode ^
        collectionID.hashCode ^
        uploadImageStatus.hashCode ^
        deleteimageStatus.hashCode ^
        imageId.hashCode ^
        deleteImageId.hashCode ^
        personDetail.hashCode ^
        personStatus.hashCode ^
        updateImageIndex.hashCode ^
        filterPersonText.hashCode ^
        isAPITokenError.hashCode ^
        imageUploadStatus.hashCode;
  }
}
