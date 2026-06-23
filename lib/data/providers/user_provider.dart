import 'package:flutter/material.dart';
import 'package:gosheep_mobile/data/models/user.dart';
import 'package:gosheep_mobile/data/services/secure_storage_service.dart';
import 'package:gosheep_mobile/data/services/user_service.dart';

class UserProvider with ChangeNotifier {
  final UserService _userService = UserService();

  User? _user;

  bool _isLoading = false;
  String? _errorMessage;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  bool get isLoggedIn => _user != null;

  Future<bool> login({required String email, required String password}) async {
    try {
      _isLoading = true;
      _errorMessage = null;

      notifyListeners();

      final loginResponse = await _userService.login(email, password);

      _user = loginResponse.user;

      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void logout() async {
    await SecureStorageService.deleteToken();
    _user = null;
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> requestPasswordReset(String email) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final message = await _userService.requestPasswordReset(email);
      _errorMessage = message; // Using errorMessage to store the success message temporarily or we can just return true.
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  Future<void> fetchProfile() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _user = await _userService.getProfile();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateProfile({
    required String name,
    required String email,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _user = await _userService.updateProfile(name: name, email: email);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
