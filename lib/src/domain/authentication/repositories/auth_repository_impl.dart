import 'package:dartz/dartz.dart';

import '../../../utils/failure.dart';

/// Auth Repository Interface
/// A blueprint to specify the app logic

abstract class AuthRepositoryImpl {
  /// Sign in
  Future<Either<Failure, void>> signinWithGoogle();

  /// Sign out
  Future<void> signOut();
}
