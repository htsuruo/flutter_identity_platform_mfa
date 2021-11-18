import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MFAVerificationPage extends ConsumerWidget {
  const MFAVerificationPage({Key? key}) : super(key: key);

  static const routeName = '/mfa_verification';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MFA Verification'),
      ),
    );
  }
}
