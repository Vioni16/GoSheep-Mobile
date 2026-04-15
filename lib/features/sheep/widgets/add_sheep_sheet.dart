import 'package:flutter/material.dart';
import 'package:gosheep_mobile/core/widgets/custom_textfield.dart';
import 'package:gosheep_mobile/features/sheep/widgets/status_toggle.dart';

class AddSheepSheet extends StatefulWidget {
  final void Function() onAdd;
  final List<String> breedList;
  const AddSheepSheet({
    super.key,
    required this.onAdd,
    required this.breedList,
  });
  @override
  State<AddSheepSheet> createState() => AddSheepSheetState();
}

class AddSheepSheetState extends State<AddSheepSheet> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _id = TextEditingController();
  final _weight = TextEditingController();
  String? _breed;
  String _status = 'Sehat';

  @override
  void dispose() {
    _name.dispose();
    _id.dispose();
    _weight.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    // Logika pengiriman data (uncomment jika sudah siap)
    // widget.onAdd(
    //   CreateSheepRequest(
    //     id: _id.text.trim(),
    //     name: _name.text.trim(),
    //     breed: _breed!,
    //     weight: double.parse(_weight.text.trim()),
    //     status: _status,
    //   ),
    // );

    Navigator.pop(context);
  }

  OutlineInputBorder _border([Color? color, double width = 1]) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: color ?? Colors.black.withValues(alpha: 0.1),
          width: width,
        ),
      );

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(20, 16, 20, 20 + bottom),
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
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Tambah Domba Baru',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.05),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close_rounded,
                      size: 18,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // MENGGUNAKAN CUSTOM TEXT FORM FIELD
            CustomTextFormField(
              label: 'Nama Domba',
              controller: _name,
              hint: 'Nama Domba (Contoh: Shaun)',
              icon: Icons.badge_outlined,
              validator: (v) => (v?.isEmpty ?? true) ? 'Wajib diisi' : null,
            ),

            const SizedBox(height: 14),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: CustomTextFormField(
                    label: 'Eartag domba',
                    controller: _id,
                    hint: 'ID (D-004)',
                    icon: Icons.tag_rounded,
                    validator: (v) => (v?.isEmpty ?? true) ? 'Wajib diisi' : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomTextFormField(
                    label: 'Berat (kg)',
                    controller: _weight,
                    hint: 'Berat (kg)',
                    icon: Icons.scale_rounded,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    validator: (v) => (v?.isEmpty ?? true)
                        ? 'Wajib diisi'
                        : double.tryParse(v!) == null
                        ? 'Angka tidak valid'
                        : null,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),
            const Text(
              'Jenis Domba',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _breed,
              hint: const Text(
                'Pilih jenis...',
                style: TextStyle(fontSize: 14),
              ),
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Colors.black54,
              ),
              items: widget.breedList
                  .map(
                    (j) => DropdownMenuItem(
                  value: j,
                  child: Text(j, style: const TextStyle(fontSize: 14)),
                ),
              )
                  .toList(),
              onChanged: (v) => setState(() => _breed = v),
              validator: (v) => v == null ? 'Pilih jenis domba' : null,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.category_outlined,
                  size: 20,
                  color: Colors.black.withValues(alpha: 0.4),
                ),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                border: _border(),
                enabledBorder: _border(),
                focusedBorder: _border(Colors.black, 1.5),
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'Status Kesehatan',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: StatusToggle(
                    label: 'Sehat',
                    selected: _status == 'Sehat',
                    bg: const Color(0xFFEAF3DE),
                    border: const Color(0xFFC0DD97),
                    text: const Color(0xFF3B6D11),
                    onTap: () => setState(() => _status = 'Sehat'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatusToggle(
                    label: 'Sakit',
                    selected: _status == 'Sakit',
                    bg: const Color(0xFFFCEBEB),
                    border: const Color(0xFFF7C1C1),
                    text: const Color(0xFFA32D2D),
                    onTap: () => setState(() => _status = 'Sakit'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _submit,
                child: const Text(
                  'Simpan Data Domba',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
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