import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_identity_platform_mfa/scaffold_messenger_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tsuruo_kit/providers/navigator.dart';
import 'package:tsuruo_kit/widgets/barrier/progress_controller.dart';

import '../gcloud_api_client.dart';
import 'mfa_verification_modal.dart';

final mfaEnrollmentController = Provider.autoDispose(
  (ref) {
    final controller = MFAEnrollmentController(ref.read);
    ref.onDispose(controller.dispose);
    return controller;
  },
);

// state: sessionInfo
class MFAEnrollmentController {
  MFAEnrollmentController(this._read);

  final Reader _read;
  final phoneNumberTextController = TextEditingController();
  ScaffoldMessengerState get _messenger =>
      _read(scaffoldMessengerProvider).currentState!;
  NavigatorState get _navigator => _read(navigatorProvider).currentState!;

  // TODO(tsuruoka): 面倒なので日本国内に限定
  String get phoneNumber => phoneNumberTextController.text.length > 1
      ? '+81${phoneNumberTextController.text.substring(1)}'
      : '';

  Future<void> sendVerificationCode() async {
    final response = await _read(progressController).executeWithProgress(
      () => _read(gcloudApiClient).startMFAEnrollment(
        phoneNumber: phoneNumber,
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
    final phoneSessionInfo =
        response.json!['phoneSessionInfo'] as Map<String, dynamic>;
    final sessionInfo = phoneSessionInfo['sessionInfo'].toString();
    _messenger.showSnackBar(
      const SnackBar(
        content: Text('Send verification successfully.'),
      ),
    );

    // 認証コードを受け取る
    final code = await showModalBottomSheet<String>(
          context: _navigator.context,
          builder: (context) => const MFAVerificationModal(),
        ) ??
        '';

    // finalize
    final finalizeResponse =
        await _read(progressController).executeWithProgress(
      () => _read(gcloudApiClient).finalizeMFAEnrollment(
        sessionInfo: sessionInfo,
        code: code,
        phoneNumber: phoneNumber,
      ),
    );
    if (!finalizeResponse.success) {
      _messenger.showSnackBar(
        SnackBar(
          content: Text(finalizeResponse.exception!.code),
        ),
      );
      return;
    }
    // enrollment success.
    _messenger.showSnackBar(
      const SnackBar(
        content: Text('MFA Enrollment successfully 🎉🎉🎉'),
      ),
    );
    Navigator.pop(_navigator.context);
  }

  void dispose() {
    phoneNumberTextController.dispose();
  }
}
