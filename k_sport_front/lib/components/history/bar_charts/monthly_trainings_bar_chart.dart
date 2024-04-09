import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MonthlyTrainingsBarChart extends StatefulWidget {
  final List<BarChartGroupData> monthlyTrainingData;
  final Color textColor;

  const MonthlyTrainingsBarChart({
    super.key,
    required this.monthlyTrainingData,
    required this.textColor,
  });

  @override
  State<MonthlyTrainingsBarChart> createState() =>
      _MonthlyTrainingsBarChartState();
}

class _MonthlyTrainingsBarChartState extends State<MonthlyTrainingsBarChart> {
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

  Widget getMonthTitles(double value, TitleMeta meta) {
    final style = TextStyle(
      color: widget.textColor,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    Widget text;
    switch (value.toInt()) {
      case 1:
        text = Text('Jan', style: style);
        break;
      case 2:
        text = Text('Fev', style: style);
        break;
      case 3:
        text = Text('Mar', style: style);
        break;
      case 4:
        text = Text('Avr', style: style);
        break;
      case 5:
        text = Text('Mai', style: style);
        break;
      case 6:
        text = Text('Jun', style: style);
        break;
      case 7:
        text = Text('Jui', style: style);
        break;
      case 8:
        text = Text('Aou', style: style);
        break;
      case 9:
        text = Text('Sep', style: style);
        break;
      case 10:
        text = Text('Oct', style: style);
        break;
      case 11:
        text = Text('Nov', style: style);
        break;
      case 12:
        text = Text('Dec', style: style);
        break;
      default:
        text = Text('', style: style);
        break;
    }
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
      text = ' 0';
    } else if (value == 10) {
      text = ' 10';
    } else if (value == 15) {
      text = ' 15';
    } else if (value == 20) {
      text = '20';
    } else {
      value.toInt() % 5 == 0 ? text = value.toInt().toString() : text = '';
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
    double chartWidth = widget.monthlyTrainingData.length *
        60.0; // Adjust the multiplier as needed

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Evolution du nombre de séances par mois",
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge,
              ),
            ),
            const SizedBox(height: 16),
            widget.monthlyTrainingData.isEmpty
                ? SizedBox(
                    height: 200,
                    child: Center(
                        child: Text("Faut s'entraîner on t'a dit",
                            style: theme.textTheme.headlineMedium)),
                  )
                : SizedBox(
                    height: 200,
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        width: chartWidth,
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
                                  getTitlesWidget: getMonthTitles,
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
                            barGroups: widget.monthlyTrainingData,
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
