import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CustomBarChart extends StatefulWidget {
  final List<BarChartGroupData> barData;
  final String chartTitle;
  final Color textColor;

  const CustomBarChart({
    Key? key,
    required this.barData,
    required this.chartTitle,
    required this.textColor,
  }) : super(key: key);

  @override
  CustomBarChartState createState() => CustomBarChartState();
}

class CustomBarChartState extends State<CustomBarChart>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<BarChartGroupData> getDisplayData(int count) {
    return widget.barData.length > count
        ? widget.barData.sublist(widget.barData.length - count)
        : widget.barData;
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                widget.chartTitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: widget.textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: '6 derniers'),
                Tab(text: '10 derniers'),
                Tab(text: '15 derniers'),
              ],
              labelColor: theme.colorScheme.onBackground,
              indicatorColor: theme.colorScheme.onBackground,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildBarChart(getDisplayData(6)),
                  _buildBarChart(getDisplayData(10)),
                  _buildBarChart(getDisplayData(15)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBarChart(List<BarChartGroupData> displayData) {
    ThemeData theme = Theme.of(context);
    return displayData.isEmpty
        ? SizedBox(
            height: 200,
            child: Center(
                child: Text("Bon il s'agirait d'arrêter de forcer",
                    style: theme.textTheme.headlineMedium)),
          )
        : Padding(
            padding: const EdgeInsets.fromLTRB(0, 32, 0, 0),
            child: BarChart(
              BarChartData(
                barTouchData: BarTouchData(
                  enabled: false,
                  touchTooltipData: BarTouchTooltipData(
                    tooltipBgColor: Colors.transparent,
                    tooltipPadding: EdgeInsets.zero,
                    tooltipMargin: 8,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        '${rod.toY.toInt()}',
                        TextStyle(color: widget.textColor, fontSize: 12),
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
                      getTitlesWidget: bottomTitles,
                    ),
                  ),
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: false,
                      reservedSize: 28,
                      interval: 1,
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: displayData,
                gridData: const FlGridData(show: false),
              ),
            ),
          );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    final index = value.toInt();
    final style = TextStyle(
      color: widget.textColor,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text = index < widget.barData.length ? '${index + 1}' : '';
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16,
      child: Text(text, style: style),
    );
  }
}
