import 'package:flutter/material.dart';
import 'package:gosheep_mobile/core/constants/form_options.dart';
import 'package:gosheep_mobile/core/utils/validators.dart';
import 'package:gosheep_mobile/core/widgets/custom_dropdown_search.dart';
import 'package:gosheep_mobile/core/widgets/custom_textfield.dart';
import 'package:gosheep_mobile/core/widgets/sheep_picker_field.dart';
import 'package:gosheep_mobile/core/widgets/toast_widget.dart';
import 'package:gosheep_mobile/data/models/cage_option.dart';
import 'package:gosheep_mobile/data/models/sheep_option.dart';
import 'package:gosheep_mobile/data/providers/sheep_form_option_provider.dart';
import 'package:gosheep_mobile/data/providers/sheep_provider.dart';
import 'package:provider/provider.dart';

class AddSheepSheet extends StatefulWidget {
  const AddSheepSheet({super.key});

  @override
  State<AddSheepSheet> createState() => _AddSheepSheetState();
}

class _AddSheepSheetState extends State<AddSheepSheet> {
  final _formKey = GlobalKey<FormState>();

  final _earTag = TextEditingController();
  final _weight = TextEditingController();
  final _color = TextEditingController();
  final _notes = TextEditingController();
  final _condition = TextEditingController();

  String? _gender;
  DateTime? _birthDate;

  SheepOption? _selectedBreed;
  CageOption? _selectedCage;

  SheepOption? _selectedSire;
  SheepOption? _selectedDam;

  String? _selectedCategory;
  String? _selectedSeverity;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = context.read<SheepFormOptionProvider>();

      await Future.wait([
        provider.loadBreedOptions(),
        provider.loadCageOptions(),
      ]);
    });
  }

  Future<void> _pickDate() async {
    _dismissKeyboard();

    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDate: DateTime.now(),
    );

    if (picked != null) {
      context.read<SheepProvider>().clearValidationError('birth_date');
      setState(() => _birthDate = picked);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final provider = context.read<SheepProvider>();

    final success = await provider.createSheep(
      earTag: _earTag.text.trim(),
      earTagColor: _color.text.trim(),
      gender: FormOptions.genders[_gender]!,
      birthDate: _birthDate!.toIso8601String(),
      breedId: _selectedBreed?.id,
      cageId: _selectedCage?.id,
      sireId: _selectedSire?.id,
      damId: _selectedDam?.id,
      condition: _condition.text.trim(),
      category: FormOptions.categories[_selectedCategory]!,
      severity: FormOptions.severities[_selectedSeverity]!,
      weight: double.parse(_weight.text),
      notes: _notes.text.trim().isEmpty ? null : _notes.text.trim(),
    );

    if (!mounted) return;

    if (success) {
      Navigator.pop(context);

      ToastService.show(
        context,
        provider.message,
        title: 'Berhasil Menambah!',
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
      provider.error ?? "Gagal menambah domba",
      title: 'Gagal Menambah Domba!',
      type: ToastType.error,
    );
  }

  void _dismissKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();

    FocusScope.of(context).requestFocus(FocusNode());
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
    final isCreating = context.watch<SheepProvider>().isCreating;

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
        style: TextStyle(color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(46),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SheepFormOptionProvider>();
    final sheepProvider = context.watch<SheepProvider>();
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
                              serverError: sheepProvider.fieldError('eartag'),
                              validator: (v) =>
                                  Validators.required(v, 'Eartag'),
                              onChanged: (_) =>
                                  sheepProvider.clearValidationError('eartag'),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: CustomTextFormField(
                              label: 'Warna Eartag',
                              hint: 'Putih',
                              icon: Icons.color_lens,
                              controller: _color,
                              serverError: sheepProvider.fieldError(
                                'eartag_color',
                              ),
                              validator: (v) =>
                                  Validators.required(v, 'Warna Eartag'),
                              onChanged: (_) => sheepProvider
                                  .clearValidationError('eartag_color'),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      Row(
                        children: [
                          Expanded(
                            child: CustomDropdownSearch<String>(
                              icon: Icons.wc,
                              label: 'Gender',
                              hint: 'Pilih gender',
                              items: (_) => FormOptions.genders.keys.toList(),
                              selectedItem: _gender,
                              serverError: sheepProvider.fieldError('gender'),
                              validator: (v) =>
                                  Validators.requiredDropdown(v, 'Gender'),
                              onSelected: (v) {
                                sheepProvider.clearValidationError('gender');
                                _dismissKeyboard();
                                setState(() => _gender = v);
                              },
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: _dateField(
                              sheepProvider.fieldError('birth_date'),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      CustomDropdownSearch<SheepOption>(
                        icon: Icons.pets,
                        label: 'Breed',
                        hint: 'Pilih breed',
                        items: (_) => provider.breedOptions,
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

                      _sectionHeader(
                        'Data Tambahan',
                        'Kandang, kesehatan & lainnya',
                      ),

                      const SizedBox(height: 16),

                      CustomDropdownSearch<CageOption>(
                        icon: Icons.home,
                        label: 'Kandang',
                        hint: 'Pilih kandang',
                        items: (_) => provider.cageOptions,
                        selectedItem: _selectedCage,
                        itemAsString: (item) => item.name,
                        compareFn: (a, b) => a.id == b.id,
                        onSelected: (v) {
                          _dismissKeyboard();

                          setState(() {
                            _selectedCage = v;
                          });
                        },
                        validator: (v) =>
                            Validators.requiredDropdown(v, 'Kandang'),
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

                      Row(
                        children: [
                          Expanded(
                            child: CustomTextFormField(
                              label: 'Kondisi',
                              hint: 'Sehat',
                              icon: Icons.medical_services_rounded,
                              controller: _condition,
                              serverError: sheepProvider.fieldError(
                                'condition',
                              ),
                              validator: (v) =>
                                  Validators.required(v, 'Kondisi'),
                              onChanged: (_) => sheepProvider
                                  .clearValidationError('condition'),
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: CustomTextFormField(
                              label: 'Berat (kg)',
                              hint: '35',
                              icon: Icons.scale,
                              controller: _weight,
                              keyboardType: TextInputType.number,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              serverError: sheepProvider.fieldError('weight'),
                              validator: (v) => Validators.weight(v),
                              onChanged: (_) =>
                                  sheepProvider.clearValidationError('weight'),
                            ),
                          ),
                        ],
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
                              serverError: sheepProvider.fieldError('category'),
                              validator: (v) =>
                                  Validators.requiredDropdown(v, 'Kategori'),
                              onSelected: (v) {
                                sheepProvider.clearValidationError('category');
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
                              serverError: sheepProvider.fieldError('severity'),
                              validator: (v) =>
                                  Validators.requiredDropdown(v, 'Keparahan'),
                              onSelected: (v) {
                                sheepProvider.clearValidationError('severity');
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
}
