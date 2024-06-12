part of 'compare_photos_bloc.dart';

@immutable
class ComparePhotosState {
  final ImageUploadStateStatus? imageUploadState;
  final ComparePhotosStateStatus? comparePhotosState;
  final String? failureMessage;
  final File? baseImageFile;
  final File? comparisonImageFile;
  final String? baseImageString;
  final String? comparisonImageString;
  final bool? isNeedPermission;
  final double? comparePercentage;
  final bool? isAPITokenError;

  const ComparePhotosState({
    this.imageUploadState,
    this.comparePhotosState,
    this.failureMessage,
    this.baseImageFile,
    this.comparisonImageFile,
    this.baseImageString,
    this.comparisonImageString,
    this.isNeedPermission,
    this.comparePercentage,
    this.isAPITokenError,
  });

  static ComparePhotosState initial() => const ComparePhotosState(
        imageUploadState: ImageUploadStateStatus.initial,
        comparePhotosState: ComparePhotosStateStatus.initial,
        failureMessage: "",
        baseImageFile: null,
        comparisonImageFile: null,
        baseImageString: "",
        comparisonImageString: "",
        isNeedPermission: false,
        comparePercentage: 0,
        isAPITokenError: false,
      );

  ComparePhotosState copyWith({
    ImageUploadStateStatus? imageUploadState,
    ComparePhotosStateStatus? comparePhotosState,
    String? failureMessage,
    File? baseImageFile,
    File? comparisonImageFile,
    String? baseImageString,
    String? comparisonImageString,
    bool? isNeedPermission,
    double? comparePercentage,
    bool? isAPITokenError,
  }) {
    return ComparePhotosState(
      imageUploadState: imageUploadState ?? this.imageUploadState,
      comparePhotosState: comparePhotosState ?? this.comparePhotosState,
      failureMessage: failureMessage ?? this.failureMessage,
      baseImageFile: baseImageFile ?? this.baseImageFile,
      comparisonImageFile: comparisonImageFile ?? this.comparisonImageFile,
      baseImageString: baseImageString ?? this.baseImageString,
      comparisonImageString:
          comparisonImageString ?? this.comparisonImageString,
      isNeedPermission: isNeedPermission ?? this.isNeedPermission,
      comparePercentage: comparePercentage ?? this.comparePercentage,
      isAPITokenError: isAPITokenError ?? this.isAPITokenError,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ComparePhotosState &&
        other.imageUploadState == imageUploadState &&
        other.comparePhotosState == comparePhotosState &&
        other.failureMessage == failureMessage &&
        other.baseImageFile == baseImageFile &&
        other.comparisonImageFile == comparisonImageFile &&
        other.baseImageString == baseImageString &&
        other.comparisonImageString == comparisonImageString &&
        other.isNeedPermission == isNeedPermission &&
        other.comparePercentage == comparePercentage &&
        other.isAPITokenError == isAPITokenError;
  }

  @override
  int get hashCode {
    return imageUploadState.hashCode ^
        comparePhotosState.hashCode ^
        failureMessage.hashCode ^
        baseImageFile.hashCode ^
        comparisonImageFile.hashCode ^
        baseImageString.hashCode ^
        comparisonImageString.hashCode ^
        isNeedPermission.hashCode ^
        comparePercentage.hashCode ^
        isAPITokenError.hashCode;
  }
}

enum ImageUploadStateStatus {
  initial,
  loading,
  success,
  failure,
}

enum ComparePhotosStateStatus {
  initial,
  loading,
  matching,
  notMatching,
  failure,
}

enum CompareImageType {
  baseImage,
  comparisonImage,
}

extension ComparePhotosStateStatusExtension on ComparePhotosStateStatus {
  bool get isInitial => this == ComparePhotosStateStatus.initial;
  bool get isLoading => this == ComparePhotosStateStatus.loading;
  bool get isMatching => this == ComparePhotosStateStatus.matching;
  bool get isNotMatching => this == ComparePhotosStateStatus.notMatching;
  bool get isFailure => this == ComparePhotosStateStatus.failure;
}

extension ImagesUploadStatusExtension on ImageUploadStateStatus {
  bool get isInitial => this == ImageUploadStateStatus.initial;
  bool get isLoading => this == ImageUploadStateStatus.loading;
  bool get isSuccess => this == ImageUploadStateStatus.success;
  bool get isFailure => this == ImageUploadStateStatus.failure;
}

extension CompareImageTypeExtension on CompareImageType {
  bool get isBaseImage => this == CompareImageType.baseImage;
  bool get isComparisonImage => this == CompareImageType.comparisonImage;
}
