import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../utils/failure.dart';

/// Auth Repository Interface
/// A blueprint to specify the app logic

abstract class AuthRepositoryImpl {
  /// Sign in
  Future<Either<Failure, void>> signinWithGoogle();

  /// Get the auth current session
  Session? getCurrentAuthSession();

  /// Sign out
  Future<void> signOut();
}
