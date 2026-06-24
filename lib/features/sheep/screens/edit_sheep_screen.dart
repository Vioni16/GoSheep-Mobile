import 'package:flutter/material.dart';
import 'package:gosheep_mobile/core/constants/form_options.dart';
import 'package:gosheep_mobile/core/utils/validators.dart';
import 'package:gosheep_mobile/core/widgets/custom_dropdown_search.dart';
import 'package:gosheep_mobile/core/widgets/custom_textfield.dart';
import 'package:gosheep_mobile/core/widgets/gender_badge.dart';
import 'package:gosheep_mobile/core/widgets/sheep_picker_field.dart';
import 'package:gosheep_mobile/core/widgets/toast_widget.dart';
import 'package:gosheep_mobile/data/models/cage_option.dart';
import 'package:gosheep_mobile/data/models/sheep_detail.dart';
import 'package:gosheep_mobile/data/models/sheep_option.dart';
import 'package:gosheep_mobile/data/providers/sheep_form_option_provider.dart';
import 'package:gosheep_mobile/data/providers/sheep_detail_provider.dart';
import 'package:provider/provider.dart';

class EditSheepScreen extends StatelessWidget {
  final SheepDetail sheep;

  const EditSheepScreen({super.key, required this.sheep});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SheepDetailProvider()),
        ChangeNotifierProvider(create: (_) => SheepFormOptionProvider()),
      ],
      child: _EditSheepForm(sheep: sheep),
    );
  }
}

class _EditSheepForm extends StatefulWidget {
  final SheepDetail sheep;

  const _EditSheepForm({required this.sheep});

  @override
  State<_EditSheepForm> createState() => _EditSheepFormState();
}

