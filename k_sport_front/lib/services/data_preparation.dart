import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:k_sport_front/helpers/logger.dart';
import 'package:k_sport_front/provider/user_provider.dart';
import 'package:k_sport_front/services/api.dart';
import 'package:k_sport_front/services/training_service.dart';

class DataPreparation {
  final UserProvider userProvider;
  static final TrainingService trainingService = TrainingService();

  DataPreparation(this.userProvider);

  Future<Map<String, dynamic>> computeMetrics() async {
    final completedTrainings = userProvider.completedTrainings;
    if (completedTrainings == null || completedTrainings.isEmpty) {
      Log.logger.i("No completed trainings found");
      return {}; // Return empty metrics if there are no completed trainings
    }

    int totalTrainings = completedTrainings.length;
    double totalWeightLifted = 0;

    // Get the date the user joined and the date of the last training session
    final accountCreationDate = userProvider.dateJoined;
    final lastTrainingDate = completedTrainings.last.dateCompleted;

    // Calculate the total number of days from account creation to the last training session
    final totalDays = lastTrainingDate.difference(accountCreationDate).inDays +
        1; // +1 to include both dates in the range

    for (var completedTraining in completedTrainings) {
      final trainingId = completedTraining.trainingId;
      final training = await TrainingService.fetchTraining(trainingId);

      // Assuming the training data has a similar structure to the example provided
      for (var exercise in training!.exercises) {
        for (var weight in exercise['weight']) {
          totalWeightLifted += weight;
        }
      }
    }

    final double meanTrainingsPerWeek = (totalTrainings / totalDays) * 7;
    final String meanTrainingsPerWeekFormatted =
        meanTrainingsPerWeek.toStringAsFixed(3);

    // Get the current month and year
    final now = DateTime.now();
    final currentMonth = now.month;
    final currentYear = now.year;

    // Filter the completedTrainings for the current month and year
    final trainingsThisMonth = completedTrainings
        .where((training) =>
            training.dateCompleted.month == currentMonth &&
            training.dateCompleted.year == currentYear)
        .length;

    Log.logger.i("Total trainings: $totalTrainings");
    Log.logger.i("Total weight lifted: $totalWeightLifted");
    Log.logger.i("Mean trainings per week: $meanTrainingsPerWeekFormatted");
    Log.logger.i("Trainings this month: $trainingsThisMonth");

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
      final trainingId = completedTraining.trainingId;
      final training = await TrainingService.fetchTraining(trainingId);
      for (var exercise in training!.exercises) {
        final exerciseId = exercise['exerciseId'];
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
      Log.logger.i("Training count for month $month: $trainingCount");
      return BarChartGroupData(
        x: month,
        barRods: [
          BarChartRodData(toY: trainingCount.toDouble(), color: Colors.blue)
        ],
        showingTooltipIndicators: [0],
      );
    }).toList();
  }
}
