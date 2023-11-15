import 'package:flutter/material.dart';

class RestTimerButton extends StatelessWidget {
  final Function startRestTimer;

  const RestTimerButton({Key? key, required this.startRestTimer})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ElevatedButton(
      onPressed: () => startRestTimer(),
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.primary,
        disabledForegroundColor: theme.colorScheme.onSurface.withOpacity(0.38),
        disabledBackgroundColor: theme.colorScheme.surface.withOpacity(0.12),
        padding: const EdgeInsets.all(15),
        textStyle: theme.textTheme.titleLarge,
      ),
      child: const Text('Lancer le repos'),
    );
  }
}
