import 'package:flutter/material.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:k_sport_front/provider/schedule_training_provider.dart';
import 'package:provider/provider.dart';

class TrainingSessionPage extends StatefulWidget {
  const TrainingSessionPage({Key? key}) : super(key: key);

  @override
  TrainingSessionPageState createState() => TrainingSessionPageState();
}

class TrainingSessionPageState extends State<TrainingSessionPage> {
  int _currentExerciseIndex = 0;
  bool _isResting = false;
  bool _isPaused = false;
  final CountDownController _controller = CountDownController();

  void _goToNextExercise() {
    setState(() {
      _currentExerciseIndex++;
      _startNextExercise();
    });
  }

  void _goToPreviousExercise() {
    if (_currentExerciseIndex > 0) {
      setState(() {
        _currentExerciseIndex--;
        _startNextExercise();
      });
    }
  }

  // Method to start the next exercise
  void _startNextExercise() {
    final provider =
        Provider.of<ScheduleTrainingProvider>(context, listen: false);
    final exercises = provider.todayWorkouts;
    if (_currentExerciseIndex < exercises.length) {
      setState(() {
        _isResting = false;
      });
    }
  }

  // Method to start the rest timer
  void _startRestTimer() {
    final restTime = _getRestTimeForCurrentExercise();
    print("restTime: $restTime");
    if (restTime > 0) {
      setState(() {
        _isResting = true;
      });
      _controller.restart(duration: restTime);
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

  // Method to toggle the timer between paused and running
  void _toggleTimer() {
    if (_isPaused) {
      _controller.resume();
    } else {
      _controller.pause();
    }

    setState(() {
      _isPaused = !_isPaused;
    });
  }

  // Method called when the timer finishes
  void _onTimerFinish() {
    setState(() {
      _currentExerciseIndex++;
      _startNextExercise();
    });
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
      appBar: AppBar(
        title: const Text('Training Session'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: exercises.isEmpty
            ? const Center(child: CircularProgressIndicator()) // Loading state
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!_isResting)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: _currentExerciseIndex > 0
                              ? _goToPreviousExercise
                              : null,
                          child: const Text('Previous'),
                        ),
                        ElevatedButton(
                          onPressed:
                              _currentExerciseIndex < exercises.length - 1
                                  ? _goToNextExercise
                                  : _finishTrainingSession,
                          child: _currentExerciseIndex < exercises.length - 1
                              ? const Text('Next')
                              : const Text('Finish'),
                        ),
                      ],
                    ),
                  if (_isResting)
                    RestTimer(
                      controller: _controller,
                      restTime: _getRestTimeForCurrentExercise(),
                      isPaused: _isPaused,
                      toggleTimer: _toggleTimer,
                      onTimerFinish: _onTimerFinish,
                    ),
                  if (!_isResting && exercise == null)
                    const WorkoutCompletedMessage(),
                  if (!_isResting && exercise != null)
                    ExerciseInfoCard(exercise: exercise),
                  if (!_isResting && exercise != null)
                    RestTimerButton(startRestTimer: _startRestTimer),
                  const SizedBox(height: 20),
                  ExerciseProgressIndicator(
                    currentExerciseIndex: _currentExerciseIndex,
                    totalExercises: exercises.length,
                  ),
                ],
              ),
      ),
    );
  }
}

class RestTimer extends StatelessWidget {
  final CountDownController controller;
  final int restTime;
  final bool isPaused;
  final Function toggleTimer;
  final Function onTimerFinish;

  const RestTimer({
    Key? key,
    required this.controller,
    required this.restTime,
    required this.isPaused,
    required this.toggleTimer,
    required this.onTimerFinish,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => toggleTimer(),
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            CircularCountDownTimer(
              duration: restTime,
              initialDuration: 0,
              controller: controller,
              width: MediaQuery.of(context).size.width / 2,
              height: MediaQuery.of(context).size.height / 2,
              ringColor: Colors.grey[300]!,
              fillColor: Colors.purpleAccent[100]!,
              backgroundColor: Colors.purple[500],
              strokeWidth: 20.0,
              strokeCap: StrokeCap.round,
              textStyle: TextStyle(
                fontSize: 33.0,
                color: isPaused ? Colors.red : Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textFormat: CountdownTextFormat.S,
              isReverse: true,
              isTimerTextShown: true,
              autoStart: true,
              onStart: () => print('Countdown Started'),
              onComplete: () {
                print('Countdown Ended');
                onTimerFinish();
              },
            ),
            if (isPaused)
              const Icon(
                Icons.pause,
                size: 50,
                color: Colors.white,
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
            'Congratulations!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            'You have completed your workout',
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}

class ExerciseInfoCard extends StatelessWidget {
  final Map<String, dynamic> exercise;

  const ExerciseInfoCard({Key? key, required this.exercise}) : super(key: key);

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
              'Exercise: ${exercise['name']}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            InfoRow(label: 'Sets', value: exercise['series'].toString()),
            InfoRow(label: 'Reps', value: exercise['reps'].toString()),
            InfoRow(label: 'Rest', value: '${exercise['restTime']}s'),
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
        backgroundColor: Colors.green, // Active color
        disabledForegroundColor: Colors.grey.withOpacity(0.38),
        disabledBackgroundColor:
            Colors.grey.withOpacity(0.12), // Disabled color
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        textStyle: const TextStyle(fontSize: 18),
      ),
      child: const Text('Start Rest Timer'),
    );
  }
}

class ExerciseProgressIndicator extends StatelessWidget {
  final int currentExerciseIndex;
  final int totalExercises;

  const ExerciseProgressIndicator({
    Key? key,
    required this.currentExerciseIndex,
    required this.totalExercises,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LinearProgressIndicator(
          value: totalExercises > 0 ? currentExerciseIndex / totalExercises : 0,
          minHeight: 10,
          backgroundColor: Colors.grey[300],
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
        ),
        const SizedBox(height: 10),
        Text(
          'Exercise $currentExerciseIndex/$totalExercises',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
