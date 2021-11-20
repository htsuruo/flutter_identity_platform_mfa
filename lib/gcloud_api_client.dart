import 'dart:convert';

import 'package:flutter_identity_platform_mfa/auth_repository.dart';
import 'package:flutter_identity_platform_mfa/mfa_info_with_credential.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import 'logger.dart';

final gcloudApiClient = Provider(
  (ref) => GcloudApiClient(ref.read),
);

class GcloudApiClient {
  GcloudApiClient(this._read);
  final Reader _read;
  static const _domain = 'identitytoolkit.googleapis.com';
  static const _pathPrefix = '/v2/accounts';
  static const _apiKey = 'xxx';
  static const _headers = <String, String>{
    'content-type': 'application/json',
  };

  Future<String?> _post({
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
      if (response.statusCode != 200) {
        return null;
      }
      return response.body;
    } on Exception catch (e) {
      logger.warning(e);
    }
  }

  Future<void> startMFAEnrollment() async {
    const method = 'mfaEnrollment:start';
    final body = <String, dynamic>{
      'idToken': await _read(authRepository).getIdToken(),
      'phoneEnrollmentInfo': <String, String>{
        'phoneNumber': '+11231231234',
      },
    };
    final responseBody = await _post(method: method, body: body);
    if (responseBody == null) {
      return;
    }
    final json = jsonDecode(responseBody) as Map<String, dynamic>;
    final phoneSessionInfo = json['phoneSessionInfo'] as Map<String, dynamic>;
    final sessionInfo = phoneSessionInfo['sessionInfo'].toString();
    logger.fine(sessionInfo);

    // TODO(tsuruoka): 仮
    await finalizeMFAEnrollment(
      sessionInfo: sessionInfo,
      code: '123456',
      phoneNumber: '+11231231234',
    );
  }

  Future<void> finalizeMFAEnrollment({
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
    final responseBody = await _post(method: method, body: body);
    logger.fine(responseBody);
  }

  // ref. https://cloud.google.com/identity-platform/docs/reference/rest/v2/accounts.mfaSignIn/start
  Future<String> startMFASignIn({
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
    final responseBody = await _post(method: method, body: body);
    if (responseBody == null) {
      return '';
    }
    final json = jsonDecode(responseBody) as Map<String, dynamic>;
    final phoneSessionInfo = json['phoneResponseInfo'] as Map<String, dynamic>;
    final sessionInfo = phoneSessionInfo['sessionInfo'].toString();
    return sessionInfo;
  }

  // ref. https://cloud.google.com/identity-platform/docs/reference/rest/v2/accounts.mfaSignIn/start
  Future<void> finalizeMFASignIn({
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
    final responseBody = await _post(method: method, body: body) ?? '';
    final json = jsonDecode(responseBody) as Map<String, dynamic>;
    final idToken = json['idToken'].toString();
    logger.info('idToken: $idToken');
  }

  // ref. https://cloud.google.com/identity-platform/docs/reference/rest/v1/accounts/signInWithPassword
  Future<MFAInfoWithCredential?> signInWithEmailAndPasswordForMFA({
    required String email,
    required String password,
  }) async {
    const method = 'accounts:signInWithPassword';
    final body = <String, dynamic>{
      'email': email,
      'password': password,
    };
    final responseBody = await _post(
      method: method,
      body: body,
      pathPrefix: '/v1',
    );
    if (responseBody == null) {
      return null;
    }
    final json = jsonDecode(responseBody) as Map<String, dynamic>;
    final mfaPendingCredential = json['mfaPendingCredential'].toString();
    final mfaInfo = json['mfaInfo'] as List<dynamic>;
    return MFAInfoWithCredential(
      mfaPendingCredential: mfaPendingCredential,
      mfaInfo: mfaInfo.first as Map<String, dynamic>,
    );
  }
}
