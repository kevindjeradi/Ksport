import 'package:flutter/material.dart';
import 'package:k_sport_front/components/exercices/workout_card_detail.dart';
import 'package:k_sport_front/components/generic/custom_navigation.dart';
import 'package:k_sport_front/components/generic/cutom_elevated_button.dart';
import 'package:k_sport_front/components/navigation/return_app_bar.dart';
import 'package:k_sport_front/models/training.dart';
import 'package:k_sport_front/services/api.dart';
import 'package:k_sport_front/views/training_session/training_session_page.dart';

class TrainingOverviewPage extends StatefulWidget {
  final Training training;

  const TrainingOverviewPage({Key? key, required this.training})
      : super(key: key);

  @override
  TrainingOverviewPageState createState() => TrainingOverviewPageState();
}

class TrainingOverviewPageState extends State<TrainingOverviewPage> {
  int calculateTrainingDuration(Training training) {
    const int secondsPerRepetition = 3;
    const int additionalActivityTime =
        180; // temps de transition entre les exos

    int totalDurationInSeconds = 0;

    for (var exercise in training.exercises) {
      int sets = exercise['sets'];
      int repetitions = exercise['repetitions'];
      int restTimePerSet = exercise['restTime'];
      totalDurationInSeconds +=
          sets * (repetitions * secondsPerRepetition + restTimePerSet);
    }

    totalDurationInSeconds += additionalActivityTime;
    return (totalDurationInSeconds / 60).ceil();
  }

  @override
  Widget build(BuildContext context) {
    const int showerTime = 15;
    final int trainingDuration = calculateTrainingDuration(widget.training);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: ReturnAppBar(
        bgColor: colorScheme.primary,
        barTitle: "Résumé de la séance",
        color: colorScheme.onPrimary,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Card(
                color: theme.colorScheme.secondaryContainer,
                elevation: 5,
                shadowColor: colorScheme.primary.withOpacity(0.5),
                margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          "Séance ${widget.training.name}",
                          style: textTheme.headlineSmall,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Icon(Icons.shower, color: colorScheme.primary),
                          const SizedBox(width: 8),
                          Text(
                            'Douche: $showerTime minutes',
                            style: textTheme.bodyLarge,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.timer, color: colorScheme.primary),
                          const SizedBox(width: 8),
                          Text(
                            'Durée totale estimée: ${trainingDuration + showerTime} minutes',
                            style: textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: widget.training.exercises.length,
                  itemBuilder: (context, index) {
                    final exercise = widget.training.exercises[index];
                    return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.2,
                      child: Card(
                        elevation: 5,
                        shadowColor: Colors.black.withOpacity(0.2),
                        margin: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () async {
                            print('Exercise tapped: ${exercise['label']}');
                            print('Exercise tapped: ${exercise['_id']}');

                            final exerciseLabel = exercise['label'];
                            if (exerciseLabel != null) {
                              final exerciseDetails =
                                  await Api.fetchExerciseDetailsByLabel(
                                      exerciseLabel);
                              if (exerciseDetails != null && mounted) {
                                CustomNavigation.push(
                                    context,
                                    WorkoutCardDetail(
                                      title:
                                          exerciseDetails['label'] ?? 'label',
                                      muscleLabel:
                                          exerciseDetails['muscleLabel'] ??
                                              'muscleLabel',
                                      image: Image.network(exerciseDetails[
                                              'imageUrl'] ??
                                          'https://via.placeholder.com/150'),
                                      description: exerciseDetails[
                                              'detailDescription'] ??
                                          'No description',
                                    ));
                              }
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      image: DecorationImage(
                                        image: NetworkImage(exercise[
                                                'imageUrl'] ??
                                            'https://via.placeholder.com/100x100'),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        exercise['label'] ?? 'Unknown',
                                        style: textTheme.titleMedium?.copyWith(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        '${exercise['sets']} séries de ${exercise['repetitions']} répétitions',
                                        style: textTheme.bodyMedium
                                            ?.copyWith(color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TrainingSessionPage(),
                      ),
                    );
                  },
                  foregroundColor: colorScheme.onPrimary,
                  backgroundColor: colorScheme.primary,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  label: 'Commencer la séance',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
