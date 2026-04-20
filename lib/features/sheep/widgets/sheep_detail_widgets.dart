import 'package:flutter/material.dart';
import 'package:gosheep_mobile/features/sheep/screens/sheep_detail_screen.dart';
import 'package:shimmer/shimmer.dart';
import 'package:gosheep_mobile/core/utils/format_helper.dart';
import 'package:gosheep_mobile/data/models/sheep_detail.dart';

const _primaryGreen = Color(0xFF0F5132);

Widget shimmerBox({
  double width = 80,
  double height = 12,
  double radius = 6,
}) {
  return Shimmer.fromColors(
    baseColor: Colors.grey.shade300,
    highlightColor: Colors.grey.shade100,
    child: Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    ),
  );
}

Widget shimmerBadge() {
  return Shimmer.fromColors(
    baseColor: Colors.grey.shade300,
    highlightColor: Colors.grey.shade100,
    child: Container(
      width: 50,
      height: 18,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
    ),
  );
}

Widget buildCard(List<Widget> children) {
  return Container(
    margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(children: children),
  );
}

Widget buildSectionTitle(String title) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(12, 14, 12, 6),
    child: Text(
      title.toUpperCase(),
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: _primaryGreen,
      ),
    ),
  );
}

Widget buildInfoTile(
    String label,
    String value, {
      required bool isLoading,
    }) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    decoration: const BoxDecoration(
      border: Border(top: BorderSide(color: Color(0xFFF0F0F0))),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, color: Colors.black54)),
        isLoading
            ? shimmerBox()
            : Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
      ],
    ),
  );
}


Widget buildStatusTile(String status, {required bool isLoading}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    decoration: const BoxDecoration(
      border: Border(top: BorderSide(color: Color(0xFFF0F0F0))),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Status Domba', style: TextStyle(fontSize: 13, color: Colors.black54)),
        isLoading
            ? shimmerBadge()
            : Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          decoration: BoxDecoration(
            color: const Color(0xFFFAEEDA),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            status == 'active' ? 'Aktif' : status,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    ),
  );
}

Widget buildWeightTile(double weight, {required bool isLoading}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    decoration: const BoxDecoration(
      border: Border(top: BorderSide(color: Color(0xFFF0F0F0))),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Berat', style: TextStyle(fontSize: 13, color: Colors.black54)),
        isLoading
            ? shimmerBox(width: 60, height: 16)
            : Text(
          FormatHelper.formatWeight(weight),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: _primaryGreen,
          ),
        ),
      ],
    ),
  );
}

Widget buildParentTile(
    BuildContext context,
    String label,
    ParentSheep? parent, {
      required bool isLoading,
    }) {
  final isClickable = !isLoading && parent != null;

  return InkWell(
    onTap: isClickable
        ? () => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SheepDetailScreen(id: parent.id),
      ),
    )
        : null,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFFF0F0F0))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 13, color: Colors.black54),
              ),
              isLoading
                  ? shimmerBox(width: 70)
                  : Text(
                FormatHelper.formatNullable(parent?.earTag),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          if (isClickable)
            const Icon(Icons.chevron_right, color: _primaryGreen),
        ],
      ),
    ),
  );
}