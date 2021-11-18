import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_identity_platform_mfa/logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRepository = Provider((ref) => AuthRepository());

class AuthRepository {
  final _auth = FirebaseAuth.instance;

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
}
