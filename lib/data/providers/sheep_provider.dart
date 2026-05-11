import 'package:flutter/material.dart';
import 'package:gosheep_mobile/data/exceptions/api_exception.dart';
import 'package:gosheep_mobile/data/exceptions/validation_exception.dart';
import 'package:gosheep_mobile/data/models/sheep.dart';
import 'package:gosheep_mobile/data/models/sheep_health_stats.dart';
import '../services/sheep_service.dart';

class SheepProvider with ChangeNotifier {
  final SheepService _service = SheepService();

  SheepHealthStats? _healthStats;
  SheepHealthStats? get healthStats => _healthStats;

  List<Sheep> _sheepList = [];
  List<Sheep> get sheepList => _sheepList;

  String _message = '';
  String get message => _message;

  bool _isInitialized = false;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isCreating = false;
  bool get isCreating => _isCreating;

  bool _hasMore = true;
  bool get hasMore => _hasMore;

  int? _lastId;
  final int _limit = 10;

  String _search = '';
  bool get isSearching => _search.isNotEmpty;

  String? _error;
  String? get error => _error;

  ValidationException? _validationError;
  ValidationException? get validationError => _validationError;

  String? fieldError(String field) {
    return _validationError?.first(field);
  }

  Future<void> fetchInitial({bool forceRefresh = false}) async {
    if (_isInitialized && !forceRefresh) return;

    _isInitialized = true;

    _sheepList = [];
    _lastId = null;
    _hasMore = true;
    _error = null;
    _validationError = null;
    _isLoading = false;

    await fetchMore();
  }

  Future<void> fetchMore() async {
    if (_isLoading || !_hasMore) return;

    _isLoading = true;
    notifyListeners();

    try {
      final response = await _service.getSheep(
        lastId: _lastId,
        limit: _limit,
        search: _search,
      );

      _sheepList.addAll(response.data);
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

  Future<bool> createSheep({
    required String earTag,
    required String earTagColor,
    required String gender,
    required String birthDate,
    int? breedId,
    int? cageId,
    int? sireId,
    int? damId,
    required String condition,
    required String category,
    required String severity,
    required double weight,
    String? notes,
  }) async {
    try {
      _isCreating = true;

      _error = null;
      _validationError = null;

      notifyListeners();

      final response = await _service.createSheep(
        earTag: earTag,
        earTagColor: earTagColor,
        gender: gender,
        birthDate: birthDate,
        breedId: breedId,
        cageId: cageId,
        sireId: sireId,
        damId: damId,
        condition: condition,
        category: category,
        severity: severity,
        weight: weight,
        notes: notes,
      );

      _sheepList.insert(0, response.data!);
      _message = response.message;

      return true;
    } on ValidationException catch (e) {
      _validationError = e;

      return false;
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

  Future<void> searchSheep(String value) async {
    _search = value;

    _sheepList = [];
    _lastId = null;
    _hasMore = true;

    _error = null;
    _validationError = null;

    notifyListeners();

    await fetchMore();
  }

  Future<void> refresh() async {
    await fetchInitial(forceRefresh: true);
  }

  Future<bool> deleteSheep(int sheepId) async {
    try {
      _isLoading = true;
      notifyListeners();

      final index = _sheepList.indexWhere((s) => s.id == sheepId);

      if (index == -1) {
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final backup = _sheepList[index];
      _sheepList.removeAt(index);

      notifyListeners();

      try {
        final message = await _service.deleteSheep(sheepId);

        _message = message;
        _error = null;

        return true;
      } catch (e) {
        _sheepList.insert(index, backup);
        _error = e.toString();

        return false;
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearValidationError(String field) {
    if (_validationError == null) return;

    _validationError!.errors.remove(field);

    if (_validationError!.errors.isEmpty) {
      _validationError = null;
    }

    notifyListeners();
  }
}
