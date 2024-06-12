abstract class ErrorMessage {
  ErrorMessage._();

  static String unknownError = "Unknown error";
  static String responseBodyFormatError =
      "Response Body is not in the expected format.";
  static String decodeResponseBody = "Failed to decode response body";
  static String somethingWentWrongError = "Something went wrong..!";
  static String pleasetryAgainError = "Something went wrong. Please try again.";
  static String accountDeletedError =
      "Account deleted or subscription expired. For questions, contact us.";
  // "Your account has been deleted and you will be logged out. If you wish to continue, please re-register";
  static String expiredSubscriptionError =
      "Account deleted or subscription expired. For questions, contact us.";
  // "Your subscription has expired. Please log in to the Developer web portal and subscribe to a new plan.";
  static String restrictedAPI =
      "Access to liveness API is restricted based on your current customer information";
}
