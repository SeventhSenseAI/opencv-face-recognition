import 'dart:io';

import '../../../../core/networking/api_provider.dart';
import '../../../../core/utils/image_picker.dart';
import '../models/comparison_images.dart';

class ImageRepository {
  final ApiProvider apiProvider;

  ImageRepository({
    required this.apiProvider,
  });

  Future<ImagePickResult> pickImageFromGallery() async {
    ImagePickResult imageFile = await ImagePickerService.pickImageFromGallery();
    return imageFile;
  }

  Future<String> convertImageToBase64({required String imagePath}) async {
    String base64Image =
        await ImagePickerService.convertImageToBase64(imagePath);
    return base64Image;
  }

  Future<double?> compareImages({
    required String baseImageString,
    required String comparisonImageString,
  }) async {
    ComparisonImages comparisonImages = ComparisonImages(
      gallery: [baseImageString],
      probe: [comparisonImageString],
      searchMode: 'ACCURATE',
    );

    final body = comparisonImages.toMap();

    final responseJson = await apiProvider.post("compare", body: body);

    double score = responseJson['score'];

    return score;
  }
}
