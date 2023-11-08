import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:k_sport_front/components/generic/custom_circle_avatar.dart';
import 'package:k_sport_front/components/generic/custom_snackbar.dart';
import 'package:k_sport_front/components/navigation/return_app_bar.dart';
import 'package:k_sport_front/provider/theme_color_scheme_provider.dart';
import 'package:k_sport_front/provider/user_provider.dart';
import 'package:k_sport_front/services/api.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  static final String baseUrl = dotenv.env['API_URL'] ?? 'http://10.0.2.2:3000';

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
                  child: GestureDetector(
                    onTap: () async {
                      var status = await Permission.photos.status;
                      if (status.isDenied) {
                        showCustomSnackBar(
                            context,
                            "Veuillez autoriser l'accès aux photos pour continuer",
                            SnackBarType.info);
                        status = await Permission.photos.request();
                      }
                      if (status.isGranted) {
                        // Use the image_picker to pick an image
                        final pickedFile = await ImagePicker()
                            .pickImage(source: ImageSource.gallery);
                        if (pickedFile != null) {
                          File image = File(pickedFile.path);

                          // Use the setUserProfileImage to upload the image
                          await Api()
                              .setUserProfileImage(image)
                              .then((response) {
                            // Assuming response contains the URL of the image
                            String newImageUrl = response['profileImage'];
                            String finalImageUrl = newImageUrl;

                            // Update the userProvider with the new image URL
                            userProvider.updateProfileImage(finalImageUrl);

                            // Show a success message
                            showCustomSnackBar(
                              context,
                              "Profile image updated successfully!",
                              SnackBarType.success,
                            );
                          }).catchError((error) {
                            // Show an error message
                            showCustomSnackBar(
                              context,
                              "Error updating profile image: $error",
                              SnackBarType.error,
                            );
                          });
                        }
                      } else if (status.isPermanentlyDenied) {
                        showCustomSnackBar(
                            context,
                            "Vous devez autoriser l’accès aux photos pour continuer",
                            SnackBarType.info);
                        openAppSettings();
                      }
                    },
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      clipBehavior: Clip.none,
                      children: [
                        CustomCircleAvatar(
                          radius: 80.0,
                          imagePath: userProvider.profileImage.isNotEmpty
                              ? '$baseUrl${userProvider.profileImage}'
                              : 'https://via.placeholder.com/150',
                        ),
                        Positioned(
                          bottom: -10,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 5.0),
                            decoration: BoxDecoration(
                              color:
                                  theme.colorScheme.surface.withOpacity(0.85),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Text(
                              'Pseudo: ${userProvider.username}',
                              style: theme.textTheme.headlineSmall?.copyWith(
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Icon(
                            Icons.camera_alt,
                            color: theme.colorScheme.primary,
                            size: 24.0,
                          ),
                        ),
                      ],
                    ),
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
