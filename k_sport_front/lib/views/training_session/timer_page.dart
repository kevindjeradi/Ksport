// timer_page.dart
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:k_sport_front/components/navigation/return_app_bar.dart';
import 'package:k_sport_front/components/training%20session/rest_timer.dart';
import 'package:k_sport_front/helpers/locale_notification_handler.dart';
import 'package:k_sport_front/helpers/logger.dart';

class TimerPage extends StatefulWidget {
  final int restTime;
  final Function onTimerFinish;
  final Map<String, dynamic> nextExercise;
  final Map<String, dynamic> currentExercise;
  final int totalExercises;
  final int currentExerciseIndex;
  final LocaleNotificationHandler notificationHandler;
  final List<int> setsPerExercise;

  const TimerPage(
      {Key? key,
      required this.restTime,
      required this.onTimerFinish,
      required this.nextExercise,
      required this.currentExercise,
      required this.totalExercises,
      required this.currentExerciseIndex,
      required this.notificationHandler,
      required this.setsPerExercise})
      : super(key: key);

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  final CountDownController _controller = CountDownController();
  bool _isPaused = false;

  void _sendScheduledNotif(int delayInSeconds, String currentExerciseName) {
    widget.notificationHandler.sendScheduledNotif(delayInSeconds,
        "Prochaine série", "Temps de repos fini pour $currentExerciseName");
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
              _sendScheduledNotif(
                  remainingTimeInSeconds, widget.currentExercise['name']);
            } else {
              Log.logger
                  .e('Failed to parse minutes and/or seconds in timer_page');
            }
          } else {
            Log.logger.e('Unexpected time format in timer_page');
          }
        } else {
          Log.logger.e('Failed to get remaining time in timer_page');
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
    final isLastSet = widget.currentExercise['currentSet'] ==
        widget.setsPerExercise[widget.currentExerciseIndex];

    String getNextExerciseText() {
      if (isLastSet) {
        // If it's the last set and there's a next exercise, show "Next exercise: ExerciseName - Set 1"
        return widget.nextExercise.isNotEmpty
            ? 'Prochain exercice : ${widget.nextExercise['name']} - Série 1'
            : '';
      } else {
        // If it's not the last set, show "Current exercise - Next set"
        return 'Prochain exercice : ${widget.currentExercise['name']} - Série ${widget.currentExercise['currentSet'] + 1}';
      }
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: ReturnAppBar(barTitle: widget.currentExercise['name']),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RestTimer(
                controller: _controller,
                restTime: widget.restTime,
                currentExerciseName: widget.currentExercise['name'],
                currentSet: widget.currentExercise['currentSet'],
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
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  getNextExerciseText(),
                  style: theme.textTheme.headlineSmall,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
