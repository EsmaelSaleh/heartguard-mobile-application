import 'dart:async';

class AuthService {
  // Private constructor for Singleton pattern
  AuthService._internal();
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;

  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  Future<bool> login(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Simple mock logic: any email with 'fail' in it will fail
    if (email.contains('fail') || password.length < 6) {
      return false;
    }

    _isLoggedIn = true;
    return true;
  }

  Future<bool> signup(String name, String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    if (email.contains('fail') || password.length < 8) {
      return false;
    }

    _isLoggedIn = true;
    return true;
  }

  void logout() {
    _isLoggedIn = false;
  }
}
