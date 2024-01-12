import 'package:flutter/material.dart';
import 'package:k_sport_front/components/navigation/bottom_nav_bar.dart';
import 'package:k_sport_front/components/navigation/bottom_nav_bar_v2.dart';
import 'package:k_sport_front/components/navigation/top_app_bar.dart';
import 'package:k_sport_front/views/profile_page.dart';
import 'package:k_sport_front/views/progress_page.dart';
import 'package:k_sport_front/views/dashboard.dart';
import 'package:k_sport_front/views/trainings_list_page.dart';
import 'package:k_sport_front/views/workout_page/muscles_page.dart';

class Home2 extends StatefulWidget {
  const Home2({super.key});

  @override
  Home2State createState() => Home2State();
}

class Home2State extends State<Home2> {
  int _currentIndex = 2;
  PageController _pageController = PageController();

  final List<Widget> _pages = [
    const TrainingsListPage(),
    const MusclesPage(),
    const Dashboard(),
    const ProgressPage(),
    const ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);

    // Listen to page changes to update currentIndex
    _pageController.addListener(() {
      setState(() {
        _currentIndex = _pageController.page!.round();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          children: _pages,
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar2(
        currentIndex: _currentIndex,
        onTap: (index) {
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
