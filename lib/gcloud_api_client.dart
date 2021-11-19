import 'dart:convert';

import 'package:flutter_identity_platform_mfa/auth_repository.dart';
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

  Future<void> _post({
    required String method,
    required Map<String, dynamic> body,
  }) async {
    try {
      final uri = Uri.https(
        _domain,
        '$_pathPrefix/$method',
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
    await _post(method: method, body: body);
  }
}
