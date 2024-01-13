// exercise_history.dart
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:k_sport_front/components/history/bar_charts/custom_bar_chart.dart';
import 'package:k_sport_front/components/history/line_charts/exercise_line_chart.dart';
import 'package:k_sport_front/components/navigation/return_app_bar.dart';
import 'package:k_sport_front/provider/user_provider.dart';
import 'package:provider/provider.dart';

class ExerciseHistory extends StatelessWidget {
  final String exerciseLabel;

  const ExerciseHistory({Key? key, required this.exerciseLabel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userProvider = Provider.of<UserProvider>(context);
    final completedTrainings = userProvider.completedTrainings ?? [];

    // Lists for storing aggregated data for charts
    List<int> totalWeightsList = [];
    List<int> totalRepsList = [];
    List<int> totalRestTimesList = [];

    // Aggregate data from exercises
    for (var completedTraining in completedTrainings) {
      final exercises = completedTraining.exercises
          .where((exercise) => exercise.label == exerciseLabel)
          .toList();

      if (exercises.isNotEmpty) {
        int totalWeight = 0;
        int totalReps = 0;
        int totalRestTime = 0;

        for (var exercise in exercises) {
          totalWeight += exercise.weight.fold(0, (sum, item) => sum + item);
          totalReps += exercise.repetitions.fold(0, (sum, item) => sum + item);
          totalRestTime += exercise.restTime.fold(0, (sum, item) => sum + item);
        }

        // Add to the lists
        totalWeightsList.add(totalWeight);
        totalRepsList.add(totalReps);
        totalRestTimesList.add(totalRestTime);
      }
    }

    // Prepare bar chart data for each chart
    List<BarChartGroupData> weightBarData = _prepareBarData(totalWeightsList);
    List<BarChartGroupData> setsBarData = _prepareBarData(totalRepsList);
    List<BarChartGroupData> restTimeBarData =
        _prepareBarData(totalRestTimesList);

    return Scaffold(
      appBar: ReturnAppBar(barTitle: "Datas sur $exerciseLabel"),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            CustomBarChart(
              barData: weightBarData,
              chartTitle: 'Evolution du poids soulevé',
              textColor: theme.colorScheme.onBackground,
            ),
            ExerciseLineChart(
              dataList: totalWeightsList,
              chartTitle: 'Evolution du poids soulevé',
              textColor: theme.colorScheme.onBackground,
            ),
            CustomBarChart(
              barData: setsBarData,
              chartTitle: 'Evolution du nombre de repetitions',
              textColor: theme.colorScheme.onBackground,
            ),
            ExerciseLineChart(
              dataList: totalRepsList,
              chartTitle: 'Evolution du nombre de repetitions',
              textColor: theme.colorScheme.onBackground,
            ),
            CustomBarChart(
              barData: restTimeBarData,
              chartTitle: 'Evolution du temps de repos',
              textColor: theme.colorScheme.onBackground,
            ),
            ExerciseLineChart(
              dataList: totalRestTimesList,
              chartTitle: 'Evolution du temps de repos',
              textColor: theme.colorScheme.onBackground,
            ),
          ],
        ),
      ),
    );
  }

  List<BarChartGroupData> _prepareBarData(List<int> dataList) {
    return dataList.asMap().entries.map((entry) {
      return BarChartGroupData(
        x: entry.key,
        barRods: [
          BarChartRodData(
            toY: entry.value.toDouble(),
            color: Colors.blue,
          ),
        ],
        showingTooltipIndicators: [0],
      );
    }).toList();
  }
}
