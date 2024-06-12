import 'package:faceapp/core/constants/api_constants.dart';
import 'package:faceapp/features/authentication/data/model/auth_details.dart';

import '../../../../core/networking/api_provider.dart';

class UserRepository {
  final ApiProvider _apiProvider =
      ApiProvider(baseURL: ApiConstants.sandboxBaseURL);

  Future<AuthDetails> login(
    Map<String, dynamic> body,
    Map<String, String>? headers,
  ) async {
    final result =
        await _apiProvider.post('login', body: body, headers: headers);
    return AuthDetails.fromJson(result as Map<String, dynamic>);
  }

  Future<String> register(
    Map<String, dynamic> body,
    Map<String, String>? headers,
  ) async {
    final result =
        await _apiProvider.post('registration', body: body, headers: headers);
    return result['registration_token'];
  }

  Future<void> sendOTP(
    String type,
    Map<String, dynamic> body,
    Map<String, String>? headers,
  ) async {
    await _apiProvider.post('registration/$type', body: body, headers: headers);
  }

  Future<void> verityOTP(
    String type,
    Map<String, dynamic> body,
    Map<String, String>? headers,
  ) async {
    await _apiProvider.post(
      'registration/$type/otp',
      body: body,
      headers: headers,
    );
  }

  Future<void> forgetPassword(
    Map<String, dynamic> body,
    Map<String, String>? headers,
  ) async {
    await _apiProvider.post(
      'forgot-password/email',
      body: body,
      headers: headers,
    );
  }

  Future<void> updateFcmToken(
    Map<String, dynamic> body,
    Map<String, String>? headers,
  ) async {
    await _apiProvider.put(
      'mobile-token',
      body: body,
      headers: headers,
    );
  }

  Future<void> deleteFcmToken(
    Map<String, dynamic> body,
    Map<String, String>? headers,
  ) async {
    await _apiProvider.delete(
      'mobile-token',
      body: body,
      headers: headers,
    );
  }
}
