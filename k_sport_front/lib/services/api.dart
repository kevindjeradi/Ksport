// api.dart
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:k_sport_front/helpers/logger.dart';
import 'package:k_sport_front/models/exercices.dart';
import 'package:k_sport_front/models/muscles.dart';
import 'package:k_sport_front/provider/user_provider.dart';
import 'package:k_sport_front/services/token_service.dart';
import 'package:k_sport_front/services/user_service.dart';

class Api {
  static final TokenService _tokenService = TokenService();
  static final _userService = UserService();
  static final String baseUrl = dotenv.env['API_URL'] ??
      'http://10.0.2.2:3000'; // Default URL if .env is not loaded

  Future<http.Response> _handleRequest(
      Future<http.Response> Function() action) async {
    try {
      final response = await action();
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      } else {
        Log.logger.e('Request failed with status: ${response.statusCode}');
        throw Exception('Failed to complete request');
      }
    } catch (e, s) {
      Log.logger.e('Error: $e\nStack trace: $s');
      throw Exception('Failed to complete request');
    }
  }

  Future<http.Response> get(String url) async {
    final token = await _tokenService.getToken();
    return _handleRequest(() => http.get(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ));
  }

  Future<http.Response> post(String url, Map<String, dynamic> data) async {
    final token = await _tokenService.getToken();
    return _handleRequest(() => http.post(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(data),
        ));
  }

  Future<http.Response> put(String url, Map<String, dynamic> data) async {
    final token = await _tokenService.getToken();
    return _handleRequest(() => http.put(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(data),
        ));
  }

  Future<http.Response> patch(String url, Map<String, dynamic> data) async {
    final token = await _tokenService.getToken();
    return _handleRequest(() => http.patch(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(data),
        ));
  }

  Future<http.Response> delete(String url) async {
    final token = await _tokenService.getToken();
    return _handleRequest(() => http.delete(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ));
  }

  static Future<void> populateUserProvider(UserProvider userProvider) async {
    try {
      // Fetch user details using the stored token
      Map<String, dynamic> userDetails =
          await _userService.fetchUserDetails(_tokenService);

      // Populate the UserProvider with the fetched details
      userProvider.setUserData(userDetails);
    } catch (e) {
      Log.logger.e("Error populating UserProvider");
    }
  }

  Future<List<String>> fetchMusclesByGroup(String group) async {
    final response = await get('$baseUrl/muscles/byGroup?group=$group');

    if (response.statusCode == 200) {
      List<dynamic> responseBody = json.decode(response.body);
      // Extracting the muscle labels from the response
      List<String> muscleLabels =
          responseBody.map((muscle) => muscle['label'] as String).toList();
      return muscleLabels;
    } else {
      throw Exception('Failed to load muscles by group -> group: $group');
    }
  }

  Future<List<Muscle>> fetchMuscles() async {
    final response = await get('$baseUrl/muscles');

    if (response.statusCode == 200) {
      List<dynamic> responseBody = json.decode(response.body);
      return responseBody.map((muscle) => Muscle.fromJson(muscle)).toList();
    } else {
      throw Exception('Failed to fetch Muscles');
    }
  }

  Future<void> addMuscle(Muscle muscle) async {
    final url = '$baseUrl/muscles';
    final response = await post(
      url,
      {
        'imageUrl': muscle.imageUrl,
        'label': muscle.label,
        'detailTitle': muscle.detailTitle,
        'groupe': muscle.groupe,
      },
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add muscle');
    }
  }

  Future<List<Exercice>> fetchExercisesByMuscle(String muscleLabel) async {
    final response = await get('$baseUrl/exercises?muscleLabel=$muscleLabel');

    if (response.statusCode == 200) {
      List<dynamic> responseBody = json.decode(response.body);
      return responseBody
          .map((exercice) => Exercice.fromJson(exercice))
          .toList();
    } else {
      throw Exception(
          'Failed to load exercises by muscle -> muscle: $muscleLabel');
    }
  }

  Future<Map<String, dynamic>?> fetchExerciseDetailsByLabel(
      String exerciseLabel) async {
    final response = await get('$baseUrl/exercises/label/$exerciseLabel');

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      Log.logger.e(
          'Failed to load exercise details by label -> exerciseLabel: $exerciseLabel');
    }
    return null;
  }

  Future<List<Exercice>> fetchExercisesByMuscleGroup(String group) async {
    // Step 1: Fetch muscle labels by group
    List<String> muscleLabels = await fetchMusclesByGroup(group);

    // Step 2: Fetch exercises by muscle labels
    List<Exercice> exercises = [];
    for (String label in muscleLabels) {
      final response = await get('$baseUrl/exercises?muscleLabel=$label');

      if (response.statusCode == 200) {
        List<dynamic> responseBody = json.decode(response.body);
        exercises.addAll(responseBody
            .map((exercise) => Exercice.fromJson(exercise))
            .toList());
      } else {
        throw Exception(
            'Failed to fetch exercises by muscle group -> label: $label / group: $group');
      }
    }
    return exercises;
  }

  static Future<List<Map<String, dynamic>>> fetchExercises() async {
    final response = await http.get(Uri.parse('$baseUrl/exercises'));
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch exercises');
    }
  }

  Future<http.Response> postTraining(Map<String, dynamic> data) {
    return post('$baseUrl/trainings', data);
  }

  Future<http.Response> updateTraining(String id, Map<String, dynamic> data) {
    return put('$baseUrl/trainings/$id', data);
  }

  Future<Map<String, dynamic>> fetchTrainingForDay(String day) async {
    final response = await get('$baseUrl/user/getTrainingForDay/$day');
    if (response.statusCode == 200) {
      return Map<String, dynamic>.from(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load training for day -> day: $day');
    }
  }

  Future<void> deleteTrainingForDay(String day) async {
    final response = await delete('$baseUrl/user/deleteTrainingForDay/$day');
    if (response.statusCode != 200) {
      throw Exception('Failed to delete training for day -> day: $day');
    }
  }
}
