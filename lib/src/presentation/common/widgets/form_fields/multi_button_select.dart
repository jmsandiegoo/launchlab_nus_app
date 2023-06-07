import 'package:flutter/material.dart';
import 'package:launchlab/src/config/app_theme.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';

class MultiButtonSingleSelectWidget<T> extends StatelessWidget {
  const MultiButtonSingleSelectWidget(
      {super.key,
      required this.value,
      required this.options,
      required this.colNo,
      required this.onPressHandler});

  final T value;
  final List<T> options;
  final int colNo;
  final void Function(T) onPressHandler;

  List<SelectButton> renderButtons() {
    List<SelectButton> buttons = [];
    for (int i = 0; i < options.length; i++) {
      buttons.add(SelectButton<T>(
          isSelected: options[i] == value,
          label: options[i].toString(),
          value: options[i],
          onPressedHandler: onPressHandler));
    }

    return buttons;
  }

  @override
  Widget build(BuildContext context) {
    List<SelectButton> buttons = renderButtons();

    return Row(
      children: [
        Expanded(
          child: GridView.count(
            crossAxisSpacing: 20.0,
            childAspectRatio: (1 / .4),
            shrinkWrap: true,
            crossAxisCount: colNo,
            children: [...buttons],
          ),
        ),
      ],
    );
  }
}

class MultiButtonMultiSelectWidget<T> extends StatelessWidget {
  const MultiButtonMultiSelectWidget(
      {super.key,
      required this.values,
      required this.options,
      required this.colNo,
      required this.onPressHandler});

  final List<T> values;
  final List<T> options;
  final int colNo;
  final void Function(List<T>) onPressHandler;

  List<SelectButton> renderButtons() {
    List<SelectButton> buttons = [];
    for (int i = 0; i < options.length; i++) {
      bool isSelected = values.contains(options[i]);
      buttons.add(
        SelectButton<T>(
          isSelected: isSelected,
          label: options[i].toString(),
          value: options[i],
          onPressedHandler: (value) {
            List<T> newValues = [...values];
            if (isSelected) {
              newValues.remove(options[i]);
            } else {
              newValues.add(options[i]);
            }
            onPressHandler(newValues);
          },
        ),
      );
    }
    return buttons;
  }

  @override
  Widget build(BuildContext context) {
    List<SelectButton> buttons = renderButtons();
    return Row(
      children: [
        Expanded(
          child: GridView.count(
            crossAxisSpacing: 20.0,
            mainAxisSpacing: 20.0,
            childAspectRatio: (1 / .25),
            shrinkWrap: true,
            crossAxisCount: colNo,
            children: [...buttons],
          ),
        ),
      ],
    );
  }
}

class SelectButton<T> extends StatelessWidget {
  const SelectButton(
      {super.key,
      required this.isSelected,
      required this.label,
      required this.value,
      required this.onPressedHandler});

  final bool isSelected;
  final String label;
  final T value;
  final void Function(T) onPressedHandler;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        onPressed: () => onPressedHandler(value),
        style: OutlinedButton.styleFrom(
          backgroundColor: isSelected ? blackColor : whiteColor,
        ),
        child: bodyText(label,
            size: 12.0, color: isSelected ? whiteColor : blackColor));
  }
}
