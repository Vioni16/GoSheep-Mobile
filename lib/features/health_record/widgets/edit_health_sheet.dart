import 'package:flutter/material.dart';
import 'package:gosheep_mobile/core/constants/form_options.dart';
import 'package:gosheep_mobile/core/utils/validators.dart';
import 'package:gosheep_mobile/core/widgets/custom_dropdown_search.dart';
import 'package:gosheep_mobile/core/widgets/custom_textfield.dart';
import 'package:gosheep_mobile/core/widgets/toast_widget.dart';
import 'package:gosheep_mobile/data/models/health.dart';
import 'package:gosheep_mobile/data/providers/health_record_provider.dart';
import 'package:provider/provider.dart';

class EditHealthSheet extends StatefulWidget {
  final Health health;

  const EditHealthSheet({super.key, required this.health});

  @override
  State<EditHealthSheet> createState() => _EditHealthSheetState();
}

class _EditHealthSheetState extends State<EditHealthSheet> {
  final _formKey = GlobalKey<FormState>();

  late final _conditionController = TextEditingController(
    text: widget.health.condition,
  );
  late final _notesController = TextEditingController(
    text: widget.health.notes ?? '',
  );

  // Reverse lookup: value -> label (e.g. 'health' -> 'Kesehatan')
  String? _selectedCategory;
  String? _selectedSeverity;

  @override
  void initState() {
    super.initState();

    // Cari label yang sesuai dengan value dari health
    _selectedCategory = FormOptions.categories.entries
        .firstWhere(
          (e) => e.value == widget.health.category,
          orElse: () =>
              MapEntry(widget.health.category, widget.health.category),
        )
        .key;

    _selectedSeverity = FormOptions.severities.entries
        .firstWhere(
          (e) => e.value == widget.health.severity,
          orElse: () =>
              MapEntry(widget.health.severity, widget.health.severity),
        )
        .key;
  }

  @override
  void dispose() {
    _conditionController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final newCondition = _conditionController.text.trim();
    final newCategory =
        FormOptions.categories[_selectedCategory] ?? _selectedCategory!;
    final newSeverity =
        FormOptions.severities[_selectedSeverity] ?? _selectedSeverity!;
    final newNotesNormalized = _notesController.text.trim();
    final oldNotesNormalized = (widget.health.notes ?? '').trim();

    final isUnchanged =
        newCondition == widget.health.condition &&
        newCategory == widget.health.category &&
        newSeverity == widget.health.severity &&
        newNotesNormalized == oldNotesNormalized;

    if (isUnchanged) {
      ToastService.show(
        context,
        'Tidak ada perubahan data rekam medis untuk disimpan.',
        title: 'Info',
        type: ToastType.warning,
      );
      return;
    }

    final provider = context.read<HealthRecordProvider>();

    final success = await provider.updateHealthRecord(
      recordId: widget.health.id,
      condition: newCondition,
      category: newCategory,
      severity: newSeverity,
      notes: newNotesNormalized.isEmpty ? null : newNotesNormalized,
    );

    if (!mounted) return;

    if (success) {
      Navigator.pop(context, true);

      ToastService.show(
        context,
        provider.message,
        title: 'Berhasil Diperbarui!',
        type: ToastType.success,
      );

      return;
    }

    ToastService.show(
      context,
      provider.error ?? 'Gagal memperbarui rekam medis',
      title: 'Gagal Memperbarui!',
      type: ToastType.error,
    );
  }

  void _dismissKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
    FocusScope.of(context).requestFocus(FocusNode());
  }

  Widget _sectionHeader(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
        ),
      ],
    );
  }

  Widget _submitButton(bool isUpdating) {
    return ElevatedButton.icon(
      onPressed: isUpdating ? null : _submit,
      icon: isUpdating
          ? const SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : const Icon(Icons.save_alt_rounded, size: 14),
      label: Text(
        isUpdating ? 'Menyimpan...' : 'Simpan Perubahan',
        style: const TextStyle(color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(46),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    final screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: Container(
        constraints: BoxConstraints(maxHeight: screenHeight * 0.85),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 4),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Divider(height: 1),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionHeader(
                        'Edit Rekam Medis',
                        'Perbarui informasi kesehatan domba',
                      ),

                      const SizedBox(height: 16),

                      CustomTextFormField(
                        label: 'Kondisi',
                        hint: 'Sehat',
                        icon: Icons.medical_services_rounded,
                        controller: _conditionController,
                        validator: (v) => Validators.required(v, 'Kondisi'),
                      ),

                      const SizedBox(height: 14),

                      Row(
                        children: [
                          Expanded(
                            child: CustomDropdownSearch<String>(
                              icon: Icons.category,
                              label: 'Kategori',
                              hint: 'Pilih kategori',
                              items: (_) =>
                                  FormOptions.categories.keys.toList(),
                              selectedItem: _selectedCategory,
                              validator: (v) =>
                                  Validators.requiredDropdown(v, 'Kategori'),
                              onSelected: (v) {
                                _dismissKeyboard();
                                setState(() => _selectedCategory = v);
                              },
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: CustomDropdownSearch<String>(
                              icon: Icons.warning_amber_rounded,
                              label: 'Keparahan',
                              hint: 'Pilih keparahan',
                              items: (_) =>
                                  FormOptions.severities.keys.toList(),
                              selectedItem: _selectedSeverity,
                              validator: (v) =>
                                  Validators.requiredDropdown(v, 'Keparahan'),
                              onSelected: (v) {
                                _dismissKeyboard();
                                setState(() => _selectedSeverity = v);
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      CustomTextFormField(
                        label: 'Catatan',
                        hint: 'Opsional',
                        icon: Icons.notes,
                        controller: _notesController,
                      ),

                      const SizedBox(height: 24),

                      Consumer<HealthRecordProvider>(
                        builder: (_, provider, __) =>
                            _submitButton(provider.isCreating),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
