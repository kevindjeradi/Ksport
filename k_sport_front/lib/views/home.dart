import 'package:flutter/material.dart';
import 'package:k_sport_front/views/progress_page.dart';
import 'package:k_sport_front/views/routine_creator_page.dart';
import 'package:k_sport_front/views/workouts_page.dart';
import 'package:k_sport_front/views/dashboard.dart';
import '../components/bottom_nav_bar.dart';

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
