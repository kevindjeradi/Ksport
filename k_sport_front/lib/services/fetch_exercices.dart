import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:k_sport_front/models/exercices.dart';

Future<List<Exercice>> fetchExercices(String muscleId) async {
  final response = await http
      .get(Uri.parse('http://10.0.2.2:3000/exercises?muscleId=$muscleId'));

  if (response.statusCode == 200) {
    List<dynamic> responseBody = json.decode(response.body);
    return responseBody.map((exercice) => Exercice.fromJson(exercice)).toList();
  } else {
    print("\n\n\n${response.statusCode}\n\n\n");
    throw Exception('Failed to load workouts');
  }
}
