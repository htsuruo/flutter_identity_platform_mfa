import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_identity_platform_mfa/authenticator.dart';
import 'package:flutter_identity_platform_mfa/page/page.dart';
import 'package:flutter_identity_platform_mfa/scaffold_messenger_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_logger/simple_logger.dart';
import 'package:tsuruo_kit/tsuruo_kit.dart';

import 'logger.dart';

Future<void> main() async {
  logger.setLevel(Level.FINEST, includeCallerInfo: true);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}

class App extends ConsumerWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    const lightScheme = ColorScheme.light();
    final user = ref.watch(authenticator).value;
    return MaterialApp(
      navigatorKey: ref.watch(navigatorProvider),
      scaffoldMessengerKey: ref.watch(scaffoldMessengerProvider),
      title: 'Identity Platform MFA Demo',
      theme: ThemeData.from(
        colorScheme: lightScheme,
      ).copyWith(
        appBarTheme: AppBarTheme(
          foregroundColor: lightScheme.primary,
          backgroundColor: colorScheme.surface,
          elevation: 0,
          titleTextStyle: theme.textTheme.bodyText1!.copyWith(
            fontWeight: FontWeight.bold,
            color: lightScheme.primary,
          ),
        ),
        snackBarTheme: const SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
        ),
        dividerTheme: const DividerThemeData(space: 0),
      ),
      home: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        switchInCurve: Curves.easeIn,
        switchOutCurve: Curves.easeOut,
        child: user == null ? const SignInUpPage() : const HomePage(),
      ),
      builder: (context, child) {
        return ProgressHUD(
          child: child!,
        );
      },
    );
  }
}
