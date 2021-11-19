import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_identity_platform_mfa/mfa_info_with_credential.dart';

class FirebaseAuthResult {
  FirebaseAuthResult({
    required this.type,
    this.exception,
    this.mfaInfoWithCredential,
  });
  final AuthResultType type;
  final FirebaseAuthException? exception;
  final MFAInfoWithCredential? mfaInfoWithCredential;
}

enum AuthResultType {
  success,
  failed,
  mfaChallenge,
}

extension AuthResultTypeX on AuthResultType {
  bool get success => this == AuthResultType.success;
  bool get failed => this == AuthResultType.failed;
}
