import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:launchlab/src/domain/authentication/repositories/auth_repository_impl.dart';
import 'package:launchlab/src/domain/user/models/user_entity.dart';
import 'package:launchlab/src/utils/failure.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
  Future<void> signinWithGoogle() async {
    var res = await _supabase.client.auth.signInWithOAuth(
      Provider.google,
      redirectTo: kIsWeb ? null : 'io.supabase.launchlabnus://login-callback/',
    );

    if (!res) {
      throw const Failure.badRequest();
    }
  }

  /// instead of having cubit - cubit dependency which is not recommended abstract
  // it in the presentation layer refer to: https://bloclibrary.dev/#/architecture?id=bloc-to-bloc-communication
  @override
  Session? getCurrentAuthSession() {
    return _supabase.client.auth.currentSession;
  }

  // only use when there is a current session
  @override
  Future<UserEntity?> getAuthUserProfile() async {
    if (getCurrentAuthSession() == null) {
      return null;
    }

    try {
      final res = await _supabase.client
          .from("users")
          .select<PostgrestList>("*")
          .eq('id', _supabase.client.auth.currentSession!.user.id);

      if (res.isEmpty) {
        return null;
      } else {
        return UserEntity.fromJson(res[0]);
      }
    } on Exception catch (error) {
      print("getAuthUserProfile error: ${error}");
      throw const Failure.badRequest();
    }
  }

  @override
  Future<void> signOut() async {
    await _supabase.client.auth.signOut();
  }
}
