import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:k_sport_front/models/exercices.dart';

Future<List<Exercice>> fetchExercices(String muscleLabel) async {
  final response = await http.get(
      Uri.parse('http://10.0.2.2:3000/exercises?muscleLabel=$muscleLabel'));

  if (response.statusCode == 200) {
    List<dynamic> responseBody = json.decode(response.body);
    return responseBody.map((exercice) => Exercice.fromJson(exercice)).toList();
  } else {
    throw Exception('Failed to load workouts');
  }
}
