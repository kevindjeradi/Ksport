// exercise_card.dart
import 'package:flutter/material.dart';

class ExerciseCard extends StatelessWidget {
  final TextEditingController labelController;
  final TextEditingController repsController;
  final TextEditingController setsController;
  final TextEditingController weightController;
  final TextEditingController restTimeController;
  final VoidCallback onRemove;

  const ExerciseCard({
    Key? key,
    required this.labelController,
    required this.repsController,
    required this.setsController,
    required this.weightController,
    required this.restTimeController,
    required this.onRemove,
  }) : super(key: key);

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
                  controller: labelController,
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
                        controller: repsController,
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
                        controller: setsController,
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
                        controller: restTimeController,
                        decoration: const InputDecoration(
                          labelText: 'Repos (sec)',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    Flexible(
                      child: TextField(
                        controller: weightController,
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
              onPressed: onRemove,
              tooltip: 'Supprimer',
            ),
          ),
        ],
      ),
    );
  }
}
