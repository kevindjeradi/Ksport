import 'package:flutter/material.dart';
import 'package:k_sport_front/components/generic/custom_navigation.dart';
import 'package:k_sport_front/components/history/training_detail_page.dart';
import 'package:k_sport_front/models/completed_training.dart';
import 'package:k_sport_front/views/home.dart';

class TrainingCompletionDialog extends StatefulWidget {
  final CompletedTraining completedTraining;

  const TrainingCompletionDialog({super.key, required this.completedTraining});

  @override
  State<TrainingCompletionDialog> createState() =>
      TrainingCompletionDialogState();
}

class TrainingCompletionDialogState extends State<TrainingCompletionDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.elasticOut);

    controller.addListener(() => setState(() {}));
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void navigateToCompletedTrainingDetail(
      BuildContext context, CompletedTraining completedTraining) async {
    if (mounted) {
      // Navigate to the detail page of the completed training
      CustomNavigation.pushReplacement(context, const Home());
      CustomNavigation.push(
          context,
          TrainingDetailPage(
            completedTraining: completedTraining,
            date: completedTraining.dateCompleted,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scaleAnimation,
      child: AlertDialog(
        title: const Text('Félicitations!',
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text(
            'Votre entraînement est terminé. Voulez-vous voir le rapport de votre entraînement?'),
        actions: [
          TextButton(
            child: const Text('Non', style: TextStyle(color: Colors.red)),
            onPressed: () {
              Navigator.of(context).pop();
              CustomNavigation.pushReplacement(context, const Home());
            },
          ),
          TextButton(
            child: const Text('Oui', style: TextStyle(color: Colors.green)),
            onPressed: () {
              Navigator.of(context).pop();
              navigateToCompletedTrainingDetail(
                  context, widget.completedTraining);
            },
          ),
        ],
      ),
    );
  }
}
