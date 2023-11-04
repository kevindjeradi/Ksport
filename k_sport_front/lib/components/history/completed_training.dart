import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:k_sport_front/components/generic/custom_loader.dart';
import 'package:k_sport_front/provider/user_provider.dart';
import 'package:k_sport_front/services/training_service.dart';
import 'package:provider/provider.dart';

class CompletedTrainings extends StatelessWidget {
  const CompletedTrainings({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final completedTrainings =
        userProvider.completedTrainings?.reversed.toList();
    final theme = Theme.of(context);

    return ListView.builder(
      itemCount: completedTrainings?.length,
      itemBuilder: (context, index) {
        final completedTraining = completedTrainings?[index];
        final trainingId = completedTraining?.trainingId;

        return FutureBuilder(
          future: TrainingService.fetchTraining(trainingId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CustomLoader();
            } else if (snapshot.hasError) {
              return ListTile(
                leading: Icon(Icons.error, color: theme.colorScheme.error),
                title: Text('Error: ${snapshot.error}',
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: theme.colorScheme.error)),
              );
            } else {
              final training = snapshot.data;
              return Card(
                margin: const EdgeInsets.all(8.0),
                color: theme.colorScheme.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Séance ${training?.name}',
                        style: theme.textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Center(
                              child: Text(
                                'Description: ${training?.description}',
                                style: theme.textTheme.bodyMedium,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Center(
                              child: Text(
                                'Objectif: ${training?.goal}',
                                style: theme.textTheme.bodyMedium,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ...?training?.exercises.asMap().entries.map((entry) {
                        final index = entry.key;
                        final exercise = entry.value;
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 12),
                          child: Card(
                            color: theme.colorScheme.primaryContainer,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              side: BorderSide(
                                  color: theme.colorScheme.onPrimary,
                                  width: 0.5),
                            ),
                            elevation: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Exercice ${index + 1}',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8.0),
                                  Center(
                                    child: Text(
                                      '${exercise['label']}',
                                      style:
                                          theme.textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8.0),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        '${exercise['repetitions']} Répétitions',
                                        style: theme.textTheme.bodySmall,
                                      ),
                                      Text(
                                        '${exercise['restTime']} secondes de repos',
                                        style: theme.textTheme.bodySmall,
                                      ),
                                    ],
                                  ),
                                  Divider(color: theme.colorScheme.onPrimary),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: List.generate(
                                        exercise['sets'],
                                        (setIndex) {
                                          final setNumber = setIndex + 1;
                                          final weight =
                                              exercise['weight'][setIndex];
                                          return Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Série $setNumber',
                                                style:
                                                    theme.textTheme.bodySmall,
                                              ),
                                              Text(
                                                '$weight kg',
                                                style:
                                                    theme.textTheme.bodySmall,
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Le ${DateFormat('dd-MM-yyyy à HH:mm:ss').format(completedTraining!.dateCompleted)}',
                          style: theme.textTheme.titleMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        );
      },
    );
  }
}
