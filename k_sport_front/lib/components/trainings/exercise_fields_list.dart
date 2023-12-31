// exercise_fields_list.dart
import 'package:flutter/material.dart';
import 'package:k_sport_front/components/generic/cutom_elevated_button.dart';
import 'exercise_card.dart';

class ExerciseFieldsList extends StatelessWidget {
  final List<Map<String, TextEditingController>> exerciseControllers;
  final VoidCallback addExerciseCallback;
  final Function(int) removeExerciseCallback;
  final Function(int) updateRepsControllers;
  final Function(int) updateWeightControllers;
  final Function(int) updateRestTimeControllers;
  final Function addError;

  const ExerciseFieldsList({
    super.key,
    required this.exerciseControllers,
    required this.addExerciseCallback,
    required this.removeExerciseCallback,
    required this.updateRepsControllers,
    required this.updateWeightControllers,
    required this.updateRestTimeControllers,
    required this.addError,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Column(
      children: [
        ...exerciseControllers.asMap().entries.map((entry) {
          int idx = entry.key;
          var controllerMap = entry.value;
          return ExerciseCard(
            labelController: controllerMap['label']!,
            setsController: controllerMap['sets']!,
            updateRepsControllers: () => updateRepsControllers(idx),
            repsController: controllerMap['repetitions']!,
            updateWeightControllers: () => updateWeightControllers(idx),
            weightController: controllerMap['weight']!,
            updateRestTimeControllers: () => updateRestTimeControllers(idx),
            restTimeController: controllerMap['restTime']!,
            onRemove: () => removeExerciseCallback(idx),
            addError: addError,
          );
        }).toList(),
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
