import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_identity_platform_mfa/pages/pages.dart';
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

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    const lightScheme = ColorScheme.light();
    return MaterialApp(
      title: 'Identity Platform MFA Demo',
      theme: ThemeData.from(
        colorScheme: lightScheme,
      ).copyWith(
        appBarTheme: AppBarTheme(
          foregroundColor: lightScheme.primary,
          backgroundColor: colorScheme.surface,
          elevation: 0,
        ),
      ),
      home: Builder(
        builder: (context) => const ProgressHUD(
          child: SignInUpPage(),
        ),
      ),
      routes: <String, WidgetBuilder>{
        HomePage.routeName: (context) => const HomePage(),
        MFAVerificationPage.routeName: (context) => const MFAVerificationPage(),
      },
    );
  }
}
