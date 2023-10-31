// api.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:k_sport_front/models/exercices.dart';
import 'package:k_sport_front/models/muscles.dart';
import 'package:k_sport_front/provider/user_provider.dart';
import 'package:k_sport_front/services/token_service.dart';
import 'package:k_sport_front/services/user_service.dart';

class Api {
  static final TokenService _tokenService = TokenService();
  static final _userService = UserService();

  static Future<http.Response> get(String url) async {
    final token = await _tokenService.getToken();
    print("\n--------------token in Api.get: $token");
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
    print("\n--------------token in post $token");
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

  static Future<http.Response> delete(String url) async {
    final token = await _tokenService.getToken();
    print("\n--------------token in Api.delete: $token");
    return http.delete(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
  }

  static Future<void> populateUserProvider(UserProvider userProvider) async {
    try {
      // Fetch user details using the stored token
      Map<String, dynamic> userDetails =
          await _userService.fetchUserDetails(_tokenService);

      // Populate the UserProvider with the fetched details
      userProvider.setUserData(userDetails);
    } catch (error) {
      print("Error populating UserProvider: $error");
    }
  }

  static Future<List<String>> fetchMusclesByGroup(String group) async {
    final response =
        await get('http://10.0.2.2:3000/muscles/byGroup?group=$group');

    if (response.statusCode == 200) {
      List<dynamic> responseBody = json.decode(response.body);
      // Extracting the muscle labels from the response
      List<String> muscleLabels =
          responseBody.map((muscle) => muscle['label'] as String).toList();
      return muscleLabels;
    } else {
      throw Exception('Failed to load muscles');
    }
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

  static Future<void> addMuscle(Muscle muscle) async {
    const url = 'http://10.0.2.2:3000/muscles';
    final response = await post(
      url,
      {
        'imageUrl': muscle.imageUrl,
        'label': muscle.label,
        'detailTitle': muscle.detailTitle,
      },
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add muscle');
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

  static Future<Map<String, dynamic>?> fetchExerciseDetailsByLabel(
      String exerciseLabel) async {
    try {
      final response =
          await get('http://10.0.2.2:3000/exercises/label/$exerciseLabel');

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('Failed to load exercise details: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
    return null;
  }

  static Future<List<Exercice>> fetchExercisesByMuscleGroup(
      String group) async {
    // Step 1: Fetch muscle labels by group
    List<String> muscleLabels = await fetchMusclesByGroup(group);

    // Step 2: Fetch exercises by muscle labels
    List<Exercice> exercises = [];
    for (String label in muscleLabels) {
      final response = await http
          .get(Uri.parse('http://10.0.2.2:3000/exercises?muscleLabel=$label'));

      if (response.statusCode == 200) {
        List<dynamic> responseBody = json.decode(response.body);
        exercises.addAll(responseBody
            .map((exercise) => Exercice.fromJson(exercise))
            .toList());
      } else {
        throw Exception('Failed to load exercises for muscle label: $label');
      }
    }
    return exercises;
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

  static Future<Map<String, dynamic>> fetchTrainingForDay(String day) async {
    final response =
        await get('http://10.0.2.2:3000/user/getTrainingForDay/$day');
    if (response.statusCode == 200) {
      return Map<String, dynamic>.from(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load training for $day');
    }
  }

  static Future<void> deleteTrainingForDay(String day) async {
    final token = await _tokenService.getToken();

    final response = await http.delete(
      Uri.parse('http://10.0.2.2:3000/user/deleteTrainingForDay/$day'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete training for $day');
    }
  }
}
