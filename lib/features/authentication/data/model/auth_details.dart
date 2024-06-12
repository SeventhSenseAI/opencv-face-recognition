class AuthDetails {
  final String adminToken;
  final String devToken;
  final String jwtToken;
  final String userType;

  AuthDetails({
    required this.adminToken,
    required this.devToken,
    required this.jwtToken,
    required this.userType,
  });

  factory AuthDetails.fromJson(Map<String, dynamic> json) {
    return AuthDetails(
      adminToken: json['admin_token'],
      devToken: json['dev_token'],
      jwtToken: json['jwt_token'],
      userType: json['user_type'],
    );
  }
}