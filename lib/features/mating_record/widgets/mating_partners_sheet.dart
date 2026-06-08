import 'package:flutter/material.dart';
import 'package:gosheep_mobile/data/models/mating_partner.dart';
import 'package:gosheep_mobile/data/services/mating_record_service.dart';
import 'package:gosheep_mobile/features/sheep/screens/sheep_detail_screen.dart';

class MatingPartnersSheet extends StatefulWidget {
  final int sheepId;
  final String eartag;
  final String gender;

  const MatingPartnersSheet({
    super.key,
    required this.sheepId,
    required this.eartag,
    required this.gender,
  });

  @override
  State<MatingPartnersSheet> createState() => _MatingPartnersSheetState();
}

class _MatingPartnersSheetState extends State<MatingPartnersSheet> {
  final MatingRecordService _service = MatingRecordService();
  List<MatingPartner>? _partners;
  String? _error;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPartners();
  }

  Future<void> _fetchPartners() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final data = await _service.getMatingPartners(widget.sheepId);
      if (mounted) {
        setState(() {
          _partners = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    final screenHeight = MediaQuery.of(context).size.height;
    final isMale = widget.gender == "male";

    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: Container(
        constraints: BoxConstraints(maxHeight: screenHeight * 0.7),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 10),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Riwayat Pasangan Kawin',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Flexible(child: _buildContent(isMale)),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(bool isMale) {
    if (_isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(40),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, size: 40, color: Colors.grey.shade400),
              const SizedBox(height: 8),
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: _fetchPartners,
                child: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      );
    }

    final partners = _partners ?? [];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isMale
                    ? Colors.blue.shade50.withValues(alpha: 0.5)
                    : Colors.pink.shade50.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isMale ? Colors.blue.shade100 : Colors.pink.shade100,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    isMale ? "EARTAG Jantan" : "EARTAG Betina",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: isMale
                          ? Colors.blue.shade900
                          : Colors.pink.shade900,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 14),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SheepDetailScreen(id: widget.sheepId),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isMale ? Colors.blue : Colors.pink,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        widget.eartag,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isMale
                    ? Colors.pink.shade50.withValues(alpha: 0.5)
                    : Colors.blue.shade50.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isMale ? Colors.pink.shade100 : Colors.blue.shade100,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    isMale ? "EARTAG Betina" : "EARTAG Jantan",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: isMale
                          ? Colors.pink.shade900
                          : Colors.blue.shade900,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 14),
                  if (partners.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        "Belum ada pasangan",
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 11,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                  else
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      alignment: WrapAlignment.center,
                      children: partners.map((partner) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    SheepDetailScreen(id: partner.id),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: isMale ? Colors.pink : Colors.blue,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              partner.eartag,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
