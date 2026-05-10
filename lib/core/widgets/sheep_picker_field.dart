import 'package:flutter/material.dart';
import 'package:gosheep_mobile/data/models/sheep_option.dart';
import 'package:gosheep_mobile/core/widgets/sheep_picker_sheet.dart';
import 'package:gosheep_mobile/data/providers/sheep_form_option_provider.dart';
import 'package:provider/provider.dart';

enum SheepPickerType { sire, dam }

class SheepPickerField extends StatelessWidget {
  final String label;
  final String hint;
  final IconData icon;

  final SheepPickerType type;

  final SheepOption? selectedItem;
  final String Function(SheepOption) itemAsString;

  final void Function(SheepOption) onSelected;

  const SheepPickerField({
    super.key,
    required this.label,
    required this.hint,
    required this.icon,
    required this.type,
    this.selectedItem,
    required this.itemAsString,
    required this.onSelected,
  });

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => ChangeNotifierProvider.value(
        value: context.read<SheepFormOptionProvider>(),
        child: SheepPickerSheet(
          title: label,
          type: type,
          initialValue: selectedItem,
          onSelected: onSelected,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        _showPicker(context);
      },
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black12),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                selectedItem != null ? itemAsString(selectedItem!) : hint,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}
