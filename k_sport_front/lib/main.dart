// main.dart
import 'package:flutter/material.dart';
import 'package:k_sport_front/provider/auth_notifier.dart';
import 'package:k_sport_front/provider/schedule_training_provider.dart';
import 'package:k_sport_front/provider/user_provider.dart';
import 'package:k_sport_front/theme/theme_light.dart';
import 'package:k_sport_front/views/auth/login_page.dart';
import 'package:k_sport_front/views/auth/register_page.dart';
import 'package:k_sport_front/views/home.dart';
import 'package:provider/provider.dart';

void main() => runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => AuthNotifier()),
          ChangeNotifierProvider(create: (context) => UserProvider()),
          ChangeNotifierProvider(
              create: (context) => ScheduleTrainingProvider()),
        ],
        child: const MyApp(),
      ),
    );

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'K Sports',
      theme: themeLight(),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => Consumer<AuthNotifier>(
              builder: (context, auth, child) {
                if (auth.isAuthenticated) {
                  return const Home();
                } else {
                  return const LoginPage();
                }
              },
            ),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => const Home(),
      },
    );
  }
}
