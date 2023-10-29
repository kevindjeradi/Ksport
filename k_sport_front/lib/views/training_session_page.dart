import 'package:flutter/material.dart';
import 'package:k_sport_front/components/navigation/return_app_bar.dart';
import 'package:k_sport_front/provider/schedule_training_provider.dart';
import 'package:k_sport_front/views/timer_page.dart';
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
      _currentExerciseIndex++;
    });
  }

  void _goToPreviousExercise() {
    if (_currentExerciseIndex > 0) {
      setState(() {
        _currentExerciseIndex--;
      });
    }
  }

  void _startRestTimer() {
    final restTime = _getRestTimeForCurrentExercise();
    print("restTime: $restTime");
    if (restTime > 0) {
      final provider =
          Provider.of<ScheduleTrainingProvider>(context, listen: false);
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
          ),
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

    if (_currentExerciseIndex < exercises.length - 1) {
      setState(() {
        _currentExerciseIndex++;
        // _startNextExercise();
      });
    } else {
      _finishTrainingSession();
    }
  }

  void _finishTrainingSession() {
    // Implement the logic to finish the training session
    print('Training Session Finished');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ScheduleTrainingProvider>();
    final exercises = provider.todayWorkouts;
    final exercise = _currentExerciseIndex < exercises.length
        ? exercises[_currentExerciseIndex]
        : null;

    return Scaffold(
      appBar: const ReturnAppBar(
          bgColor: Colors.blue,
          barTitle: "Séance d'entrainement",
          color: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: exercises.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (exercise == null) const WorkoutCompletedMessage(),
                  const SizedBox(height: 20),
                  if (exercise != null)
                    Text(
                      'Exercice ${_currentExerciseIndex + 1}/${exercises.length}',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  const SizedBox(height: 20),
                  if (exercise != null)
                    ExerciseInfoCard(
                      exercise: exercise,
                      startRestTimer: _startRestTimer,
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

class WorkoutCompletedMessage extends StatelessWidget {
  const WorkoutCompletedMessage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        children: [
          Text(
            'Bravo !',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            'Tu as terminé ta séance !',
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}

class ExerciseInfoCard extends StatelessWidget {
  final Map<String, dynamic> exercise;
  final Function startRestTimer;

  const ExerciseInfoCard(
      {Key? key, required this.exercise, required this.startRestTimer})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${exercise['name']}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            InfoRow(label: 'Sets', value: exercise['series'].toString()),
            InfoRow(label: 'Reps', value: exercise['reps'].toString()),
            InfoRow(label: 'Rest', value: '${exercise['restTime']}s'),
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(fontSize: 18))),
          Text(value, style: const TextStyle(fontSize: 18)),
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
    return ElevatedButton(
      onPressed: () => startRestTimer(),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        disabledForegroundColor: Colors.grey.withOpacity(0.38),
        disabledBackgroundColor: Colors.grey.withOpacity(0.12),
        padding: const EdgeInsets.all(15),
        textStyle: const TextStyle(fontSize: 18),
      ),
      child: const Text('lancer le repos'),
    );
  }
}
