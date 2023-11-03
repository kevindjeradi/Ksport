// timer_page.dart
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:k_sport_front/components/generic/cutom_elevated_button.dart';
import 'package:k_sport_front/components/navigation/return_app_bar.dart';
import 'package:k_sport_front/services/notification_handler.dart';

class TimerPage extends StatefulWidget {
  final int restTime;
  final Function onTimerFinish;
  final Map<String, dynamic> nextExercise;
  final Map<String, dynamic> currentExercise;
  final int totalExercises;
  final int currentExerciseIndex;
  final NotificationHandler notificationHandler;

  const TimerPage(
      {Key? key,
      required this.restTime,
      required this.onTimerFinish,
      required this.nextExercise,
      required this.currentExercise,
      required this.totalExercises,
      required this.currentExerciseIndex,
      required this.notificationHandler})
      : super(key: key);

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  final CountDownController _controller = CountDownController();
  bool _isPaused = false;

  void _sendScheduledNotif(int delayInSeconds) {
    widget.notificationHandler.sendScheduledNotif(
        delayInSeconds); // Update the method call to use the NotificationHandler instance
  }

  void _cancelScheduledNotification(int id) {
    widget.notificationHandler.cancelScheduledNotification(id);
  }

// Method to skip the rest time and go to the next exercise
  void _skipTimer() {
    if (mounted) {
      _controller.pause();
      _cancelScheduledNotification(0);
      Navigator.of(context).pop();
      widget.onTimerFinish();
    }
  }

// Method to toggle the timer between paused and running
  void _toggleTimer() {
    if (mounted) {
      if (_isPaused) {
        // Get the remaining time when resuming
        final remainingTimeAsString = _controller.getTime();
        if (remainingTimeAsString != null) {
          final parts = remainingTimeAsString.split(':');
          if (parts.length == 2) {
            final minutes = int.tryParse(parts[0]);
            final seconds = int.tryParse(parts[1]);
            if (minutes != null && seconds != null) {
              final remainingTimeInSeconds = minutes * 60 + seconds;
              _sendScheduledNotif(remainingTimeInSeconds);
            } else {
              print('Failed to parse minutes and/or seconds');
            }
          } else {
            print('Unexpected time format');
          }
        } else {
          print('Failed to get remaining time');
        }
        _controller.resume();
      } else {
        _controller.pause();
        _cancelScheduledNotification(0);
      }

      setState(() {
        _isPaused = !_isPaused;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: ReturnAppBar(
          bgColor: theme.colorScheme.primary,
          barTitle: widget.currentExercise['name'],
          color: theme.colorScheme.onPrimary),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RestTimer(
              controller: _controller,
              restTime: widget.restTime,
              sendScheduledNotif: _sendScheduledNotif,
              onTimerFinish: () {
                Navigator.of(context).pop();
                widget.onTimerFinish();
              },
              stopTimer: () {
                _cancelScheduledNotification(0);
                Navigator.of(context).pop();
              },
              isPaused: _isPaused,
              toggleTimer: () {
                _toggleTimer();
              },
              skipTimer: () {
                _skipTimer();
              },
            ),
            const SizedBox(height: 20),
            ExerciseProgressIndicator(
              currentExerciseIndex: widget.currentExerciseIndex + 1,
              totalExercises: widget.totalExercises,
              nextExerciseName:
                  widget.nextExercise['name'] ?? "Fin de la séance",
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
  final Function sendScheduledNotif;
  final Function toggleTimer;
  final Function onTimerFinish;
  final Function stopTimer;
  final Function skipTimer;

  const RestTimer({
    Key? key,
    required this.controller,
    required this.restTime,
    required this.isPaused,
    required this.sendScheduledNotif,
    required this.toggleTimer,
    required this.onTimerFinish,
    required this.stopTimer,
    required this.skipTimer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    'Temps de repos',
                    style: theme.textTheme.displaySmall,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  color: theme.colorScheme.onSurface,
                  onPressed: () => stopTimer(),
                ),
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
                  ringColor: theme.colorScheme.primaryContainer,
                  fillColor: theme.colorScheme.secondary,
                  backgroundColor: theme.colorScheme.primary,
                  strokeWidth: 20.0,
                  strokeCap: StrokeCap.round,
                  textStyle: TextStyle(
                    fontSize: 33.0,
                    color: isPaused
                        ? theme.colorScheme.error
                        : theme.colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                  textFormat: CountdownTextFormat.MM_SS,
                  isReverse: true,
                  isTimerTextShown: true,
                  autoStart: true,
                  onStart: () {
                    print('Countdown Started');
                    sendScheduledNotif(restTime);
                  },
                  onComplete: () {
                    print('Countdown Ended');
                    onTimerFinish();
                  },
                ),
                if (isPaused)
                  Icon(
                    Icons.pause,
                    size: 50,
                    color: theme.colorScheme.onPrimary,
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        CustomElevatedButton(
          onPressed: () => skipTimer(),
          label: 'Passer le repos',
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
        ),
      ],
    );
  }
}

class ExerciseProgressIndicator extends StatelessWidget {
  final int currentExerciseIndex;
  final int totalExercises;
  final String nextExerciseName;

  const ExerciseProgressIndicator({
    Key? key,
    required this.currentExerciseIndex,
    required this.totalExercises,
    this.nextExerciseName = "",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value:
                totalExercises > 0 ? currentExerciseIndex / totalExercises : 0,
            minHeight: 20,
            backgroundColor: theme.colorScheme.background,
            valueColor:
                AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
          ),
        ),
        const SizedBox(height: 10),
        if (nextExerciseName.isNotEmpty)
          currentExerciseIndex < totalExercises
              ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Prochain exercice : $nextExerciseName",
                    style: theme.textTheme.headlineSmall,
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    nextExerciseName,
                    style: theme.textTheme.headlineSmall,
                  ),
                ),
      ],
    );
  }
}
