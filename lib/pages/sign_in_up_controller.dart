import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_identity_platform_mfa/auth_repository.dart';
import 'package:flutter_identity_platform_mfa/auth_result.dart';
import 'package:flutter_identity_platform_mfa/gcloud_api_client.dart';
import 'package:flutter_identity_platform_mfa/logger.dart';
import 'package:flutter_identity_platform_mfa/pages/mfa_verification_modal.dart';
import 'package:flutter_identity_platform_mfa/scaffold_messenger_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tsuruo_kit/tsuruo_kit.dart';

final signInUpController = Provider(
  (ref) => SignInUpController(ref.read),
);

class SignInUpController {
  SignInUpController(this._read);
  final Reader _read;
  TextEditingController emailTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();

  ScaffoldMessengerState get _messenger =>
      _read(scaffoldMessengerProvider).currentState!;
  NavigatorState get _navigator => _read(navigatorProvider).currentState!;

  Future<void> signUp() async {
    final result = await _read(progressController).executeWithProgress(
      () => _read(authRepository).createUserWithEmailAndPassword(
        email: emailTextController.text,
        password: passwordTextController.text,
      ),
    );
    if (result.type.failed) {
      _messenger.showSnackBar(
        SnackBar(content: Text(result.exception!.code)),
      );
      return;
    }
  }

  Future<void> signIn() async {
    final result = await _read(progressController).executeWithProgress(
      () => _read(authRepository).signInWithEmailAndPassword(
        email: emailTextController.text,
        password: passwordTextController.text,
      ),
    );
    switch (result.type) {
      case AuthResultType.success:
        break;
      case AuthResultType.mfaChallenge:
        final mfaInfoWithCredential = result.mfaInfoWithCredential!;
        final code = await showModalBottomSheet<String>(
              context: _navigator.context,
              builder: (context) => const MFAVerificationModal(),
            ) ??
            '';
        logger.info('code: $code');
        final response = await _read(progressController).executeWithProgress(
          () => _read(gcloudApiClient).finalizeMFASignIn(
            mfaInfoWithCredential: mfaInfoWithCredential,
            sessionInfo: mfaInfoWithCredential.sessionInfo!,
            code: code,
          ),
        );
        if (!response.success) {
          _messenger.showSnackBar(
            SnackBar(
              content: Text(response.exception!.code),
            ),
          );
          return;
        }
        final idToken = response.json!['idToken'].toString();
        logger.info('idToken: $idToken');
        break;
      case AuthResultType.failed:
        _messenger.showSnackBar(
          SnackBar(content: Text(result.exception!.code)),
        );
        break;
    }
  }
}
