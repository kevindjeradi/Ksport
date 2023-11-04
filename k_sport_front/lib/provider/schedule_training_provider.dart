// schedule_training_provider.dart
import 'package:flutter/material.dart';
import 'package:k_sport_front/models/training.dart';
import 'package:k_sport_front/services/api.dart';
import 'package:k_sport_front/services/training_service.dart';

class ScheduleTrainingProvider with ChangeNotifier {
  List<Training?> weekTrainings = List.filled(7, null);
  List<Training> trainings = [];
  int currentSet = 1;
  bool isLoading = false;
  String errorMessage = '';
  static const List<String> dayNames = [
    'Lundi',
    'Mardi',
    'Mercredi',
    'Jeudi',
    'Vendredi',
    'Samedi',
    'Dimanche'
  ];

  Future<void> fetchTrainings() async {
    try {
      isLoading = true;
      notifyListeners();
      trainings = await TrainingService.fetchTrainings();
      isLoading = false;
      notifyListeners();
    } catch (e) {
      errorMessage = 'Error fetching trainings';
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchTrainingForDay(String dayName, int dayIndex) async {
    try {
      isLoading = true;
      notifyListeners();
      Training? training = await TrainingService.fetchTrainingForDay(dayName);
      weekTrainings[dayIndex] = training;
      isLoading = false;
      notifyListeners();
    } catch (e) {
      errorMessage = "Error fetching training for day $dayName";
      isLoading = false;
      notifyListeners();
    }
  }

  updateTrainingForDay(int dayIndex, Training? training) {
    weekTrainings[dayIndex] = training;
    notifyListeners();
  }

  fetchAllTrainingsForTheWeek() async {
    try {
      isLoading = true;
      notifyListeners();
      for (int index = 0; index < 7; index++) {
        await fetchTrainingForDay(dayNames[index], index);
        notifyListeners();
      }
      isLoading = false;
      notifyListeners();
    } catch (e) {
      errorMessage = "Error fetching trainings for the week";
      isLoading = false;
      notifyListeners();
    }
  }

  List<Map<String, dynamic>> get todayWorkouts {
    final today = DateTime.now().weekday -
        1; // DateTime.now().weekday returns 1 for Monday, 2 for Tuesday, etc.
    final trainingOfToday = weekTrainings[today];

    if (trainingOfToday != null) {
      return trainingOfToday.exercises
          .map((exercise) => {
                'name': exercise['label'],
                'series': exercise['sets'],
                'reps': exercise['repetitions'],
                'restTime': exercise['restTime'],
              })
          .toList();
    }
    return [];
  }

  Training? getTrainingForDay(String dayName) {
    int dayIndex = dayNames.indexOf(dayName);
    if (dayIndex != -1) {
      return weekTrainings[dayIndex];
    }
    return null;
  }

  Future<void> deleteTrainingForDay(int dayIndex) async {
    // Get the day name from dayNames list
    String dayName = dayNames[dayIndex].toLowerCase();
    try {
      isLoading = true;
      notifyListeners();
      // Delete training from the database
      await Api().deleteTrainingForDay(dayName);

      // Remove training from weekTrainings list
      weekTrainings[dayIndex] = null;

      isLoading = false;
      notifyListeners();
    } catch (e) {
      errorMessage = "Error deleting training for day $dayName\n\n$e";
      isLoading = false;
      notifyListeners();
    }
  }

  // Method to update the current set
  void updateCurrentSet(int newSet) {
    currentSet = newSet;
    notifyListeners();
  }
}
