import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:k_sport_front/models/exercices.dart';
import 'package:k_sport_front/models/muscles.dart';
import 'package:k_sport_front/services/token_service.dart';

class Api {
  static final TokenService _tokenService = TokenService();

  static Future<http.Response> get(String url) async {
    final token = await _tokenService.getToken();
    print("\n\n--------------token in Api.get: $token--------------\n\n");
    return http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
  }

  static Future<http.Response> post(
      String url, Map<String, dynamic> data) async {
    final token = await _tokenService.getToken();
    return http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );
  }

  static Future<http.Response> put(
      String url, Map<String, dynamic> data) async {
    final token = await _tokenService.getToken();
    return http.put(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );
  }

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
    return post('http://10.0.2.2:3000/trainings', data);
  }

  static Future<http.Response> updateTraining(
      String id, Map<String, dynamic> data) {
    return put('http://10.0.2.2:3000/trainings/$id', data);
  }
}
