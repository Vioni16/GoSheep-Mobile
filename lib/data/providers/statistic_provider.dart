import 'package:flutter/material.dart';
import 'package:gosheep_mobile/data/models/statistics/mating_record_stats.dart';
import 'package:gosheep_mobile/data/models/statistics/overview_stats.dart';
import 'package:gosheep_mobile/data/models/statistics/sheep_health_stats.dart';
import 'package:gosheep_mobile/data/models/statistics/overview_stats.dart';
import 'package:gosheep_mobile/data/services/statistic_service.dart';

class StatisticProvider with ChangeNotifier {
  final StatisticService _service = StatisticService();

  SheepHealthStats? _healthStats;
  SheepHealthStats? get healthStats => _healthStats;

  MatingRecordStats? _matingRecordStats;
  MatingRecordStats? get matingRecordStats => _matingRecordStats;

  OverviewStats? _overviewStats;
  OverviewStats? get overviewStats => _overviewStats;

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

  Future<void> fetchMatingRecStats() async {
    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();

    try {
      final stats = await _service.getMatingRecStats();
      _matingRecordStats = stats;
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchOverviewStats() async {
    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();

    try {
      final stats = await _service.getOverviewStats();
      _overviewStats = stats;
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
