import 'package:flutter/material.dart';

class ExerciseProgressIndicator extends StatelessWidget {
  final int currentExerciseIndex;
  final int totalExercises;
  final String nextExerciseName;

  const ExerciseProgressIndicator({
    Key? key,
    required this.currentExerciseIndex,
    required this.totalExercises,
    this.nextExerciseName = "",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value:
                totalExercises > 0 ? currentExerciseIndex / totalExercises : 0,
            minHeight: 20,
            backgroundColor: theme.colorScheme.background,
            valueColor:
                AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
          ),
        ),
        const SizedBox(height: 10),
        if (nextExerciseName.isNotEmpty)
          currentExerciseIndex < totalExercises
              ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Prochain exercice : $nextExerciseName",
                    style: theme.textTheme.headlineSmall,
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    nextExerciseName,
                    style: theme.textTheme.headlineSmall,
                  ),
                ),
      ],
    );
  }
}
