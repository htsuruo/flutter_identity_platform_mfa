import 'package:flutter/material.dart';
import 'package:flutter_identity_platform_mfa/auth_repository.dart';
import 'package:flutter_identity_platform_mfa/authenticator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:tsuruo_kit/tsuruo_kit.dart';

class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  static const routeName = '/home';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final user = ref.watch(authenticator).value!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'uid: ${user.uid}\n'
              'displayName: ${user.displayName}\n'
              'email: ${user.email}\n'
              'emailVerified: ${user.emailVerified}\n'
              'lastSignInTime: ${user.metadata.lastSignInTime}\n'
              'providerId: ${user.providerData.first.providerId}\n',
              style: theme.textTheme.bodyText2!.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(44),
            OutlinedButton(
              onPressed: () async {
                await ref.read(progressController).executeWithProgress(
                      () => ref.read(authRepository).signOut(),
                    );
              },
              child: const Text('Logout'),
            )
          ],
        ),
      ),
    );
  }
}
