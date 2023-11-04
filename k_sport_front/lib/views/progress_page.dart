import 'package:flutter/material.dart';
import 'package:k_sport_front/components/generic/custom_navigation.dart';
import 'package:k_sport_front/views/history_page.dart';

class ProgressPage extends StatelessWidget {
  const ProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Mes Progrès",
                  style: theme.textTheme.displaySmall,
                ),
              ),
              InkWell(
                onTap: () {
                  CustomNavigation.push(context, const HistoryPage());
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    color: theme.colorScheme.surface,
                    elevation: 5.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(
                          color: theme.colorScheme.onSurface, width: 1.0),
                    ),
                    child: ListTile(
                      leading: Icon(Icons.history,
                          size: 40, color: theme.colorScheme.onSurface),
                      title: Center(
                        child: Text('Historique de mes séances',
                            style: theme.textTheme.headlineMedium),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
