import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:k_sport_front/components/navigation/return_app_bar.dart';

class TrainingDetailPage extends StatelessWidget {
  final dynamic training;
  final DateTime date;

  const TrainingDetailPage(
      {super.key, required this.training, required this.date});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
        appBar: ReturnAppBar(
          barTitle: 'Retour vers mon historique',
          bgColor: theme.colorScheme.primary,
          color: theme.colorScheme.onPrimary,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Séance ${training?.name} du ${DateFormat('dd-MM-yyyy').format(date)}',
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
                          '${training?.description}',
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
                          '${training?.goal}',
                          style: theme.textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              ...?training?.exercises.asMap().entries.map((entry) {
                final index = entry.key;
                final exercise = entry.value;
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  child: Card(
                    color: theme.colorScheme.primaryContainer,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      side: BorderSide(
                          color: theme.colorScheme.onPrimary, width: 0.5),
                    ),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Exercice ${index + 1}',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          Center(
                            child: Text(
                              '${exercise['label']}',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                '${exercise['repetitions']} Répétitions',
                                style: theme.textTheme.bodyMedium,
                              ),
                              Text(
                                '${exercise['restTime']} secondes de repos',
                                style: theme.textTheme.bodyMedium,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Divider(color: theme.colorScheme.onPrimary),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: List.generate(
                              exercise['sets'],
                              (setIndex) {
                                final setNumber = setIndex + 1;
                                final weight = exercise['weight'][setIndex];
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Série $setNumber',
                                      style: theme.textTheme.bodyLarge,
                                    ),
                                    Text(
                                      '$weight kg',
                                      style: theme.textTheme.bodyLarge,
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "Entraînement fini à ${DateFormat('HH:mm:ss').format(date)}",
                  style: theme.textTheme.bodyLarge,
                ),
              ),
            ],
          ),
        ));
  }
}