class _EditSheepFormState extends State<_EditSheepForm> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _earTag;
  late final TextEditingController _color;

  String? _gender;
  DateTime? _birthDate;

  SheepOption? _selectedBreed;
  CageOption? _selectedCage;

  SheepOption? _selectedSire;
  SheepOption? _selectedDam;

  String? _selectedStatus;

  @override
  void initState() {
    super.initState();
    _earTag = TextEditingController(text: widget.sheep.earTag);
    _color = TextEditingController(text: widget.sheep.earTagColor);
    _gender = widget.sheep.gender == 'male' ? 'Jantan' : 'Betina';
    _birthDate = widget.sheep.birthDate;

    if (widget.sheep.sire != null) {
      _selectedSire = SheepOption(
        id: widget.sheep.sire!.id,
        label: widget.sheep.sire!.earTag,
      );
    }
    if (widget.sheep.dam != null) {
      _selectedDam = SheepOption(
        id: widget.sheep.dam!.id,
        label: widget.sheep.dam!.earTag,
      );
    }

    _selectedStatus = _statusLabel(widget.sheep.status);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = context.read<SheepFormOptionProvider>();

      await Future.wait([
        provider.loadBreedOptions(),
        provider.loadCageOptions(),
      ]);

      if (widget.sheep.cageId != null) {
        final matchedCage = provider.cageOptions.firstWhere(
          (c) => c.id == widget.sheep.cageId,
          orElse: () => CageOption(
            id: widget.sheep.cageId!,
            name: widget.sheep.cage ?? '',
            currentCapacity: 0,
            maxCapacity: 0,
          ),
        );
        setState(() {
          _selectedCage = matchedCage;
        });
      }

      if (widget.sheep.breedId != null) {
        final matchedBreed = provider.breedOptions.firstWhere(
          (b) => b.id == widget.sheep.breedId,
          orElse: () => SheepOption(
            id: widget.sheep.breedId!,
            label: widget.sheep.breed ?? '',
          ),
        );
        setState(() {
          _selectedBreed = matchedBreed;
        });
      }
    });
  }

  @override
  void dispose() {
    _earTag.dispose();
    _color.dispose();
    super.dispose();
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'active':
        return 'Aktif';
      case 'sold':
        return 'Terjual';
      case 'dead':
        return 'Mati';
      default:
        return 'Aktif';
    }
  }

  String _statusValue(String label) {
    switch (label) {
      case 'Aktif':
        return 'active';
      case 'Terjual':
        return 'sold';
      case 'Mati':
        return 'dead';
      default:
        return 'active';
    }
  }

  void _dismissKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
    FocusScope.of(context).requestFocus(FocusNode());
  }

  Future<void> _pickDate() async {
    _dismissKeyboard();

    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDate: _birthDate ?? DateTime.now(),
    );

    if (picked != null) {
      if (mounted) {
        context.read<SheepDetailProvider>().clearValidationError('birth_date');
      }
      setState(() => _birthDate = picked);
    }
  }

  Future<void> _submit() async {
    _dismissKeyboard();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final provider = context.read<SheepDetailProvider>();

    final data = <String, dynamic>{
      'eartag': _earTag.text.trim(),
      'eartag_color': _color.text.trim(),
      'gender': FormOptions.genders[_gender]!,
      'birth_date': _birthDate!.toIso8601String().split('T')[0],
      'breed_id': _selectedBreed?.id,
      'cage_id': _selectedCage?.id,
      'sire_id': _selectedSire?.id,
      'dam_id': _selectedDam?.id,
      'status': _statusValue(_selectedStatus!),
    };

    final success = await provider.updateSheep(widget.sheep.id, data);

    if (!mounted) return;

    if (success) {
      Navigator.pop(context, true);

      ToastService.show(
        context,
        'Data domba berhasil diperbarui',
        title: 'Berhasil Update!',
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
      provider.error ?? "Gagal memperbarui data domba",
      title: 'Gagal Update!',
      type: ToastType.error,
    );
  }

  Widget _genderField(String? serverError) {
    final genderOptions = FormOptions.genders.keys.toList();
    final genderValues = FormOptions.genders.values.toList();

    return FormField<String>(
      validator: (_) {
        if (_gender == null) {
          return 'Gender wajib dipilih';
        }
        return serverError;
      },
      builder: (field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Gender',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(genderOptions.length, (index) {
                final option = genderOptions[index];
                final value = genderValues[index];
                final isSelected = _gender == option;

                return GestureDetector(
                  onTap: () {
                    context.read<SheepDetailProvider>().clearValidationError(
                      'gender',
                    );
                    setState(() => _gender = option);
                    field.didChange(option);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isSelected ? Colors.green : Colors.grey.shade400,
                        width: isSelected ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      color: isSelected
                          ? Colors.green.withValues(alpha: 0.1)
                          : Colors.transparent,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GenderBadge(gender: value),
                        const SizedBox(height: 8),
                        Text(
                          option,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                            color: isSelected ? Colors.green : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
            if (field.hasError) ...[
              const SizedBox(height: 8),
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

  Widget _dateField(String? serverError) {
    return FormField<DateTime>(
      validator: (_) {
        if (_birthDate == null) {
          return 'Tanggal Lahir wajib diisi';
        }
        return serverError;
      },
      builder: (field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tanggal Lahir',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 6),
            GestureDetector(
              onTap: () async {
                _dismissKeyboard();
                await _pickDate();
                field.didChange(_birthDate);
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
                      _birthDate == null
                          ? 'Pilih tanggal'
                          : _birthDate.toString().split(' ')[0],
                      style: TextStyle(
                        fontSize: 13,
                        color: _birthDate == null
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

  Widget _submitButton() {
    final isUpdating = context.watch<SheepDetailProvider>().isUpdating;

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
    final optionProvider = context.watch<SheepFormOptionProvider>();
    final detailProvider = context.watch<SheepDetailProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Domba',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            letterSpacing: 0.3,
          ),
        ),
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionHeader('Data Domba', 'Informasi identitas domba'),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: CustomTextFormField(
                      label: 'Eartag',
                      hint: 'D-001',
                      icon: Icons.tag,
                      controller: _earTag,
                      serverError: detailProvider.fieldError('eartag'),
                      validator: (v) => Validators.required(v, 'Eartag'),
                      onChanged: (_) =>
                          detailProvider.clearValidationError('eartag'),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomTextFormField(
                      label: 'Warna Eartag',
                      hint: 'Putih',
                      icon: Icons.color_lens,
                      controller: _color,
                      serverError: detailProvider.fieldError('eartag_color'),
                      validator: (v) => Validators.required(v, 'Warna Eartag'),
                      onChanged: (_) =>
                          detailProvider.clearValidationError('eartag_color'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              _genderField(detailProvider.fieldError('gender')),
              const SizedBox(height: 14),
              _dateField(detailProvider.fieldError('birth_date')),
              const SizedBox(height: 14),
              CustomDropdownSearch<SheepOption>(
                icon: Icons.pets,
                label: 'Breed',
                hint: 'Pilih breed',
                items: (_) => optionProvider.breedOptions,
                selectedItem: _selectedBreed,
                itemAsString: (item) => item.label,
                compareFn: (a, b) => a.id == b.id,
                onSelected: (v) {
                  _dismissKeyboard();
                  setState(() {
                    _selectedBreed = v;
                  });
                },
              ),
              const SizedBox(height: 24),
              _sectionHeader('Data Tambahan', 'Kandang, keturunan & status'),
              const SizedBox(height: 16),
              CustomDropdownSearch<CageOption>(
                icon: Icons.home,
                label: 'Kandang',
                hint: 'Pilih kandang',
                items: (_) => optionProvider.cageOptions,
                selectedItem: _selectedCage,
                itemAsString: (item) => item.name,
                compareFn: (a, b) => a.id == b.id,
                onSelected: (v) {
                  _dismissKeyboard();
                  setState(() {
                    _selectedCage = v;
                  });
                },
                validator: (v) => Validators.requiredDropdown(v, 'Kandang'),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: SheepPickerField(
                      label: 'Sire',
                      hint: 'Pilih sire',
                      icon: Icons.male,
                      type: SheepPickerType.sire,
                      selectedItem: _selectedSire,
                      itemAsString: (item) => item.label,
                      onSelected: (item) {
                        _dismissKeyboard();
                        setState(() {
                          _selectedSire = item;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SheepPickerField(
                      label: 'Dam',
                      hint: 'Pilih dam',
                      icon: Icons.female,
                      type: SheepPickerType.dam,
                      selectedItem: _selectedDam,
                      itemAsString: (item) => item.label,
                      onSelected: (item) {
                        _dismissKeyboard();
                        setState(() {
                          _selectedDam = item;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              CustomDropdownSearch<String>(
                icon: Icons.info_outline,
                label: 'Status Domba',
                hint: 'Pilih status',
                items: (_) => ['Aktif', 'Terjual', 'Mati'],
                selectedItem: _selectedStatus,
                serverError: detailProvider.fieldError('status'),
                validator: (v) =>
                    Validators.requiredDropdown(v, 'Status Domba'),
                onSelected: (v) {
                  detailProvider.clearValidationError('status');
                  _dismissKeyboard();
                  setState(() => _selectedStatus = v);
                },
              ),
              const SizedBox(height: 32),
              _submitButton(),
            ],
          ),
        ),
      ),
    );
  }
}
