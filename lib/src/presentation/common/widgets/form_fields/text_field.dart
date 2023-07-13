import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:formz/formz.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';

/// Define FormzInput
class TextFieldInput extends FormzInput<String, TextFieldError> {
  const TextFieldInput.unvalidated([String value = '']) : super.pure(value);
  const TextFieldInput.validated([String value = '']) : super.dirty(value);

  @override
  TextFieldError? validator(String value) {
    if (value.trim().isEmpty) {
      return TextFieldError.empty;
    }
    return null;
  }
}

class NotReqTextFieldInput extends FormzInput<String, TextFieldError> {
  const NotReqTextFieldInput.unvalidated([String value = ''])
      : super.pure(value);
  const NotReqTextFieldInput.validated([String value = ''])
      : super.dirty(value);

  @override
  TextFieldError? validator(String value) {
    return null;
  }
}

enum TextFieldError {
  empty,
}

extension TextFieldErrorExt on TextFieldError {
  String text() {
    switch (this) {
      case TextFieldError.empty:
        return "Field is required";
    }
  }
}

/// Widget

class TextFieldWidget extends StatefulWidget {
  const TextFieldWidget({
    super.key,
    required this.focusNode,
    required this.onChangedHandler,
    required this.label,
    required this.value,
    required this.hint,
    this.errorText,
    this.endSpacing = true,
    this.size = 1,
    required this.controller,
    this.keyboard = TextInputType.multiline,
    this.inputFormatter = const [],
    this.prefixWidget,
    this.suffixWidget,
  });

  final FocusNode focusNode;
  final void Function(String) onChangedHandler;
  final String label;
  final String value;
  final String hint;
  final String? errorText;
  final bool endSpacing;
  final int size;
  final TextEditingController controller;
  final TextInputType keyboard;
  final List<TextInputFormatter> inputFormatter;
  final Widget? prefixWidget;
  final Widget? suffixWidget;

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.controller.text = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return userInput(
      endSpacing: widget.endSpacing,
      prefixWidget: widget.prefixWidget,
      suffixWidget: widget.suffixWidget,
      focusNode: widget.focusNode,
      controller: widget.controller,
      onChangedHandler: widget.onChangedHandler,
      label: widget.label,
      hint: widget.hint,
      errorText: widget.errorText,
      size: widget.size,
      keyboard: widget.keyboard,
      inputFormatter: widget.inputFormatter,
    );
  }
}
