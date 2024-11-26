import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:k_sport_front/components/dashboard/schedule.dart';
import 'package:k_sport_front/components/dashboard/todays_workout.dart';
import 'package:k_sport_front/components/dashboard/weekly_activity.dart';
import 'package:k_sport_front/components/dashboard/welcome_banner.dart';
import 'package:k_sport_front/components/generic/custom_loader.dart';
import 'package:k_sport_front/components/generic/custom_navigation.dart';
import 'package:k_sport_front/components/navigation/top_app_bar.dart';
import 'package:k_sport_front/helpers/logger.dart';
import 'package:k_sport_front/models/training.dart';
import 'package:k_sport_front/provider/schedule_training_provider.dart';
import 'package:k_sport_front/services/api.dart';
import 'package:k_sport_front/views/cardio/cardio_page.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {
  static final String baseUrl = dotenv.env['API_URL'] ??
      'http://10.0.2.2:3000'; // Default URL if .env is not loaded
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const CustomAppBar(
        title: "Accueil",
        position: 'left',
      ),
      backgroundColor: theme.colorScheme.background,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const WelcomeBanner(),
                const SizedBox(height: 20),
                ScheduleComponent(
                  onDayTapped: (int index) {},
                  onTrainingAssigned: (int dayIndex, Training? training) async {
                    setState(() {
                      loading = true;
                    });
                    final trainingProvider =
                        Provider.of<ScheduleTrainingProvider>(context,
                            listen: false);
                    Log.logger.i(
                        "on training assigned : dayIndex: $dayIndex\ntraining: $training");
                    trainingProvider.updateTrainingForDay(
                        dayIndex - 1, training);
                    if (training != null) {
                      final response = await Api().post(
                        '$baseUrl/user/updateTrainingForDay',
                        {"day": dayIndex, "trainingId": training.id},
                      );

                      if (response.statusCode == 200) {
                        Log.logger.i('Training updated successfully');
                      } else {
                        Log.logger
                            .e('Error updating training: ${response.body}');
                      }
                      await Future.delayed(const Duration(seconds: 1));
                      setState(() {
                        loading = false;
                      });
                    }
                  },
                ),
                const SizedBox(height: 20),
                loading ? const CustomLoader() : const TodaysWorkout(),
                const SizedBox(height: 20),
                const WeeklyActivity(),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    color: theme.colorScheme.surface,
                    child: InkWell(
                      onTap: () {
                        CustomNavigation.push(context, const CardioPage());
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.directions_run,
                                size: 40, color: theme.colorScheme.primary),
                            const SizedBox(width: 16),
                            Text(
                              'Séance Cardio',
                              style: theme.textTheme.headlineMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
