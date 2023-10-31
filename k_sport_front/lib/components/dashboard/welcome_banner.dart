import 'package:flutter/material.dart';
import 'package:k_sport_front/provider/user_provider.dart';
import 'package:provider/provider.dart';

class WelcomeBanner extends StatelessWidget {
  const WelcomeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: theme.colorScheme.secondaryContainer,
        elevation: 5,
        shadowColor: colorScheme.primary.withOpacity(0.5),
        margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundImage:
                        NetworkImage('https://via.placeholder.com/80'),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Hey ! Bonne journée ${userProvider.username}!',
                      style: theme.textTheme.headlineSmall
                          ?.copyWith(color: theme.colorScheme.onBackground),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                'Message de motivation à la con',
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: theme.colorScheme.onBackground),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
