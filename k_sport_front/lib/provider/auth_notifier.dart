// auth_notifier.dart
import 'package:flutter/foundation.dart';
import 'package:k_sport_front/services/token_service.dart';
import 'package:k_sport_front/services/user_service.dart';

class AuthNotifier extends ChangeNotifier {
  bool _isAuthenticated = false;
  final _tokenService = TokenService();
  final _userService = UserService();

  bool get isAuthenticated => _isAuthenticated;

  Future<void> checkAuthStatus() async {
    final token = await _tokenService.getToken();
    _isAuthenticated = token != null;
    notifyListeners();
  }

  Future<bool> login(String username, String password) async {
    try {
      final response = await _userService.login(username, password);
      if (response.containsKey('token')) {
        await _tokenService.saveToken(response['token']);
        _isAuthenticated = true;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<void> logout() async {
    await _tokenService.deleteToken();
    _isAuthenticated = false;
    notifyListeners();
  }
}
