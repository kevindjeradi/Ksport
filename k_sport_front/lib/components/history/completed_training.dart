import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:k_sport_front/services/training_service.dart';
import 'package:k_sport_front/views/history/training_detail_page.dart';
import 'package:k_sport_front/helpers/logger.dart';
import 'package:k_sport_front/provider/user_provider.dart';
import 'package:provider/provider.dart';

class CompletedTrainings extends StatefulWidget {
  const CompletedTrainings({super.key});

  @override
  State<CompletedTrainings> createState() => _CompletedTrainingsState();
}

class _CompletedTrainingsState extends State<CompletedTrainings> {
  Future<bool> _showDeleteConfirmationDialog(BuildContext context) async {
    return await showDialog(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: const Text('Confirmer la suppression'),
              content: const Text(
                  'Voulez-vous vraiment supprimer cet entraînement ?'),
              actions: <Widget>[
                TextButton(
                  child: Text('Annuler',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface)),
                  onPressed: () => Navigator.of(dialogContext).pop(false),
                ),
                TextButton(
                  child: Text('Supprimer',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface)),
                  onPressed: () => Navigator.of(dialogContext).pop(true),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final completedTrainings =
        userProvider.completedTrainings?.reversed.toList();
    final theme = Theme.of(context);

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
                  IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: theme.colorScheme.error,
                    ),
                    onPressed: () async {
                      bool confirmDelete =
                          await _showDeleteConfirmationDialog(context);
                      if (confirmDelete) {
                        try {
                          await TrainingService.deleteCompletedTraining(
                              completedTraining!.id);
                          if (context.mounted) {
                            // Update the UserProvider state
                            final userProvider = Provider.of<UserProvider>(
                                context,
                                listen: false);
                            userProvider
                                .removeCompletedTraining(completedTraining);

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Entraînement supprimé avec succès'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        } catch (e) {
                          Log.logger.e('Error deleting completed training: $e');
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Erreur lors de la suppression: Réessayez un peu plus tard'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        }
                      }
                    },
                  ),
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
