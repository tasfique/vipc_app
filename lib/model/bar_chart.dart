// /// Bar chart example
// import 'package:charts_flutter/flutter.dart' as charts;
// import 'package:flutter/material.dart';
// import 'package:vipc_app/model/chart_data.dart';

// class BarChart extends StatelessWidget {
//   final List<charts.Series> seriesList;
//   final bool animate;

//   BarChart(this.seriesList, {this.animate});

//   /// Creates a [BarChart] with sample data and no transition.
//   factory BarChart.withSampleData() {
//     return new BarChart(
//       _createSampleData(),
//       // Disable animations for image tests.
//       animate: false,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return new charts.BarChart(
//       seriesList,
//       animate: animate,
//     );
//   }

//   /// Create one series with sample hard coded data.
//   static List<charts.Series<Sales, String>> _createSampleData() {
//     final data = [
//       new Sales('2014', 5),
//       new Sales('2015', 25),
//       new Sales('2016', 100),
//       new Sales('2017', 75),
//     ];

//     return [
//       new charts.Series<Sales, String>(
//         id: 'Sales',
//         colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
//         domainFn: (Sales sales, _) => sales.year,
//         measureFn: (Sales sales, _) => sales.sales,
//         data: data,
//       )
//     ];
//   }
// }
