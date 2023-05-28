import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
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
      redirectTo: kIsWeb ? null : 'io.supabase.launchlabnus://login-callback/',
    );

    if (!res) {
      return left(const Failure.badRequest());
    }

    return right(null);
  }

  /// instead of having cubit - cubit dependency which is not recommended abstract
  // it in the presentation layer refer to: https://bloclibrary.dev/#/architecture?id=bloc-to-bloc-communication
  @override
  Session? getCurrentAuthSession() {
    return _supabase.client.auth.currentSession;
  }

  @override
  Future<void> signOut() async {
    await _supabase.client.auth.signOut();
  }
}
