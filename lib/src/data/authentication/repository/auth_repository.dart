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
    _subscription?.cancel(  );
  }

  @override
  Future<void> signinWithGoogle() async {
    try {
      var res = await _supabase.client.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo:
            kIsWeb ? null : 'io.supabase.launchlabnus://login-callback/',
      );

      if (!res) {
        throw Failure.unexpected();
      }
    } on Failure catch (_) {
      rethrow;
    } on AuthException catch (error) {
      debugPrint("Sign in google authenticaton error occured: $error");
      throw Failure.unauthorized(
          code: error.statusCode, message: error.message);
    } on Exception catch (error) {
      debugPrint(
          "Sign in google authenticaton unexpected error occured: $error");
      throw Failure.unexpected();
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
          .select("*")
          .eq('id', _supabase.client.auth.currentSession!.user.id);

      if (res.isEmpty) {
        return null;
      } else {
        return UserEntity.fromJson(res[0]);
      }
    } on PostgrestException catch (error) {
      debugPrint(
          "Get curr user authenticaton profile postgre error occured: $error");
      throw Failure.unauthorized(code: error.code);
    } on Exception catch (error) {
      debugPrint(
          "Sign in google authenticaton unexpected error occured: $error");
      throw Failure.unexpected();
    }
  }

  @override
  Future<void> signOut() async {
    await _supabase.client.auth.signOut();
  }
}
