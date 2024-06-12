class ApiException implements Exception {
  final int statusCode;
  final String message;
  final String? errorCode;

  ApiException({
    required this.statusCode,
    required this.message,
    this.errorCode,
  });

  @override
  String toString() => 'ApiException: $errorCode - $statusCode - $message';
}
