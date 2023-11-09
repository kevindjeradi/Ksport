// user_provider.dart

import 'package:flutter/foundation.dart';
import 'package:k_sport_front/helpers/logger.dart';
import 'package:k_sport_front/models/completed_training.dart';

class UserProvider extends ChangeNotifier {
  String? _username;
  DateTime? _dateJoined;
  String? _profileImage;
  int? _numberOfTrainings;
  String? _theme;
  List<CompletedTraining>? _completedTrainings;

  String get username => _username ?? '';
  DateTime get dateJoined => _dateJoined ?? DateTime.now();
  String get profileImage => _profileImage ?? '';
  int get numberOfTrainings => _numberOfTrainings ?? 0;
  String get theme => _theme ?? '';
  List<CompletedTraining>? get completedTrainings => _completedTrainings ?? [];

  void updateProfileImage(String newImageUrl) {
    _profileImage = newImageUrl;
    notifyListeners();
  }

  void addCompletedTraining(CompletedTraining training) {
    completedTrainings?.add(training);
    notifyListeners();
  }

  setUserData(Map<String, dynamic> userDetails) {
    _username = userDetails['username'];
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
    notifyListeners();
  }
}
