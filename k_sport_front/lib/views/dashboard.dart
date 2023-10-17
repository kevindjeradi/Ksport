import 'package:flutter/material.dart';
import 'package:k_sport_front/components/weekly_activity.dart';
import '../components/schedule.dart';
import '../components/todays_workout.dart';
import '../components/welcome_banner.dart';
import '../components/bottom_nav_bar.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  DashboardState createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Image.network('https://via.placeholder.com/100x30',
            fit: BoxFit.cover, height: 30), // placeholder logo
        leading: IconButton(
          icon: const Icon(Icons.account_circle),
          onPressed: () {
            // Handle profile interactions
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Search functionality
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Handle notifications
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
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
      ),
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }
}
