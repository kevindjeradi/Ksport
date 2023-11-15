import 'package:flutter/material.dart';
import 'package:k_sport_front/components/generic/custom_image.dart';
import 'package:k_sport_front/components/generic/custom_snackbar.dart';
import 'package:k_sport_front/components/training%20session/info_row.dart';
import 'package:k_sport_front/components/training%20session/rest_timer_button.dart';

class ExerciseInfoCard extends StatelessWidget {
  final Map<String, dynamic> exercise;
  final String exerciseImage;
  final Function startRestTimer;
  final int currentSet;
  final Function(int) onRepsUpdated;
  final Function(int) onWeightsUpdated;

  const ExerciseInfoCard(
      {Key? key,
      required this.exercise,
      required this.startRestTimer,
      required this.currentSet,
      required this.exerciseImage,
      required this.onRepsUpdated,
      required this.onWeightsUpdated})
      : super(key: key);

  void _updateReps(BuildContext context) {
    TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Changer le nombre de répétitions"),
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: controller,
              autofocus: true,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Entrez le nombre de répétitions',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(foregroundColor: Colors.grey),
              child: const Text("Annuler"),
            ),
            TextButton(
              onPressed: () {
                final newReps = int.tryParse(controller.text);
                if (newReps != null && newReps >= 0) {
                  Navigator.of(context).pop(newReps);
                } else {
                  showCustomSnackBar(
                      context,
                      'Veuillez entrer un nombre valide de répétitions (supérieur ou égal à 0)',
                      SnackBarType.error);
                }
              },
              style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).primaryColor),
              child: const Text("Modifier"),
            ),
          ],
        );
      },
    ).then((newReps) {
      if (newReps != null) {
        onRepsUpdated(newReps);
      }
    });
  }

  void _updateWeights(BuildContext context) {
    TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Changer le poids"),
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: controller,
              autofocus: true,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Entrez le nouveau poids',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(foregroundColor: Colors.grey),
              child: const Text("Annuler"),
            ),
            TextButton(
              onPressed: () {
                final newWeights = int.tryParse(controller.text);
                if (newWeights != null && newWeights > 0) {
                  Navigator.of(context).pop(newWeights);
                } else {
                  showCustomSnackBar(
                      context,
                      'Veuillez entrer un nombre valide pour le poids (supérieur à 0)',
                      SnackBarType.error);
                }
              },
              style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).primaryColor),
              child: const Text("Modifier"),
            ),
          ],
        );
      },
    ).then((newWeights) {
      if (newWeights != null) {
        onWeightsUpdated(newWeights);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final List<int> reps = List<int>.from(exercise['reps']);
    final List<int> weights = List<int>.from(exercise['weight']);
    final String repsForCurrentSet = reps[currentSet - 1].toString();
    final String weightsForCurrentSet = weights[currentSet - 1].toString();

    return Card(
      elevation: theme.cardTheme.elevation,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${exercise['name']}',
              style: theme.textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            CustomImage(
                imagePath: exerciseImage, height: 250, fit: BoxFit.contain),
            const SizedBox(height: 10),
            InfoRow(
              label: 'Séries',
              value: "$currentSet / ${exercise['series'].toString()}",
            ),
            InfoRow(
              label: 'Répétitions',
              value: repsForCurrentSet,
              isEditable: true,
              onTap: () => _updateReps(context),
            ),
            InfoRow(
              label: 'Poids',
              value: "$weightsForCurrentSet kg",
              isEditable: true,
              onTap: () => _updateWeights(context),
            ),
            InfoRow(
                label: 'Repos',
                value: '${exercise['restTime'][currentSet - 1]}s'),
            RestTimerButton(startRestTimer: startRestTimer),
          ],
        ),
      ),
    );
  }
}
