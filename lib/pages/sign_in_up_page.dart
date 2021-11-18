import 'package:flutter/material.dart';
import 'package:flutter_identity_platform_mfa/pages/sign_in_up_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class SignInUpPage extends ConsumerWidget {
  const SignInUpPage({Key? key}) : super(key: key);

  static const routeName = '/';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const padding = EdgeInsets.all(16);
    final controller = ref.watch(signInUpController);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In / Sign Up'),
      ),
      body: ListView(
        children: [
          Padding(
            padding: padding,
            child: TextFormField(
              controller: controller.emailTextController,
              decoration: const InputDecoration(
                label: Text('email'),
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
              enableSuggestions: false,
            ),
          ),
          Padding(
            padding: padding,
            child: TextFormField(
              controller: controller.passwordTextController,
              decoration: const InputDecoration(
                label: Text('password'),
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
              obscureText: true,
              enableSuggestions: false,
            ),
          ),
          Padding(
            padding: padding,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: controller.signIn,
                  child: const Text('Sign in'),
                ),
                const Gap(20),
                ElevatedButton(
                  onPressed: controller.signUp,
                  child: const Text('Sign up'),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
