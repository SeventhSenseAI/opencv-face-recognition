part of 'search_bloc.dart';

sealed class SearchBlocEvent {}

class ImageSearched extends SearchBlocEvent {
  final String base64Image;
  final bool isLivenessCheck;
  final String compressBase64Image;

  ImageSearched({
    required this.base64Image,
    required this.isLivenessCheck,
    required this.compressBase64Image,
  });
}

class SpoofingDetected extends SearchBlocEvent {
  final List<DetectResponse> result;
  final String base64Image;
  final bool isSpoofing;
  final String compressBase64Image;

  SpoofingDetected({
    required this.result,
    required this.base64Image,
    required this.isSpoofing,
    required this.compressBase64Image,
  });
}

class UpdateRepositories extends SearchBlocEvent {
  final String apiKey;
  final String base64Image;
  final bool isLivenessCheck;
  final String compressBase64Image;
  final String token;

  UpdateRepositories({
    required this.apiKey,
    required this.token,
    required this.base64Image,
    required this.isLivenessCheck,
    required this.compressBase64Image,
  });
}
