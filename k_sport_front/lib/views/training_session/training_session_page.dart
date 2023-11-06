import 'package:flutter/material.dart';
import 'package:k_sport_front/components/generic/custom_loader.dart';
import 'package:k_sport_front/components/navigation/return_app_bar.dart';
import 'package:k_sport_front/helpers/logger.dart';
import 'package:k_sport_front/provider/schedule_training_provider.dart';
import 'package:k_sport_front/helpers/notification_handler.dart';
import 'package:k_sport_front/services/training_service.dart';
import 'package:k_sport_front/views/training_session/timer_page.dart';
import 'package:provider/provider.dart';

class TrainingSessionPage extends StatefulWidget {
  const TrainingSessionPage({Key? key}) : super(key: key);

  @override
  TrainingSessionPageState createState() => TrainingSessionPageState();
}

class TrainingSessionPageState extends State<TrainingSessionPage> {
  int _currentExerciseIndex = 0;

  void _goToNextExercise() {
    setState(() {
      context.read<ScheduleTrainingProvider>().updateCurrentSet(1);
      _currentExerciseIndex++;
    });
  }

  void _goToPreviousExercise() {
    if (_currentExerciseIndex > 0) {
      setState(() {
        context.read<ScheduleTrainingProvider>().updateCurrentSet(1);
        _currentExerciseIndex--;
      });
    }
  }

  void _startRestTimer() {
    final restTime = _getRestTimeForCurrentExercise();
    if (restTime > 0) {
      final provider =
          Provider.of<ScheduleTrainingProvider>(context, listen: false);
      final notificationHandler =
          Provider.of<NotificationHandler>(context, listen: false);

      final exercises = provider.todayWorkouts;

      final currentExercise = exercises[_currentExerciseIndex];

      final nextExercise = _currentExerciseIndex < exercises.length - 1
          ? exercises[_currentExerciseIndex + 1]
          : null;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TimerPage(
              restTime: restTime,
              onTimerFinish: _onTimerFinish,
              currentExercise: currentExercise,
              nextExercise: nextExercise ?? {},
              totalExercises: exercises.length,
              currentExerciseIndex: _currentExerciseIndex,
              notificationHandler: notificationHandler),
        ),
      );
    }
  }

  // Method to get the rest time for the current exercise
  int _getRestTimeForCurrentExercise() {
    final provider =
        Provider.of<ScheduleTrainingProvider>(context, listen: false);
    final exercises = provider.todayWorkouts;

    if (_currentExerciseIndex < exercises.length) {
      return exercises[_currentExerciseIndex]['restTime'];
    }
    return 0;
  }

  // Method called when the timer finishes
  void _onTimerFinish() {
    final provider =
        Provider.of<ScheduleTrainingProvider>(context, listen: false);
    final exercises = provider.todayWorkouts;
    int currentSet = provider.currentSet;
    final totalSets = exercises[_currentExerciseIndex]['series'];

    if (_currentExerciseIndex < exercises.length - 1) {
      if (currentSet < totalSets) {
        provider.updateCurrentSet(currentSet + 1);
      } else {
        provider.updateCurrentSet(1);
        _goToNextExercise();
      }
    } else {
      if (currentSet < totalSets) {
        provider.updateCurrentSet(currentSet + 1);
      } else {
        provider.updateCurrentSet(1);
        _finishTrainingSession();
      }
    }
  }

  void _finishTrainingSession() async {
    // Implement the logic to finish the training session
    final provider =
        Provider.of<ScheduleTrainingProvider>(context, listen: false);
    final today = DateTime.now().weekday -
        1; // DateTime.now().weekday returns 1 for Monday, 2 for Tuesday, etc.
    final trainingId = provider.weekTrainings[today]!.id;
    Log.logger.i('Training Session Finished');
    try {
      Log.logger.i('Try');
      Log.logger.i(trainingId.toString());

      await TrainingService.recordCompletedTraining(trainingId);
      Log.logger.i('Training recorded successfully');
    } catch (e) {
      Log.logger.e('Failed to record training: $e');
    }

    // Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ScheduleTrainingProvider>();
    final exercises = provider.todayWorkouts;
    final exercise = _currentExerciseIndex < exercises.length
        ? exercises[_currentExerciseIndex]
        : null;

    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: ReturnAppBar(
          bgColor: theme.colorScheme.primary,
          barTitle: "Séance d'entrainement",
          color: theme.colorScheme.onPrimary),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: exercises.isEmpty
            ? const Center(child: CustomLoader())
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  if (exercise != null)
                    Text(
                      'Exercice ${_currentExerciseIndex + 1}/${exercises.length}',
                      style: theme.textTheme.headlineMedium,
                    ),
                  const SizedBox(height: 20),
                  if (exercise != null)
                    ExerciseInfoCard(
                        exercise: exercise,
                        startRestTimer: _startRestTimer,
                        currentSet: provider.currentSet),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: _currentExerciseIndex > 0
                            ? _goToPreviousExercise
                            : null,
                        child: const Text('Précédent'),
                      ),
                      ElevatedButton(
                        onPressed: _currentExerciseIndex < exercises.length - 1
                            ? _goToNextExercise
                            : _finishTrainingSession,
                        child: _currentExerciseIndex < exercises.length - 1
                            ? const Text('Suivant')
                            : const Text('Terminer'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ExerciseProgressIndicator(
                    currentExerciseIndex: _currentExerciseIndex + 1,
                    totalExercises: exercises.length,
                  ),
                ],
              ),
      ),
    );
  }
}

class ExerciseInfoCard extends StatelessWidget {
  final Map<String, dynamic> exercise;
  final Function startRestTimer;
  final int currentSet;

  const ExerciseInfoCard(
      {Key? key,
      required this.exercise,
      required this.startRestTimer,
      required this.currentSet})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final List<int> reps = List<int>.from(exercise['reps']);
    final String repsForCurrentSet = reps[currentSet - 1].toString();

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
            InfoRow(
              label: 'Séries',
              value: "$currentSet / ${exercise['series'].toString()}",
            ),
            InfoRow(label: 'Répétitions', value: repsForCurrentSet),
            InfoRow(label: 'Repos', value: '${exercise['restTime']}s'),
            RestTimerButton(startRestTimer: startRestTimer),
          ],
        ),
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const InfoRow({Key? key, required this.label, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: theme.textTheme.titleLarge),
          ),
          Text(value, style: theme.textTheme.headlineSmall),
        ],
      ),
    );
  }
}

class RestTimerButton extends StatelessWidget {
  final Function startRestTimer;

  const RestTimerButton({Key? key, required this.startRestTimer})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ElevatedButton(
      onPressed: () => startRestTimer(),
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.primary,
        disabledForegroundColor: theme.colorScheme.onSurface.withOpacity(0.38),
        disabledBackgroundColor: theme.colorScheme.surface.withOpacity(0.12),
        padding: const EdgeInsets.all(15),
        textStyle: theme.textTheme.titleLarge,
      ),
      child: const Text('Lancer le repos'),
    );
  }
}
