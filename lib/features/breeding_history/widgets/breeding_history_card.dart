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

  @override
  Widget build(BuildContext context) {
    final color = _statusColor;

    final male = item["male"] ?? "-";
    final female = item["female"] ?? "-";
    final date = item["date"] ?? "-";
    final status = item["status"] ?? "-";

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border(left: BorderSide(color: color, width: 3)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 6),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _GenderAvatar(isMale: true),
                    const SizedBox(width: 4),
                    Text(
                      male,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6),
                      child: Text("×", style: TextStyle(color: Colors.grey)),
                    ),
                    _GenderAvatar(isMale: false),
                    const SizedBox(width: 4),
                    Text(
                      female,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                const Text(
                  "Pasangan Breeding",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                ),

                const SizedBox(height: 6),

                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 12,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      date,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // status
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GenderAvatar extends StatelessWidget {
  final bool isMale;

  const _GenderAvatar({required this.isMale});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      child: Icon(
        Icons.sell,
        size: 14,
        color: isMale ? Colors.green : Colors.pink,
      ),
    );
  }
}
