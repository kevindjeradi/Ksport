import 'package:flutter/material.dart';
import 'package:k_sport_front/components/dashboard/schedule.dart';
import 'package:k_sport_front/components/dashboard/todays_workout.dart';
import 'package:k_sport_front/components/dashboard/weekly_activity.dart';
import 'package:k_sport_front/components/dashboard/welcome_banner.dart';
import 'package:k_sport_front/models/training.dart';
import 'package:http/http.dart' as http;
import 'package:k_sport_front/services/api.dart';

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
              onTrainingAssigned: (int dayIndex, Training? training) async {
                if (training != null) {
                  final response = await Api.post(
                    'http://10.0.2.2:3000/user/updateTrainingForDay',
                    {"day": dayIndex, "trainingId": training.id},
                  );

                  if (response.statusCode == 200) {
                    print('Training updated successfully');
                  } else {
                    print('Error updating training: ${response.body}');
                  }
                } else {
                  final response = await http.delete(
                    Uri.parse(
                        'http://10.0.2.2:3000/user/deleteTrainingForDay/$dayIndex'),
                  );

                  if (response.statusCode == 200) {
                    print('Training deleted successfully');
                  } else {
                    print('Error deleting training');
                  }
                }
              },
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
