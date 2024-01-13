import 'package:flutter/material.dart';
import 'package:k_sport_front/components/generic/custom_loader.dart';
import 'package:k_sport_front/components/generic/custom_snackbar.dart';
import 'package:k_sport_front/components/navigation/return_app_bar.dart';
import 'package:k_sport_front/components/training%20session/exercise_info_card.dart';
import 'package:k_sport_front/helpers/logger.dart';
import 'package:k_sport_front/models/completed_training.dart';
import 'package:k_sport_front/provider/schedule_training_provider.dart';
import 'package:k_sport_front/helpers/notification_handler.dart';
import 'package:k_sport_front/provider/user_provider.dart';
import 'package:k_sport_front/services/training_service.dart';
import 'package:k_sport_front/views/training_session/exercise_progress_indicator.dart';
import 'package:k_sport_front/views/training_session/timer_page.dart';
import 'package:k_sport_front/components/training%20session/training_completion_dialog.dart';
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
    final provider =
        Provider.of<ScheduleTrainingProvider>(context, listen: false);
    final exercises = provider.todayWorkouts;
    int totalSets = exercises[_currentExerciseIndex]['series'];
    int currentSet = provider.currentSet;

    if (currentSet < totalSets) {
      provider.updateCurrentSet(currentSet + 1);
    } else if (_currentExerciseIndex < exercises.length - 1) {
      setState(() {
        provider.updateCurrentSet(1);
        _currentExerciseIndex++;
      });
    }
  }

  void _goToPreviousExercise() {
    final provider =
        Provider.of<ScheduleTrainingProvider>(context, listen: false);
    int currentSet = provider.currentSet;

    if (currentSet > 1) {
      provider.updateCurrentSet(currentSet - 1);
    } else if (_currentExerciseIndex > 0) {
      setState(() {
        _currentExerciseIndex--;
        int totalSets = provider.todayWorkouts[_currentExerciseIndex]['series'];
        provider.updateCurrentSet(totalSets);
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
            notificationHandler: notificationHandler,
            setsPerExercise: exercises.map<int>((e) => e['series']).toList(),
          ),
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
      // Each exercise's rest time array has at least as many elements as there are sets
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
        // Use the updated repetitions from provider's data
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
      await TrainingService.recordCompletedTraining(completedTraining);

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
    List<int> setsPerExercise = exercises.map<int>((e) => e['series']).toList();
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: const ReturnAppBar(barTitle: "Séance d'entrainement"),
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
                      onWeightsUpdated: (newWeights) {
                        setState(() {
                          Log.logger.i("new weights: $newWeights");
                          exercises[_currentExerciseIndex]['weight']
                              [provider.currentSet - 1] = newWeights;
                          Log.logger.i(
                              "array -> ${exercises[_currentExerciseIndex]['weight']}\nexercises current exercise currentSet ${exercises[_currentExerciseIndex]['weight'][provider.currentSet - 1]}");
                        });
                      },
                    ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: _currentExerciseIndex > 0 ||
                                Provider.of<ScheduleTrainingProvider>(context,
                                            listen: false)
                                        .currentSet >
                                    1
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
                    setsPerExercise: setsPerExercise,
                    currentSet: provider.currentSet,
                  ),
                ],
              ),
      ),
    );
  }
}
