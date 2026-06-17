import 'package:flutter/material.dart';
import 'package:gosheep_mobile/data/exceptions/api_exception.dart';
import 'package:gosheep_mobile/data/models/weight.dart';
import 'package:gosheep_mobile/data/services/weight_record_service.dart';

class WeightRecordProvider with ChangeNotifier {
  final WeightRecordService _service = WeightRecordService();
  final int _sheepId;

  WeightRecordProvider(this._sheepId);

  List<Weight> _weightRecords = [];
  List<Weight> get weightRecords => _weightRecords;

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
    _weightRecords = [];
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
      final response = await _service.getWeightRecord(
        sheepId: _sheepId,
        lastId: _lastId,
        limit: _limit,
      );

      _weightRecords.addAll(response.data.first.weightRecords);
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

  Future<bool> createWeightRecord({required double weight}) async {
    if (_isCreating) return false;

    _isCreating = true;

    _error = null;

    notifyListeners();

    try {
      final response = await _service.createWeightRecord(
        sheepId: _sheepId,
        weight: weight,
      );

      _weightRecords.insert(0, response.data!);
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

  Future<bool> updateWeightRecord({
    required int recordId,
    required double weight,
  }) async {
    if (_isCreating) return false;

    _isCreating = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _service.updateWeightRecord(
        recordId: recordId,
        weight: weight,
      );

      final index = _weightRecords.indexWhere((r) => r.id == recordId);
      if (index != -1 && response.data != null) {
        _weightRecords[index] = response.data!;
      }

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
