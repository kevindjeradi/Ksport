import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:k_sport_front/components/generic/custom_loader.dart';
import 'package:k_sport_front/components/generic/custom_navigation.dart';
import 'package:k_sport_front/components/history/metric_card.dart';
import 'package:k_sport_front/components/history/muscle_group_repartition_pie.dart';
import 'package:k_sport_front/components/history/trainings_bar_chart.dart';
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
  late final Future<Map<String, Map<String, int>>> muscleGroupProportionsFuture;
  late final Future<List<BarChartGroupData>> monthlyTrainingDataFuture;

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final dataPreparation = DataPreparation(userProvider);
    metricsFuture = dataPreparation.computeMetrics();
    muscleGroupProportionsFuture =
        dataPreparation.computeMuscleGroupProportions();
    monthlyTrainingDataFuture = dataPreparation.getMonthlyTrainingData();
  }

  Widget getMonthTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    Widget text;
    switch (value.toInt()) {
      case 1:
        text = const Text('Jan', style: style);
        break;
      case 2:
        text = const Text('Fev', style: style);
        break;
      case 3:
        text = const Text('Mar', style: style);
        break;
      case 4:
        text = const Text('Avr', style: style);
        break;
      case 5:
        text = const Text('Mai', style: style);
        break;
      case 6:
        text = const Text('Jun', style: style);
        break;
      case 7:
        text = const Text('Jui', style: style);
        break;
      case 8:
        text = const Text('Aou', style: style);
        break;
      case 9:
        text = const Text('Sep', style: style);
        break;
      case 10:
        text = const Text('Oct', style: style);
        break;
      case 11:
        text = const Text('Nov', style: style);
        break;
      case 12:
        text = const Text('Dec', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16,
      child: text,
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff7589a2),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    if (value == 0) {
      text = '0';
    } else if (value == 10) {
      text = '10';
    } else if (value == 20) {
      text = '20';
    } else if (value == 30) {
      text = '30';
    } else {
      return Container();
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 0,
      child: Text(text, style: style),
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
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
                          child: Text('Voir l\'historique de mes séances',
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
                                          value:
                                              metrics['meanTrainingsPerWeek']),
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
                                  indicatorColor:
                                      theme.colorScheme.onBackground,
                                ),
                                SizedBox(
                                  height: 200,
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
                      return TrainingsBarChart(
                          monthlyTrainingData: monthlyTrainingData!);
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
