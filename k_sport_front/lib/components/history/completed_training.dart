// completed_training.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:k_sport_front/components/generic/custom_loader.dart';
import 'package:k_sport_front/components/history/training_detail_page.dart';
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
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 4.0,
                  margin: const EdgeInsets.all(8.0),
                  color: theme.colorScheme.secondaryContainer,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TrainingDetailPage(
                            training: training,
                            date: completedTraining.dateCompleted,
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Séance ${training?.name}',
                                style: theme.textTheme.headlineSmall,
                              ),
                              const SizedBox(height: 16.0),
                              Text(
                                'Le ${DateFormat('dd-MM-yyyy').format(completedTraining!.dateCompleted)}',
                                style: theme.textTheme.titleMedium,
                              ),
                            ],
                          ),
                          const Icon(Icons.arrow_forward_ios)
                        ],
                      ),
                    ),
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
