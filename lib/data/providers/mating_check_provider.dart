import 'package:flutter/material.dart';
import 'package:gosheep_mobile/data/exceptions/api_exception.dart';
import 'package:gosheep_mobile/data/exceptions/validation_exception.dart';
import 'package:gosheep_mobile/data/models/mating_check.dart';
import 'package:gosheep_mobile/data/services/mating_check_service.dart';

class MatingCheckProvider with ChangeNotifier {
  final MatingCheckService _service = MatingCheckService();
  final int _matingId;

  MatingCheckProvider(this._matingId);

  List<MatingCheck> _matingChecks = [];
  List<MatingCheck> get matingChecks => _matingChecks;

  String _message = '';
  String get message => _message;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isCreating = false;
  bool get isCreating => _isCreating;

  String? _error;
  String? get error => _error;

  ValidationException? _validationError;
  ValidationException? get validationError => _validationError;

  String? fieldError(String field) {
    return _validationError?.first(field);
  }

  Future<void> fetchMatingChecks() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _service.getMatingChecks(_matingId);

      _matingChecks = response.data ?? [];
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createMatingCheck({
    required String checkDate,
    required String result,
    String? notes,
    String? expectedBirthDate,
  }) async {
    if (_isCreating) return false;

    _isCreating = true;
    _error = null;
    _validationError = null;
    notifyListeners();

    try {
      final response = await _service.createMatingCheck(
        matingId: _matingId,
        checkDate: checkDate,
        result: result,
        notes: notes,
        expectedBirthDate: expectedBirthDate,
      );

      _matingChecks.insert(0, response.data!);
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

  void clearValidationError(String field) {
    if (_validationError == null) return;

    _validationError!.errors.remove(field);

    if (_validationError!.errors.isEmpty) {
      _validationError = null;
    }

    notifyListeners();
  }

  Future<bool> updateMatingCheck({
    required int matingCheckId,
    required String checkDate,
    required String result,
    String? notes,
    String? expectedBirthDate,
  }) async {
    if (_isCreating) return false;

    _isCreating = true;
    _error = null;
    _validationError = null;
    notifyListeners();

    try {
      final response = await _service.updateMatingCheck(
        matingCheckId: matingCheckId,
        checkDate: checkDate,
        result: result,
        notes: notes,
        expectedBirthDate: expectedBirthDate,
      );

      final updatedCheck = response.data!;
      final index = _matingChecks.indexWhere((c) => c.id == matingCheckId);
      if (index != -1) {
        _matingChecks[index] = updatedCheck;
        _matingChecks.sort((a, b) {
          int cmp = b.checkDate.compareTo(a.checkDate);
          if (cmp == 0) {
            return b.id.compareTo(a.id);
          }
          return cmp;
        });
      }
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
}
