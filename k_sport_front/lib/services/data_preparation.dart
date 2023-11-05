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
}
