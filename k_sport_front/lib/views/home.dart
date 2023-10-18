import 'package:flutter/material.dart';
import 'package:k_sport_front/components/navigation/bottom_nav_bar.dart';
import 'package:k_sport_front/components/navigation/top_app_bar.dart';
import 'package:k_sport_front/views/progress_page.dart';
import 'package:k_sport_front/views/routine_creator_page.dart';
import 'package:k_sport_front/views/workouts_page.dart';
import 'package:k_sport_front/views/dashboard.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const Dashboard(),
    const WorkoutsPage(),
    const RoutineCreatorPage(),
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
