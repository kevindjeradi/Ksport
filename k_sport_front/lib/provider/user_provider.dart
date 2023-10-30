// user_provider.dart

import 'package:flutter/foundation.dart';

class UserProvider extends ChangeNotifier {
  String? _username;
  DateTime? _dateJoined;
  String? _profileImage;
  int? _numberOfTrainings;

  String get username => _username ?? '';
  DateTime get dateJoined => _dateJoined ?? DateTime.now();
  String get profileImage => _profileImage ?? '';
  int get numberOfTrainings => _numberOfTrainings ?? 0;

  setUserData(Map<String, dynamic> userDetails) {
    _username = userDetails['username'];
    _dateJoined = DateTime.parse(userDetails['dateJoined']);
    _profileImage = userDetails['profileImage'];
    _numberOfTrainings = userDetails['numberOfTrainings'];
    notifyListeners();
  }
}
