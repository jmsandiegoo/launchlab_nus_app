import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';

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

class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget(
      {super.key,
      required this.focusNode,
      required this.onChangedHandler,
      required this.label});

  final FocusNode focusNode;
  final void Function(String) onChangedHandler;
  final String label;

  @override
  Widget build(BuildContext context) {
    return userInput(
        focusNode: focusNode, onChangedHandler: onChangedHandler, label: label);
  }
}
