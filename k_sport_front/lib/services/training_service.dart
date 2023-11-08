// training_service.dart
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'package:k_sport_front/helpers/logger.dart';
import 'package:k_sport_front/services/api.dart';
import 'package:k_sport_front/models/training.dart';

class TrainingService {
  static final String baseUrl = dotenv.env['API_URL'] ??
      'http://10.0.2.2:3000'; // Default URL if .env is not loaded

  Future<List<Map<String, dynamic>>> fetchExercises() async {
    try {
      return await Api.fetchExercises();
    } catch (e, s) {
      Log.logger.e('Error fetching exercises: $e\nStack trace: $s');
      rethrow;
    }
  }

  Future<Response> saveTraining(
      Map<String, dynamic> data, Training? editingTraining) async {
    if (editingTraining == null) {
      try {
        return await Api().postTraining(data);
      } catch (e, s) {
        Log.logger.e('Error saving training: $e\nStack trace: $s');
        rethrow;
      }
    } else {
      try {
        return await Api().updateTraining(editingTraining.id, data);
      } catch (e, s) {
        Log.logger.e('Error updating training: $e\nStack trace: $s');
        rethrow;
      }
    }
  }

  static Future<List<Training>> fetchTrainings() async {
    try {
      final response = await Api().get('$baseUrl/trainings');
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((item) => Training.fromJson(item)).toList();
      } else {
        throw Exception(
            'Error fetching trainings status code: ${response.statusCode}');
      }
    } catch (e, s) {
      Log.logger.e('Error fetching trainings: $e\nStack trace: $s');
      rethrow;
    }
  }

  static Future<Training?> fetchTraining(String? trainingId) async {
    if (trainingId == null) return null; // Handle null trainingId

    try {
      final response = await Api().get('$baseUrl/trainings/$trainingId');
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return Training.fromJson(data);
      } else {
        throw Exception(
            'Error fetching training, status code: ${response.statusCode}');
      }
    } catch (e, s) {
      Log.logger.e('Error fetching training: $e\nStack trace: $s');
      rethrow;
    }
  }

  static Future<Training?> fetchTrainingForDay(String day) async {
    try {
      final trainingData = await Api().fetchTrainingForDay(day.toLowerCase());
      if (trainingData.isEmpty) {
        return null;
      } else {
        return Training.fromJson(trainingData);
      }
    } catch (e, s) {
      Log.logger
          .e('Error fetching training for day: $day: $e\nStack trace: $s');
      rethrow;
    }
  }

  static Future<void> recordCompletedTraining(String trainingId) async {
    final DateTime now = DateTime.now();
    final String dateCompleted =
        now.toIso8601String(); // Convert to a string in ISO 8601 format

    final response = await Api().post(
      '$baseUrl/user/recordCompletedTraining',
      {
        'trainingId': trainingId,
        'dateCompleted': dateCompleted,
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to record training: ${response.body}');
    }
  }
}
