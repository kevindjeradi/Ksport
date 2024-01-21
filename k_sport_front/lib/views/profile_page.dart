import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:k_sport_front/components/generic/custom_circle_avatar.dart';
import 'package:k_sport_front/components/generic/custom_navigation.dart';
import 'package:k_sport_front/components/generic/custom_snackbar.dart';
import 'package:k_sport_front/components/navigation/top_app_bar.dart';
import 'package:k_sport_front/provider/auth_provider.dart';
import 'package:k_sport_front/provider/theme_color_scheme_provider.dart';
import 'package:k_sport_front/provider/user_provider.dart';
import 'package:k_sport_front/services/api.dart';
import 'package:k_sport_front/services/user_service.dart';
import 'package:k_sport_front/views/auth/login_page.dart';
import 'package:k_sport_front/views/social/add_friend.dart';
import 'package:k_sport_front/views/social/friends_list.dart';
import 'package:k_sport_front/views/social/scan_qr.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  static final String baseUrl = dotenv.env['API_URL'] ?? 'http://10.0.2.2:3000';
  final UserService _userService = UserService();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProvider = Provider.of<ThemeColorSchemeProvider>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: const CustomAppBar(
        title: "Mon profil",
        position: 'left',
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: GestureDetector(
                    onTap: () async {
                      var status = await Permission.photos.status;
                      if (status.isDenied) {
                        if (mounted) {
                          showCustomSnackBar(
                              context,
                              "Veuillez autoriser l'accès aux photos pour continuer",
                              SnackBarType.info);
                        }
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
                        if (mounted) {
                          showCustomSnackBar(
                              context,
                              "Vous devez autoriser l'accès aux photos pour continuer",
                              SnackBarType.info);
                        }
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
                const SizedBox(height: 24.0),
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
                const SizedBox(height: 24.0),
                Card(
                  elevation: 2.0,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Wrap(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  CustomNavigation.push(
                                      context, const FriendsList());
                                },
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.people_alt),
                                    SizedBox(width: 10),
                                    Text("Voir mes amis"),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          if (userProvider.uniqueIdentifier.isNotEmpty)
                            Column(
                              children: [
                                Text(
                                  "Partager mon compte",
                                  style: theme.textTheme.titleLarge,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.6,
                                          padding: const EdgeInsets.all(20),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Text(
                                                "Partager mon code ami",
                                                style: theme
                                                    .textTheme.displayMedium,
                                              ),
                                              QrImageView(
                                                data: userProvider
                                                    .uniqueIdentifier,
                                                version: QrVersions.auto,
                                                size: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.8,
                                                gapless: false,
                                                dataModuleStyle:
                                                    QrDataModuleStyle(
                                                        color: theme.colorScheme
                                                            .onBackground),
                                                eyeStyle: QrEyeStyle(
                                                    color: theme.colorScheme
                                                        .onBackground),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: QrImageView(
                                    data: userProvider.uniqueIdentifier,
                                    version: QrVersions.auto,
                                    size: 100.0,
                                    gapless: false,
                                    dataModuleStyle: QrDataModuleStyle(
                                        color: theme.colorScheme.onBackground),
                                    eyeStyle: QrEyeStyle(
                                        color: theme.colorScheme.onBackground),
                                  ),
                                )
                              ],
                            ),
                          const SizedBox(height: 10),
                          Wrap(
                            children: [
                              ElevatedButton(
                                onPressed: () => _navigateAndScanQR(context),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.person_add_alt_1),
                                    SizedBox(width: 10),
                                    Text("Scanner un QR ami"),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12.0),
                Card(
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
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
                            Flexible(
                              child: Text(
                                "Thème de l'application:",
                                style: theme.textTheme.titleMedium,
                              ),
                            ),
                            const SizedBox(width: 10),
                            DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: themeProvider.currentThemeName,
                                icon: const Icon(Icons.arrow_drop_down_outlined,
                                    size: 24),
                                elevation: 8,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: theme.colorScheme.onBackground,
                                  fontWeight: FontWeight.bold,
                                ),
                                dropdownColor: theme.colorScheme.surface,
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
                                    child: Text(
                                      value,
                                      style: TextStyle(
                                          color:
                                              theme.colorScheme.onBackground),
                                    ),
                                  );
                                }).toList(),
                                borderRadius: BorderRadius.circular(15),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Wrap(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        final authProvider =
                            Provider.of<AuthProvider>(context, listen: false);
                        await authProvider.logout();
                        if (mounted) {
                          CustomNavigation.pushReplacement(
                              context, const LoginPage());
                        }
                      },
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.logout),
                          SizedBox(width: 10),
                          Text("Se déconnecter"),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }

  void _navigateAndScanQR(BuildContext context) async {
    final scannedData = await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const ScanQR()),
    );

    if (scannedData != null) {
      final result = await _userService.userExists(scannedData);

      if (result['exists']) {
        if (mounted) {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return AddFriend(
                scannedUserId: scannedData,
                username: result['username'],
                profileImage: result['profileImage'],
              );
            },
          );
        }
      } else {
        if (mounted) {
          showCustomSnackBar(
              context, "Utilisateur introuvable", SnackBarType.error);
        }
      }
    }
  }
}
