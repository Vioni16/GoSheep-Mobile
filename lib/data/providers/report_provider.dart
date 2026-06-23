import 'package:flutter/material.dart';
import 'package:gosheep_mobile/data/models/farm_report.dart';
import 'package:gosheep_mobile/data/services/report_service.dart';

class ReportProvider with ChangeNotifier {
  final ReportService _service = ReportService();

  FarmReport? _report;
  FarmReport? get report => _report;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Future<void> loadReport() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _service.getFarmReport();
      _report = response.data;
    } catch (e) {
      _error = e.toString();
      _report = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}