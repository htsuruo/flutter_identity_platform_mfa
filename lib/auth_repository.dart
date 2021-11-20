import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_identity_platform_mfa/gcloud_api_client.dart';
import 'package:flutter_identity_platform_mfa/logger.dart';
import 'package:flutter_identity_platform_mfa/model/firebase_auth_result.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'model/mfa_info_with_credential.dart';

final authRepository = Provider((ref) => AuthRepository(ref.read));

class AuthRepository {
  AuthRepository(this._read);
  final _auth = FirebaseAuth.instance;
  final Reader _read;

  Stream<User?> authStateChange() => _auth.authStateChanges();
  Stream<User?> userChanges() => _auth.userChanges();
  Future<void> signOut() => _auth.signOut();
  Future<void> reload() => _auth.currentUser!.reload();
  Future<String> getIdToken() => _auth.currentUser!.getIdToken();

  Future<FirebaseAuthResult> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return FirebaseAuthResult(type: AuthResultType.success);
    } on FirebaseAuthException catch (e) {
      logger.warning(e);
      return FirebaseAuthResult(type: AuthResultType.failed, exception: e);
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
      return FirebaseAuthResult(type: AuthResultType.success);
    } on FirebaseAuthException catch (e) {
      logger.warning(e);
      if (e.code == 'second-factor-required') {
        final response =
            await _read(gcloudApiClient).signInWithEmailAndPasswordForMFA(
          email: email,
          password: password,
        );
        if (response.success) {
          final mfaPendingCredential =
              response.json!['mfaPendingCredential'].toString();
          final mfaInfo = response.json!['mfaInfo'] as List<dynamic>;
          final mfaInfoWithCredential = MFAInfoWithCredential(
            mfaPendingCredential: mfaPendingCredential,
            mfaInfo: mfaInfo.first as Map<String, dynamic>,
          );
          // MFA Challenge
          final mfaResponse = await _read(gcloudApiClient).startMFASignIn(
            mfaInfoWithCredential: mfaInfoWithCredential,
          );
          if (mfaResponse.success) {
            final phoneSessionInfo =
                mfaResponse.json!['phoneResponseInfo'] as Map<String, dynamic>;
            final sessionInfo = phoneSessionInfo['sessionInfo'].toString();
            return FirebaseAuthResult(
              type: AuthResultType.mfaChallenge,
              mfaInfoWithCredential: mfaInfoWithCredential.sessionInfoCopyWith(
                sessionInfo: sessionInfo,
              ),
            );
          }
        }
      }
      return FirebaseAuthResult(type: AuthResultType.failed, exception: e);
    }
  }

  Future<FirebaseAuthResult> sendEmailVerification() async {
    try {
      await _auth.currentUser!.sendEmailVerification();
      return FirebaseAuthResult(type: AuthResultType.success);
    } on FirebaseAuthException catch (e) {
      logger.warning(e);
      return FirebaseAuthResult(type: AuthResultType.failed, exception: e);
    }
  }
}
