// training_service.dart
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
}
