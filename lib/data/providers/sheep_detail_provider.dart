import 'package:flutter/material.dart';
import 'package:gosheep_mobile/data/models/sheep.dart';
import 'package:gosheep_mobile/data/models/sheep_detail.dart';
import 'package:gosheep_mobile/data/services/sheep_service.dart';

class SheepDetailProvider with ChangeNotifier {
  final SheepService _service = SheepService();

  SheepDetail? _sheepDetail;
  bool _isLoading = false;
  String? _error;

  SheepDetail? get sheepDetail => _sheepDetail;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> init(int id, {Sheep? initialData, bool forceRefresh = false}) async {

    if (!forceRefresh && initialData != null) {
      _sheepDetail = SheepDetail.fromSheep(initialData);
      notifyListeners();
    }

    _isLoading = true;
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
}