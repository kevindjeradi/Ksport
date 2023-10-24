// user_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:k_sport_front/services/api.dart';
import 'package:k_sport_front/services/token_service.dart';

class UserService {
  static const String _baseUrl = 'http://10.0.2.2:3000';

  Future<Map<String, dynamic>> signup(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/signup'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({'username': username, 'password': password}),
      );

      return json.decode(response.body);
    } catch (e) {
      print("An error occurred on signup: $e");
      rethrow;
    }
  }

  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({'username': username, 'password': password}),
      );

      return json.decode(response.body);
    } catch (e) {
      print("An error occurred on login: $e");
      rethrow;
    }
  }

  Future<Map<String, dynamic>> fetchUserDetails(
      TokenService tokenService) async {
    try {
      final response = await Api.get('$_baseUrl/user/details');

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to fetch user details');
      }
    } catch (e) {
      print("An error occurred fetching user details: $e");
      rethrow;
    }
  }
}
