import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:k_sport_front/components/generic/custom_circle_avatar.dart';
import 'package:k_sport_front/helpers/TextGenerator.dart';
import 'package:k_sport_front/provider/user_provider.dart';
import 'package:provider/provider.dart';

class WelcomeBanner extends StatelessWidget {
  const WelcomeBanner({super.key});
  static final String baseUrl = dotenv.env['API_URL'] ?? 'http://10.0.2.2:3000';

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
                  CustomCircleAvatar(
                    radius: 40,
                    imagePath: userProvider.profileImage != ""
                        ? baseUrl + userProvider.profileImage
                        : 'https://via.placeholder.com/100',
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      '${TextGenerator.randomGreeting()} ${userProvider.username} !',
                      style: theme.textTheme.headlineSmall
                          ?.copyWith(color: theme.colorScheme.onBackground),
                      overflow: TextOverflow.visible,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                TextGenerator.randomMotivationalText(),
                style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onBackground,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
