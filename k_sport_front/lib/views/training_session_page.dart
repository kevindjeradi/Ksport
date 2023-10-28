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
    print("restTime: $restTime");
    if (restTime > 0) {
      setState(() {
        _isResting = true;
      });
      _controller.restart(duration: restTime);
    }
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isResting)
              GestureDetector(
                onTap: _toggleTimer,
                child: Center(
                  child: CircularCountDownTimer(
                    duration: _isResting ? _getRestTimeForCurrentExercise() : 0,
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
                    isReverse: true,
                    isReverseAnimation: false,
                    isTimerTextShown: true,
                    autoStart: _isResting,
                    onStart: () {
                      print('Countdown Started');
                    },
                    onComplete: () {
                      print('Countdown Ended');
                      _onTimerFinish();
                    },
                  ),
                ),
              ),
            if (!_isResting && exercise == null)
              const Center(
                child: Text(
                  'Workout Completed!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            const SizedBox(height: 20),
            Text(
              'Exercise $_currentExerciseIndex/${exercises.length}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            if (!_isResting && exercise != null)
              ExerciseInfoCard(exercise: exercise),
            const SizedBox(height: 20),
            if (!_isResting && exercise != null)
              ElevatedButton(
                onPressed: _startRestTimer,
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const Text('Start Rest Timer'),
              ),
          ],
        ),
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
