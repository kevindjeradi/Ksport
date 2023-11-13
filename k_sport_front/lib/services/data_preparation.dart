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
      return {
        'allTime': {},
        'lastThreeMonths': {},
        'currentMonth': {},
      }; // Return empty maps if there are no completed trainings
    }

    Map<String, int> emptyMuscleGroupCounts() {
      return {
        'Jambes': 0,
        'Dos': 0,
        'Torse': 0,
        'Bras': 0,
      };
    }

    Map<String, int> allTimeMuscleGroupCounts = emptyMuscleGroupCounts();
    Map<String, int> lastThreeMonthsMuscleGroupCounts =
        emptyMuscleGroupCounts();
    Map<String, int> currentMonthMuscleGroupCounts = emptyMuscleGroupCounts();

    final now = DateTime.now();
    final threeMonthsAgo = now.subtract(const Duration(days: 90));
    final firstDayOfCurrentMonth = DateTime(now.year, now.month, 1);
    final lastDayOfCurrentMonth = DateTime(now.year, now.month + 1, 0);

    for (var completedTraining in completedTrainings) {
      for (var exercise in completedTraining.exercises) {
        final exerciseId = exercise.exerciseId;
        final exerciseData = await Api().getExerciseById(exerciseId);
        final muscleLabel = exerciseData['muscleLabel'];
        final muscleGroup = await Api().getMuscleGroup(muscleLabel);

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
    final completedTrainings = userProvider.completedTrainings;
    if (completedTrainings == null || completedTrainings.isEmpty) {
      return [];
    }
    Map<int, int> monthlyTrainingCounts = {};
    for (var training in completedTrainings) {
      final month = training.dateCompleted.month;
      monthlyTrainingCounts[month] = (monthlyTrainingCounts[month] ?? 0) + 1;
    }
    return monthlyTrainingCounts.entries.map((entry) {
      final month = entry.key;
      final trainingCount = entry.value;

      return BarChartGroupData(
        x: month,
        barRods: [
          BarChartRodData(toY: trainingCount.toDouble(), color: Colors.blue)
        ],
        showingTooltipIndicators: [0],
      );
    }).toList();
  }

  Future<List<BarChartGroupData>> getWeeklyTrainingData() async {
    final completedTrainings = userProvider.completedTrainings;
    if (completedTrainings == null || completedTrainings.isEmpty) {
      return [];
    }

    // Determine the date range for the data, adjusting the startDate to the beginning of the week.
    final startDate = completedTrainings.first.dateCompleted;
    final startWeekDate = startDate.subtract(Duration(days: startDate.weekday));
    final endDate = completedTrainings.last.dateCompleted;

    // Determine the total number of weeks between the start and end dates.
    final totalWeeks = endDate.difference(startWeekDate).inDays ~/ 7;

    // Initialize a map to hold the count of trainings per week.
    Map<int, int> weeklyTrainingCounts = {};

    // Loop through each training session and increment the count for the corresponding week.
    for (var training in completedTrainings) {
      final weekNumber =
          training.dateCompleted.difference(startWeekDate).inDays ~/ 7;
      weeklyTrainingCounts[weekNumber] =
          (weeklyTrainingCounts[weekNumber] ?? 0) + 1;
    }

    // Convert the map of weekly training counts to a list of BarChartGroupData.
    return List.generate(totalWeeks + 1, (weekNumber) {
      final trainingCount = weeklyTrainingCounts[weekNumber] ?? 0;

      return BarChartGroupData(
        x: weekNumber,
        barRods: [
          BarChartRodData(toY: trainingCount.toDouble(), color: Colors.blue)
        ],
        showingTooltipIndicators: [0],
      );
    });
  }
}
