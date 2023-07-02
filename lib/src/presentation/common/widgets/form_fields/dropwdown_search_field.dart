import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:launchlab/src/config/app_theme.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';

class DropdownSearchFieldWidget<T> extends StatelessWidget {
  DropdownSearchFieldWidget({
    super.key,
    required this.focusNode,
    required this.label,
    required this.getItems,
    this.isFilterOnline = false,
    required this.onChangedHandler,
    required this.compareFnHandler,
    this.selectedItem,
    this.hint,
    this.errorText,
  });
  final _dropdownKey = GlobalKey<DropdownSearchState<T>>();
  final FocusNode focusNode;
  final String label;
  final String? hint;
  final Future<List<T>> Function(String) getItems;
  final bool isFilterOnline;
  final T? selectedItem;
  final void Function(T?) onChangedHandler;
  final bool Function(T, T) compareFnHandler;
  final String? errorText;

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
            key: _dropdownKey,
            popupProps: PopupProps.menu(
              isFilterOnline: isFilterOnline,
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
              loadingBuilder: (context, searchEntry) => Container(
                color: blackColor,
                child: const Center(child: CircularProgressIndicator()),
              ),
              errorBuilder: (context, searchEntry, exception) {
                return const Center(
                    child: Text(
                  "Error occured please try again.",
                  style: TextStyle(color: whiteColor),
                ));
              },
            ),
            itemAsString: (item) => item.toString(),
            asyncItems: getItems,
            onChanged: onChangedHandler,
            compareFn: compareFnHandler,
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
        ...() {
          if (errorText != null) {
            return [smallText(errorText!, color: errorColor)];
          }
          return [];
        }(),
        const SizedBox(
          height: 20,
        )
      ],
    );
  }
}

class DropdownSearchFieldMultiWidget<T> extends StatelessWidget {
  DropdownSearchFieldMultiWidget({
    super.key,
    required this.focusNode,
    required this.label,
    required this.getItems,
    required this.isChipsOutside,
    this.isFilterOnline = false,
    required this.selectedItems,
    required this.onChangedHandler,
    required this.compareFnHandler,
    this.errorText,
  });
  final _dropdownKey = GlobalKey<DropdownSearchState<T>>();
  final FocusNode focusNode;
  final String label;
  final Future<List<T>> Function(String) getItems;
  final bool isChipsOutside;
  final bool isFilterOnline;
  final List<T> selectedItems;
  final void Function(List<T>) onChangedHandler;
  final bool Function(T, T) compareFnHandler;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
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
        DropdownSearch<T>.multiSelection(
          key: _dropdownKey,
          popupProps: PopupPropsMultiSelection.menu(
            loadingBuilder: (context, searchEntry) => Container(
              color: blackColor,
              child: const Center(child: CircularProgressIndicator()),
            ),
            isFilterOnline: isFilterOnline, // for repeated api calls
            showSearchBox: true,
            showSelectedItems: false,
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
            errorBuilder: (context, searchEntry, exception) {
              return const Center(
                  child: Text(
                "Error occured please try again.",
                style: TextStyle(color: whiteColor),
              ));
            },
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
          selectedItems: selectedItems,
          compareFn: compareFnHandler,
          dropdownDecoratorProps: DropDownDecoratorProps(
            dropdownSearchDecoration: InputDecoration(
              fillColor: whiteColor,
              filled: true,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Colors.grey.shade400, width: 0.25),
                  borderRadius: const BorderRadius.all(Radius.circular(10.0))),
            ),
          ),
          dropdownBuilder: (context, selectedItems) {
            if (isChipsOutside || selectedItems.isEmpty) {
              return const ListTile(
                  dense: true,
                  minVerticalPadding: 0,
                  visualDensity: VisualDensity.compact,
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    "Search an interest / skill name",
                    style: TextStyle(
                      color: Colors.grey,
                      height: 1.0,
                    ),
                  ));
            } else {
              return chipsWrap(selectedItems, onDeleteHandler: (value) {
                List<T>? newSelectedItems =
                    _dropdownKey.currentState?.getSelectedItems;

                newSelectedItems?.remove(value);

                _dropdownKey.currentState
                    ?.changeSelectedItems(newSelectedItems ?? []);
              });
            }
          },
        ),
        ...() {
          List<Widget> widgets = [];
          if (errorText != null) {
            widgets.add(smallText(errorText!, color: errorColor));
          }

          if (isChipsOutside) {
            widgets.add(chipsWrap<T>(selectedItems, onDeleteHandler: (value) {
              List<T>? newSelectedItems =
                  _dropdownKey.currentState?.getSelectedItems;

              newSelectedItems?.remove(value);

              _dropdownKey.currentState
                  ?.changeSelectedItems(newSelectedItems ?? []);
            }));
          }

          return widgets;
        }(),
      ],
    );
  }
}
