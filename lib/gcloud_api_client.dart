import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_identity_platform_mfa/auth_repository.dart';
import 'package:flutter_identity_platform_mfa/model/mfa_info_with_credential.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import 'logger.dart';
import 'model/model.dart';

final gcloudApiClient = Provider(
  (ref) => GcloudApiClient(ref.read),
);

class GcloudApiClient {
  GcloudApiClient(this._read);
  final Reader _read;
  static const _domain = 'identitytoolkit.googleapis.com';
  static const _pathPrefix = '/v2/accounts';
  static const _apiKey = String.fromEnvironment('API_KEY');
  static const _headers = <String, String>{
    'content-type': 'application/json',
  };

  Future<ApiResponse> _post({
    required String method,
    required Map<String, dynamic> body,
    String pathPrefix = _pathPrefix,
  }) async {
    try {
      final uri = Uri.https(
        _domain,
        '$pathPrefix/$method',
        <String, dynamic>{
          'key': _apiKey,
        },
      );
      final response = await http.post(
        uri,
        headers: _headers,
        body: jsonEncode(body),
      );
      logger.info('${response.statusCode}: ${response.body}');
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode != 200) {
        final error = json['error'] as Map<String, dynamic>;
        return ApiResponse(
          success: false,
          exception: PlatformException(
            code: '${error['code']}: ${error['message']}',
            message: error['status'].toString(),
          ),
        );
      }
      return ApiResponse(success: true, json: json);
    } on PlatformException catch (e) {
      logger.warning(e);
      return ApiResponse(success: false, exception: e);
    }
  }

  // ref. https://cloud.google.com/identity-platform/docs/reference/rest/v2/accounts.mfaEnrollment/start
  Future<ApiResponse> startMFAEnrollment({required String phoneNumber}) async {
    const method = 'mfaEnrollment:start';
    final body = <String, dynamic>{
      'idToken': await _read(authRepository).getIdToken(),
      'phoneEnrollmentInfo': <String, String>{
        'phoneNumber': phoneNumber,
      },
    };
    return _post(method: method, body: body);
  }

  // ref. https://cloud.google.com/identity-platform/docs/reference/rest/v2/accounts.mfaEnrollment/finalize
  Future<ApiResponse> finalizeMFAEnrollment({
    required String sessionInfo,
    required String code,
    required String phoneNumber,
  }) async {
    const method = 'mfaEnrollment:finalize';
    final body = <String, dynamic>{
      'idToken': await _read(authRepository).getIdToken(),
      'phoneVerificationInfo': <String, String>{
        'sessionInfo': sessionInfo,
        'code': code,
        'phoneNumber': phoneNumber,
      },
    };
    return _post(method: method, body: body);
  }

  // ref. https://cloud.google.com/identity-platform/docs/reference/rest/v2/accounts.mfaSignIn/start
  Future<ApiResponse> startMFASignIn({
    required MFAInfoWithCredential mfaInfoWithCredential,
  }) async {
    const method = 'mfaSignIn:start';
    final body = <String, dynamic>{
      'mfaPendingCredential': mfaInfoWithCredential.mfaPendingCredential,
      'mfaEnrollmentId': mfaInfoWithCredential.mfaEnrollmentId,
      'phoneSignInInfo': <String, String>{
        'phoneNumber': mfaInfoWithCredential.phoneInfo,
      },
    };
    return _post(method: method, body: body);
  }

  // ref. https://cloud.google.com/identity-platform/docs/reference/rest/v2/accounts.mfaSignIn/start
  Future<ApiResponse> finalizeMFASignIn({
    required MFAInfoWithCredential mfaInfoWithCredential,
    required String sessionInfo,
    required String code,
  }) async {
    const method = 'mfaSignIn:finalize';
    final body = <String, dynamic>{
      'mfaPendingCredential': mfaInfoWithCredential.mfaPendingCredential,
      'phoneVerificationInfo': <String, String>{
        'sessionInfo': sessionInfo,
        'code': code,
        'phoneNumber': mfaInfoWithCredential.phoneInfo,
      },
    };
    return _post(method: method, body: body);
  }

  // ref. https://cloud.google.com/identity-platform/docs/reference/rest/v1/accounts/signInWithPassword
  Future<ApiResponse> signInWithEmailAndPasswordForMFA({
    required String email,
    required String password,
  }) async {
    const method = 'accounts:signInWithPassword';
    final body = <String, dynamic>{
      'email': email,
      'password': password,
    };
    return _post(
      method: method,
      body: body,
      pathPrefix: '/v1',
    );
  }
}
