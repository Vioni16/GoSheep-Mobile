import 'package:flutter/material.dart';

class BreedingCard extends StatelessWidget {
  final Map<String, dynamic> item;

  const BreedingCard({super.key, required this.item});

  Color get _statusColor {
    switch (item["status"]) {
      case "Berhasil":
        return Colors.green;
      case "Gagal":
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  IconData get _statusIcon {
    switch (item["status"]) {
      case "Berhasil":
        return Icons.check;
      case "Gagal":
        return Icons.close;
      default:
        return Icons.access_time;
    }
  }

  String get _statusText {
    switch (item["status"]) {
      case "Berhasil":
        return "Bunting";
      case "Gagal":
        return "Gagal";
      default:
        return "Proses";
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _statusColor;

    final male = item["male"] ?? "-";
    final female = item["female"] ?? "-";
    final date = item["date"] ?? "-";
    final status = item["status"] ?? "-";

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TOP
          Row(
            children: [
              _animalChip(female, Colors.pink),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Icon(
                  Icons.favorite_border,
                  size: 16,
                  color: Colors.grey,
                ),
              ),

              _animalChip(male, Colors.green),

              const Spacer(),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _statusText,
                  style: TextStyle(
                    color: color,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.sell_outlined, size: 16, color: Colors.pink),

                  const SizedBox(width: 6),

                  const Text(
                    "Betina:",
                    style: TextStyle(fontSize: 12, color: Colors.black),
                  ),

                  const SizedBox(width: 8),

                  Text(
                    female,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              Row(
                children: [
                  const Icon(
                    Icons.sell_outlined,
                    size: 16,
                    color: Colors.green,
                  ),

                  const SizedBox(width: 6),

                  const Text(
                    "Jantan:",
                    style: TextStyle(fontSize: 12, color: Colors.black),
                  ),

                  const SizedBox(width: 8),

                  Text(
                    male,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 10),

          Divider(color: Colors.grey.shade200),

          const SizedBox(height: 10),

          // TANGGAL
          _infoRow(Icons.calendar_today_outlined, "Kawin: $date"),

          const SizedBox(height: 8),

          _infoRow(Icons.event_available_outlined, "Selesai: 25 Mei 2026"),

          const SizedBox(height: 8),

          _infoRow(
            _statusIcon,
            status == "Proses" ? "Menunggu hasil konfirmasi" : "Hasil dicatat",
            iconColor: color,
          ),
        ],
      ),
    );
  }

  Widget _animalChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),

          const SizedBox(width: 6),

          Text(
            text,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String text, {Color? iconColor}) {
    return Row(
      children: [
        Icon(icon, size: 15, color: iconColor ?? Colors.grey),

        const SizedBox(width: 8),

        Text(text, style: const TextStyle(fontSize: 13, color: Colors.black87)),
      ],
    );
  }
}
