// training_detail_page.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:k_sport_front/components/history/user_note.dart';
import 'package:k_sport_front/components/navigation/return_app_bar.dart';
import 'package:k_sport_front/models/completed_training.dart';
import 'package:k_sport_front/provider/user_provider.dart';
import 'package:provider/provider.dart';

// In training_detail_page.dart
class TrainingDetailPage extends StatelessWidget {
  final CompletedTraining completedTraining;
  final DateTime date;

  const TrainingDetailPage(
      {Key? key, required this.completedTraining, required this.date})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return Scaffold(
      appBar: ReturnAppBar(
        barTitle: 'Retour vers mon historique',
        bgColor: theme.colorScheme.primary,
        color: theme.colorScheme.onPrimary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Séance ${completedTraining.name} du ${DateFormat('dd-MM-yyyy').format(date)}',
                style: theme.textTheme.headlineMedium,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          'Description',
                          style: theme.textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          completedTraining.description,
                          style: theme.textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          'Objectif',
                          style: theme.textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          completedTraining.goal,
                          style: theme.textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              ...completedTraining.exercises.asMap().entries.map((entry) {
                final index = entry.key;
                final exercise = entry.value;
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 0),
                  child: Card(
                    color: theme.colorScheme.primaryContainer,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(
                          color: theme.colorScheme.onPrimary, width: 0.5),
                    ),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Exercice ${index + 1}',
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                exercise.sets > 1
                                    ? '${exercise.sets} séries'
                                    : '${exercise.sets} série',
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16.0),
                          Center(
                            child: Text(
                              exercise.label,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          Column(
                            children: List.generate(exercise.sets, (setIndex) {
                              final setNumber = setIndex + 1;
                              final repetitions =
                                  exercise.repetitions[setIndex];
                              final weight = exercise.weight[setIndex];
                              final restTime = exercise.restTime[setIndex];

                              return Card(
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                elevation: 2,
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Série $setNumber',
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                                fontWeight: FontWeight.bold),
                                      ),
                                      Row(
                                        children: [
                                          const Icon(Icons.repeat, size: 16),
                                          const SizedBox(width: 4),
                                          Text(
                                            '$repetitions',
                                            style: theme.textTheme.bodyMedium,
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Icon(Icons.fitness_center,
                                              size: 16),
                                          const SizedBox(width: 4),
                                          Text(
                                            '$weight kg',
                                            style: theme.textTheme.bodyMedium,
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Icon(Icons.timer, size: 16),
                                          const SizedBox(width: 4),
                                          Text(
                                            '$restTime s',
                                            style: theme.textTheme.bodyMedium,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
              const SizedBox(height: 16),
              UserNote(
                initialNote: completedTraining.note,
                onSave: (newNote) {
                  userProvider.updateTrainingNote(
                      completedTraining.trainingId, newNote);
                },
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "Entraînement fini à ${DateFormat('HH:mm:ss').format(date)}",
                    style: theme.textTheme.bodyLarge,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
