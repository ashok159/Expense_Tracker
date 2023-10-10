import 'bar.dart';
class BarData {
  final double sundayAmount;
  final double mondayAmount;
  final double tuesdayAmount;
  final double wednesdayAmount;
  final double thursdayAmount;
  final double fridayAmount;
  final double saturdayAmount;

  BarData({
    required this.sundayAmount,
    required this.mondayAmount,
    required this.tuesdayAmount,
    required this.wednesdayAmount,
    required this.thursdayAmount,
    required this.fridayAmount,
    required this.saturdayAmount,
  });

  List<Bar> barData = [];

  void initializeBarData() {
    barData = [
      Bar(x: 0, y: sundayAmount),
      Bar(x: 1, y: mondayAmount),
      Bar(x: 2, y: tuesdayAmount),
      Bar(x: 3, y: wednesdayAmount),
      Bar(x: 4, y: thursdayAmount),
      Bar(x: 5, y: fridayAmount),
      Bar(x: 6, y: saturdayAmount),
    ];
  }

}