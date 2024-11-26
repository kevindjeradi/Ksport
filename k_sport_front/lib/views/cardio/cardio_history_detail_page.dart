import 'package:flutter/material.dart';
import 'package:k_sport_front/components/navigation/return_app_bar.dart';
import 'package:intl/intl.dart';

class CardioHistoryDetailPage extends StatelessWidget {
  final Map<String, dynamic> session;

  const CardioHistoryDetailPage({Key? key, required this.session})
      : super(key: key);

  Widget _buildDetailRow(String label, dynamic value, BuildContext context) {
    if (value == null) return const SizedBox.shrink();
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: theme.textTheme.titleMedium),
          Text(value.toString(), style: theme.textTheme.bodyLarge),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final date = DateTime.parse(session['date']);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: ReturnAppBar(
        barTitle: 'Détails ${session['exerciseName']}',
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                color: theme.colorScheme.surface,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat('dd/MM/yyyy HH:mm').format(date),
                        style: theme.textTheme.titleLarge,
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
                        _buildDetailRow('Vitesse moyenne',
                            '${session['averageSpeed']} km/h', context),
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
                        _buildDetailRow(
                            'Dénivelé', '${session['elevation']} m', context),
                      ],
                      if (session['note'] != null) ...[
                        const SizedBox(height: 16),
                        Text('Notes:', style: theme.textTheme.titleMedium),
                        const SizedBox(height: 8),
                        Text(session['note'], style: theme.textTheme.bodyLarge),
                      ],
                    ],
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
