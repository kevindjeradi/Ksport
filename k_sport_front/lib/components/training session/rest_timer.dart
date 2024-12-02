import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:k_sport_front/components/generic/cutom_elevated_button.dart';

class RestTimer extends StatelessWidget {
  final CountDownController controller;
  final int restTime;
  final String currentExerciseName;
  final int currentSet;
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
    required this.currentExerciseName,
    required this.currentSet,
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            '$currentExerciseName - Série $currentSet',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
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
                    sendScheduledNotif(restTime, currentExerciseName);
                  },
                  onComplete: () {
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
