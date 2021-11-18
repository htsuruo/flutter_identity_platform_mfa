import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_identity_platform_mfa/logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final authRepository = Provider((ref) => AuthRepository());

class AuthRepository {
  final _auth = FirebaseAuth.instance;
  static const _domain = 'identitytoolkit.googleapis.com';
  static const _pathPrefix = '/v2/accounts';

  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      logger.info(userCredential);
    } on FirebaseAuthException catch (e) {
      logger.warning(e);
    }
  }

  Future<void> mfaSetup() async {
    try {
      final uri = Uri.https(_domain, '$_pathPrefix/mfaEnrollment:start');
      final headers = <String, String>{
        'content-type': 'application/json',
        'key': 'xxx',
      };
      final body = <String, String>{
        'idToken': await _auth.currentUser!.getIdToken(),
        'phoneEnrollmentInfo': '{phoneNumber:xxx}',
      };
      final response = await http.post(
        uri,
        headers: headers,
        body: jsonEncode(body),
      );
      logger.info('${response.statusCode}: ${response.body}');
    } on FirebaseException catch (e) {
      logger.warning(e);
    }
  }
}
