import 'package:flutter/material.dart';
import 'package:gosheep_mobile/core/widgets/custom_textfield.dart';

class AddHealthSheet extends StatefulWidget {
  const AddHealthSheet({super.key});

  @override
  State<AddHealthSheet> createState() => _AddHealthSheetState();
}

class _AddHealthSheetState extends State<AddHealthSheet> {
  final _formKey = GlobalKey<FormState>();

  final _conditionController = TextEditingController();
  final _notesController = TextEditingController();

  String? _selectedSheep;
  String? _selectedCategory;
  String? _selectedSeverity;

  final List<String> _sheepList = ["ET015", "ET017", "ET020", "ET031"];
  final List<String> _categories = [
    "Pemeriksaan",
    "Vaksinasi",
    "Vitamin",
    "Infeksi",
    "Cedera",
  ];
  final List<String> _severities = ["Ringan", "Sedang", "Berat"];
  String? _selectedExaminer;

  final List<String> _examiners = ["Peternak", "Sistem", "Dokter Hewan"];
  @override
  void dispose() {
    _conditionController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _submitData() {
    if (_formKey.currentState!.validate()) {
      final newData = {
        "id": DateTime.now().millisecondsSinceEpoch,
        "earTag": _selectedSheep,
        "gender": _selectedSheep == "ET017" || _selectedSheep == "ET031"
            ? "Betina"
            : "Jantan",
        "category": _selectedCategory,
        "condition": _conditionController.text,
        "severity": _selectedSeverity,
        "date": "22 Mei 2026",
        "source": "Input Manual",
        "recordedBy": "Peternak",
      };

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Berhasil menambahkan rekam medis!')),
      );

      Navigator.pop(context, newData);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.85,
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Center(
                    child: Text(
                      "Tambah Rekam Medis",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  _buildDropdownLabel("Domba (Ear Tag)"),
                  DropdownButtonFormField<String>(
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    decoration: _dropdownDecoration(
                      Icons.check_circle_outline,
                      "Pilih Domba",
                    ),
                    value: _selectedSheep,
                    items: _sheepList
                        .map(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: Text(
                              e,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (val) => setState(() => _selectedSheep = val),
                    validator: (val) =>
                        val == null ? 'Domba harus dipilih' : null,
                  ),
                  const SizedBox(height: 18),

                  _buildDropdownLabel("Kategori"),
                  DropdownButtonFormField<String>(
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    decoration: _dropdownDecoration(
                      Icons.category_outlined,
                      "Pilih Kategori",
                    ),
                    value: _selectedCategory,
                    items: _categories
                        .map(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: Text(
                              e,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (val) => setState(() => _selectedCategory = val),
                    validator: (val) =>
                        val == null ? 'Kategori harus dipilih' : null,
                  ),
                  const SizedBox(height: 18),

                  CustomTextFormField(
                    icon: Icons.medical_services_outlined,
                    label: "Kondisi Kesehatan",
                    hint: "Contoh: Demam ringan, Nafsu makan turun",
                    controller: _conditionController,
                    validator: (val) => val == null || val.isEmpty
                        ? 'Kondisi tidak boleh kosong'
                        : null,
                  ),
                  const SizedBox(height: 18),

                  _buildDropdownLabel("Tingkat Keparahan"),
                  DropdownButtonFormField<String>(
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    decoration: _dropdownDecoration(
                      Icons.report_problem_outlined,
                      "Pilih Tingkat Keparahan",
                    ),
                    value: _selectedSeverity,
                    items: _severities
                        .map(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: Text(
                              e,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (val) => setState(() => _selectedSeverity = val),
                    validator: (val) =>
                        val == null ? 'Tingkat keparahan harus dipilih' : null,
                  ),
                  const SizedBox(height: 18),
                  _buildDropdownLabel("Pemeriksa"),
                  DropdownButtonFormField<String>(
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    decoration: _dropdownDecoration(
                      Icons.person_outline,
                      "Pilih Pemeriksa",
                    ),
                    value: _selectedExaminer,
                    items: _examiners
                        .map(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: Text(
                              e,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (val) => setState(() => _selectedExaminer = val),
                    validator: (val) =>
                        val == null ? 'Pemeriksa harus dipilih' : null,
                  ),
                  const SizedBox(height: 24),

                  CustomTextFormField(
                    icon: Icons.description_outlined,
                    label: "Catatan / Penanganan (Opsional)",
                    hint: "Tuliskan detail gejala atau tindakan medis...",
                    controller: _notesController,
                    keyboardType: TextInputType.multiline,
                  ),
                  const SizedBox(height: 32),

                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      onPressed: _submitData,
                      child: const Text(
                        "Simpan Data Kesehatan",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
    );
  }

  InputDecoration _dropdownDecoration(IconData icon, String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.black54, fontSize: 10),
      prefixIcon: Icon(
        icon,
        size: 20,
        color: Colors.black.withValues(alpha: 0.4),
      ),
      isDense: true,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.black.withValues(alpha: 0.1)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.black, width: 1.5),
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
  }
}
