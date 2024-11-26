import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:k_sport_front/components/generic/custom_loader.dart';
import 'package:k_sport_front/components/generic/custom_navigation.dart';
import 'package:k_sport_front/components/history/bar_charts/monthly_trainings_bar_chart.dart';
import 'package:k_sport_front/components/history/bar_charts/weekly_trainings_bar_chart.dart';
import 'package:k_sport_front/components/history/metric_card.dart';
import 'package:k_sport_front/components/history/pies/muscle_group_repartition_pie.dart';
import 'package:k_sport_front/components/navigation/top_app_bar.dart';
import 'package:k_sport_front/provider/user_provider.dart';
import 'package:k_sport_front/services/data_preparation.dart';
import 'package:k_sport_front/views/cardio/cardio_history_page.dart';
import 'package:k_sport_front/views/history/history_page.dart';
import 'package:provider/provider.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({Key? key}) : super(key: key);

  @override
  ProgressPageState createState() => ProgressPageState();
}

class ProgressPageState extends State<ProgressPage> {
  late final Future<Map<String, dynamic>> metricsFuture;
  late final Future<Map<String, Map<String, int>>> muscleGroupProportionsFuture;
  late final Future<List<BarChartGroupData>> monthlyTrainingDataFuture;
  late final Future<List<BarChartGroupData>> weeklyTrainingDataFuture;

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final dataPreparation = DataPreparation(userProvider);
    metricsFuture = dataPreparation.computeMetrics();
    muscleGroupProportionsFuture =
        dataPreparation.computeMuscleGroupProportions();
    monthlyTrainingDataFuture = dataPreparation.getMonthlyTrainingData();
    weeklyTrainingDataFuture = dataPreparation.getWeeklyTrainingData();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: const CustomAppBar(
        title: "Mes progrès",
        position: 'left',
      ),
      backgroundColor: theme.colorScheme.background,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Center(
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  CustomNavigation.push(context, const HistoryPage());
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 14.0, horizontal: 16.0),
                  child: Card(
                    color: theme.colorScheme.surface,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: ListTile(
                      leading: Icon(Icons.history,
                          size: 40, color: theme.colorScheme.onSurface),
                      title: Center(
                        child: Text('Voir l\'historique de mes séances',
                            style: theme.textTheme.headlineMedium),
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  CustomNavigation.push(context, const CardioHistoryPage());
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 14.0, horizontal: 16.0),
                  child: Card(
                    color: theme.colorScheme.surface,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: ListTile(
                      leading: Icon(Icons.directions_run,
                          size: 40, color: theme.colorScheme.onSurface),
                      title: Center(
                        child: Text('Voir l\'historique de mes séances cardio',
                            style: theme.textTheme.headlineMedium),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: FutureBuilder<Map<String, dynamic>>(
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
              ),
              FutureBuilder<Map<String, Map<String, int>>>(
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
                      child: Card(
                        child: DefaultTabController(
                          length: 3,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  "Répartition des groupes musculaires travaillés",
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.titleLarge,
                                ),
                              ),
                              TabBar(
                                tabs: const [
                                  Tab(text: 'Mois en cours'),
                                  Tab(text: 'Trimestre'),
                                  Tab(text: 'Tout le temps'),
                                ],
                                labelColor: theme.colorScheme.onBackground,
                                indicatorColor: theme.colorScheme.onBackground,
                              ),
                              SizedBox(
                                height: 210,
                                child: TabBarView(
                                  children: [
                                    MuscleGroupRepartitionPie(
                                      muscleGroupProportions:
                                          muscleGroupProportions![
                                              'currentMonth']!,
                                    ),
                                    MuscleGroupRepartitionPie(
                                      muscleGroupProportions:
                                          muscleGroupProportions[
                                              'lastThreeMonths']!,
                                    ),
                                    MuscleGroupRepartitionPie(
                                      muscleGroupProportions:
                                          muscleGroupProportions['allTime']!,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
              FutureBuilder<List<BarChartGroupData>>(
                future: monthlyTrainingDataFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    final monthlyTrainingData = snapshot.data;
                    return MonthlyTrainingsBarChart(
                        textColor: theme.colorScheme.onBackground,
                        monthlyTrainingData: monthlyTrainingData!);
                  }
                },
              ),
              FutureBuilder<List<BarChartGroupData>>(
                future: weeklyTrainingDataFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    final weeklyTrainingData = snapshot.data;
                    return WeeklyTrainingsBarChart(
                        textColor: theme.colorScheme.onBackground,
                        weeklyTrainingData: weeklyTrainingData!);
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
