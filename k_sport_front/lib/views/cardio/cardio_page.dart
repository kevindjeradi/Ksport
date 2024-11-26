import 'package:flutter/material.dart';
import 'package:k_sport_front/components/navigation/return_app_bar.dart';
import 'package:k_sport_front/views/cardio/cardio_session_page.dart';

class CardioPage extends StatelessWidget {
  const CardioPage({Key? key}) : super(key: key);

  final List<Map<String, dynamic>> cardioExercises = const [
    {'name': 'Vélo', 'icon': Icons.directions_bike},
    {'name': 'Rameur', 'icon': Icons.rowing},
    {'name': 'Escalier', 'icon': Icons.stairs},
    {'name': 'Course', 'icon': Icons.directions_run},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: const ReturnAppBar(barTitle: "Cardio"),
      body: GridView.count(
        padding: const EdgeInsets.all(16),
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: cardioExercises.map((exercise) {
          return Card(
            elevation: 4,
            child: InkWell(
              onTap: () => _showDurationPicker(context, exercise['name']),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    exercise['icon'],
                    size: 48,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    exercise['name'],
                    style: theme.textTheme.titleLarge,
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  void _showDurationPicker(BuildContext context, String exerciseName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        int selectedDuration = 30;
        return AlertDialog(
          title: Text('Durée de $exerciseName'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Minutes:'),
                  Slider(
                    value: selectedDuration.toDouble(),
                    min: 1,
                    max: 120,
                    divisions: 119,
                    label: selectedDuration.toString(),
                    onChanged: (double value) {
                      setState(() {
                        selectedDuration = value.round();
                      });
                    },
                  ),
                  Text('$selectedDuration minutes'),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CardioSessionPage(
                      exerciseName: exerciseName,
                      duration: selectedDuration,
                    ),
                  ),
                );
              },
              child: const Text('Commencer'),
            ),
          ],
        );
      },
    );
  }
}
