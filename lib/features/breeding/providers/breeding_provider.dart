import 'package:flutter/material.dart';
import 'package:gosheep_mobile/data/models/sheep_breeding.dart';
import 'package:gosheep_mobile/data/models/recommendation.dart';
import 'package:gosheep_mobile/features/breeding/services/breeding_service.dart';

class BreedingProvider with ChangeNotifier {
  final BreedingService _service = BreedingService();

  List<SheepBreeding> _femaleList = [];
  List<SheepBreeding> get femaleList => _femaleList;

  List<SheepBreeding> _maleList = [];
  List<SheepBreeding> get maleList => _maleList;

  bool _isLoadingList = false;
  bool get isLoadingList => _isLoadingList;

  String? _listError;
  String? get listError => _listError;

  RecommendationResult? _result;
  RecommendationResult? get result => _result;

  bool _isLoadingRecommendation = false;
  bool get isLoadingRecommendation => _isLoadingRecommendation;

  String? _recommendationError;
  String? get recommendationError => _recommendationError;

  SheepBreeding? _selectedSheep;
  SheepBreeding? get selectedSheep => _selectedSheep;

  Future<void> loadSheepList() async {
    _isLoadingList = true;
    _listError = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        _service.getSheepList('female'),
        _service.getSheepList('male'),
      ]);

      _femaleList = results[0].data ?? [];
      _maleList = results[1].data ?? [];
    } catch (e) {
      _listError = e.toString();
      _femaleList = [];
      _maleList = [];
    } finally {
      _isLoadingList = false;
      notifyListeners();
    }
  }

  Future<void> selectSheep(SheepBreeding sheep) async {
    _selectedSheep = sheep;
    _isLoadingRecommendation = true;
    _recommendationError = null;
    _result = null;
    notifyListeners();

    try {
      final response = await _service.getRecommendations(sheep.id);
      _result = response.data;
    } catch (e) {
      _recommendationError = e.toString();
      _result = null;
    } finally {
      _isLoadingRecommendation = false;
      notifyListeners();
    }
  }
}
