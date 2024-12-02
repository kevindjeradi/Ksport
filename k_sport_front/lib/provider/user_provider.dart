// user_provider.dart

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:k_sport_front/helpers/logger.dart';
import 'package:k_sport_front/models/completed_training.dart';
import 'package:k_sport_front/services/api.dart';

final String baseUrl = dotenv.env['API_URL'] ?? 'http://10.0.2.2:3000';

class UserProvider extends ChangeNotifier {
  String? _username;
  String? _uniqueIdentifier;
  DateTime? _dateJoined;
  String? _profileImage;
  int? _numberOfTrainings;
  String? _theme;
  List<CompletedTraining>? _completedTrainings;
  List<Map<String, dynamic>> _friends = [];

  String get username => _username ?? '';
  String get uniqueIdentifier => _uniqueIdentifier ?? '';
  DateTime get dateJoined => _dateJoined ?? DateTime.now();
  String get profileImage => _profileImage ?? '';
  int get numberOfTrainings => _numberOfTrainings ?? 0;
  String get theme => _theme ?? '';
  List<CompletedTraining>? get completedTrainings => _completedTrainings ?? [];
  List<Map<String, dynamic>> get friends => _friends;

  void updateProfileImage(String newImageUrl) {
    _profileImage = newImageUrl;
    notifyListeners();
  }

  void addCompletedTraining(CompletedTraining training) {
    Log.logger.i(
        "completed training in user_provider: ${training.trainingId}\nTraining.name: ${training.name}\nTraining.description: ${training.description}\nTraining.exercises: ${training.exercises}\nTraining.goal: ${training.goal}");
    completedTrainings?.add(training);
    Log.logger
        .i("user_provider.completedTrainings in add: $completedTrainings");
    notifyListeners();
  }

  void removeCompletedTraining(CompletedTraining training) {
    _completedTrainings =
        completedTrainings?.where((t) => t.id != training.id).toList();
    notifyListeners();
  }

  void updateTrainingNote(String trainingId, String newNote) async {
    final trainingIndex =
        _completedTrainings?.indexWhere((t) => t.trainingId == trainingId);
    if (trainingIndex != null && trainingIndex >= 0) {
      _completedTrainings![trainingIndex].note = newNote;
      notifyListeners();
    }

    await Api().patch('$baseUrl/user/updateTrainingNote', {
      'trainingId': trainingId,
      'note': newNote,
    });
  }

  setUserData(Map<String, dynamic> userDetails) {
    _username = userDetails['username'];
    _uniqueIdentifier = userDetails['uniqueIdentifier'];
    _dateJoined = DateTime.parse(userDetails['dateJoined']);
    _profileImage = userDetails['profileImage'];
    _numberOfTrainings = userDetails['numberOfTrainings'];
    _theme = userDetails['theme'];
    // Check for null or non-list values
    if (userDetails['completedTrainings'] is List) {
      _completedTrainings = (userDetails['completedTrainings'] as List)
          .map((item) => CompletedTraining.fromMap(item))
          .toList();
    } else {
      Log.logger.e(
          'Unexpected data format for completedTrainings in user_provider: ${userDetails['completedTrainings']}');
    }
    if (userDetails['friends'] is List) {
      _friends = List<Map<String, dynamic>>.from(userDetails['friends']);
      Log.logger.i('user_provider.friends: $_friends');
    } else {
      Log.logger.e(
          'Unexpected data format for friends in user_provider : ${userDetails['friends']}');
    }
    notifyListeners();
  }
}
