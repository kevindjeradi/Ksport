import 'package:flutter/material.dart';
import 'package:k_sport_front/components/history/completed_training.dart';
import 'package:k_sport_front/components/navigation/return_app_bar.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: ReturnAppBar(
          barTitle: "Retour vers mes progrès",
          bgColor: theme.colorScheme.primary,
          color: theme.colorScheme.onPrimary,
          elevation: 0),
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
