// login_page.dart
import 'package:flutter/material.dart';
import 'package:k_sport_front/components/generic/custom_image.dart';
import 'package:k_sport_front/components/generic/custom_loader.dart';
import 'package:k_sport_front/components/generic/custom_navigation.dart';
import 'package:k_sport_front/components/generic/custom_snackbar.dart';
import 'package:k_sport_front/provider/theme_color_scheme_provider.dart';
import 'package:k_sport_front/provider/user_provider.dart';
import 'package:k_sport_front/services/api.dart';
import 'package:k_sport_front/services/token_service.dart';
import 'package:k_sport_front/services/user_service.dart';
import 'package:k_sport_front/views/auth/register_page.dart';
import 'package:k_sport_front/views/home.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final FocusNode _usernameFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  bool _passwordVisible = false;
  bool showError = false;
  bool _loading = false;
  final validationNotifier = ValueNotifier<bool>(false);
  final _userService = UserService();

  void _validateFields() {
    setState(() {
      showError = _passwordController.text.isEmpty ||
          _usernameController.text.isEmpty ||
          _passwordController.text.length < 4 ||
          _usernameController.text.length < 4;
    });

    validationNotifier.value = _usernameController.text.isNotEmpty &&
        _usernameController.text.length >= 4 &&
        _passwordController.text.isNotEmpty &&
        _passwordController.text.length >= 4;
  }

  @override
  void initState() {
    super.initState();
    _usernameController.addListener(_validateFields);
    _passwordController.addListener(_validateFields);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _usernameFocus.dispose();
    _passwordFocus.dispose();
    validationNotifier.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_passwordController.text.isEmpty) {
      setState(() {
        showError = true;
      });
      return;
    }
    try {
      _loading = true;
      final response = await _userService.login(
          _usernameController.text, _passwordController.text);
      _loading = false;
      if (response.containsKey('token')) {
        // saving token
        await TokenService().saveToken(response['token']);
        if (mounted) {
          // Fetch user details
          final userProvider =
              Provider.of<UserProvider>(context, listen: false);
          final themeProvider =
              Provider.of<ThemeColorSchemeProvider>(context, listen: false);
          await Api.populateUserProvider(userProvider);
          themeProvider.setThemeByName(userProvider.theme);
        }
        if (mounted) {
          CustomNavigation.pushReplacement(context, const Home());
          showCustomSnackBar(
              context, 'Connecté avec succès', SnackBarType.success);
        }
      } else {
        // Show error message
        if (mounted) {
          showCustomSnackBar(
              context, 'Impossible de se connecter', SnackBarType.error);
        }
      }
    } catch (error) {
      // Show error message
      if (mounted) {
        showCustomSnackBar(
            context, 'Une erreur est survenue -> $error', SnackBarType.error);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      children: [
        if (_loading) const Center(child: CustomLoader()),
        Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          body: Center(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    CustomImage(
                        imagePath: 'assets/icon/logo.png',
                        width: MediaQuery.of(context).size.width * 0.6),
                    const SizedBox(height: 32),
                    Text(
                      'Connexion',
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    const SizedBox(height: 32),
                    TextField(
                      controller: _usernameController,
                      focusNode: _usernameFocus,
                      onSubmitted: (_) => _passwordFocus.requestFocus(),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person),
                        prefixIconColor: theme.colorScheme.onBackground,
                        labelText: 'Pseudo',
                        labelStyle:
                            TextStyle(color: theme.colorScheme.onBackground),
                        errorText: showError &&
                                _usernameController.text.length < 4 &&
                                _usernameController.text.isNotEmpty
                            ? 'Le pseudo doit faire au moins 4 lettres'
                            : null,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _passwordController,
                      focusNode: _passwordFocus,
                      onSubmitted: (_) {
                        if (validationNotifier.value) {
                          _login();
                        }
                      },
                      obscureText: !_passwordVisible,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock),
                        suffixIconColor: theme.colorScheme.onBackground,
                        prefixIconColor: theme.colorScheme.onBackground,
                        labelText: 'Mot de passe',
                        labelStyle:
                            TextStyle(color: theme.colorScheme.onBackground),
                        errorText: showError &&
                                _passwordController.text.length < 4 &&
                                _passwordController.text.isNotEmpty
                            ? 'Le mot de passe doit faire au moins 4 lettres'
                            : null,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ValueListenableBuilder<bool>(
                      valueListenable: validationNotifier,
                      builder: (context, isValid, child) {
                        return ElevatedButton(
                          onPressed: isValid ? () => _login() : null,
                          child: const Text('Se connecter'),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation1, animation2) =>
                                const RegisterPage(),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              const begin = Offset(1.0, 0.0);
                              const end = Offset.zero;
                              const curve = Curves.easeInOut;
                              var tween = Tween(begin: begin, end: end)
                                  .chain(CurveTween(curve: curve));
                              var offsetAnimation = animation.drive(tween);
                              return SlideTransition(
                                  position: offsetAnimation, child: child);
                            },
                          ),
                        );
                      },
                      child: Text("S'inscrire",
                          style:
                              TextStyle(color: theme.colorScheme.onBackground)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
