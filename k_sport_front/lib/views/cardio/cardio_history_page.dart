import 'package:flutter/material.dart';
import 'package:k_sport_front/components/generic/custom_navigation.dart';
import 'package:k_sport_front/components/navigation/return_app_bar.dart';
import 'package:k_sport_front/services/cardio_service.dart';
import 'package:intl/intl.dart';
import 'package:k_sport_front/views/cardio/cardio_history_detail_page.dart';

class CardioHistoryPage extends StatefulWidget {
  const CardioHistoryPage({Key? key}) : super(key: key);

  @override
  State<CardioHistoryPage> createState() => _CardioHistoryPageState();
}

class _CardioHistoryPageState extends State<CardioHistoryPage> {
  Future<bool> _showDeleteConfirmationDialog(BuildContext context) async {
    return await showDialog(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: const Text('Confirmer la suppression'),
              content: const Text(
                  'Voulez-vous vraiment supprimer cette séance cardio ?'),
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
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: const ReturnAppBar(barTitle: 'Historique Cardio'),
      body: FutureBuilder(
        future: CardioService().getCardioSessions(),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Erreur lors du chargement de l\'historique',
                style: theme.textTheme.bodyLarge,
              ),
            );
          }

          final sessions = snapshot.data ?? [];

          if (sessions.isEmpty) {
            return Center(
              child: Text(
                'Aucune séance cardio enregistrée',
                style: theme.textTheme.bodyLarge,
              ),
            );
          }

          return Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: ListView.builder(
              itemCount: sessions.length,
              itemBuilder: (context, index) {
                final session = sessions[index];
                final date = DateTime.parse(session['date']);

                return Card(
                  elevation: 4.0,
                  margin: const EdgeInsets.all(8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  color: theme.colorScheme.surface,
                  child: InkWell(
                    onTap: () {
                      CustomNavigation.push(
                        context,
                        CardioHistoryDetailPage(session: session),
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
                                  await CardioService()
                                      .deleteCardioSession(session['_id']);
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Session supprimée avec succès'),
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                    // Refresh the page
                                    setState(() {});
                                  }
                                } catch (e) {
                                  print('Error deleting cardio session: $e');
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Erreur lors de la suppression'),
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
                                'Séance ${session['exerciseName']} - ${session['duration']} min',
                                style: theme.textTheme.headlineSmall,
                              ),
                              const SizedBox(height: 16.0),
                              if (session['calories'] != null) ...[
                                Text(
                                  '${session['calories']} kcal dépensées',
                                  style: theme.textTheme.titleMedium,
                                ),
                                const SizedBox(height: 16.0),
                              ],
                              Text(
                                "Le ${DateFormat('dd/MM/yyyy HH:mm').format(date)}",
                                style: theme.textTheme.titleMedium,
                              ),
                            ],
                          ),
                          const Icon(Icons.arrow_forward_ios),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
