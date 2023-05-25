import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../domain/authentication/repositories/auth_repository_impl.dart';
import '../../../utils/failure.dart';

class AuthRepository implements AuthRepositoryImpl {
  StreamSubscription<AuthState>? _subscription;

  final Supabase _supabase;
  AuthRepository(this._supabase);

  void listenToAuth(void Function(AuthState data) streamHandler) {
    _subscription = _supabase.client.auth.onAuthStateChange
        .listen((event) => streamHandler(event));
  }

  void stopListenToAuth() {
    _subscription?.cancel();
  }

  @override
  Future<Either<Failure, void>> signinWithGoogle() async {
    var res = await _supabase.client.auth.signInWithOAuth(
      Provider.google,
    );

    if (!res) {
      return left(const Failure.badRequest());
    }

    return right(null);
  }

  @override
  Future<void> signOut() async {
    await _supabase.client.auth.signOut();
  }
}
