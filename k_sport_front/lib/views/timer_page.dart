import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:k_sport_front/components/navigation/return_app_bar.dart';

class TimerPage extends StatefulWidget {
  final int restTime;
  final Function onTimerFinish;
  final Map<String, dynamic> nextExercise;
  final Map<String, dynamic> currentExercise;
  final int totalExercises;
  final int currentExerciseIndex;

  const TimerPage({
    Key? key,
    required this.restTime,
    required this.onTimerFinish,
    required this.nextExercise,
    required this.currentExercise,
    required this.totalExercises,
    required this.currentExerciseIndex,
  }) : super(key: key);

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  final CountDownController _controller = CountDownController();
  bool _isPaused = false;

// Method to toggle the timer between paused and running
  void _toggleTimer() {
    if (mounted) {
      if (_isPaused) {
        _controller.resume();
      } else {
        _controller.pause();
      }

      setState(() {
        _isPaused = !_isPaused;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ReturnAppBar(
          bgColor: Colors.blue,
          barTitle: widget.currentExercise['name'],
          color: Colors.white),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RestTimer(
            controller: _controller,
            restTime: widget.restTime,
            onTimerFinish: () {
              Navigator.of(context).pop();
              widget.onTimerFinish();
            },
            stopTimer: () {
              Navigator.of(context).pop();
            },
            isPaused: _isPaused,
            toggleTimer: _toggleTimer,
          ),
          const SizedBox(height: 20),
          ExerciseProgressIndicator(
            currentExerciseIndex: widget.currentExerciseIndex + 1,
            totalExercises: widget.totalExercises,
            exerciseName: widget.nextExercise['name'] ?? "Fin de la séance",
          ),
        ],
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
  final Function stopTimer;

  const RestTimer({
    Key? key,
    required this.controller,
    required this.restTime,
    required this.isPaused,
    required this.toggleTimer,
    required this.onTimerFinish,
    required this.stopTimer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Expanded(
                child: Text(
                  'Temps de repos',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => stopTimer(),
              ),
            ],
          ),
        ),
        GestureDetector(
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
        ),
      ],
    );
  }
}

class ExerciseProgressIndicator extends StatelessWidget {
  final int currentExerciseIndex;
  final int totalExercises;
  final String exerciseName;

  const ExerciseProgressIndicator({
    Key? key,
    required this.currentExerciseIndex,
    required this.totalExercises,
    this.exerciseName = "",
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
        if (exerciseName.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: currentExerciseIndex > totalExercises
                ? Text(
                    "Prochain exercice : $exerciseName",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  )
                : Text(
                    exerciseName,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
          ),
      ],
    );
  }
}
