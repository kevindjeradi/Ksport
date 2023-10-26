// training_provider.dart

import 'package:flutter/material.dart';
import 'package:k_sport_front/models/training.dart';

class TrainingProvider with ChangeNotifier {
  final List<Training?> _weekTrainings = List.filled(7, null);

  List<Training?> get weekTrainings => _weekTrainings;

  void setTrainingForDay(int day, Training? training) {
    _weekTrainings[day - 1] = training;
    notifyListeners();
  }
}
