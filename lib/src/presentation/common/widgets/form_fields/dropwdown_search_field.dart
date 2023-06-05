import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:launchlab/src/config/app_theme.dart';

class DropdownSearchFieldWidget<T> extends StatelessWidget {
  const DropdownSearchFieldWidget({
    super.key,
    required this.focusNode,
    required this.label,
    required this.getItems,
    required this.onChangedHandler,
    this.selectedItem,
    this.hint,
  });

  final FocusNode focusNode;
  final String label;
  final String? hint;
  final Future<List<T>> Function(String) getItems;
  final T? selectedItem;
  final void Function(T?) onChangedHandler;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...() {
          if (label == "") {
            return [];
          }
          return [
            Text(
              label,
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
            ),
            const SizedBox(
              height: 5,
            )
          ];
        }(),
        Focus(
          focusNode: focusNode,
          child: DropdownSearch<T>(
            popupProps: PopupProps.menu(
              showSearchBox: true,
              showSelectedItems: true,
              searchFieldProps: TextFieldProps(
                decoration: InputDecoration(
                  filled: true,
                  hintText: "Search",
                  fillColor: Colors.grey.shade800,
                ),
                style: const TextStyle(color: whiteColor),
              ),
              menuProps: const MenuProps(
                backgroundColor: blackColor,
              ),
              itemBuilder: (context, item, isSelected) {
                return ListTile(
                    title: Text(item.toString(),
                        style: TextStyle(
                            color: isSelected ? yellowColor : whiteColor)));
              },
            ),
            itemAsString: (item) => item.toString(),
            asyncItems: getItems,
            onChanged: onChangedHandler,
            selectedItem: selectedItem,
            dropdownDecoratorProps: DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                fillColor: whiteColor,
                filled: true,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.grey.shade400, width: 0.25),
                    borderRadius:
                        const BorderRadius.all(Radius.circular(10.0))),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        )
      ],
    );
  }
}
