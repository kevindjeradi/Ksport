import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:k_sport_front/helpers/logger.dart';
import 'package:k_sport_front/services/api.dart';
import 'package:k_sport_front/services/token_service.dart';

class CardioService {
  final TokenService _tokenService = TokenService();

  Future<http.Response> saveCardioSession(Map<String, dynamic> data) async {
    try {
      final token = await _tokenService.getToken();
      final response = await http.post(
        Uri.parse('${Api.baseUrl}/cardio-sessions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data),
      );
      return response;
    } catch (e, s) {
      Log.logger.e('Error saving cardio session: $e\nStack trace: $s');
      rethrow;
    }
  }

  Future<List<dynamic>> getCardioSessions() async {
    try {
      final token = await _tokenService.getToken();
      final response = await http.get(
        Uri.parse('${Api.baseUrl}/cardio-sessions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load cardio sessions');
      }
    } catch (e, s) {
      Log.logger.e('Error getting cardio sessions: $e\nStack trace: $s');
      rethrow;
    }
  }
}
