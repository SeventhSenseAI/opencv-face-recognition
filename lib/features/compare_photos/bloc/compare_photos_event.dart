part of 'compare_photos_bloc.dart';

@immutable
sealed class ComparePhotosEvent {}

class PickImage extends ComparePhotosEvent {
  final CompareImageType compareImageType;

  PickImage({
    required this.compareImageType,
  });
}

class CompareImages extends ComparePhotosEvent {}

class UpdateRepositories extends ComparePhotosEvent {
  final String apiKey;
  final String token;

  UpdateRepositories({
    required this.apiKey,
    required this.token,
  });
}
