import 'package:flutter/material.dart';
import 'package:gosheep_mobile/core/constants/form_options.dart';
import 'package:gosheep_mobile/core/enums/mating_result_enum.dart';
import 'package:gosheep_mobile/core/theme/theme.dart';
import 'package:gosheep_mobile/core/utils/format_helper.dart';
import 'package:gosheep_mobile/core/widgets/custom_textfield.dart';
import 'package:gosheep_mobile/core/widgets/toast_widget.dart';
import 'package:gosheep_mobile/data/models/mating_record.dart';
import 'package:gosheep_mobile/data/providers/mating_check_provider.dart';
import 'package:gosheep_mobile/data/providers/mating_record_provider.dart';
import 'package:provider/provider.dart';

class MatingCheckSheet extends StatefulWidget {
  final MatingRecord matingRecord;

  const MatingCheckSheet({super.key, required this.matingRecord});

  @override
  State<MatingCheckSheet> createState() => _MatingCheckSheetState();
}

class _MatingCheckSheetState extends State<MatingCheckSheet> {
  bool _isFormMode = false;

  final _formKey = GlobalKey<FormState>();
  final _notes = TextEditingController();

  DateTime? _checkDate;
  String? _selectedResult;

  @override
  void dispose() {
    _notes.dispose();
    super.dispose();
  }

  void _switchToForm() {
    setState(() {
      _isFormMode = true;
      _checkDate = null;
      _selectedResult = null;
      _notes.clear();
    });
  }

  void _switchToList() {
    setState(() => _isFormMode = false);
  }

  Future<void> _pickDate() async {
    _dismissKeyboard();

    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDate: DateTime.now(),
    );

    if (picked != null && mounted) {
      context.read<MatingCheckProvider>().clearValidationError('check_date');
      setState(() => _checkDate = picked);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<MatingCheckProvider>();

    final success = await provider.createMatingCheck(
      checkDate: _checkDate!.toIso8601String().split('T')[0],
      result: FormOptions.matingCheckResults[_selectedResult]!,
      notes: _notes.text.trim().isEmpty ? null : _notes.text.trim(),
    );

    if (!mounted) return;

    if (success) {
      try {
        final resultValue =
            FormOptions.matingCheckResults[_selectedResult]!;
        context.read<MatingRecordProvider>().updateResult(
              widget.matingRecord.id,
              MatingResult.fromString(resultValue),
            );
      } catch (_) {}

      ToastService.show(
        context,
        provider.message,
        title: 'Berhasil!',
        type: ToastType.success,
      );

      _switchToList();
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
      provider.error ?? 'Gagal menambah pemeriksaan',
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

            Flexible(child: _isFormMode ? _buildForm() : _buildList()),
          ],
        ),
      ),
    );
  }

  Widget _buildList() {
    final provider = context.watch<MatingCheckProvider>();
    final matingRecord = context.watch<MatingRecordProvider>().matingRecords.firstWhere(
          (r) => r.id == widget.matingRecord.id,
          orElse: () => widget.matingRecord,
        );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Riwayat Pemeriksaan',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${matingRecord.ramEarTag} × ${matingRecord.eweEarTag}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.cream,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      matingRecord.result.icon,
                      size: 13,
                      color: matingRecord.result.color,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      matingRecord.result.label,
                      style: TextStyle(
                        color: matingRecord.result.color,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        Flexible(child: _buildListContent(provider)),

        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
          child: ElevatedButton.icon(
            onPressed: _switchToForm,
            icon: const Icon(Icons.add_rounded, size: 18),
            label: const Text(
              'Tambah Pemeriksaan',
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(46),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildListContent(MatingCheckProvider provider) {
    if (provider.isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (provider.error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, size: 40, color: Colors.grey.shade400),
              const SizedBox(height: 8),
              Text(
                provider.error!,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: provider.fetchMatingChecks,
                child: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      );
    }

    if (provider.matingChecks.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.assignment_outlined,
                size: 40,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 8),
              Text(
                'Belum ada pemeriksaan',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Tambah pemeriksaan pertama',
                style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: provider.matingChecks.length,
      separatorBuilder: (_, __) =>
          Divider(color: Colors.grey.shade100, height: 1),
      itemBuilder: (_, index) {
        final check = provider.matingChecks[index];

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.cream,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.fact_check_outlined,
                  size: 18,
                  color: AppTheme.primaryGreen,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      FormatHelper.formatDate(check.checkDate),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (check.notes != null && check.notes!.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        check.notes!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              Text(
                FormatHelper.timeAgo(check.createdAt),
                style: TextStyle(fontSize: 11, color: Colors.grey.shade400),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildForm() {
    final provider = context.watch<MatingCheckProvider>();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: _switchToList,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.arrow_back_rounded,
                      size: 18,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tambah Pemeriksaan',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Catat hasil pemeriksaan kawin',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            _dateField(provider.fieldError('check_date')),

            const SizedBox(height: 16),

            _resultField(),

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
        isCreating ? 'Menyimpan...' : 'Simpan',
        style: const TextStyle(color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(46),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
