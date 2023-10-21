import 'package:flutter/material.dart';
import 'package:k_sport_front/components/navigation/bottom_nav_bar.dart';
import 'package:k_sport_front/components/navigation/top_app_bar.dart';
import 'package:k_sport_front/views/progress_page.dart';
import 'package:k_sport_front/views/trainings_page.dart';
import 'package:k_sport_front/views/dashboard.dart';
import 'package:k_sport_front/views/workout_page/muscles_page.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const Dashboard(),
    const MusclesPage(),
    const TrainingsPage(),
    const ProgressPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
