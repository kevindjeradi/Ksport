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
  final CountDownController _controller = CountDownController();

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

  void _startRestTimer() {
    final restTime = _getRestTimeForCurrentExercise();
    setState(() {
      _isResting = true;
      _controller.restart(duration: restTime);
    });
  }

  int _getRestTimeForCurrentExercise() {
    final provider =
        Provider.of<ScheduleTrainingProvider>(context, listen: false);
    final exercises = provider.todayWorkouts;
    if (_currentExerciseIndex < exercises.length) {
      return exercises[_currentExerciseIndex]['restTime'];
    }
    return 0;
  }

  void _onTimerFinish() {
    setState(() {
      _currentExerciseIndex++;
      _startNextExercise();
    });
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
      body: _isResting
          ? Center(
              child: CircularCountDownTimer(
                duration: _getRestTimeForCurrentExercise(),
                initialDuration: 0,
                controller: _controller,
                width: MediaQuery.of(context).size.width / 2,
                height: MediaQuery.of(context).size.height / 2,
                ringColor: Colors.grey[300]!,
                ringGradient: null,
                fillColor: Colors.purpleAccent[100]!,
                fillGradient: null,
                backgroundColor: Colors.purple[500],
                backgroundGradient: null,
                strokeWidth: 20.0,
                strokeCap: StrokeCap.round,
                textStyle: const TextStyle(
                  fontSize: 33.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textFormat: CountdownTextFormat.S,
                isReverse: false,
                isReverseAnimation: false,
                isTimerTextShown: true,
                autoStart: false,
                onStart: () {
                  print('Countdown Started');
                },
                onComplete: () {
                  print('Countdown Ended');
                  _onTimerFinish();
                },
              ),
            )
          : exercise != null
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Exercise: ${exercise['name']}'),
                      Text('Sets: ${exercise['series']}'),
                      Text('Reps: ${exercise['reps']}'),
                      Text('rest: ${exercise['restTime']}'),
                      ElevatedButton(
                        onPressed: _startRestTimer,
                        child: const Text('Start Rest Timer'),
                      ),
                    ],
                  ),
                )
              : const Center(
                  child: Text('Workout Completed!'),
                ),
    );
  }
}
