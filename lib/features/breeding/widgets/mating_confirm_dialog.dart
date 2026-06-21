import 'package:flutter/material.dart';
import 'package:gosheep_mobile/core/widgets/toast_widget.dart';
import 'package:gosheep_mobile/data/models/sheep_breeding.dart';
import 'package:gosheep_mobile/data/models/recommendation.dart';
import 'package:gosheep_mobile/data/services/mating_record_service.dart';

class MatingConfirmDialog extends StatefulWidget {
  final SheepBreeding selectedSheep;
  final RecommendationSheep candidate;
  final int? recommendationId;

  const MatingConfirmDialog({
    super.key,
    required this.selectedSheep,
    required this.candidate,
    this.recommendationId,
  });

  @override
  State<MatingConfirmDialog> createState() => _MatingConfirmDialogState();
}

class _MatingConfirmDialogState extends State<MatingConfirmDialog> {
  late DateTime _startDate;
  late DateTime _endDate;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _startDate = DateTime.now();
    _endDate = DateTime.now().add(const Duration(days: 20));
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _startDate = picked;
        _endDate = _startDate.add(const Duration(days: 20));
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _endDate,
      firstDate: _startDate,
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _endDate = picked;
      });
    }
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year;
    return '$day/$month/$year';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text(
        'Konfirmasi Perkawinan',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Apakah Anda yakin ingin mengawinkan ${widget.selectedSheep.eartag} dengan ${widget.candidate.eartag}?',
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
            const SizedBox(height: 16),
            const Text(
              'Tanggal Mulai:',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 6),
            InkWell(
              onTap: () => _selectStartDate(context),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatDate(_startDate),
                      style: const TextStyle(fontSize: 14),
                    ),
                    const Icon(
                      Icons.calendar_today_rounded,
                      size: 16,
                      color: Color(0xFF0F5132),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'Tanggal Selesai:',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 6),
            InkWell(
              onTap: () => _selectEndDate(context),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatDate(_endDate),
                      style: const TextStyle(fontSize: 14),
                    ),
                    const Icon(
                      Icons.calendar_today_rounded,
                      size: 16,
                      color: Color(0xFF0F5132),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          child: const Text(
            'Batal',
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
          ),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _submitMating,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0F5132),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: _isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text(
                  'Konfirmasi',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
        ),
      ],
    );
  }

  Future<void> _submitMating() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final startStr = _startDate.toIso8601String().split('T')[0];
      final endStr = _endDate.toIso8601String().split('T')[0];

      final isSelectedFemale = widget.selectedSheep.gender == 'female';
      final eweId = isSelectedFemale
          ? widget.selectedSheep.id
          : widget.candidate.id;
      final ramId = isSelectedFemale
          ? widget.candidate.id
          : widget.selectedSheep.id;

      await MatingRecordService().createMatingRecord(
        eweId: eweId,
        ramId: ramId,
        recommendationId: widget.recommendationId,
        matingDate: startStr,
        endDate: endStr,
      );

      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ToastService.show(
          context,
          e.toString().replaceAll('Exception: ', ''),
          title: 'Gagal!',
          type: ToastType.error,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
