import 'package:flutter/material.dart';
import 'package:k_sport_front/components/generic/custom_snackbar.dart';
import 'package:k_sport_front/components/history/user_note.dart';
import 'package:k_sport_front/components/navigation/return_app_bar.dart';
import 'package:intl/intl.dart';
import 'package:k_sport_front/services/cardio_service.dart';

class CardioHistoryDetailPage extends StatelessWidget {
  final Map<String, dynamic> session;

  const CardioHistoryDetailPage({Key? key, required this.session})
      : super(key: key);

  Widget _buildDetailRow(String label, dynamic value, BuildContext context) {
    if (value == null) return const SizedBox.shrink();
    final theme = Theme.of(context);

    return Card(
      color: theme.colorScheme.background,
      margin: const EdgeInsets.symmetric(vertical: 12),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: theme.textTheme.titleMedium),
            Text(value.toString(), style: theme.textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final date = DateTime.parse(session['date']);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: const ReturnAppBar(barTitle: 'Retour vers mon historique'),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Session ${session['exerciseName']} du ${DateFormat('dd-MM-yyyy').format(date)}',
                style: theme.textTheme.headlineMedium,
              ),
              const SizedBox(height: 16),
              Card(
                color: theme.colorScheme.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: BorderSide(
                      color: theme.colorScheme.onPrimary, width: 0.5),
                ),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          "Escaliers",
                          style: theme.textTheme.titleLarge,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildDetailRow(
                          'Durée', '${session['duration']} minutes', context),
                      _buildDetailRow(
                          'Calories', '${session['calories']} kcal', context),
                      if (session['exerciseName'] == 'Vélo') ...[
                        _buildDetailRow('Puissance moyenne',
                            '${session['averageWatts']} watts', context),
                        _buildDetailRow(
                            'Distance', '${session['distance']} km', context),
                        if (session['averageSpeed'] != null)
                          _buildDetailRow('Vitesse moyenne',
                              '${session['averageSpeed']} km/h', context),
                        _buildDetailRow('Cadence moyenne',
                            '${session['cadence']} rpm', context),
                        _buildDetailRow(
                            'BPM moyen', session['averageBpm'], context),
                        _buildDetailRow('BPM max', session['maxBpm'], context),
                      ] else if (session['exerciseName'] == 'Rameur') ...[
                        _buildDetailRow(
                            'Distance', '${session['distance']} m', context),
                        _buildDetailRow('Puissance moyenne',
                            '${session['averageWatts']} watts', context),
                        _buildDetailRow(
                            'Split /500m moyen', session['split500m'], context),
                        _buildDetailRow('Coups par minute moyen',
                            session['strokesPerMinute'], context),
                      ] else if (session['exerciseName'] == 'Escalier') ...[
                        _buildDetailRow('Étages', session['floors'], context),
                        _buildDetailRow(
                            'BPM moyen', session['averageBpm'], context),
                        _buildDetailRow('BPM max', session['maxBpm'], context),
                      ] else if (session['exerciseName'] == 'Course') ...[
                        _buildDetailRow(
                            'Distance', '${session['distance']} km', context),
                        _buildDetailRow(
                            'Allure moyenne', session['pace'], context),
                        if (session['elevation'] != null)
                          _buildDetailRow(
                              'Dénivelé', '${session['elevation']} m', context),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              UserNote(
                initialNote: session['note'],
                onSave: (newNote) async {
                  try {
                    await CardioService()
                        .updateCardioNote(session['_id'], newNote);
                    if (context.mounted) {
                      showCustomSnackBar(
                        context,
                        "Note mise à jour avec succès",
                        SnackBarType.success,
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      showCustomSnackBar(
                        context,
                        "Erreur lors de la mise à jour de la note",
                        SnackBarType.error,
                      );
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
