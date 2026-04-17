import 'package:flutter/material.dart';
import 'package:gosheep_mobile/core/theme/theme.dart';

class AppRefreshIndicator extends StatelessWidget {
  final Widget child;
  final Future<void> Function() onRefresh;

  const AppRefreshIndicator({
    super.key,
    required this.child,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppTheme.primaryGreen,
      backgroundColor: Colors.white,
      strokeWidth: 3,
      displacement: 60,
      edgeOffset: 12,
      onRefresh: onRefresh,
      child: child,
    );
  }
}
