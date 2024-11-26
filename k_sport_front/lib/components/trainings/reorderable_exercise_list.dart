import 'package:flutter/material.dart';
import 'package:k_sport_front/components/trainings/exercise_card.dart';

class ReorderableExerciseList extends StatefulWidget {
  final List<Map<String, TextEditingController>> exerciseControllers;
  final Function(int) removeExerciseCallback;
  final Function(int) updateRepsControllers;
  final Function(int) updateWeightControllers;
  final Function(int) updateRestTimeControllers;
  final Function addError;
  final String trainingId;

  const ReorderableExerciseList({
    Key? key,
    required this.exerciseControllers,
    required this.removeExerciseCallback,
    required this.updateRepsControllers,
    required this.updateWeightControllers,
    required this.updateRestTimeControllers,
    required this.addError,
    required this.trainingId,
  }) : super(key: key);

  @override
  ReorderableExerciseListState createState() => ReorderableExerciseListState();
}

class ReorderableExerciseListState extends State<ReorderableExerciseList> {
  @override
  Widget build(BuildContext context) {
    return ReorderableListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.exerciseControllers.length,
      onReorder: _onReorder,
      itemBuilder: (context, index) {
        final controllers = widget.exerciseControllers[index];
        final isCardio = controllers.containsKey('duration');

        return Padding(
          key: ValueKey(index),
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            children: [
              ReorderableDragStartListener(
                index: index,
                child: const Icon(Icons.drag_handle),
              ),
              Expanded(
                child: ExerciseCard(
                  labelController: controllers['label']!,
                  setsController:
                      isCardio ? TextEditingController() : controllers['sets']!,
                  repsController: isCardio
                      ? TextEditingController()
                      : controllers['repetitions']!,
                  weightController: isCardio
                      ? TextEditingController()
                      : controllers['weight']!,
                  restTimeController: isCardio
                      ? TextEditingController()
                      : controllers['restTime']!,
                  onRemove: () => widget.removeExerciseCallback(index),
                  updateRepsControllers: () =>
                      widget.updateRepsControllers(index),
                  updateWeightControllers: () =>
                      widget.updateWeightControllers(index),
                  updateRestTimeControllers: () =>
                      widget.updateRestTimeControllers(index),
                  addError: widget.addError,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }
      final item = widget.exerciseControllers.removeAt(oldIndex);
      widget.exerciseControllers.insert(newIndex, item);
    });
  }
}
