import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';

/// Define FormzInput
class TextFieldInput extends FormzInput<String, TextFieldError> {
  const TextFieldInput.unvalidated([String value = '']) : super.pure(value);
  const TextFieldInput.validated([String value = '']) : super.dirty(value);

  @override
  TextFieldError? validator(String value) {
    if (value.isEmpty) {
      return TextFieldError.empty;
    }
    return null;
  }
}

enum TextFieldError {
  empty,
}

/// Widget
class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget({
    super.key,
    required this.focusNode,
    required this.onChangedHandler,
    required this.label,
    required this.hint,
    this.size = 1,
  });

  final FocusNode focusNode;
  final void Function(String) onChangedHandler;
  final String label;
  final String hint;
  final int size;

  @override
  Widget build(BuildContext context) {
    return userInput(
        focusNode: focusNode,
        onChangedHandler: onChangedHandler,
        label: label,
        hint: hint,
        size: size);
  }
}
