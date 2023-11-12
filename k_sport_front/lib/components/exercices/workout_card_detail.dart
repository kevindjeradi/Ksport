// workout_card_detail.dart
import 'package:flutter/material.dart';
import 'package:k_sport_front/components/generic/custom_image.dart';
import 'package:k_sport_front/components/generic/custom_navigation.dart';
import 'package:k_sport_front/components/history/exercise_history.dart';
import 'package:k_sport_front/components/navigation/return_app_bar.dart';

class WorkoutCardDetail extends StatelessWidget {
  final String title;
  final String muscleLabel;
  final String imageUrl;
  final String description;

  const WorkoutCardDetail({
    Key? key,
    required this.title,
    required this.muscleLabel,
    required this.imageUrl,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: ReturnAppBar(
          barTitle: "${title.toLowerCase()} pour $muscleLabel",
          bgColor: theme.colorScheme.primary,
          color: theme.colorScheme.onPrimary,
          elevation: 0),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Flexible(
              child: Center(
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: CustomImage(imagePath: imageUrl),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  description,
                  style: theme.textTheme.bodyLarge,
                ),
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  CustomNavigation.push(
                      context, ExerciseHistory(exerciseLabel: title));
                },
                child: const Text("Voir vos datas sur cet exercice"))
            // Expanded(
            //   child: SingleChildScrollView(
            //     child: ExerciseHistory(exerciseLabel: title),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
