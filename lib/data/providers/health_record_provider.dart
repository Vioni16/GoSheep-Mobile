import 'package:flutter/material.dart';
import 'package:gosheep_mobile/data/exceptions/api_exception.dart';
import 'package:gosheep_mobile/data/models/health.dart';
import 'package:gosheep_mobile/data/services/health_record_service.dart';

class HealthRecordProvider with ChangeNotifier {
  final HealthRecordService _service = HealthRecordService();
  final int _sheepId;

  HealthRecordProvider(this._sheepId);

  List<Health> _healthRecords = [];
  List<Health> get healthRecords => _healthRecords;

  String _message = '';
  String get message => _message;

  bool _isCreating = false;
  bool get isCreating => _isCreating;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _hasMore = true;
  bool get hasMore => _hasMore;

  int? _lastId;
  final int _limit = 10;

  String? _error;
  String? get error => _error;

  Future<void> fetchInitial() async {
    _healthRecords = [];
    _lastId = null;
    _hasMore = true;
    _error = null;
    _isLoading = false;

    await fetchMore();
  }

  Future<void> fetchMore() async {
    if (_isLoading || !_hasMore) return;

    _isLoading = true;
    notifyListeners();

    try {
      final response = await _service.getHealthRecord(
        sheepId: _sheepId,
        lastId: _lastId,
        limit: _limit,
      );

      _healthRecords.addAll(response.data.first.healthRecords);
      _lastId = response.nextCursor;
      _hasMore = response.hasMore;

      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createHealthRecord({
    required String condition,
    required String category,
    required String severity,
    String? notes,
  }) async {
    if (_isCreating) return false;

    _isCreating = true;

    _error = null;

    notifyListeners();

    try {
      final response = await _service.createHealthRecord(
        sheepId: _sheepId,
        condition: condition,
        category: category,
        severity: severity,
        notes: notes,
      );

      _healthRecords.insert(0, response.data!);
      _message = response.message;

      return true;
    } on ApiException catch (e) {
      _error = e.message;
      return false;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isCreating = false;
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    await fetchInitial();
  }
}
