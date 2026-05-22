import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddBreedingSheet extends StatefulWidget {
  const AddBreedingSheet({super.key});

  @override
  State<AddBreedingSheet> createState() => _AddBreedingSheetState();
}

class _AddBreedingSheetState extends State<AddBreedingSheet> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _dateController = TextEditingController();

  String? _selectedRam;
  String? _selectedEwe;
  String _selectedResult = "proses";
  DateTime _selectedDate = DateTime.now();

  final List<String> _ramList = ["ET015", "ET020"];
  final List<String> _eweList = ["ET017", "ET031"];

  final List<String> _resultOptions = ["proses", "berhasil", "gagal"];

  @override
  void initState() {
    super.initState();
    _dateController.text = DateFormat('yyyy-MM-dd').format(_selectedDate);
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _submitData() {
    if (_formKey.currentState!.validate()) {
      final newRecord = {
        "mating_date": _dateController.text,
        "result": _selectedResult == "berhasil"
            ? "Berhasil"
            : _selectedResult == "gagal"
            ? "Gagal"
            : "Proses",
        "male": _selectedRam,
        "female": _selectedEwe,
      };

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Berhasil menambahkan record perkawinan!'),
        ),
      );

      Navigator.pop(context, newRecord);
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
                      "Tambah Record Perkawinan",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  _buildDropdownLabel("Pejantan (Ram)"),
                  DropdownButtonFormField<String>(
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    decoration: _dropdownDecoration(
                      Icons.male,
                      "Pilih Ear Tag Pejantan",
                    ),
                    value: _selectedRam,
                    items: _ramList
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
                    onChanged: (val) => setState(() => _selectedRam = val),
                    validator: (val) =>
                        val == null ? 'Pejantan harus dipilih' : null,
                  ),
                  const SizedBox(height: 18),

                  _buildDropdownLabel("Indukan (Ewe)"),
                  DropdownButtonFormField<String>(
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    decoration: _dropdownDecoration(
                      Icons.female,
                      "Pilih Ear Tag Indukan",
                    ),
                    value: _selectedEwe,
                    items: _eweList
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
                    onChanged: (val) => setState(() => _selectedEwe = val),
                    validator: (val) =>
                        val == null ? 'Indukan harus dipilih' : null,
                  ),
                  const SizedBox(height: 18),

                  _buildDropdownLabel("Tanggal Perkawinan (Mating Date)"),
                  TextFormField(
                    controller: _dateController,
                    readOnly: true,
                    onTap: _pickDate,
                    style: const TextStyle(color: Colors.black87, fontSize: 14),
                    decoration: _dropdownDecoration(
                      Icons.calendar_today_outlined,
                      "Pilih Tanggal Perkawinan",
                    ),
                  ),
                  const SizedBox(height: 18),

                  _buildDropdownLabel("Status Hasil Perkawinan"),
                  DropdownButtonFormField<String>(
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    decoration: _dropdownDecoration(
                      Icons.analytics_outlined,
                      "Pilih Status",
                    ),
                    value: _selectedResult,
                    items: _resultOptions
                        .map(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: Text(
                              e == "proses"
                                  ? "Dalam Proses"
                                  : e == "berhasil"
                                  ? "Berhasil (Bunting)"
                                  : "Gagal Kawin",
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => _selectedResult = val);
                      }
                    },
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
                        "Simpan Record Perkawinan",
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
      hintStyle: const TextStyle(color: Colors.black54, fontSize: 14),
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
