import 'package:flutter/material.dart';
import 'package:flutter_identity_platform_mfa/page/mfa_enrollment_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MFAEnrollmentPage extends ConsumerWidget {
  const MFAEnrollmentPage({Key? key}) : super(key: key);

  static const routeName = '/mfa_enrollment';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(mfaEnrollmentController);
    return Scaffold(
      appBar: AppBar(
        title: const Text('MFA Enrollment'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const Text('Please input your phone number'),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 16,
                ),
                child: TextFormField(
                  controller: controller.phoneNumberTextController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    label: Text('Phone Number'),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                  enableSuggestions: false,
                ),
              ),
              OutlinedButton(
                onPressed: controller.sendVerificationCode,
                child: const Text('Send Verification Code'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
