import 'package:flutter/material.dart';
import 'package:gosheep_mobile/data/models/sheep_health_stats.dart';
import 'package:gosheep_mobile/data/services/sheep_stats_service.dart';

class SheepStatsProvider with ChangeNotifier {
  final SheepStatsService _service = SheepStatsService();

  SheepHealthStats? _healthStats;
  SheepHealthStats? get healthStats => _healthStats;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Future<void> fetchHealthStats() async {
    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();

    try {
      final stats = await _service.getSheepHealthStats();
      _healthStats = stats;
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}