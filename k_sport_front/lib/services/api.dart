import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:k_sport_front/models/exercices.dart';
import 'package:k_sport_front/models/muscles.dart';

class Api {
  static Future<List<Muscle>> fetchMuscles() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:3000/muscles'));

    if (response.statusCode == 200) {
      List<dynamic> responseBody = json.decode(response.body);
      return responseBody.map((muscle) => Muscle.fromJson(muscle)).toList();
    } else {
      throw Exception('Failed to load workouts');
    }
  }

  static Future<List<Exercice>> fetchExercisesByMuscle(
      String muscleLabel) async {
    final response = await http.get(
        Uri.parse('http://10.0.2.2:3000/exercises?muscleLabel=$muscleLabel'));

    if (response.statusCode == 200) {
      List<dynamic> responseBody = json.decode(response.body);
      return responseBody
          .map((exercice) => Exercice.fromJson(exercice))
          .toList();
    } else {
      throw Exception('Failed to load exercises');
    }
  }

  static Future<List<Map<String, dynamic>>> fetchExercises() async {
    final response =
        await http.get(Uri.parse('http://10.0.2.2:3000/exercises'));
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load exercises');
    }
  }

  static Future<http.Response> postTraining(Map<String, dynamic> data) {
    return http.post(
      Uri.parse('http://10.0.2.2:3000/trainings'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
  }

  static Future<http.Response> updateTraining(
      String id, Map<String, dynamic> data) {
    return http.put(
      Uri.parse('http://10.0.2.2:3000/trainings/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
  }
}
