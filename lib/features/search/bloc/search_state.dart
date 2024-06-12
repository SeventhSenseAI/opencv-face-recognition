part of 'search_bloc.dart';

enum SearchResultStateStatus {
  initial,
  loading,
  noFaceDetected,
  identified,
  unidentified,
  multipleFacesDetected,
  failure,
}

extension ComparePhotosStateStatusExtension on SearchResultStateStatus {
  bool get isUnknown => this == SearchResultStateStatus.initial;
  bool get isLoading => this == SearchResultStateStatus.loading;
  bool get isNoFaceDetected => this == SearchResultStateStatus.noFaceDetected;
  bool get isIdentified => this == SearchResultStateStatus.identified;
  bool get isUnidentified => this == SearchResultStateStatus.unidentified;
  bool get isMultipleFacesDetected =>
      this == SearchResultStateStatus.multipleFacesDetected;
  bool get isFailure => this == SearchResultStateStatus.failure;
}

enum SpoofingStateStatus {
  unknown,
  liveNoSpoofingDetected,
  spoofingDetected,
  failure,
}

extension SpoofingStateStatusExtension on SpoofingStateStatus {
  bool get isUnknown => this == SpoofingStateStatus.unknown;
  bool get isLiveNoSpoofingDetected =>
      this == SpoofingStateStatus.liveNoSpoofingDetected;
  bool get isSpoofingDetected => this == SpoofingStateStatus.spoofingDetected;
  bool get isFailure => this == SpoofingStateStatus.failure;
}

class SearchState {
  final SearchResultStateStatus? searchResultStateStatus;
  final SpoofingStateStatus? spoofingStateStatus;
  final String? errorMessage;
  final Person? user;
  final List<DetectResponse>? searchResults;
  final bool? isSpoofingEnabled;
  final String? base64Image;
  final String? compressBase64Image;
  final bool? isLivenessCheck;
  final double? score;
  final bool? isAPITokenError;

  const SearchState({
    this.searchResultStateStatus,
    this.spoofingStateStatus,
    this.errorMessage,
    this.user,
    this.searchResults,
    required this.isSpoofingEnabled,
    this.base64Image,
    this.compressBase64Image,
    this.isLivenessCheck,
    this.score,
    this.isAPITokenError,
  });
 
  static SearchState initialState() => const SearchState(
        errorMessage: '',
        searchResultStateStatus: SearchResultStateStatus.initial,
        spoofingStateStatus: SpoofingStateStatus.unknown,
        user: null,
        searchResults: [],
        isSpoofingEnabled: false,
        isLivenessCheck: false,
        compressBase64Image: "",
        base64Image: "",
        score: 0.0,
        isAPITokenError: false,
      );

  SearchState copyWith({
    SearchResultStateStatus? searchResultStateStatus,
    SpoofingStateStatus? spoofingStateStatus,
    String? errorMessage,
    Person? user,
    List<DetectResponse>? searchResults,
    bool? isSpoofingEnabled,
    String? base64Image,
    String? compressBase64Image,
    bool? isLivenessCheck,
    double? score,
    bool? isAPITokenError,
  }) {
    return SearchState(
      searchResultStateStatus:
          searchResultStateStatus ?? this.searchResultStateStatus,
      spoofingStateStatus: spoofingStateStatus ?? this.spoofingStateStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      user: user ?? this.user,
      searchResults: searchResults ?? this.searchResults,
      isSpoofingEnabled: isSpoofingEnabled ?? this.isSpoofingEnabled,
      base64Image: base64Image ?? this.base64Image,
      compressBase64Image: compressBase64Image ?? this.compressBase64Image,
      isLivenessCheck: isLivenessCheck ?? this.isLivenessCheck,
      score: score ?? this.score,
      isAPITokenError: isAPITokenError ?? this.isAPITokenError,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SearchState &&
        other.searchResultStateStatus == searchResultStateStatus &&
        other.spoofingStateStatus == spoofingStateStatus &&
        other.errorMessage == errorMessage &&
        other.user == user &&
        listEquals(other.searchResults, searchResults) &&
        other.isSpoofingEnabled == isSpoofingEnabled &&
        other.base64Image == base64Image &&
        other.compressBase64Image == compressBase64Image &&
        other.isLivenessCheck == isLivenessCheck &&
        other.score == score &&
        other.isAPITokenError == isAPITokenError;
  }

  @override
  int get hashCode {
    return searchResultStateStatus.hashCode ^
        spoofingStateStatus.hashCode ^
        errorMessage.hashCode ^
        user.hashCode ^
        searchResults.hashCode ^
        isSpoofingEnabled.hashCode ^
        base64Image.hashCode ^
        compressBase64Image.hashCode ^
        isLivenessCheck.hashCode ^
        score.hashCode ^
        isAPITokenError.hashCode;
  }
}