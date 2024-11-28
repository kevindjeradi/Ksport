import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:k_sport_front/views/history/training_detail_page.dart';
import 'package:k_sport_front/helpers/logger.dart';
import 'package:k_sport_front/provider/user_provider.dart';
import 'package:provider/provider.dart';

class CompletedTrainings extends StatelessWidget {
  const CompletedTrainings({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final completedTrainings =
        userProvider.completedTrainings?.reversed.toList();
    final theme = Theme.of(context);

    Log.logger.i("Completed training: $completedTrainings");

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: completedTrainings?.length,
      itemBuilder: (context, index) {
        final completedTraining = completedTrainings?[index];
        Log.logger.i("Completed training: $completedTraining");

        return Card(
          elevation: 4.0,
          margin: const EdgeInsets.all(8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TrainingDetailPage(
                    completedTraining: completedTraining,
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
                        'Séance ${completedTraining?.name}',
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
        );
      },
    );
  }
}
