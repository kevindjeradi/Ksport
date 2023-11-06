import 'package:flutter/material.dart';
import 'package:k_sport_front/helpers/logger.dart';
import 'package:provider/provider.dart';
import 'package:k_sport_front/provider/user_provider.dart';

class WeeklyActivity extends StatefulWidget {
  const WeeklyActivity({super.key});

  @override
  WeeklyActivityState createState() => WeeklyActivityState();
}

class WeeklyActivityState extends State<WeeklyActivity> {
  List<bool> progress = [false, false, false, false, false, false, false];

  @override
  void initState() {
    super.initState();
    fetchProgress();
  }

  void fetchProgress() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final completedTrainings = userProvider.completedTrainings;

    // Assume the week starts on Monday
    final now = DateTime.now();
    final startOfWeek = DateTime(now.year, now.month, now.day)
        .subtract(Duration(days: now.weekday - 1));
    final endOfWeek = DateTime(now.year, now.month, now.day)
        .add(Duration(days: 6 - now.weekday + 1))
        .subtract(const Duration(minutes: 1));

    for (var training in completedTrainings!) {
      final dateCompleted = training.dateCompleted;
      Log.logger.i(
          "Date completed: $dateCompleted\nStart of week: $startOfWeek\nEnd of week: $endOfWeek");
      if (dateCompleted.isAfter(startOfWeek) &&
          dateCompleted.isBefore(endOfWeek)) {
        Log.logger.i("Training completed: $training");
        final dayOfWeek = dateCompleted.weekday - 1; // 0-indexed
        setState(() {
          progress[dayOfWeek] = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TextTheme textTheme = theme.textTheme;
    ColorScheme colorScheme = theme.colorScheme;

    return Column(
      children: [
        Text("Cette semaine", style: textTheme.headlineMedium),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  7,
                  (index) => Expanded(
                    child: Column(
                      children: [
                        Container(
                          width: 20,
                          height: 100,
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: progress[index]
                                ? colorScheme.primary
                                : Colors.grey.shade400,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          ['L', 'M', 'M', 'J', 'V', 'S', 'D'][index],
                          style: textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {},
                child: Text("Voir les détails >", style: textTheme.bodyMedium),
              )
            ],
          ),
        ),
      ],
    );
  }
}
