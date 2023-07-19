import 'dart:io';
import 'package:formz/formz.dart';

class UserResumeFieldInput extends FormzInput<File?, UserResumeFieldError> {
  const UserResumeFieldInput.unvalidated([File? value]) : super.pure(value);
  const UserResumeFieldInput.validated([File? value]) : super.dirty(value);

  @override
  UserResumeFieldError? validator(File? value) {
    // Size check todo in the future
    return null;
  }
}

enum UserResumeFieldError {
  sizeTooLarge,
}
