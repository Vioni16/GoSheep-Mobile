import 'package:flutter/material.dart';
import 'package:gosheep_mobile/core/utils/validators.dart';
import 'package:gosheep_mobile/core/widgets/custom_textfield.dart';
import 'package:gosheep_mobile/core/widgets/toast_widget.dart';
import 'package:gosheep_mobile/data/models/weight.dart';
import 'package:gosheep_mobile/data/providers/statistic_provider.dart';
import 'package:gosheep_mobile/data/providers/weight_record_provider.dart';
import 'package:provider/provider.dart';

class EditWeightSheet extends StatefulWidget {
  final Weight weight;
  final int sheepId;

  const EditWeightSheet({
    super.key,
    required this.weight,
    required this.sheepId,
  });

  @override
  State<EditWeightSheet> createState() => _EditWeightSheetState();
}

class _EditWeightSheetState extends State<EditWeightSheet> {
  final _formKey = GlobalKey<FormState>();

  late final _weightController = TextEditingController(
    text: widget.weight.weight.toString(),
  );

  @override
  void dispose() {
    _weightController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final double? newWeight = double.tryParse(_weightController.text.trim());
    if (newWeight == null) return;

    final isUnchanged = newWeight == widget.weight.weight;

    if (isUnchanged) {
      ToastService.show(
        context,
        'Tidak ada perubahan data berat badan untuk disimpan.',
        title: 'Info',
        type: ToastType.warning,
      );
      return;
    }

    final provider = context.read<WeightRecordProvider>();

    final success = await provider.updateWeightRecord(
      recordId: widget.weight.id,
      weight: newWeight,
    );

    if (!mounted) return;

    if (success) {
      // Refresh statistik berat badan bulanan
      context.read<StatisticProvider>().refreshMonthlyWeightStatistics(
            sheepId: widget.sheepId,
          );

      Navigator.pop(context, true);

      ToastService.show(
        context,
        provider.message,
        title: 'Berhasil Diperbarui!',
        type: ToastType.success,
      );

      return;
    }

    ToastService.show(
      context,
      provider.error ?? 'Gagal memperbarui berat badan',
      title: 'Gagal Memperbarui!',
      type: ToastType.error,
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                      _sectionHeader(
                        'Edit Rekam Berat Badan',
                        'Perbarui informasi timbangan domba',
                      ),
                      const SizedBox(height: 20),
                      CustomTextFormField(
                        label: 'Berat Badan (kg)',
                        hint: 'Contoh: 30.5',
                        icon: Icons.monitor_weight_outlined,
                        controller: _weightController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        validator: (v) {
                          final req = Validators.required(v, 'Berat badan');
                          if (req != null) return req;
                          final num = double.tryParse(v!.trim());
                          if (num == null) return 'Berat badan harus berupa angka';
                          if (num <= 0) return 'Berat badan harus lebih besar dari 0';
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      Consumer<WeightRecordProvider>(
                        builder: (_, provider, __) =>
                            _submitButton(provider.isCreating),
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
}
