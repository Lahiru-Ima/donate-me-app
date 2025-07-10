import 'package:donate_me_app/src/services/session_service.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthenticationProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  UserModel? _userModel;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get userModel => _userModel;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Check if user is authenticated
  bool get isAuthenticated => _authService.isSignedIn && _userModel != null;

  // Sign in
  Future<void> signIn(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _userModel = await _authService.signIn(email, password);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  // Sign up
  Future<void> signUp(
    String name,
    String phoneNumber,
    String email,
    String password,
    String dob,
    String gender,
  ) async {
    try {
      _userModel = await _authService.signUp(
        name,
        phoneNumber,
        email,
        password,
        dob,
        gender,
      );
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  // Update user
  Future<void> updateUser(UserModel user) async {
    try {
      await _authService.updateUser(user);
      _userModel = user;
      notifyListeners();
    } catch (e) {
      throw AuthException('Failed to update user: ${e.toString()}');
    }
  }

  // Sign out
  Future<void> signOut() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authService.signOut();
      _userModel = null;
      _errorMessage = null;
      await SharedPref.clearSession();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to sign out: ${e.toString()}';
      notifyListeners();
      rethrow;
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authService.resetPassword(email);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  // Fetch user model
  Future<void> loadUser() async {
    try {
      final userId = await SharedPref.getUserId();
      if (userId != null) {
        _userModel = await _authService.fetchUserModel(userId);
        notifyListeners();
      }
    } catch (e) {
      await SharedPref.clearSession();
    }
  }

  // Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
