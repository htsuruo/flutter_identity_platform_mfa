import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthResult {
  FirebaseAuthResult({
    required this.success,
    this.exception,
  });
  final bool success;
  final FirebaseAuthException? exception;
}
