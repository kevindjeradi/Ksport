import 'package:flutter/material.dart';
import 'package:k_sport_front/components/generic/custom_navigation.dart';
import 'package:k_sport_front/views/history/training_detail_page.dart';
import 'package:k_sport_front/models/completed_training.dart';
import 'package:confetti/confetti.dart';

class TrainingCompletionDialog extends StatefulWidget {
  final CompletedTraining completedTraining;

  const TrainingCompletionDialog({super.key, required this.completedTraining});

  @override
  State<TrainingCompletionDialog> createState() =>
      _TrainingCompletionDialogState();
}

class _TrainingCompletionDialogState extends State<TrainingCompletionDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _scaleAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.elasticOut);

    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));

    _controller.addListener(() => setState(() {}));
    _controller.forward();
    _confettiController.play();
  }

  @override
  void dispose() {
    _controller.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  void navigateToCompletedTrainingDetail(
      BuildContext context, CompletedTraining completedTraining) async {
    if (mounted) {
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
    return Stack(
      alignment: Alignment.center,
      children: [
        ScaleTransition(
          scale: _scaleAnimation,
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
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Oui', style: TextStyle(color: Colors.green)),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  navigateToCompletedTrainingDetail(
                      context, widget.completedTraining);
                },
              ),
            ],
          ),
        ),
        Positioned(
          top: 0,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            particleDrag: 0.05,
            emissionFrequency: 0.05,
            numberOfParticles: 20,
            gravity: 0.05,
            shouldLoop: false,
            colors: const [
              Colors.green,
              Colors.blue,
              Colors.pink,
              Colors.orange,
              Colors.purple
            ],
          ),
        ),
      ],
    );
  }
}
