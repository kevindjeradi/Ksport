import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:k_sport_front/models/muscles.dart';

Future<List<Muscle>> fetchMuscles() async {
  final response = await http.get(Uri.parse('http://10.0.2.2:3000/muscles'));

  if (response.statusCode == 200) {
    List<dynamic> responseBody = json.decode(response.body);
    return responseBody.map((muscle) => Muscle.fromJson(muscle)).toList();
  } else {
    print("\n\n\n${response.statusCode}\n\n\n");
    throw Exception('Failed to load workouts');
  }
}
