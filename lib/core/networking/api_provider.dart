import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:faceapp/core/constants/error_messages.dart';
import 'package:http/http.dart' as http;

import 'api_exception.dart';

class ApiProvider {
  late String baseURL;

  final Map<String, String> _defaultHeaders = {
    'Content-Type': 'application/json',
    'Charset': 'utf-8',
  };

  ApiProvider({
    required this.baseURL,
  });

  void updateApiKey(String apiKey, String devToken) {
    // _defaultHeaders['x-api-key'] = apiKey;
    _defaultHeaders['Authorization'] = "Bearer $devToken";
    _defaultHeaders['x-client'] = Platform.isAndroid ? "android" : "ios";
  }

  // get Method
  Future<dynamic> get(
    String endpoint, {
    Map<String, dynamic>? params,
    Map<String, String>? headers,
  }) async {
    final Uri uri = _buildUri(endpoint, params);
    final http.Response response =
        await http.get(uri, headers: headers ?? _defaultHeaders);
    return _handleResponse(response);
  }

  // post Method
  Future<dynamic> post(
    String? endpoint, {
    Map<String, dynamic>? params,
    Map<String, String>? headers,
    dynamic body,
  }) async {
    final Uri uri = _buildUri(endpoint, params);
    final http.Response response = await http.post(
      uri,
      headers: headers ?? _defaultHeaders,
      body: json.encode(body),
    );
    return _handleResponse(response);
  }

  // put Method
  Future<dynamic> put(
    String endpoint, {
    Map<String, dynamic>? params,
    Map<String, String>? headers,
    dynamic body,
  }) async {
    final Uri uri = _buildUri(endpoint, params);
    final http.Response response = await http.put(
      uri,
      headers: headers ?? _defaultHeaders,
      body: json.encode(body),
    );
    return _handleResponse(response);
  }

  // delete Method
  Future<dynamic> delete(
    String endpoint, {
    Map<String, dynamic>? params,
    Map<String, String>? headers,
    dynamic body,
  }) async {
    final Uri uri = _buildUri(endpoint, params);
    final http.Response response = await http.delete(
      uri,
      headers: headers ?? _defaultHeaders,
      body: json.encode(body),
    );
    return _handleResponse(response);
  }

  // patch Method
  Future<dynamic> patch(
    String endpoint, {
    Map<String, dynamic>? params,
    Map<String, String>? headers,
    dynamic body,
  }) async {
    final Uri uri = _buildUri(endpoint, params);
    final http.Response response = await http.patch(
      uri,
      headers: headers ?? _defaultHeaders,
      body: json.encode(body),
    );
    return _handleResponse(response);
  }

  Uri _buildUri(String? endpoint, Map<String, dynamic>? params) {
    Uri uri;
    if (endpoint != null) {
      uri = Uri.parse(baseURL + endpoint);
    } else {
      uri = Uri.parse(baseURL);
    }
    if (params != null && params.isNotEmpty) {
      uri = uri.replace(queryParameters: params);
    }
    return uri;
  }

  Future<dynamic> _handleResponse(http.Response response) async {
    dynamic result;
    try {
      result = json.decode(response.body);
    } catch (e) {
      throw ApiException(
        statusCode: response.statusCode,
        message: ErrorMessage.decodeResponseBody,
      );
    }
    if (result is Map<String, dynamic> || result is List<dynamic>) {
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return result;
      } else if (response.statusCode == 403 ||
          response.statusCode == 401 ||
          response.statusCode == 400 ||
          response.statusCode == 404) {
        final String? error = result['message'];
        final String? code = result['code'];
        throw ApiException(
          statusCode: response.statusCode,
          message: '$error',
          errorCode: code,
        );
      } else {
        final String? error = _extractErrorMessage(result);
        throw ApiException(
          statusCode: response.statusCode,
          message: error ?? ErrorMessage.unknownError,
        );
      }
    } else {
      throw ApiException(
        statusCode: response.statusCode,
        message: ErrorMessage.responseBodyFormatError,
      );
    }
  }

  String? _extractErrorMessage(dynamic result) {
    if (result is Map<String, dynamic> && result.containsKey('detail')) {
      final List<dynamic> details = result['detail'];
      if (details.isNotEmpty && details[0] is Map<String, dynamic>) {
        final Map<String, dynamic> error = details[0];
        return error['msg'];
      }
    }
    return null;
  }
}
