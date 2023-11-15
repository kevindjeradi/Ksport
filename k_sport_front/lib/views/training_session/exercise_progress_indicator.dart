import 'package:flutter/material.dart';

class ExerciseProgressIndicator extends StatelessWidget {
  final int currentExerciseIndex;
  final int currentSet;
  final List<int> setsPerExercise;

  const ExerciseProgressIndicator({
    Key? key,
    required this.currentExerciseIndex,
    required this.currentSet,
    required this.setsPerExercise,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    double calculateProgress() {
      int completedSets = setsPerExercise
              .take(currentExerciseIndex - 1)
              .fold(0, (sum, element) => sum + element) +
          currentSet;
      int totalSetsOverall =
          setsPerExercise.fold(0, (sum, element) => sum + element);

      return completedSets / totalSetsOverall.toDouble();
    }

    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: calculateProgress(),
            minHeight: 20,
            backgroundColor: theme.colorScheme.background,
            valueColor:
                AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
