import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_identity_platform_mfa/sign_in_page.dart';
import 'package:simple_logger/simple_logger.dart';

import 'logger.dart';

Future<void> main() async {
  logger.setLevel(Level.FINEST, includeCallerInfo: true);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Identity Platform MFA Demo',
      theme: ThemeData.from(
        colorScheme: const ColorScheme.light(),
      ),
      initialRoute: SignInPage.routeName,
      routes: <String, WidgetBuilder>{
        SignInPage.routeName: (context) => const SignInPage(),
      },
    );
  }
}
