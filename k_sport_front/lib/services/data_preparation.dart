import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:k_sport_front/helpers/logger.dart';
import 'package:k_sport_front/provider/user_provider.dart';
import 'package:k_sport_front/services/api.dart';

class DataPreparation {
  final UserProvider userProvider;

  DataPreparation(this.userProvider);

  Future<Map<String, dynamic>> computeMetrics() async {
    final completedTrainings = userProvider.completedTrainings;
    if (completedTrainings == null || completedTrainings.isEmpty) {
      Log.logger.w("No completed trainings found");
      return {}; // Return empty metrics if there are no completed trainings
    }

    int totalTrainings = completedTrainings.length;
    double totalWeightLifted = 0;
    int totalDays = 0;

    DateTime? accountCreationDate = userProvider.dateJoined;
    DateTime? lastTrainingDate;

    for (var completedTraining in completedTrainings) {
      for (var exercise in completedTraining.exercises) {
        totalWeightLifted +=
            exercise.weight.fold(0, (total, weight) => total + weight);
      }

      if (lastTrainingDate == null ||
          lastTrainingDate.isBefore(completedTraining.dateCompleted)) {
        lastTrainingDate = completedTraining.dateCompleted;
      }
    }

    if (lastTrainingDate != null) {
      totalDays = lastTrainingDate.difference(accountCreationDate).inDays + 1;
    }

    final double meanTrainingsPerWeek =
        totalDays > 0 ? (totalTrainings / totalDays) * 7 : 0;
    final String meanTrainingsPerWeekFormatted =
        meanTrainingsPerWeek.toStringAsFixed(2);

    final now = DateTime.now();
    final currentMonth = now.month;
    final currentYear = now.year;

    final trainingsThisMonth = completedTrainings
        .where((training) =>
            training.dateCompleted.month == currentMonth &&
            training.dateCompleted.year == currentYear)
        .length;

    return {
      'totalTrainings': totalTrainings,
      'totalWeightLifted': totalWeightLifted,
      'meanTrainingsPerWeek': meanTrainingsPerWeekFormatted,
      'trainingsThisMonth': trainingsThisMonth,
    };
  }

  Future<Map<String, Map<String, int>>> computeMuscleGroupProportions() async {
    final completedTrainings = userProvider.completedTrainings;
    if (completedTrainings == null || completedTrainings.isEmpty) {
      return {'allTime': {}, 'lastThreeMonths': {}, 'currentMonth': {}};
    }

    Map<String, int> emptyMuscleGroupCounts() =>
        {'Jambes': 0, 'Dos': 0, 'Torse': 0, 'Bras': 0};

    var allTimeMuscleGroupCounts = emptyMuscleGroupCounts();
    var lastThreeMonthsMuscleGroupCounts = emptyMuscleGroupCounts();
    var currentMonthMuscleGroupCounts = emptyMuscleGroupCounts();

    final now = DateTime.now();
    final threeMonthsAgo = now.subtract(const Duration(days: 90));
    final firstDayOfCurrentMonth = DateTime(now.year, now.month, 1);
    final lastDayOfCurrentMonth = DateTime(now.year, now.month + 1, 0);

    var exerciseCache = <String, String>{};

    for (var completedTraining in completedTrainings) {
      for (var exercise in completedTraining.exercises) {
        String muscleGroup;
        if (exerciseCache.containsKey(exercise.exerciseId)) {
          muscleGroup = exerciseCache[exercise.exerciseId]!;
        } else {
          final exerciseData = await Api().getExerciseById(exercise.exerciseId);
          muscleGroup = await Api().getMuscleGroup(exerciseData['muscleLabel']);
          exerciseCache[exercise.exerciseId] = muscleGroup;
        }

        // Update all-time counts
        allTimeMuscleGroupCounts[muscleGroup] =
            (allTimeMuscleGroupCounts[muscleGroup] ?? 0) + 1;

        // Update last three months counts
        if (completedTraining.dateCompleted.isAfter(threeMonthsAgo) &&
            completedTraining.dateCompleted.isBefore(now)) {
          lastThreeMonthsMuscleGroupCounts[muscleGroup] =
              (lastThreeMonthsMuscleGroupCounts[muscleGroup] ?? 0) + 1;
        }

        // Update current month counts
        if (completedTraining.dateCompleted.isAfter(firstDayOfCurrentMonth) &&
            completedTraining.dateCompleted.isBefore(lastDayOfCurrentMonth)) {
          currentMonthMuscleGroupCounts[muscleGroup] =
              (currentMonthMuscleGroupCounts[muscleGroup] ?? 0) + 1;
        }
      }
    }

    return {
      'allTime': allTimeMuscleGroupCounts,
      'lastThreeMonths': lastThreeMonthsMuscleGroupCounts,
      'currentMonth': currentMonthMuscleGroupCounts,
    };
  }

  Future<List<BarChartGroupData>> getMonthlyTrainingData() async {
    final accountCreationDate = userProvider.dateJoined ?? DateTime.now();
    final completedTrainings = userProvider.completedTrainings ?? [];
    DateTime now = DateTime.now();
    int monthsSinceInscription = (now.year - accountCreationDate.year) * 12 +
        now.month -
        accountCreationDate.month;

    Map<int, int> monthlyTrainingCounts = {};
    for (var training in completedTrainings) {
      final monthKey =
          (training.dateCompleted.year - accountCreationDate.year) * 12 +
              training.dateCompleted.month -
              accountCreationDate.month;
      monthlyTrainingCounts[monthKey] =
          (monthlyTrainingCounts[monthKey] ?? 0) + 1;
    }

    return List.generate(monthsSinceInscription + 1, (index) {
      final year = accountCreationDate.year +
          (accountCreationDate.month + index - 1) ~/ 12;
      final month = (accountCreationDate.month + index - 1) % 12 + 1;
      final trainingCount = monthlyTrainingCounts[index] ?? 0;

      return BarChartGroupData(
        x: month,
        barRods: [
          BarChartRodData(toY: trainingCount.toDouble(), color: Colors.blue)
        ],
        showingTooltipIndicators: trainingCount > 0 ? [0] : [],
      );
    });
  }

  Future<List<BarChartGroupData>> getWeeklyTrainingData() async {
    final accountCreationDate = userProvider.dateJoined ?? DateTime.now();
    final completedTrainings = userProvider.completedTrainings ?? [];
    DateTime now = DateTime.now();
    int totalWeeks = now.difference(accountCreationDate).inDays ~/ 7;

    Map<int, int> weeklyTrainingCounts = {};
    for (var training in completedTrainings) {
      int weekNumber =
          training.dateCompleted.difference(accountCreationDate).inDays ~/ 7;
      weeklyTrainingCounts[weekNumber] =
          (weeklyTrainingCounts[weekNumber] ?? 0) + 1;
    }

    return List.generate(totalWeeks + 1, (index) {
      final trainingCount = weeklyTrainingCounts[index] ?? 0;

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(toY: trainingCount.toDouble(), color: Colors.blue)
        ],
        showingTooltipIndicators: trainingCount > 0 ? [0] : [],
      );
    });
  }
}
