import 'package:flutter/material.dart';
import 'package:k_sport_front/provider/auth_provider.dart';
import 'package:k_sport_front/provider/theme_color_scheme_provider.dart';
import 'package:k_sport_front/provider/user_provider.dart';
import 'package:k_sport_front/services/api.dart';
import 'package:k_sport_front/views/auth/login_page.dart';
import 'package:k_sport_front/views/home.dart';
import 'package:provider/provider.dart';

class AuthCheck extends StatefulWidget {
  const AuthCheck({Key? key}) : super(key: key);

  @override
  AuthCheckState createState() => AuthCheckState();
}

class AuthCheckState extends State<AuthCheck> {
  late Future<void> _checkAuth;

  @override
  void initState() {
    super.initState();
    _checkAuth =
        Provider.of<AuthProvider>(context, listen: false).checkAuthStatus();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _checkAuth,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final authProvider =
              Provider.of<AuthProvider>(context, listen: false);
          if (authProvider.isAuthenticated) {
            final userProvider =
                Provider.of<UserProvider>(context, listen: false);
            final themeProvider =
                Provider.of<ThemeColorSchemeProvider>(context, listen: false);
            return FutureBuilder(
              future: Api.populateUserProvider(userProvider),
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.done) {
                  themeProvider.setThemeByName(userProvider.theme);
                  return const Home();
                } else {
                  return const CircularProgressIndicator();
                }
              },
            );
          } else {
            return const LoginPage();
          }
        } else {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
