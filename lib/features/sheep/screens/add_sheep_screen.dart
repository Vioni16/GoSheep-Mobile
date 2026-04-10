import 'package:flutter/material.dart';
import 'package:gosheep_mobile/core/widgets/custom_button.dart';

// ==========================================
// ADD SHEEP SCREEN
// ==========================================
class AddSheepScreen extends StatefulWidget {
  const AddSheepScreen({super.key});

  @override
  State<AddSheepScreen> createState() => _AddSheepScreenState();
}

class _AddSheepScreenState extends State<AddSheepScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TextEditingController _namaController;
  late TextEditingController _jenisController;
  late TextEditingController _beratController;
  late TextEditingController _statusKesehatanController;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController();
    _jenisController = TextEditingController();
    _beratController = TextEditingController();
    _statusKesehatanController = TextEditingController();
  }

  @override
  void dispose() {
    _namaController.dispose();
    _jenisController.dispose();
    _beratController.dispose();
    _statusKesehatanController.dispose();
    super.dispose();
  }

  void _addSheep() {
    if (_formKey.currentState!.validate()) {
      // TODO: Implement add sheep functionality
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Domba ${_namaController.text} berhasil ditambahkan!'),
          duration: const Duration(seconds: 2),
        ),
      );

      // Clear form
      _namaController.clear();
      _jenisController.clear();
      _beratController.clear();
      _statusKesehatanController.clear();

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Domba Baru'), elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nama
              const Text(
                'Nama Domba',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _namaController,
                decoration: InputDecoration(
                  hintText: 'Contoh: Shaun',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Nama domba tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Jenis
              const Text(
                'Jenis Domba',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _jenisController,
                decoration: InputDecoration(
                  hintText: 'Contoh: Merino, Garut, Texel',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Jenis domba tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Berat
              const Text(
                'Berat (kg)',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _beratController,
                decoration: InputDecoration(
                  hintText: 'Contoh: 45.5',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Berat tidak boleh kosong';
                  }
                  if (double.tryParse(value!) == null) {
                    return 'Berat harus berupa angka';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Status Kesehatan
              const Text(
                'Status Kesehatan',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _statusKesehatanController,
                decoration: InputDecoration(
                  hintText: 'Contoh: Sehat, Sakit',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Status kesehatan tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),

              // Custom Button
              CustomButton(text: 'Tambah Domba', onPressed: _addSheep),
            ],
          ),
        ),
      ),
    );
  }
}
