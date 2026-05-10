import 'package:flutter/material.dart';
import 'package:gosheep_mobile/data/models/cage_option.dart';
import 'package:gosheep_mobile/data/models/sheep_option.dart';
import 'package:gosheep_mobile/data/services/sheep_form_option_service.dart';

class SheepFormOptionProvider with ChangeNotifier {
  final SheepFormOptionService _service = SheepFormOptionService();

  List<SheepOption> _breedOptions = [];
  List<SheepOption> get breedOptions => _breedOptions;

  bool _isLoadingBreeds = false;
  bool get isLoadingBreeds => _isLoadingBreeds;

  List<CageOption> _cageOptions = [];
  List<CageOption> get cageOptions => _cageOptions;

  bool _isLoadingCages = false;
  bool get isLoadingCages => _isLoadingCages;

  List<SheepOption> _sireOptions = [];
  List<SheepOption> get sireOptions => _sireOptions;

  bool _isLoadingSires = false;
  bool get isLoadingSires => _isLoadingSires;

  bool _sireHasMore = true;
  bool get sireHasMore => _sireHasMore;

  int? _sireLastId;

  String _sireSearch = '';
  bool get isSearchingSires => _sireSearch.isNotEmpty;

  List<SheepOption> _damOptions = [];
  List<SheepOption> get damOptions => _damOptions;

  bool _isLoadingDams = false;
  bool get isLoadingDams => _isLoadingDams;

  bool _damHasMore = true;
  bool get damHasMore => _damHasMore;

  int? _damLastId;

  String _damSearch = '';
  bool get isSearchingDams => _damSearch.isNotEmpty;

  String? _error;
  String? get error => _error;

  Future<void> loadBreedOptions() async {
    if (_isLoadingBreeds) return;

    _isLoadingBreeds = true;
    _error = null;

    notifyListeners();

    try {
      final result = await _service.getBreedOptions();

      _breedOptions = result;
    } catch (e) {
      _error = e.toString();
      _breedOptions = [];
    } finally {
      _isLoadingBreeds = false;
      notifyListeners();
    }
  }

  Future<void> loadCageOptions() async {
    if (_isLoadingCages) return;

    _isLoadingCages = true;
    _error = null;

    notifyListeners();

    try {
      final result = await _service.getCageOptions();

      _cageOptions = result;
    } catch (e) {
      _error = e.toString();
      _cageOptions = [];
    } finally {
      _isLoadingCages = false;
      notifyListeners();
    }
  }

  Future<void> loadInitialSires({bool forceRefresh = false}) async {
    if (_sireOptions.isNotEmpty && !forceRefresh) {
      return;
    }

    _sireOptions = [];
    _sireLastId = null;
    _sireHasMore = true;
    _error = null;

    await loadMoreSires();
  }

  Future<void> loadMoreSires() async {
    if (_isLoadingSires || !_sireHasMore) {
      return;
    }

    _isLoadingSires = true;

    notifyListeners();

    try {
      final response = await _service.getSireOptions(
        lastId: _sireLastId,
        search: _sireSearch,
      );

      _sireOptions.addAll(response.data);

      _sireLastId = response.nextCursor;

      _sireHasMore = response.hasMore;
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoadingSires = false;
      notifyListeners();
    }
  }

  Future<void> searchSires(String value) async {
    _sireSearch = value;

    _sireOptions = [];
    _sireLastId = null;
    _sireHasMore = true;
    _error = null;

    notifyListeners();

    await loadMoreSires();
  }

  Future<void> loadInitialDams({bool forceRefresh = false}) async {
    if (_damOptions.isNotEmpty && !forceRefresh) {
      return;
    }

    _damOptions = [];
    _damLastId = null;
    _damHasMore = true;
    _error = null;

    await loadMoreDams();
  }

  Future<void> loadMoreDams() async {
    if (_isLoadingDams || !_damHasMore) {
      return;
    }

    _isLoadingDams = true;

    notifyListeners();

    try {
      final response = await _service.getDamOptions(
        lastId: _damLastId,
        search: _damSearch,
      );

      _damOptions.addAll(response.data);

      _damLastId = response.nextCursor;

      _damHasMore = response.hasMore;
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoadingDams = false;
      notifyListeners();
    }
  }

  Future<void> searchDams(String value) async {
    _damSearch = value;

    _damOptions = [];
    _damLastId = null;
    _damHasMore = true;
    _error = null;

    notifyListeners();

    await loadMoreDams();
  }
}
