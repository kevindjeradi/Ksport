// exercise_history.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:k_sport_front/components/generic/custom_loader.dart';
import 'package:k_sport_front/components/navigation/return_app_bar.dart';
import 'package:k_sport_front/services/training_service.dart';
import 'package:k_sport_front/provider/user_provider.dart';
import 'package:provider/provider.dart';

class ExerciseHistory extends StatelessWidget {
  final String exerciseLabel;

  const ExerciseHistory({Key? key, required this.exerciseLabel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userProvider = Provider.of<UserProvider>(context);
    final completedTrainings = userProvider.completedTrainings ?? [];

    return Scaffold(
      appBar: ReturnAppBar(
          barTitle: "datas sur $exerciseLabel",
          bgColor: theme.colorScheme.primary,
          color: theme.colorScheme.onPrimary,
          elevation: 0),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: completedTrainings.length,
              itemBuilder: (context, index) {
                final completedTraining = completedTrainings[index];
                final trainingId = completedTraining.trainingId;

                return FutureBuilder(
                  future: TrainingService.fetchTraining(trainingId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CustomLoader();
                    } else if (snapshot.hasError) {
                      return ListTile(
                        leading: const Icon(Icons.error),
                        title: Text('Error: ${snapshot.error}'),
                      );
                    } else {
                      final training = snapshot.data;
                      final exercises = training?.exercises
                          .where(
                              (exercise) => exercise['label'] == exerciseLabel)
                          .toList();

                      if (exercises!.isEmpty) {
                        return Container(); // No exercise found
                      }

                      return Card(
                        margin: const EdgeInsets.all(8.0),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Training: ${training?.name}',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              Text(
                                'Date: ${DateFormat('dd-MM-yyyy').format(completedTraining.dateCompleted)}',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 8),
                              ...exercises.map((exercise) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children:
                                      List.generate(exercise['sets'], (index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4.0),
                                      child: Text(
                                        'Set ${index + 1}: ${exercise['repetitions'][index]} reps, ${exercise['weight'][index]} kg, ${exercise['restTime'][index]} s rest',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                      ),
                                    );
                                  }),
                                );
                              }).toList(),
                            ],
                          ),
                        ),
                      );
                    }
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
