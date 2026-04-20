import 'package:flutter/material.dart';

class ModernCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final List<Widget> children;

  const ModernCard({
    super.key,
    required this.icon,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: primary, size: 18),
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: TextStyle(
                    color: primary,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),

          Divider(height: 1, color: Colors.grey.shade100),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }
}

class ModernInfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isLoading;
  final Color? valueColor;

  const ModernInfoRow({
    super.key,
    required this.label,
    required this.value,
    this.isLoading = false,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? _ShimmerBox()
                : Text(
                    value,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: valueColor ?? Colors.grey.shade800,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _ShimmerBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        height: 14,
        width: 80,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}
