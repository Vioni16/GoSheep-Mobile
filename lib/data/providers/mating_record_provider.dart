import 'package:flutter/material.dart';
import 'package:gosheep_mobile/core/enums/mating_result_enum.dart';
import 'package:gosheep_mobile/data/models/mating_record.dart';
import 'package:gosheep_mobile/data/services/mating_record_service.dart';

class MatingRecordProvider with ChangeNotifier {
  final MatingRecordService _service = MatingRecordService();

  List<MatingRecord> _matingRecords = [];
  List<MatingRecord> get matingRecords => _matingRecords;

  String _message = '';
  String get message => _message;

  bool _isInitialized = false;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _hasMore = true;
  bool get hasMore => _hasMore;

  int? _lastId;
  final int _limit = 10;

  String _search = '';
  bool get isSearching => _search.isNotEmpty;

  String? _error;
  String? get error => _error;

  Future<void> fetchInitial({bool forceRefresh = false}) async {
    if (_isInitialized && !forceRefresh) return;

    _isInitialized = true;

    _matingRecords = [];
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
      final response = await _service.getMatingRec(
        lastId: _lastId,
        limit: _limit,
        search: _search,
      );

      _matingRecords.addAll(response.data);
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

  Future<void> searchMatingRec(String value) async {
    _search = value;

    _matingRecords = [];
    _lastId = null;
    _hasMore = true;

    _error = null;

    notifyListeners();

    await fetchMore();
  }

  Future<void> refresh() async {
    await fetchInitial(forceRefresh: true);
  }

  void updateResult(int matingRecordId, MatingResult result) {
    final index = _matingRecords.indexWhere((r) => r.id == matingRecordId);
    if (index == -1) return;

    _matingRecords[index] = _matingRecords[index].copyWith(result: result);
    notifyListeners();
  }
}
