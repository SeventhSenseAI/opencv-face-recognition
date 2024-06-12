class RegisterInfo {
  final String firstName;
  final String lastName;
  final String companyName;
  final String email;
  final String mobile;
  final String region;
  String? password;

  RegisterInfo({
    required this.firstName,
    required this.lastName,
    required this.companyName,
    required this.email,
    required this.mobile,
    required this.region,
    this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      "first_name": firstName,
      "last_name": lastName,
      "company_name": companyName,
      "password": password,
      "email": email,
      "mobile": mobile,
      "region": region,
      "recaptcha_token": "",
    };
  }
}
