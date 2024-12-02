import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class WeeklyTrainingsBarChart extends StatefulWidget {
  final List<BarChartGroupData> weeklyTrainingData;
  final Color textColor;

  const WeeklyTrainingsBarChart({
    Key? key,
    required this.weeklyTrainingData,
    required this.textColor,
  }) : super(key: key);

  @override
  State<WeeklyTrainingsBarChart> createState() =>
      _WeeklyTrainingsBarChartState();
}

class _WeeklyTrainingsBarChartState extends State<WeeklyTrainingsBarChart> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget getWeekTitles(double value, TitleMeta meta) {
    final weekNumber = value.toInt() + 1;
    final style = TextStyle(
      color: widget.textColor,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    final text = Text('S $weekNumber', style: style);

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16,
      child: text,
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    final style = TextStyle(
      color: widget.textColor,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    if (value == 0) {
      text = '0';
    } else if (value == 2) {
      text = value.toInt().toString();
    } else if (value == 4) {
      text = value.toInt().toString();
    } else if (value == 6) {
      text = value.toInt().toString();
    } else {
      value.toInt() % 2 == 0 ? text = value.toInt().toString() : text = '';
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
    double chartWidth =
        widget.weeklyTrainingData.length * 60.0; // Adjust based on your needs

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Evolution du nombre de séances par semaine",
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge,
              ),
            ),
            const SizedBox(height: 16),
            widget.weeklyTrainingData.isEmpty
                ? SizedBox(
                    height: 200,
                    child: Center(
                        child: Text("Bon il s'agirait d'arrêter de forcer",
                            style: theme.textTheme.headlineMedium)),
                  )
                : SingleChildScrollView(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: chartWidth,
                      child: SizedBox(
                        height: 200,
                        child: BarChart(
                          BarChartData(
                            barTouchData: BarTouchData(
                              enabled: true,
                              touchTooltipData: BarTouchTooltipData(
                                tooltipRoundedRadius: 10,
                                tooltipPadding: const EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 8),
                                tooltipBgColor: theme.colorScheme.onBackground,
                                tooltipHorizontalAlignment:
                                    FLHorizontalAlignment.center,
                                tooltipMargin: -60,
                                getTooltipItem: (
                                  BarChartGroupData group,
                                  int groupIndex,
                                  BarChartRodData rod,
                                  int rodIndex,
                                ) {
                                  return BarTooltipItem(
                                    '${rod.toY.toInt()}',
                                    TextStyle(
                                      color: theme.colorScheme.background,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                },
                              ),
                            ),
                            titlesData: FlTitlesData(
                              show: true,
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 38,
                                  getTitlesWidget: getWeekTitles,
                                ),
                              ),
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 28,
                                  interval: 1,
                                  getTitlesWidget: leftTitles,
                                ),
                              ),
                              topTitles: const AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: false,
                                ),
                              ),
                              rightTitles: const AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: false,
                                ),
                              ),
                            ),
                            borderData: FlBorderData(
                              show: false,
                            ),
                            barGroups: widget.weeklyTrainingData,
                            gridData: const FlGridData(show: false),
                          ),
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
