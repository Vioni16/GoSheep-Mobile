import 'package:flutter/material.dart';
import 'package:gosheep_mobile/core/widgets/custom_button.dart';

class AddSheepScreen extends StatefulWidget {
  const AddSheepScreen({super.key});

  @override
  State<AddSheepScreen> createState() => _AddSheepScreenState();
}

class _AddSheepScreenState extends State<AddSheepScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _breedController;
  late TextEditingController _weightController;
  late TextEditingController _healthStatusController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _breedController = TextEditingController();
    _weightController = TextEditingController();
    _healthStatusController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _breedController.dispose();
    _weightController.dispose();
    _healthStatusController.dispose();
    super.dispose();
  }

  void _addSheep() {
    if (_formKey.currentState!.validate()) {
      // TODO: Implement add sheep functionality
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Domba ${_nameController.text} berhasil ditambahkan!'),
          duration: const Duration(seconds: 2),
        ),
      );

      _nameController.clear();
      _breedController.clear();
      _weightController.clear();
      _healthStatusController.clear();

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
              const Text(
                'Nama Domba',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
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

              const Text(
                'Jenis Domba',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _breedController,
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

              const Text(
                'Berat (kg)',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _weightController,
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

              const Text(
                'Status Kesehatan',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _healthStatusController,
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

              CustomButton(text: 'Tambah Domba', onPressed: _addSheep),
            ],
          ),
        ),
      ),
    );
  }
}
