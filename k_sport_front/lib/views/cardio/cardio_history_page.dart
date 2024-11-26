import 'package:flutter/material.dart';
import 'package:k_sport_front/components/generic/custom_navigation.dart';
import 'package:k_sport_front/components/navigation/return_app_bar.dart';
import 'package:k_sport_front/services/cardio_service.dart';
import 'package:intl/intl.dart';
import 'package:k_sport_front/views/cardio/cardio_history_detail_page.dart';

class CardioHistoryPage extends StatelessWidget {
  const CardioHistoryPage({Key? key}) : super(key: key);

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

          return ListView.builder(
            itemCount: sessions.length,
            itemBuilder: (context, index) {
              final session = sessions[index];
              final date = DateTime.parse(session['date']);

              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Card(
                  color: theme.colorScheme.surface,
                  child: ListTile(
                    title: Text(
                      '${session['exerciseName']} - ${session['duration']} minutes',
                      style: theme.textTheme.titleLarge,
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(DateFormat('dd/MM/yyyy HH:mm').format(date)),
                        if (session['calories'] != null)
                          Text('Calories: ${session['calories']} kcal'),
                      ],
                    ),
                    trailing: Icon(
                      Icons.chevron_right,
                      color: theme.colorScheme.primary,
                    ),
                    onTap: () {
                      CustomNavigation.push(
                        context,
                        CardioHistoryDetailPage(session: session),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
