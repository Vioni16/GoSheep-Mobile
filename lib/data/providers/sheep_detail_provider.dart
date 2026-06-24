import 'package:flutter/material.dart';
import 'package:gosheep_mobile/data/exceptions/api_exception.dart';
import 'package:gosheep_mobile/data/exceptions/validation_exception.dart';
import 'package:gosheep_mobile/data/models/sheep.dart';
import 'package:gosheep_mobile/data/models/sheep_detail.dart';
import 'package:gosheep_mobile/data/services/sheep_service.dart';

class SheepDetailProvider with ChangeNotifier {
  final SheepService _service = SheepService();

  SheepDetail? _sheepDetail;
  bool _isLoading = false;
  bool _isUpdating = false;
  String? _error;
  ValidationException? _validationError;

  SheepDetail? get sheepDetail => _sheepDetail;
  bool get isLoading => _isLoading;
  bool get isUpdating => _isUpdating;
  String? get error => _error;
  ValidationException? get validationError => _validationError;

  String? fieldError(String field) {
    return _validationError?.first(field);
  }

  void clearValidationError(String field) {
    if (_validationError == null) return;
    _validationError!.errors.remove(field);
    if (_validationError!.errors.isEmpty) {
      _validationError = null;
    }
    notifyListeners();
  }

  Future<void> init(
    int id, {
    Sheep? initialData,
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh && initialData != null) {
      _sheepDetail = SheepDetail.fromSheep(initialData);
      notifyListeners();
    }

    _isLoading = true;
    _error = null;
    _validationError = null;
    notifyListeners();

    try {
      final detail = await _service.getSheepDetails(id);
      _sheepDetail = detail;
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh(int id) async {
    await init(id, forceRefresh: true);
  }

  Future<bool> updateSheep(int id, Map<String, dynamic> data) async {
    try {
      _isUpdating = true;
      _error = null;
      _validationError = null;
      notifyListeners();

      final updatedDetail = await _service.updateSheep(id, data);
      _sheepDetail = updatedDetail;
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
      _isUpdating = false;
      notifyListeners();
    }
  }
}

