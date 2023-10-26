// training_service.dart
import 'dart:convert';

import 'package:http/http.dart';
import 'package:k_sport_front/services/api.dart';
import 'package:k_sport_front/models/training.dart';

class TrainingService {
  Future<List<Map<String, dynamic>>> fetchExercises() async {
    try {
      return await Api.fetchExercises();
    } catch (e) {
      print('Error fetching exercises: $e');
      rethrow;
    }
  }

  Future<Response> saveTraining(
      Map<String, dynamic> data, Training? editingTraining) async {
    if (editingTraining == null) {
      try {
        return await Api.postTraining(data);
      } catch (e) {
        print('Error posting training: $e');
        rethrow;
      }
    } else {
      try {
        return await Api.updateTraining(editingTraining.id, data);
      } catch (e) {
        print('Error updating training: $e');
        rethrow;
      }
    }
  }

  static Future<List<Training>> fetchTrainings() async {
    try {
      final response = await Api.get('http://10.0.2.2:3000/trainings');
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((item) => Training.fromJson(item)).toList();
      } else {
        throw Exception('Error fetching trainings');
      }
    } catch (e) {
      print('Error fetching trainings: $e');
      rethrow;
    }
  }

  static Future<Training?> fetchTrainingForDay(String day) async {
    try {
      final trainingData = await Api.fetchTrainingForDay(day.toLowerCase());
      if (trainingData.isEmpty) {
        return null;
      } else {
        return Training.fromJson(trainingData);
      }
    } catch (e) {
      print('Error fetching training for day $day: $e');
      rethrow;
    }
  }
}
