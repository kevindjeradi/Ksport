import 'package:flutter/material.dart';
import 'package:k_sport_front/components/history/completed_training.dart';
import 'package:k_sport_front/components/navigation/return_app_bar.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: const ReturnAppBar(barTitle: "Retour vers mes progrès"),
      backgroundColor: theme.colorScheme.background,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Mon historique",
                  style: theme.textTheme.displaySmall,
                ),
              ),
              const SizedBox(height: 10),
              const Expanded(child: CompletedTrainings()),
            ],
          ),
        ),
      ),
    );
  }
}
