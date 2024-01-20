// user_service.dart
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:k_sport_front/helpers/logger.dart';
import 'package:k_sport_front/services/api.dart';
import 'package:k_sport_front/services/token_service.dart';

class UserService {
  static final String baseUrl = dotenv.env['API_URL'] ??
      'http://10.0.2.2:3000'; // Default URL if .env is not loaded

  Future<Map<String, dynamic>> signup(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/signup'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({'username': username, 'password': password}),
      );

      return json.decode(response.body);
    } catch (e, s) {
      Log.logger.e("An error occurred on signup: $e\n Stack trace: $s");
      rethrow;
    }
  }

  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({'username': username, 'password': password}),
      );

      return json.decode(response.body);
    } catch (e) {
      Log.logger.e("An error occurred on login: $e");
      rethrow;
    }
  }

  Future<Map<String, dynamic>> fetchUserDetails(
      TokenService tokenService) async {
    try {
      final response = await Api().get('$baseUrl/user/details');

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to fetch user details');
      }
    } catch (e) {
      Log.logger.e("An error occurred fetching user details: $e");
      rethrow;
    }
  }

  Future<Map<String, dynamic>> userExists(String uniqueIdentifier) async {
    final response = await Api().get('$baseUrl/user/exists/$uniqueIdentifier');
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return {'exists': false};
    }
  }

  Future<bool> addFriend(String friendId) async {
    try {
      final response = await Api().post(
        '$baseUrl/user/addFriend',
        {'friendId': friendId},
      );

      if (response.statusCode == 200) {
        return true; // Friend added successfully
      } else {
        Log.logger.e('Failed to add friend: ${response.body}');
        return false; // Failed to add friend
      }
    } catch (e) {
      Log.logger.e("An error occurred while adding friend: $e");
      return false; // An error occurred
    }
  }

  Future<bool> validateToken(String token) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/validate'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({'token': token}),
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        return responseBody['valid'];
      } else {
        return false;
      }
    } catch (e) {
      Log.logger.e("An error occurred during token validation: $e");
      return false;
    }
  }
}
