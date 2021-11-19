import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_identity_platform_mfa/auth_result.dart';
import 'package:flutter_identity_platform_mfa/logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRepository = Provider((ref) => AuthRepository());

class AuthRepository {
  final _auth = FirebaseAuth.instance;

  Stream<User?> authStateChange() => _auth.authStateChanges();
  Stream<User?> userChanges() => _auth.userChanges();

  Future<void> signOut() => _auth.signOut();

  Future<FirebaseAuthResult> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return FirebaseAuthResult(success: true);
    } on FirebaseAuthException catch (e) {
      logger.warning(e);
      return FirebaseAuthResult(success: false, exception: e);
    }
  }

  Future<FirebaseAuthResult> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return FirebaseAuthResult(success: true);
    } on FirebaseAuthException catch (e) {
      logger.warning(e);
      return FirebaseAuthResult(success: false, exception: e);
    }
  }

  Future<String> getIdToken() => _auth.currentUser!.getIdToken();
}
