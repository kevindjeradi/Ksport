import 'package:flutter/material.dart';
import 'package:k_sport_front/components/generic/custom_loader.dart';
import 'package:k_sport_front/components/generic/custom_navigation.dart';
import 'package:k_sport_front/components/history/metric_card.dart';
import 'package:k_sport_front/components/history/muscle_group_repartition_pie.dart';
import 'package:k_sport_front/provider/user_provider.dart';
import 'package:k_sport_front/services/data_preparation.dart';
import 'package:k_sport_front/views/history_page.dart';
import 'package:provider/provider.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({Key? key}) : super(key: key);

  @override
  ProgressPageState createState() => ProgressPageState();
}

class ProgressPageState extends State<ProgressPage> {
  late final Future<Map<String, dynamic>> metricsFuture;
  late final Future<Map<String, int>> muscleGroupProportionsFuture;

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final dataPreparation = DataPreparation(userProvider);
    metricsFuture = dataPreparation.computeMetrics();
    muscleGroupProportionsFuture =
        dataPreparation.computeMuscleGroupProportions();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: SingleChildScrollView(
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
                FutureBuilder<Map<String, dynamic>>(
                  future: metricsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CustomLoader();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      final metrics = snapshot.data;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          children: [
                            IntrinsicHeight(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: MetricCard(
                                        title:
                                            'Nombre d\'entrainements depuis la création du compte',
                                        value: metrics!['totalTrainings']),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: MetricCard(
                                        title:
                                            'Poids manipulés depuis la création du compte',
                                        value: metrics['totalWeightLifted'],
                                        particle: 'kg'),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            IntrinsicHeight(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: MetricCard(
                                        title:
                                            'Nombre d\'entrainements moyen par semaine',
                                        value: metrics['meanTrainingsPerWeek']),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: MetricCard(
                                        title:
                                            'Nombre d\'entrainements ce mois',
                                        value: metrics['trainingsThisMonth']),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
                FutureBuilder<Map<String, int>>(
                  future: muscleGroupProportionsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CustomLoader();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      final muscleGroupProportions = snapshot.data;
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: MuscleGroupRepartitionPie(
                          muscleGroupProportions: muscleGroupProportions!,
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
