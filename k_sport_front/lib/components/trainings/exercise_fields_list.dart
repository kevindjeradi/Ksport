// exercise_fields_list.dart
import 'package:flutter/material.dart';
import 'package:k_sport_front/components/generic/cutom_elevated_button.dart';
import 'exercise_card.dart';

class ExerciseFieldsList extends StatelessWidget {
  final List<Map<String, TextEditingController>> exerciseControllers;
  final VoidCallback addExerciseCallback;
  final Function(int) removeExerciseCallback;

  const ExerciseFieldsList({
    super.key,
    required this.exerciseControllers,
    required this.addExerciseCallback,
    required this.removeExerciseCallback,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...exerciseControllers.asMap().entries.map((entry) {
          int idx = entry.key;
          var controllerMap = entry.value;
          return ExerciseCard(
            labelController: controllerMap['label']!,
            repsController: controllerMap['repetitions']!,
            setsController: controllerMap['sets']!,
            restTimeController: controllerMap['restTime']!,
            onRemove: () => removeExerciseCallback(idx),
          );
        }).toList(),
        const SizedBox(height: 12.0),
        CustomElevatedButton(
          label: 'Ajouter un exercice',
          onPressed: addExerciseCallback,
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
        )
      ],
    );
  }
}
