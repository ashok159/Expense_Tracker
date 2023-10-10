import 'package:budget_app/get_cloud_data.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:budget_app/indicator.dart';
import 'get_cloud_data.dart';

final colorSet = [
  const Color.fromRGBO(155, 95, 224, 1),
  const Color.fromRGBO(22, 164, 216, 1),
  const Color.fromRGBO(96, 219, 232, 1),
  const Color.fromRGBO(139, 211, 70, 1),
  const Color.fromRGBO(239, 223, 72, 1),
  const Color.fromRGBO(249, 165, 44, 1),
  const Color.fromRGBO(214, 78, 18, 1),
];

class ChartsPage extends StatefulWidget {
  final List<String> expense;

  final VoidCallback updateParentState;

  const ChartsPage(
      {Key? key, required this.expense, required this.updateParentState})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => Chart2State();
}

class Chart2State extends State<ChartsPage> {
  int touchedIndex = -1;

  void updateState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: Row(
        children: <Widget>[
          const SizedBox(
            height: 18,
          ),
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: PieChart(
                PieChartData(
                  // pieTouchData: PieTouchData(
                  //   touchCallback: (FlTouchEvent event, pieTouchResponse) {
                  //     setState(() {
                  //       if (!event.isInterestedForInteractions ||
                  //           pieTouchResponse == null ||
                  //           pieTouchResponse.touchedSection == null) {
                  //         touchedIndex = -1;
                  //         return;
                  //       }
                  //       touchedIndex = pieTouchResponse
                  //           .touchedSection!.touchedSectionIndex;
                  //     });
                  //   },
                  // ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  sectionsSpace: 0,
                  centerSpaceRadius: 100,
                  sections: showingSections(),
                ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: showingIndicators(),
          ),
          const SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }

/* class ChartsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Replace with your Firestore data-fetching function
      future: getExpenseByCategory(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Data is still loading, return a loading indicator or placeholder
          return CircularProgressIndicator(); // Or any other loading widget
        } else if (snapshot.hasError) {
          // Handle the error
          return Text('Error: ${snapshot.error}');
        } else {
          // Data has been successfully fetched, build the PieChart
          return Chart2(); // Or build your PieChart here
        }
      },
    );
  }

class Chart2 extends StatefulWidget {
  @override
  _Chart2State createState() => _Chart2State();
}



class _Chart2State extends State<Chart2> {
  int touchedIndex = -1;
  
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: Row(
        children: <Widget>[
          const SizedBox(
            height: 18,
          ),
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          touchedIndex = -1;
                          return;
                        }
                        touchedIndex = pieTouchResponse
                            .touchedSection!.touchedSectionIndex;
                      });
                    },
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  sectionsSpace: 0,
                  centerSpaceRadius: 100,
                  sections: showingSections(),
                ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: showingIndicators(),
          ),
          const SizedBox(
            width: 20,
          ),
        ],
      ),
    );

          
} */

  List<PieChartSectionData> showingSections() {
    return List.generate(7, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 22.0 : 14.0;
      final radius = isTouched
          ? MediaQuery.of(context).size.width * 0.06
          : MediaQuery.of(context).size.width * 0.05;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

      return PieChartSectionData(
        color: colorSet[i],
        value: double.parse(double.parse(widget.expense[i * 2 + 1]).toStringAsFixed(2)),
        title: double.parse(widget.expense[i * 2 + 1]).toStringAsFixed(2),
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          decoration: TextDecoration.none,
          shadows: shadows,
        ),
      );
    });
  }
}

List<Widget> showingIndicators() {
  List<Widget> indicators = [];

  for (int i = 0; i < 7; i++) {
    indicators.add(
      Indicator(
          color: colorSet[i],
          text: userExpenseByCategory[i * 2],
          isSquare: true),
    );
    if (i != 6) {
      indicators.add(const SizedBox(
        height: 4,
      ));
    } else {
      indicators.add(const SizedBox(
        height: 20,
      ));
    }
  }

  return indicators;
}
