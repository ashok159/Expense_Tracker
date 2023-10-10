import 'package:budget_app/bar_data.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'charts_page.dart';

List<double> weeklySummary = [23.45, 16.23, 52.30, 44.89, 20.11, 41.05, 62.33];

class BarGraph extends StatefulWidget {
  const BarGraph({super.key});

  @override
  State<StatefulWidget> createState() => BarGraph2State();
}

class BarGraph2State extends State {
  

  @override
  Widget build(BuildContext context) {
    BarData userBarData = BarData(
      sundayAmount: weeklySummary[0],
      mondayAmount: weeklySummary[1],
      tuesdayAmount: weeklySummary[2],
      wednesdayAmount: weeklySummary[3],
      thursdayAmount: weeklySummary[4],
      fridayAmount: weeklySummary[5], 
      saturdayAmount: weeklySummary[6]
    );
    userBarData.initializeBarData();

    return BarChart(
      BarChartData(
        maxY: 100,
        minY: 0,
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: const FlTitlesData(
          show: true,
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: bottomTitles))
        ),
        barGroups: userBarData.barData.map(
          (data) => BarChartGroupData(
            x: data.x,
            barRods: [BarChartRodData(
              toY: data.y,
              color: colorSet[data.x],
              width: 25,
              borderRadius: BorderRadius.circular(10),
              )],
          )
        ).toList(),
      ),
    );
  }
}

Widget bottomTitles(double value, TitleMeta meta) {
  const style = TextStyle(
    color: Colors.grey,
    fontWeight: FontWeight.bold,
    fontSize: 14,
  );

  Widget text;
  switch(value.toInt()) {
    case 0:
      text = const Text('S', style: style);
      break;
    case 1:
      text = const Text('M', style: style);
      break;
    case 2:
      text = const Text('T', style: style);
      break;
    case 3:
      text = const Text('W', style: style);
      break;
    case 4:
      text = const Text('T', style: style);
      break;
    case 5:
      text = const Text('F', style: style);
      break;
    case 6:
      text = const Text('S', style: style);
      break;
    default:
      text = const Text('', style: style);
      break;
  }

  return SideTitleWidget(axisSide: meta.axisSide, child: text);
}