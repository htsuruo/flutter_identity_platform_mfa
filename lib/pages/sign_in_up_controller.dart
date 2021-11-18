import 'package:flutter/cupertino.dart';
import 'package:flutter_identity_platform_mfa/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final signInUpController = Provider(
  (ref) => SignInUpController(ref.read),
);

class SignInUpController {
  SignInUpController(this._read);
  final Reader _read;
  TextEditingController emailTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();

  Future<void> signUp() async {
    await _read(authRepository).createUserWithEmailAndPassword(
      email: emailTextController.text,
      password: passwordTextController.text,
    );
  }

  Future<void> signIn() async {}
}
