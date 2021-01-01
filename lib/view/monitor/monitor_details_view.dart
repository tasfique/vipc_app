import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:vipc_app/model/chart_data.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:pie_chart/pie_chart.dart';
import 'package:vipc_app/view/appbar/appbar_view.dart';
import 'package:vipc_app/view/drawer/drawer_view.dart';
import 'package:vipc_app/controller/monitor/monitor_controller.dart';

class MonitorDetailsView extends StatefulWidget {
  MonitorDetailsView({key}) : super(key: key);

  @override
  _MonitorDetailsViewState createState() => _MonitorDetailsViewState();
}

class _MonitorDetailsViewState extends StateMVC {
  _MonitorDetailsViewState() : super(MonitorController()) {
    _con = MonitorController.con;
  }

  MonitorController _con;
  int key = 0;

  @override
  Widget build(BuildContext context) {
    Map<String, double> dataMap = {
      "Complete": 500,
      "Incomplete": _con.totalPoints[_con.selectedIndex].toDouble(),
    };
    List<Color> colorList = [
      Colors.red,
      Colors.green,
      Colors.blue,
      Colors.yellow,
    ];

    // BAR GRAPH
    var data = [
      MonthlyPointBarChart(
          'Week 1', _con.firstWeekPoints[_con.selectedIndex], Colors.red),
      MonthlyPointBarChart(
          'Week 2', _con.secondWeekPoints[_con.selectedIndex], Colors.yellow),
      MonthlyPointBarChart(
          'Week 3', _con.thirdWeekPoints[_con.selectedIndex], Colors.green),
      MonthlyPointBarChart(
          'Week 4', _con.fourthWeekPoints[_con.selectedIndex], Colors.blue),
    ];

    var series = [
      charts.Series(
        domainFn: (MonthlyPointBarChart clickData, _) => clickData.month,
        measureFn: (MonthlyPointBarChart clickData, _) => clickData.point,
        colorFn: (MonthlyPointBarChart clickData, _) => clickData.color,
        id: 'week',
        data: data,
      ),
    ];

    var chart = charts.BarChart(
      series,
      animate: true,
    );

    var pieChartWidget = PieChart(
      dataMap: dataMap,
      animationDuration: Duration(milliseconds: 800),
      chartLegendSpacing: 32,
      // chartRadius: MediaQuery.of(context).size.width / 2,
      colorList: colorList,
      initialAngleInDegree: 0,
      chartType: ChartType.ring,
      // ringStrokeWidth: 32,
      centerText: "Performance",
      legendOptions: LegendOptions(
        showLegendsInRow: true,
        legendPosition: LegendPosition.bottom,
        showLegends: true,
        // legendShape: _BoxShape.circle,
        legendTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      chartValuesOptions: ChartValuesOptions(
        showChartValueBackground: true,
        showChartValues: true,
        showChartValuesInPercentage: true,
        showChartValuesOutside: false,
      ),
    );

    var barChartWidget = Container(
      child: SizedBox(
        height: MediaQuery.of(context).size.height / 3.5,
        child: chart,
      ),
    );

    return Scaffold(
      appBar: CustomAppBar(),
      drawer: CustomDrawer(),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(25),
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _con.monitorNames[_con.selectedIndex],
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(25),
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    "Monthly Performance",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  padding: EdgeInsets.all(15),
                  width: MediaQuery.of(context).size.width / 1.5,
                  child: pieChartWidget,
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  padding: EdgeInsets.all(15),
                  width: MediaQuery.of(context).size.width / 1.5,
                  child: barChartWidget,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  "Weekly Average: " +
                      _con.weeklyAvgPoints[_con.selectedIndex].toString() +
                      " pts",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  "Total: " +
                      _con.totalPoints[_con.selectedIndex].toString() +
                      " pts",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
