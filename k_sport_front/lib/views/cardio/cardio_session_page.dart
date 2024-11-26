import 'package:flutter/material.dart';
import 'package:k_sport_front/components/navigation/return_app_bar.dart';
import 'dart:async';

import 'package:k_sport_front/views/cardio/cardio_completion_page.dart';

class CardioSessionPage extends StatefulWidget {
  final String exerciseName;
  final int duration;

  const CardioSessionPage({
    Key? key,
    required this.exerciseName,
    required this.duration,
  }) : super(key: key);

  @override
  CardioSessionPageState createState() => CardioSessionPageState();
}

class CardioSessionPageState extends State<CardioSessionPage> {
  late Timer _timer;
  late int _remainingSeconds;
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.duration * 60;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        _timer.cancel();
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CardioCompletionPage(
                exerciseName: widget.exerciseName,
                duration: widget.duration,
              ),
            ),
          );
        }
      }
    });
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: ReturnAppBar(barTitle: widget.exerciseName),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _formatTime(_remainingSeconds),
              style: theme.textTheme.displayLarge,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  if (_isActive) {
                    _timer.cancel();
                  } else {
                    _startTimer();
                  }
                  _isActive = !_isActive;
                });
              },
              child: Text(_isActive ? 'Pause' : 'Reprendre'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CardioCompletionPage(
                      exerciseName: widget.exerciseName,
                      duration: widget.duration,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.error,
              ),
              child: const Text('Terminer'),
            ),
          ],
        ),
      ),
    );
  }
}
