import 'package:flutter/material.dart';
import 'package:gosheep_mobile/core/utils/format_helper.dart';
import 'package:gosheep_mobile/core/widgets/custom_textfield.dart';
import 'package:gosheep_mobile/core/widgets/toast_widget.dart';
import 'package:gosheep_mobile/data/models/pregnancy.dart';
import 'package:gosheep_mobile/data/providers/pregnant_sheep_provider.dart';
import 'package:provider/provider.dart';

class EditPregnancySheet extends StatefulWidget {
  final Pregnancy pregnancy;

  const EditPregnancySheet({super.key, required this.pregnancy});

  @override
  State<EditPregnancySheet> createState() => _EditPregnancySheetState();
}

class _EditPregnancySheetState extends State<EditPregnancySheet> {
  final _formKey = GlobalKey<FormState>();

  late DateTime _expectedBirthDate;
  DateTime? _endDate;
  late String _selectedStatus;
  late final TextEditingController _notesController;
  late final TextEditingController _totalLambsController;
  late final TextEditingController _birthNotesController;

  @override
  void initState() {
    super.initState();
    _expectedBirthDate = widget.pregnancy.expectedBirthDate;
    _endDate = widget.pregnancy.endDate ?? DateTime.now();
    _selectedStatus = widget.pregnancy.status;
    _notesController = TextEditingController(text: widget.pregnancy.notes ?? '');
    _totalLambsController = TextEditingController(
      text: widget.pregnancy.birth?.totalLambs.toString() ?? '',
    );
    _birthNotesController = TextEditingController(
      text: widget.pregnancy.birth?.birthNotes ?? '',
    );
  }

  @override
  void dispose() {
    _notesController.dispose();
    _totalLambsController.dispose();
    _birthNotesController.dispose();
    super.dispose();
  }

