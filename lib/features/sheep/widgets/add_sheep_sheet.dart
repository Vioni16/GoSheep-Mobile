import 'package:flutter/material.dart';
import 'package:gosheep_mobile/core/constants/form_options.dart';
import 'package:gosheep_mobile/core/utils/validators.dart';
import 'package:gosheep_mobile/core/widgets/custom_textfield.dart';
import 'package:gosheep_mobile/core/widgets/custom_dropdown_search.dart';

class AddSheepSheet extends StatefulWidget {
  final void Function(Map<String, dynamic> data) onAdd;

  const AddSheepSheet({super.key, required this.onAdd});

  @override
  State<AddSheepSheet> createState() => _AddSheepSheetState();
}

class _AddSheepSheetState extends State<AddSheepSheet> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();

  final _earTag = TextEditingController();
  final _weight = TextEditingController();
  final _color = TextEditingController();
  final _notes = TextEditingController();
  final _condition = TextEditingController();

  String? _gender;
  DateTime? _birthDate;

  Map<String, dynamic>? _selectedBreed;
  Map<String, dynamic>? _selectedCage;
  Map<String, dynamic>? _selectedSire;
  Map<String, dynamic>? _selectedDam;

  String? _selectedCategory;
  String? _selectedSeverity;

  static const _totalSteps = 2;

  final breeds = [
    {'id': 1, 'name': 'Dorper'},
    {'id': 2, 'name': 'Suffolk'},
  ];

  final cages = [
    {'id': 1, 'name': 'Kandang A'},
    {'id': 2, 'name': 'Kandang B'},
  ];

  final rams = [
    {'id': 1, 'eartag': 'D-001'},
  ];

  final ewes = [
    {'id': 2, 'eartag': 'D-010'},
  ];

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDate: DateTime.now(),
    );
    if (picked != null) setState(() => _birthDate = picked);
  }

  void _nextStep() {
    if (_currentPage == 0 && !_formKey1.currentState!.validate()) return;
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _prevStep() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _submit() {
    if (!_formKey2.currentState!.validate()) return;
    widget.onAdd({
      'eartag': _earTag.text.trim(),
      'eartag_color': _color.text.trim(),
      'gender': FormOptions.genders[_gender],
      'birth_date': _birthDate?.toIso8601String(),
      'breed': _selectedBreed?['id'],
      'cage': _selectedCage?['id'],
      'sire': _selectedSire?['id'],
      'dam': _selectedDam?['id'],
      'condition': _condition.text.trim(),
      'category': FormOptions.categories[_selectedCategory],
      'severity': FormOptions.severities[_selectedSeverity],
      'weight': double.tryParse(_weight.text),
      'notes': _notes.text.trim().isEmpty
        ? null
        : _notes.text.trim(),
    });
    Navigator.pop(context);
  }

  Widget _buildStepIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_totalSteps * 2 - 1, (i) {
        if (i.isOdd) {
          final filled = _currentPage >= (i ~/ 2) + 1;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 32,
            height: 2,
            color: filled
                ? Theme.of(context).colorScheme.primary
                : Colors.grey.shade300,
          );
        }
        final step = i ~/ 2;
        final isActive = step == _currentPage;
        final isDone = step < _currentPage;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isDone
                ? Theme.of(context).colorScheme.primary
                : isActive
                ? Theme.of(context).colorScheme.primary
                : Colors.grey.shade200,
            border: isActive
                ? Border.all(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  )
                : null,
          ),
          child: Center(
            child: isDone
                ? const Icon(Icons.check, size: 14, color: Colors.white)
                : Text(
                    '${step + 1}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isActive ? Colors.white : Colors.grey.shade500,
                    ),
                  ),
          ),
        );
      }),
    );
  }

  Widget _dateField() {
    return FormField<DateTime>(
      validator: (_) {
        if (_birthDate == null) {
          return 'Tanggal Lahir wajib diisi';
        }
        return null;
      },
      builder: (field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tanggal Lahir',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 6),

            GestureDetector(
              onTap: () async {
                await _pickDate();

                field.didChange(_birthDate);
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: field.hasError
                        ? Colors.red
                        : Colors.grey.shade400,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
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
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                ),
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

  Widget _navButtons({bool isLast = false}) {
    return Row(
      children: [
        if (_currentPage > 0) ...[
          Expanded(
            child: OutlinedButton.icon(
              onPressed: _prevStep,
              icon: const Icon(Icons.arrow_back_ios, size: 14),
              label: const Text('Back'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(46),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
        ],
        Expanded(
          flex: 2,
          child: ElevatedButton.icon(
            onPressed: isLast ? _submit : _nextStep,
            icon: Icon(
              isLast ? Icons.save_alt_rounded : Icons.arrow_forward_ios,
              size: 14,
            ),
            label: Text(isLast ? 'Simpan' : 'Lanjut'),
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

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    final screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: screenHeight * (_currentPage == 0 ? 0.6 : 0.7),
        ),
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

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: _buildStepIndicator(),
            ),

            const Divider(height: 1),

            Flexible(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (i) => setState(() => _currentPage = i),
                children: [_buildStep1(), _buildStep2()],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep1() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      child: Form(
        key: _formKey1,
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
                    validator: (v) => Validators.required(v, 'Eartag'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomTextFormField(
                    label: 'Warna Eartag',
                    hint: 'Putih',
                    icon: Icons.color_lens,
                    controller: _color,
                    validator: (v) => Validators.required(v, 'Warna Eartag'),
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
                    validator: (v) => Validators.requiredDropdown(v, 'Gender'),
                    onSelected: (v) => setState(() => _gender = v),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(child: _dateField()),
              ],
            ),
            const SizedBox(height: 14),

            CustomDropdownSearch<Map<String, dynamic>>(
              icon: Icons.pets,
              label: 'Breed',
              hint: 'Pilih breed',
              items: (_) => breeds,
              selectedItem: _selectedBreed,
              itemAsString: (item) => item['name'],
              compareFn: (a, b) => a['id'] == b['id'],
              onSelected: (v) => setState(() => _selectedBreed = v),
              validator: (v) => Validators.requiredDropdown(v, 'Breed'),
            ),
            const SizedBox(height: 24),

            _navButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildStep2() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      child: Form(
        key: _formKey2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionHeader('Data Tambahan', 'Kandang, kesehatan & lainnya'),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: CustomDropdownSearch<Map<String, dynamic>>(
                    icon: Icons.home,
                    label: 'Kandang',
                    hint: 'Pilih kandang',
                    items: (_) => cages,
                    selectedItem: _selectedCage,
                    itemAsString: (item) => item['name'],
                    compareFn: (a, b) => a['id'] == b['id'],
                    onSelected: (v) => setState(() => _selectedCage = v),
                    validator: (v) => Validators.requiredDropdown(v, 'Kandang'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomDropdownSearch<Map<String, dynamic>>(
                    icon: Icons.male,
                    label: 'Sire (Pejantan/Ayah)',
                    hint: 'Pilih sire',
                    items: (_) => rams,
                    selectedItem: _selectedSire,
                    itemAsString: (item) => item['eartag'],
                    compareFn: (a, b) => a['id'] == b['id'],
                    onSelected: (v) => setState(() => _selectedSire = v),
                    validator: (v) => Validators.requiredDropdown(v, 'Sire'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            Row(
              children: [
                Expanded(
                  child: CustomDropdownSearch<Map<String, dynamic>>(
                    icon: Icons.female,
                    label: 'Dam (Induk)',
                    hint: 'Pilih dam',
                    items: (_) => ewes,
                    selectedItem: _selectedDam,
                    itemAsString: (item) => item['eartag'],
                    compareFn: (a, b) => a['id'] == b['id'],
                    onSelected: (v) => setState(() => _selectedDam = v),
                    validator: (v) => Validators.requiredDropdown(v, 'Dam'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomTextFormField(
                    label: 'Kondisi',
                    hint: 'Sehat',
                    icon: Icons.medical_services_rounded,
                    controller: _condition,
                    keyboardType: TextInputType.text,
                    validator: (v) => Validators.required(v, 'Kondisi'),
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
                    items: (_) => FormOptions.categories.keys.toList(),
                    selectedItem: _selectedCategory,
                    onSelected: (v) => setState(() => _selectedCategory = v),
                    validator: (v) => Validators.requiredDropdown(v, 'Kategori'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomDropdownSearch<String>(
                    icon: Icons.warning_amber_rounded,
                    label: 'Keparahan',
                    hint: 'Pilih Keparahan',
                    items: (_) => FormOptions.severities.keys.toList(),
                    selectedItem: _selectedSeverity,
                    onSelected: (v) => setState(() => _selectedSeverity = v),
                    validator: (v) => Validators.requiredDropdown(v, 'Keparahan'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            Row(
              children: [
                Expanded(
                  child: CustomTextFormField(
                    label: 'Berat (kg)',
                    hint: '35',
                    icon: Icons.scale,
                    controller: _weight,
                    keyboardType: TextInputType.number,
                    validator: (v) => Validators.required(v, 'Berat'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomTextFormField(
                    label: 'Notes',
                    hint: 'Opsional',
                    icon: Icons.notes,
                    controller: _notes,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            _navButtons(isLast: true),
          ],
        ),
      ),
    );
  }
}
