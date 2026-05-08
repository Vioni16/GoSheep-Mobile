import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class CustomDropdownSearch<T> extends StatelessWidget {
  final IconData icon;
  final String? label;
  final String hint;
  final T? selectedItem;
  final List<T> Function(String filter) items;
  final String Function(T)? itemAsString;
  final bool Function(T, T)? compareFn;
  final void Function(T?)? onSelected;
  final String? Function(T?)? validator;
  final bool enabled;
  final bool searchable;

  const CustomDropdownSearch({
    super.key,
    required this.icon,
    required this.items,
    this.label,
    this.hint = '',
    this.selectedItem,
    this.itemAsString,
    this.compareFn,
    this.onSelected,
    this.validator,
    this.enabled = true,
    this.searchable = false,
  });

  InputDecoration get _decoration => InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(color: Colors.black26, fontSize: 14),
    prefixIcon: Icon(
      icon,
      size: 20,
      color: Colors.black.withValues(alpha: 0.4),
    ),
    isDense: true,
    filled: true,
    fillColor: Colors.white,
    hintMaxLines: 1,
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.black.withValues(alpha: 0.1)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.black, width: 1.5),
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.black.withValues(alpha: 0.05)),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.red),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.red, width: 1.5),
    ),
    errorStyle: const TextStyle(fontSize: 12, height: 1.2),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Text(
            label!,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        const SizedBox(height: 8),
        DropdownSearch<T>(
          mode: Mode.form,
          enabled: enabled,
          selectedItem: selectedItem,
          items: (filter, _) => items(filter),
          itemAsString: itemAsString,
          compareFn: compareFn,
          onSelected: onSelected,
          validator: validator,
          decoratorProps: DropDownDecoratorProps(decoration: _decoration),
          popupProps: PopupProps.menu(
            fit: FlexFit.loose,
            showSearchBox: searchable,
          ),
        ),
      ],
    );
  }
}
