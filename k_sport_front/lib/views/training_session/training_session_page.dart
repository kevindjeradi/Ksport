import 'package:flutter/material.dart';
import 'package:k_sport_front/components/generic/custom_image.dart';
import 'package:k_sport_front/components/generic/custom_loader.dart';
import 'package:k_sport_front/components/generic/custom_snackbar.dart';
import 'package:k_sport_front/components/navigation/return_app_bar.dart';
import 'package:k_sport_front/helpers/logger.dart';
import 'package:k_sport_front/models/completed_training.dart';
import 'package:k_sport_front/provider/schedule_training_provider.dart';
import 'package:k_sport_front/helpers/notification_handler.dart';
import 'package:k_sport_front/provider/user_provider.dart';
import 'package:k_sport_front/services/training_service.dart';
import 'package:k_sport_front/views/training_session/timer_page.dart';
import 'package:k_sport_front/views/training_session/training_completion_dialog.dart';
import 'package:provider/provider.dart';

class TrainingSessionPage extends StatefulWidget {
  final List<String> exerciseImageUrls;

  const TrainingSessionPage({Key? key, required this.exerciseImageUrls})
      : super(key: key);

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

// Method to get the rest time for the current exercise for the current set
  int _getRestTimeForCurrentExercise() {
    final provider =
        Provider.of<ScheduleTrainingProvider>(context, listen: false);
    final exercises = provider.todayWorkouts;

    if (_currentExerciseIndex < exercises.length) {
      // Assuming each exercise's rest time array has at least as many elements as there are sets
      List<int> restTimesForExercise =
          List<int>.from(exercises[_currentExerciseIndex]['restTime']);
      int currentSet = provider.currentSet;

      // Check if the currentSet is within the range of the restTimes array
      if (currentSet - 1 < restTimesForExercise.length) {
        return restTimesForExercise[currentSet - 1];
      }
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
    final provider =
        Provider.of<ScheduleTrainingProvider>(context, listen: false);
    final today = DateTime.now().weekday - 1;
    final trainingId = provider.weekTrainings[today]!.id;

    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final now = DateTime.now();

      Log.logger.i("trainingId: $trainingId");

      // Fetch the training details to create a snapshot, but use updated reps
      final trainingDetails = await TrainingService.fetchTraining(trainingId);

      List<TrainingExercise> updatedExercises =
          provider.todayWorkouts.map((exerciseData) {
        // Here, use the updated repetitions from your provider's data
        List<int> updatedReps = List<int>.from(exerciseData['reps']);
        Log.logger.i("updated reps: $updatedReps\nexerciseData: $exerciseData");

        return TrainingExercise(
          label: exerciseData['name'],
          exerciseId: exerciseData['exerciseId'],
          repetitions: updatedReps,
          sets: exerciseData['series'],
          weight: List<int>.from(exerciseData['weight']),
          restTime: List<int>.from(exerciseData['restTime']),
        );
      }).toList();

      final CompletedTraining completedTraining = CompletedTraining(
        trainingId: trainingId,
        dateCompleted: now,
        name: trainingDetails!.name,
        description: trainingDetails.description,
        exercises:
            updatedExercises, // Use the list of updated TrainingExercise instances
        goal: trainingDetails.goal,
      );

      userProvider.addCompletedTraining(completedTraining);

      if (mounted) {
        showCustomSnackBar(context, 'Votre séance à bien été enregistrée',
            SnackBarType.success);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return TrainingCompletionDialog(
                completedTraining: completedTraining);
          },
        );
      }
    } catch (e) {
      if (mounted) {
        showCustomSnackBar(
            context,
            'Un problème est survenu lors de l\'enregistrement de votre séance',
            SnackBarType.error);
      }
      Log.logger.e('Failed to record training: $e');
    }
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
                      exerciseImage:
                          widget.exerciseImageUrls[_currentExerciseIndex],
                      startRestTimer: _startRestTimer,
                      currentSet: provider.currentSet,
                      onRepsUpdated: (newReps) {
                        setState(() {
                          Log.logger.i("newReps: $newReps");
                          exercises[_currentExerciseIndex]['reps']
                              [provider.currentSet - 1] = newReps;
                          Log.logger.i(
                              "array -> ${exercises[_currentExerciseIndex]['reps']}\nexercises current exercise currentSet ${exercises[_currentExerciseIndex]['reps'][provider.currentSet - 1]}");
                        });
                      },
                    ),
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
  final String exerciseImage;
  final Function startRestTimer;
  final int currentSet;
  final Function(int) onRepsUpdated;

  const ExerciseInfoCard(
      {Key? key,
      required this.exercise,
      required this.startRestTimer,
      required this.currentSet,
      required this.exerciseImage,
      required this.onRepsUpdated})
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
            CustomImage(imagePath: exerciseImage),
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
                label: 'Repos',
                value: '${exercise['restTime'][currentSet - 1]}s'),
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
  final VoidCallback? onTap;
  final bool isEditable;

  const InfoRow({
    Key? key,
    required this.label,
    required this.value,
    this.onTap,
    this.isEditable = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          children: [
            Expanded(
              child: Text(label, style: theme.textTheme.titleLarge),
            ),
            if (isEditable)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.edit, size: 18, color: theme.primaryColor),
                  const SizedBox(width: 4),
                  Text(value, style: theme.textTheme.headlineSmall),
                ],
              )
            else
              Text(value, style: theme.textTheme.headlineSmall),
          ],
        ),
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
