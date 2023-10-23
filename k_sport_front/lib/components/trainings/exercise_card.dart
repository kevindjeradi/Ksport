import 'package:flutter/material.dart';

class ExerciseCard extends StatelessWidget {
  final TextEditingController labelController;
  final TextEditingController repsController;
  final TextEditingController setsController;
  final TextEditingController restTimeController;
  final VoidCallback onRemove;

  const ExerciseCard({
    Key? key,
    required this.labelController,
    required this.repsController,
    required this.setsController,
    required this.restTimeController,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                TextField(
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
