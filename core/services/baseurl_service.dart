
class BaseURLService {
  // Private constructor
  BaseURLService._();

  // Singleton instance
  static final BaseURLService _instance = BaseURLService._();

  // Factory method to provide access to the singleton instance
  factory BaseURLService() => _instance;

  // Property to hold the base URL
  String baseURL = '';

  // Method to set the base URL
  void setBaseURL(String url) {
    baseURL = url;
  }
}
  