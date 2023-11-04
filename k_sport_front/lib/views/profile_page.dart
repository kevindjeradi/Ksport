import 'package:flutter/material.dart';
import 'package:k_sport_front/components/generic/custom_snackbar.dart';
import 'package:k_sport_front/components/navigation/return_app_bar.dart';
import 'package:k_sport_front/provider/theme_color_scheme_provider.dart';
import 'package:k_sport_front/provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProvider = Provider.of<ThemeColorSchemeProvider>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: ReturnAppBar(
        barTitle: "Profil",
        bgColor: theme.colorScheme.primary,
        color: theme.colorScheme.onPrimary,
        elevation: 0,
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20.0),
                Center(
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      const CircleAvatar(
                        radius: 80.0,
                        backgroundImage:
                            NetworkImage('https://via.placeholder.com/100'),
                        backgroundColor: Colors.transparent,
                      ),
                      Positioned(
                        bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 5.0),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surface.withOpacity(0.85),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Text(
                            'Pseudo: ${userProvider.username}',
                            style: theme.textTheme.headlineSmall
                                ?.copyWith(color: theme.colorScheme.onSurface),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40.0),
                Card(
                  elevation: 2.0,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Compte crée le : ${DateFormat('dd/MM/yyyy').format(userProvider.dateJoined)}',
                            style: theme.textTheme.bodyLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10.0),
                          Text(
                            "${userProvider.numberOfTrainings} entrainements dans ma liste",
                            style: theme.textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                Card(
                  elevation:
                      4.0, // Slightly increased elevation for better shadow
                  margin: const EdgeInsets.all(10.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        15), // Rounded corners for the card
                  ), // Added margin for spacing
                  child: Padding(
                    padding: const EdgeInsets.all(
                        16.0), // Increased padding for more space
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.settings,
                                color: theme.colorScheme.primary, size: 30),
                            const SizedBox(width: 10),
                            Text(
                              'Paramètres du compte',
                              style: theme.textTheme.titleLarge?.copyWith(
                                color: theme.colorScheme.onBackground,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 30.0, thickness: 2.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Thème de l'application:",
                              style: theme.textTheme.titleMedium,
                            ),
                            DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: themeProvider.currentThemeName,
                                icon:
                                    const Icon(Icons.arrow_drop_down_outlined),
                                elevation: 16,
                                style: TextStyle(
                                        color: theme.colorScheme.onBackground)
                                    .copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                                onChanged: (String? newValue) {
                                  themeProvider
                                      .updateTheme(newValue!)
                                      .then((_) {
                                    showCustomSnackBar(
                                        context,
                                        "Thème changé avec succès!",
                                        SnackBarType.success);
                                  }).catchError((error) {
                                    showCustomSnackBar(
                                        context,
                                        "Erreur lors du changement de thème: $error",
                                        SnackBarType.error);
                                  });
                                },
                                items: themeProvider.availableThemes
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
