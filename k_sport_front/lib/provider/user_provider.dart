// user_provider.dart

import 'package:flutter/foundation.dart';

class UserProvider extends ChangeNotifier {
  String? _username;
  DateTime? _dateJoined;
  String? _profileImage;

  String get username => _username ?? '';
  DateTime get dateJoined => _dateJoined ?? DateTime.now();
  String get profileImage => _profileImage ?? '';

  setUserData(Map<String, dynamic> userDetails) {
    _username = userDetails['username'];
    _dateJoined = DateTime.parse(userDetails['dateJoined']);
    _profileImage = userDetails['profileImage'];
    notifyListeners();
  }
}
