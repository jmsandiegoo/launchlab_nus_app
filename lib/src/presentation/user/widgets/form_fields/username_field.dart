import 'dart:async';

import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:launchlab/src/data/user/user_repository.dart';
import 'package:launchlab/src/domain/user/models/requests/check_if_username_exists_request.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UsernameFieldInput extends FormzInput<String, UsernameFieldError> {
  const UsernameFieldInput.unvalidated([String value = '']) : super.pure(value);
  const UsernameFieldInput.validated([String value = '']) : super.dirty(value);

  @override
  UsernameFieldError? validator(String value) {
    if (value.trim().isEmpty) {
      return UsernameFieldError.empty;
    }

    if (value.trim().length < 3 || value.trim().length > 15) {
      return UsernameFieldError.invalidLength;
    }

    if (!RegExp(r'^[a-z0-9_]{3,15}$').hasMatch(value)) {
      return UsernameFieldError.invalidFormat;
    }

    return null;
  }

  Future<bool> isValidAsync(String? currUsername) async =>
      await validatorAsync(currUsername) == null;

  // for unfocus event
  Future<UsernameFieldError?> validatorAsync(String? currUsername) async {
    if (value.trim().isEmpty) {
      return UsernameFieldError.empty;
    }

    if (value.trim().length < 3 || value.trim().length > 15) {
      return UsernameFieldError.invalidLength;
    }

    if (!RegExp(r'^[a-z0-9_]{3,15}(?<!\s)$').hasMatch(value)) {
      return UsernameFieldError.invalidFormat;
    }

    // network call
    try {
      final isExists = await UserRepository(Supabase.instance)
          .checkIfUsernameExists(CheckIfUsernameExistsRequest(
              username: value, currUsername: currUsername));
      print("is username exists: $isExists");
      if (isExists) {
        return UsernameFieldError.exist;
      }

      return null;
    } on Exception catch (error) {
      debugPrint("$error");
      return UsernameFieldError.networkError;
    }
  }
}

enum UsernameFieldError {
  empty,
  invalidLength,
  invalidFormat,
  exist,
  networkError,
}

extension UsernameFieldErrorExt on UsernameFieldError {
  String text() {
    switch (this) {
      case UsernameFieldError.empty:
        return "Username is required";
      case UsernameFieldError.invalidLength:
        return "Username must be 3 to 15 characters long.";
      case UsernameFieldError.invalidFormat:
        return "Username entered is invalid.";
      case UsernameFieldError.exist:
        return "Username is not available";
      case UsernameFieldError.networkError:
        return "Network error occured when checking username. Please retype and submit again.";
    }
  }
}
