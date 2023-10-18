import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:k_sport_front/models/workout.dart';

Future<List<Workout>> fetchWorkouts() async {
  final response = await http.get(Uri.parse('http://10.0.2.2:3000/workouts'));

  if (response.statusCode == 200) {
    List<dynamic> responseBody = json.decode(response.body);
    return responseBody.map((workout) => Workout.fromJson(workout)).toList();
  } else {
    throw Exception('Failed to load workouts');
  }
}
