import 'package:flutter/material.dart';
import 'package:k_sport_front/components/history/completed_training.dart';

class ProgressPage extends StatelessWidget {
  const ProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Mes Progrès",
                  style: theme.textTheme.displaySmall,
                ),
              ),
              const Expanded(child: CompletedTrainings()),
            ],
          ),
        ),
      ),
    );
  }
}
