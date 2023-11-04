// user_provider.dart

import 'package:flutter/foundation.dart';
import 'package:k_sport_front/helpers/logger.dart';

class UserProvider extends ChangeNotifier {
  String? _username;
  DateTime? _dateJoined;
  String? _profileImage;
  int? _numberOfTrainings;
  String? _theme;

  String get username => _username ?? '';
  DateTime get dateJoined => _dateJoined ?? DateTime.now();
  String get profileImage => _profileImage ?? '';
  int get numberOfTrainings => _numberOfTrainings ?? 0;
  String get theme => _theme ?? '';

  setUserData(Map<String, dynamic> userDetails) {
    Log.logger.i("user details theme: ${userDetails['theme']}");

    _username = userDetails['username'];
    _dateJoined = DateTime.parse(userDetails['dateJoined']);
    _profileImage = userDetails['profileImage'];
    _numberOfTrainings = userDetails['numberOfTrainings'];
    _theme = userDetails['theme'];
    notifyListeners();
  }
}
