import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_identity_platform_mfa/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authenticator = StreamProvider<User?>(
  (ref) => ref.watch(authRepository).userChanges(),
);
