// profile_page.dart
import 'package:flutter/material.dart';
import 'package:k_sport_front/components/navigation/return_app_bar.dart';
import 'package:k_sport_front/provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: ReturnAppBar(
          barTitle: "Profil",
          bgColor: theme.colorScheme.primary,
          color: theme.colorScheme.onPrimary,
          elevation: 0),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: CircleAvatar(
                    radius: 50.0,
                    backgroundImage:
                        NetworkImage('https://via.placeholder.com/100'),
                    backgroundColor: Colors.transparent,
                  ),
                ),
                const SizedBox(height: 20.0),
                Center(
                  child: Text(
                    'Pseudo: ${userProvider.username}',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
                const SizedBox(height: 20.0),
                Text(
                  'Date de création du compte: ${DateFormat('dd/MM/yyyy').format(userProvider.dateJoined)}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 20.0),
                Text(
                  "Nombre d'entraînements dans ma liste: ${userProvider.numberOfTrainings}",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const Divider(height: 30.0),
              ],
            ),
          );
        },
      ),
    );
  }
}
