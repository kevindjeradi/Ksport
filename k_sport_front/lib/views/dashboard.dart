import 'package:flutter/material.dart';
import 'package:k_sport_front/components/dashboard/schedule.dart';
import 'package:k_sport_front/components/dashboard/todays_workout.dart';
import 'package:k_sport_front/components/dashboard/weekly_activity.dart';
import 'package:k_sport_front/components/dashboard/welcome_banner.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const WelcomeBanner(),
            ScheduleComponent(
              onDayTapped: (int index) {},
            ),
            const SizedBox(height: 20),
            TodaysWorkout(),
            const SizedBox(height: 20),
            const WeeklyActivity(
              progress: [false, true, false, true, true, true, true],
            ),
          ],
        ),
      ),
    );
  }
}
