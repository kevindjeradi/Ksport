import 'package:flutter/material.dart';
import 'package:k_sport_front/components/generic/cutom_elevated_button.dart';
import 'package:k_sport_front/components/trainings/reorderable_exercise_list.dart';

class ExerciseFieldsList extends StatelessWidget {
  final List<Map<String, TextEditingController>> exerciseControllers;
  final VoidCallback addExerciseCallback;
  final Function(int) removeExerciseCallback;
  final Function(int) updateRepsControllers;
  final Function(int) updateWeightControllers;
  final Function(int) updateRestTimeControllers;
  final Function addError;
  final String? trainingId;

  const ExerciseFieldsList({
    super.key,
    required this.exerciseControllers,
    required this.addExerciseCallback,
    required this.removeExerciseCallback,
    required this.updateRepsControllers,
    required this.updateWeightControllers,
    required this.updateRestTimeControllers,
    required this.addError,
    this.trainingId,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Column(
      children: [
        ReorderableExerciseList(
          exerciseControllers: exerciseControllers,
          removeExerciseCallback: removeExerciseCallback,
          updateRepsControllers: updateRepsControllers,
          updateWeightControllers: updateWeightControllers,
          updateRestTimeControllers: updateRestTimeControllers,
          addError: addError,
          trainingId: trainingId ?? '',
        ),
        const SizedBox(height: 12.0),
        CustomElevatedButton(
          label: 'Ajouter un exercice',
          onPressed: addExerciseCallback,
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
        )
      ],
    );
  }
}
