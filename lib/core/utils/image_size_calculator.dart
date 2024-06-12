import 'dart:convert';
import 'dart:io';

double imageSizeCalculator(String base64Image) {
  // Decode the base64 image string into bytes
  List<int> bytes = base64Decode(base64Image);

  // Calculate the size of the decoded bytes
  int imageSizeInBytes = bytes.length;
  double imageSizeInKB = imageSizeInBytes / 1024;
  double imageSizeInMB = imageSizeInKB / 1024;

  return imageSizeInMB;
}

double imageFileSizeCalculator(File imageFile) {
  // Get the file size in bytes
  int imageSizeInBytes = imageFile.lengthSync();

  // Calculate the size in kilobytes (KB) and megabytes (MB)
  double imageSizeInKB = imageSizeInBytes / 1024;
  double imageSizeInMB = imageSizeInKB / 1024;

  return imageSizeInMB;
}
