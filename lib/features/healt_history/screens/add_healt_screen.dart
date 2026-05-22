import 'package:flutter/material.dart';
import 'package:gosheep_mobile/core/widgets/custom_textfield.dart';

class AddHealthRecordScreen extends StatefulWidget {
  const AddHealthRecordScreen({super.key});

  @override
  State<AddHealthRecordScreen> createState() => _AddHealthRecordScreenState();
}

class _AddHealthRecordScreenState extends State<AddHealthRecordScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _conditionController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

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

  @override
  void dispose() {
    _conditionController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          "Tambah Rekam Medis",
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
        ),
        centerTitle: true,
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDropdownLabel("Pilih Domba (Tag/Nama)"),
              DropdownButtonFormField<String>(
                decoration: _dropdownDecoration(
                  Icons.gavel_outlined,
                  "Pilih Domba",
                ),
                value: _selectedSheep,
                items: _sheepList
                    .map(
                      (e) => DropdownMenuItem(
                        value: e,
                        child: Text(e, style: const TextStyle(fontSize: 14)),
                      ),
                    )
                    .toList(),
                onChanged: (val) => setState(() => _selectedSheep = val),
                validator: (val) => val == null ? 'Domba harus dipilih' : null,
              ),
              const SizedBox(height: 18),

              _buildDropdownLabel("Kategori"),
              DropdownButtonFormField<String>(
                decoration: _dropdownDecoration(
                  Icons.category_outlined,
                  "Pilih Kategori",
                ),
                value: _selectedCategory,
                items: _categories
                    .map(
                      (e) => DropdownMenuItem(
                        value: e,
                        child: Text(e, style: const TextStyle(fontSize: 14)),
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
                decoration: _dropdownDecoration(
                  Icons.report_problem_outlined,
                  "Pilih Tingkat Keparahan",
                ),
                value: _selectedSeverity,
                items: _severities
                    .map(
                      (e) => DropdownMenuItem(
                        value: e,
                        child: Text(e, style: const TextStyle(fontSize: 14)),
                      ),
                    )
                    .toList(),
                onChanged: (val) => setState(() => _selectedSeverity = val),
                validator: (val) =>
                    val == null ? 'Tingkat keparahan harus dipilih' : null,
              ),
              const SizedBox(height: 18),

              CustomTextFormField(
                icon: Icons.description_outlined,
                label: "Catatan / Penanganan (Opsional)",
                hint: "Tuliskan detail gejala atau tindakan medis...",
                controller: _notesController,
                keyboardType: TextInputType.multiline,
              ),
              const SizedBox(height: 32),

              SizedBox(
                width:
                    double.infinity, 
                height: 48, 
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.primary, 
                    foregroundColor: Colors.white, 
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        12,
                      ), 
                    ),
                    elevation:
                        0, 
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final newData = {
                        "id": DateTime.now().millisecondsSinceEpoch,
                        "earTag": _selectedSheep,
                        "gender":
                            _selectedSheep == "ET017" ||
                                _selectedSheep == "ET031"
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
                        const SnackBar(
                          content: Text('Berhasil menambahkan rekam medis!'),
                        ),
                      );

                      Navigator.pop(context, newData);
                    }
                  },
                  child: const Text(
                    "Simpan Data Kesehatan",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
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
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
    );
  }

  InputDecoration _dropdownDecoration(IconData icon, String hint) {
    return InputDecoration(
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
