import 'package:flutter/material.dart';

class EmptyData extends StatelessWidget {
  final String? message;
  final String? description;

  const EmptyData({
    super.key,
    this.message,
    this.description
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: const Color(0xFFF0EDE6),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.inbox_rounded,
                size: 36,
                color: Color(0xFFB0A898),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              message ?? 'Tidak ada data',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xFF5C5752),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              description ?? 'Masih belum ada data..',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFFADAA9F),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}