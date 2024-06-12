import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerService {
  static Future<ImagePickResult> pickImageFromGallery() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        File imageFile = File(pickedFile.path);
        return ImagePickResult(success: true, imageFile: imageFile);
      } else {
        return ImagePickResult(success: true, imageFile: null);
      }
    } catch (e) {
      return ImagePickResult(success: false, imageFile: null);
    }
  }

  static Future<String> convertImageToBase64(String imagePath) async {
    try {
      List<int> imageBytes = File(imagePath).readAsBytesSync();
      String base64Image = base64Encode(Uint8List.fromList(imageBytes));
      return base64Image;
    } catch (e) {
      return '';
    }
  }

  static Future<String?> compressImageAndGetBase64(
    File file, {
    int quality = 70,
  }) async {
    int imageSizeInBytes = file.lengthSync();

    double imageSizeInKB = imageSizeInBytes / 1024;
    double imageSizeInMB = imageSizeInKB / 1024;

    try {
      if (imageSizeInMB > 1) {
        Uint8List? result = await FlutterImageCompress.compressWithFile(
          file.absolute.path,
          quality: 80,
        );
        String base64String = base64Encode(result!);

        return base64String;
      } else {
        final base64 = convertImageToBase64(file.path);
        return base64;
      }
    } catch (e) {
      final base64 = convertImageToBase64(file.path);
      return base64;
    }
  }
}

class ImageConverterService {
  static String encodeImageToBase64(File imageFile) {
    List<int> imageBytes = imageFile.readAsBytesSync();
    return base64Encode(imageBytes);
  }
}

class ImagePickResult {
  final bool success;
  final File? imageFile;

  ImagePickResult({required this.success, this.imageFile});
}