  void _dismissKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
    FocusScope.of(context).requestFocus(FocusNode());
  }

  Future<void> _pickExpectedBirthDate() async {
    _dismissKeyboard();
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      initialDate: _expectedBirthDate,
    );

    if (picked != null && mounted) {
      setState(() => _expectedBirthDate = picked);
    }
  }

  Future<void> _pickEndDate() async {
    _dismissKeyboard();
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)), // allow slight future for flexibility
      initialDate: _endDate ?? DateTime.now(),
    );

    if (picked != null && mounted) {
      setState(() => _endDate = picked);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final targetExpectedStr = _expectedBirthDate.toIso8601String().split('T')[0];
    final originalExpectedStr = widget.pregnancy.expectedBirthDate.toIso8601String().split('T')[0];

    final hasEndDate = _selectedStatus == 'birthed' || _selectedStatus == 'miscarried';
    final targetEndStr = hasEndDate ? (_endDate ?? DateTime.now()).toIso8601String().split('T')[0] : null;
    final originalEndStr = widget.pregnancy.endDate?.toIso8601String().split('T')[0];

    final targetNotes = _notesController.text.trim();
    final originalNotes = (widget.pregnancy.notes ?? '').trim();

    final targetTotalLambs = _selectedStatus == 'birthed'
        ? int.tryParse(_totalLambsController.text.trim())
        : null;
    final originalTotalLambs = widget.pregnancy.birth?.totalLambs;

    final targetBirthNotes = _birthNotesController.text.trim();
    final originalBirthNotes = (widget.pregnancy.birth?.birthNotes ?? '').trim();

    final isUnchanged =
        widget.pregnancy.status == _selectedStatus &&
        originalExpectedStr == targetExpectedStr &&
        originalEndStr == targetEndStr &&
        originalNotes == targetNotes &&
        originalTotalLambs == targetTotalLambs &&
        originalBirthNotes == targetBirthNotes;

    if (isUnchanged) {
      ToastService.show(
        context,
        'Tidak ada perubahan data kehamilan untuk disimpan.',
        title: 'Info',
        type: ToastType.warning,
      );
      return;
    }

    final provider = context.read<PregnantSheepProvider>();

    final success = await provider.updatePregnancy(
      widget.pregnancy.id,
      expectedBirthDate: targetExpectedStr,
      status: _selectedStatus,
      endDate: targetEndStr,
      notes: targetNotes.isEmpty ? null : targetNotes,
      totalLambs: targetTotalLambs,
      birthNotes: targetBirthNotes.isEmpty ? null : targetBirthNotes,
    );

    if (!mounted) return;

    if (success) {
      Navigator.pop(context, true);
      ToastService.show(
        context,
        'Data kehamilan berhasil diperbarui.',
        title: 'Berhasil!',
        type: ToastType.success,
      );
    } else {
      ToastService.show(
        context,
        provider.error ?? 'Gagal memperbarui data kehamilan',
        title: 'Gagal!',
        type: ToastType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    final screenHeight = MediaQuery.of(context).size.height;
    final isDoneStatus = _selectedStatus == 'birthed' || _selectedStatus == 'miscarried';

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
                            'Edit Kehamilan',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Perbarui status dan perkiraan kelahiran indukan',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _statusField(),
                      const SizedBox(height: 16),
                      _dateField(
                        label: 'Tanggal Perkiraan Lahir',
                        date: _expectedBirthDate,
                        onTap: _pickExpectedBirthDate,
                      ),
                      if (isDoneStatus) ...[
                        const SizedBox(height: 16),
                        _dateField(
                          label: _selectedStatus == 'birthed'
                              ? 'Tanggal Melahirkan'
                              : 'Tanggal Keguguran',
                          date: _endDate,
                          onTap: _pickEndDate,
                        ),
                      ],
                      if (_selectedStatus == 'birthed') ...[
                        const SizedBox(height: 16),
                        CustomTextFormField(
                          label: 'Jumlah Anak',
                          hint: 'Masukkan jumlah anak yang lahir',
                          icon: Icons.pets_rounded,
                          controller: _totalLambsController,
                          keyboardType: TextInputType.number,
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return 'Jumlah anak wajib diisi';
                            }
                            final n = int.tryParse(val.trim());
                            if (n == null || n < 1 || n > 20) {
                              return 'Jumlah anak harus antara 1–20 ekor';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        CustomTextFormField(
                          label: 'Catatan Kelahiran',
                          hint: 'Mis. 2 jantan 1 betina (opsional)',
                          icon: Icons.child_care_rounded,
                          controller: _birthNotesController,
                        ),
                      ],
                      const SizedBox(height: 16),
                      CustomTextFormField(
                        label: 'Catatan Kehamilan',
                        hint: 'Masukkan catatan kehamilan',
                        icon: Icons.notes,
                        controller: _notesController,
                      ),
                      const SizedBox(height: 24),
                      Consumer<PregnantSheepProvider>(
                        builder: (_, provider, __) => _submitButton(provider.isUpdating),
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

  Widget _statusField() {
    final statusConfig = {
      'ongoing': {
        'label': 'Bunting (Sedang Berjalan)',
        'color': const Color(0xFF2E7D52),
        'icon': Icons.pregnant_woman_rounded,
      },
      'birthed': {
        'label': 'Melahirkan',
        'color': const Color(0xFF1E88E5),
        'icon': Icons.child_care_rounded,
      },
      'miscarried': {
        'label': 'Keguguran',
        'color': Colors.red.shade700,
        'icon': Icons.warning_rounded,
      },
    };

    return FormField<String>(
      validator: (_) {
        if (_selectedStatus.isEmpty) {
          return 'Status kehamilan wajib dipilih';
        }
        return null;
      },
      builder: (field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Status Kehamilan',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            ...statusConfig.entries.map((entry) {
              final statusKey = entry.key;
              final config = entry.value;
              final isSelected = _selectedStatus == statusKey;
              final color = config['color'] as Color;
              final icon = config['icon'] as IconData;
              final label = config['label'] as String;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedStatus = statusKey;
                  });
                  field.didChange(statusKey);
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isSelected ? color : Colors.grey.shade300,
                      width: isSelected ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    color: isSelected
                        ? color.withValues(alpha: 0.08)
                        : Colors.transparent,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isSelected
                            ? Icons.radio_button_checked
                            : Icons.radio_button_off,
                        size: 20,
                        color: isSelected ? color : Colors.grey.shade400,
                      ),
                      const SizedBox(width: 10),
                      Icon(icon, size: 16, color: color),
                      const SizedBox(width: 8),
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.normal,
                          color: isSelected ? color : Colors.black87,
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

  Widget _dateField({
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 18,
                  color: Colors.grey.shade500,
                ),
                const SizedBox(width: 8),
                Text(
                  date == null ? 'Pilih tanggal' : FormatHelper.formatDate(date),
                  style: TextStyle(
                    fontSize: 13,
                    color: date == null ? Colors.grey.shade500 : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
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
        backgroundColor: Theme.of(context).colorScheme.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
