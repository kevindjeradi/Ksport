// exercise_card.dart
import 'package:flutter/material.dart';

class ExerciseCard extends StatefulWidget {
  final TextEditingController labelController;
  final TextEditingController repsController;
  final TextEditingController setsController;
  final TextEditingController weightController;
  final TextEditingController restTimeController;
  final VoidCallback onRemove;
  final Function updateWeightControllers;

  const ExerciseCard({
    Key? key,
    required this.labelController,
    required this.repsController,
    required this.setsController,
    required this.weightController,
    required this.restTimeController,
    required this.onRemove,
    required this.updateWeightControllers,
  }) : super(key: key);

  @override
  State<ExerciseCard> createState() => _ExerciseCardState();
}

class _ExerciseCardState extends State<ExerciseCard> {
  late TextEditingController setsController;
  late List<TextEditingController> weightControllers;

  @override
  void initState() {
    super.initState();
    setsController = widget.setsController;
    weightControllers = widget.weightController.text
        .split(',')
        .map((e) => TextEditingController(text: e))
        .toList();

    setsController.addListener(() {
      var currentSets = int.tryParse(setsController.text) ?? 0;

      while (weightControllers.length < currentSets) {
        weightControllers.add(TextEditingController(text: '0'));
      }

      if (weightControllers.length > currentSets) {
        weightControllers = weightControllers.take(currentSets).toList();
      }

      widget.weightController.text =
          weightControllers.map((e) => e.text).join(',');
    });
  }

  @override
  void dispose() {
    for (var controller in weightControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12.0),
      elevation: 2,
      shadowColor: theme.colorScheme.primary.withOpacity(0.5),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                TextField(
                  style: theme.textTheme.headlineSmall,
                  controller: widget.labelController,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    hintText: "Nom de l'exercice",
                    border: InputBorder.none,
                  ),
                ),
                const SizedBox(height: 12.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: TextField(
                        controller: widget.repsController,
                        decoration: const InputDecoration(
                          labelText: 'Répétitions',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Flexible(
                      child: TextField(
                        controller: widget.setsController,
                        decoration: const InputDecoration(
                          labelText: 'Séries',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Flexible(
                      child: TextField(
                        controller: widget.restTimeController,
                        decoration: const InputDecoration(
                          labelText: 'Repos (sec)',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    Flexible(
                      child: TextField(
                        controller: widget.weightController,
                        decoration: const InputDecoration(
                          labelText: 'Poids (kg)',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: IconButton(
              icon: const Icon(Icons.remove_circle_outline),
              onPressed: widget.onRemove,
              tooltip: 'Supprimer',
            ),
          ),
        ],
      ),
    );
  }
}
