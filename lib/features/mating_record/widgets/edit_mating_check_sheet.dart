import 'package:flutter/material.dart';
import 'package:gosheep_mobile/core/constants/form_options.dart';
import 'package:gosheep_mobile/core/enums/mating_result_enum.dart';
import 'package:gosheep_mobile/core/widgets/custom_textfield.dart';
import 'package:gosheep_mobile/core/widgets/toast_widget.dart';
import 'package:gosheep_mobile/data/models/mating_check.dart';
import 'package:gosheep_mobile/data/providers/mating_check_provider.dart';
import 'package:gosheep_mobile/data/providers/mating_record_provider.dart';
import 'package:provider/provider.dart';

class EditMatingCheckSheet extends StatefulWidget {
  final int matingRecordId;
  final MatingCheck matingCheck;
  final MatingResult currentResult;

  const EditMatingCheckSheet({
    super.key,
    required this.matingRecordId,
    required this.matingCheck,
    required this.currentResult,
  });

  @override
  State<EditMatingCheckSheet> createState() => _EditMatingCheckSheetState();
}

class _EditMatingCheckSheetState extends State<EditMatingCheckSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _notes;

  DateTime? _checkDate;
  DateTime? _expectedBirthDate;
  String? _selectedResult;

  @override
  void initState() {
    super.initState();
    _notes = TextEditingController(text: widget.matingCheck.notes ?? '');
    _checkDate = widget.matingCheck.checkDate;
    _expectedBirthDate = widget.matingCheck.expectedBirthDate;

    final apiValue = widget.currentResult.toApiValue();
    _selectedResult = FormOptions.matingCheckResults.entries
        .firstWhere(
          (entry) => entry.value == apiValue,
          orElse: () => FormOptions.matingCheckResults.entries.first,
        )
        .key;
  }

  @override
  void dispose() {
    _notes.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    _dismissKeyboard();

    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDate: _checkDate ?? DateTime.now(),
    );

    if (picked != null && mounted) {
      context.read<MatingCheckProvider>().clearValidationError('check_date');
      setState(() => _checkDate = picked);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final targetResult = FormOptions.matingCheckResults[_selectedResult]!;
    final targetNotes = _notes.text.trim().isEmpty ? null : _notes.text.trim();
    final targetDate = _checkDate!;

    final originalApiResult = widget.currentResult.toApiValue();
    final originalNotes = widget.matingCheck.notes;
    final originalDate = widget.matingCheck.checkDate;

    final originalDateStr = originalDate.toIso8601String().split('T')[0];
    final targetDateStr = targetDate.toIso8601String().split('T')[0];

    final originalExpectedBirthDateStr = widget.matingCheck.expectedBirthDate
        ?.toIso8601String()
        .split('T')[0];
    final targetExpectedBirthDateStr =
        targetResult == 'pregnant' && _expectedBirthDate != null
        ? _expectedBirthDate!.toIso8601String().split('T')[0]
        : null;

    if (originalApiResult == targetResult &&
        originalNotes == targetNotes &&
        originalDateStr == targetDateStr &&
        originalExpectedBirthDateStr == targetExpectedBirthDateStr) {
      ToastService.show(
        context,
        'Tidak ada perubahan data untuk disimpan.',
        title: 'Info',
        type: ToastType.warning,
      );
      return;
    }

    final provider = context.read<MatingCheckProvider>();

    final success = await provider.updateMatingCheck(
      matingCheckId: widget.matingCheck.id,
      checkDate: targetDateStr,
      result: targetResult,
      notes: targetNotes,
      expectedBirthDate: targetExpectedBirthDateStr,
    );

    if (!mounted) return;

    if (success) {
      try {
        context.read<MatingRecordProvider>().updateResult(
          widget.matingRecordId,
          MatingResult.fromString(targetResult),
        );
      } catch (_) {}

      Navigator.pop(context);

      ToastService.show(
        context,
        provider.message,
        title: 'Berhasil!',
        type: ToastType.success,
      );

      return;
    }

    if (provider.validationError != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _formKey.currentState!.validate();
      });
      return;
    }

    ToastService.show(
      context,
      provider.error ?? 'Gagal memperbarui pemeriksaan',
      title: 'Gagal!',
      type: ToastType.error,
    );
  }

  void _dismissKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
    FocusScope.of(context).requestFocus(FocusNode());
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
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Edit Pemeriksaan',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Ubah hasil pemeriksaan kawin',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _dateField(
                        context.read<MatingCheckProvider>().fieldError(
                          'check_date',
                        ),
                      ),
                      const SizedBox(height: 16),
                      _resultField(),

                      if (_selectedResult != null &&
                          FormOptions.matingCheckResults[_selectedResult] ==
                              'pregnant') ...[
                        const SizedBox(height: 16),
                        _expectedBirthDateField(
                          context.read<MatingCheckProvider>().fieldError(
                            'expected_birth_date',
                          ),
                        ),
                      ],

                      const SizedBox(height: 16),
                      CustomTextFormField(
                        label: 'Catatan',
                        hint: 'Opsional',
                        icon: Icons.notes,
                        controller: _notes,
                      ),
                      const SizedBox(height: 24),
                      _submitButton(),
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

  Widget _dateField(String? serverError) {
    return FormField<DateTime>(
      validator: (_) {
        if (_checkDate == null) {
          return 'Tanggal pemeriksaan wajib diisi';
        }
        return serverError;
      },
      builder: (field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tanggal Pemeriksaan',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 6),
            GestureDetector(
              onTap: () async {
                _dismissKeyboard();
                await _pickDate();
                field.didChange(_checkDate);
              },
              child: Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: field.hasError ? Colors.red : Colors.grey.shade400,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 18,
                      color: Colors.grey.shade500,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _checkDate == null
                          ? 'Pilih tanggal'
                          : _checkDate.toString().split(' ')[0],
                      style: TextStyle(
                        fontSize: 13,
                        color: _checkDate == null
                            ? Colors.grey.shade500
                            : Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (field.hasError) ...[
              const SizedBox(height: 6),
              Text(
                field.errorText!,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _resultField() {
    final results = FormOptions.matingCheckResults;

    return FormField<String>(
      validator: (_) {
        if (_selectedResult == null) {
          return 'Hasil pemeriksaan wajib dipilih';
        }
        return null;
      },
      builder: (field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hasil Pemeriksaan',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            ...results.keys.map((label) {
              final isSelected = _selectedResult == label;
              final apiValue = results[label]!;
              final result = MatingResult.fromString(apiValue);

              return GestureDetector(
                onTap: () {
                  setState(() => _selectedResult = label);
                  field.didChange(label);
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isSelected ? result.color : Colors.grey.shade300,
                      width: isSelected ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    color: isSelected
                        ? result.color.withValues(alpha: 0.08)
                        : Colors.transparent,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isSelected
                            ? Icons.radio_button_checked
                            : Icons.radio_button_off,
                        size: 20,
                        color: isSelected ? result.color : Colors.grey.shade400,
                      ),
                      const SizedBox(width: 10),
                      Icon(result.icon, size: 16, color: result.color),
                      const SizedBox(width: 8),
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.normal,
                          color: isSelected ? result.color : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
            if (field.hasError) ...[
              const SizedBox(height: 4),
              Text(
                field.errorText!,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _submitButton() {
    final isCreating = context.watch<MatingCheckProvider>().isCreating;

    return ElevatedButton.icon(
      onPressed: isCreating ? null : _submit,
      icon: isCreating
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
        isCreating ? 'Menyimpan...' : 'Simpan Perubahan',
        style: const TextStyle(color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(46),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _expectedBirthDateField(String? serverError) {
    return FormField<DateTime>(
      validator: (_) {
        if (_expectedBirthDate == null) {
          return 'Tanggal perkiraan lahir wajib diisi jika status bunting';
        }
        return serverError;
      },
      builder: (field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tanggal Perkiraan Lahir',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 6),
            GestureDetector(
              onTap: () async {
                _dismissKeyboard();
                final picked = await showDatePicker(
                  context: context,
                  firstDate: DateTime.now().subtract(const Duration(days: 30)),
                  lastDate: DateTime.now().add(const Duration(days: 200)),
                  initialDate:
                      _expectedBirthDate ??
                      DateTime.now().add(const Duration(days: 147)),
                );
                if (picked != null && mounted) {
                  context.read<MatingCheckProvider>().clearValidationError(
                    'expected_birth_date',
                  );
                  setState(() => _expectedBirthDate = picked);
                  field.didChange(_expectedBirthDate);
                }
              },
              child: Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: field.hasError ? Colors.red : Colors.grey.shade400,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 18,
                      color: Colors.grey.shade500,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _expectedBirthDate == null
                          ? 'Pilih tanggal perkiraan lahir'
                          : _expectedBirthDate.toString().split(' ')[0],
                      style: TextStyle(
                        fontSize: 13,
                        color: _expectedBirthDate == null
                            ? Colors.grey.shade500
                            : Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (field.hasError) ...[
              const SizedBox(height: 6),
              Text(
                field.errorText!,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ],
          ],
        );
      },
    );
  }
}
