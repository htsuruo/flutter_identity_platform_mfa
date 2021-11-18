import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_identity_platform_mfa/pages/pages.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_logger/simple_logger.dart';

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

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Identity Platform MFA Demo',
      theme: ThemeData.from(
        colorScheme: const ColorScheme.light(),
      ),
      initialRoute: SignInUpPage.routeName,
      routes: <String, WidgetBuilder>{
        SignInUpPage.routeName: (context) => const SignInUpPage(),
        HomePage.routeName: (context) => const HomePage(),
        MFAVerificationPage.routeName: (context) => const MFAVerificationPage(),
      },
    );
  }
}
