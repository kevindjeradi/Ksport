import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:k_sport_front/helpers/logger.dart';
import 'package:k_sport_front/services/api.dart';

class CardioService {
  Future<void> deleteCardioSession(String id) async {
    final response = await Api().delete('${Api.baseUrl}/cardio-sessions/$id');
    if (response.statusCode != 200) {
      throw Exception('Failed to delete cardio session');
    }
  }

  Future<http.Response> saveCardioSession(Map<String, dynamic> data) async {
    try {
      final response = await Api().post(
        '${Api.baseUrl}/cardio-sessions',
        data,
      );
      return response;
    } catch (e, s) {
      Log.logger.e('Error saving cardio session: $e\nStack trace: $s');
      rethrow;
    }
  }

  Future<List<dynamic>> getCardioSessions() async {
    try {
      final response = await Api().get('${Api.baseUrl}/cardio-sessions');

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

  Future<void> updateCardioNote(String sessionId, String newNote) async {
    try {
      final response = await Api().patch(
        '${Api.baseUrl}/cardio/updateNote',
        {
          'sessionId': sessionId,
          'note': newNote,
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update note');
      }
    } catch (e) {
      Log.logger.e('Error updating cardio note: $e');
      rethrow;
    }
  }
}
