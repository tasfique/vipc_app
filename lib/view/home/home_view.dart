// If the role is manager, there should be one more button 'monitor' in the middle.

import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:vipc_app/controller/home/home_controller.dart';
import 'package:vipc_app/model/chart_data.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:pie_chart/pie_chart.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:vipc_app/view/appbar/appbar_view.dart';
import 'package:vipc_app/view/drawer/drawer_view.dart';
import 'package:vipc_app/view/sales/sales_view.dart';
import 'package:vipc_app/view/monitor/monitor_view.dart';
import 'package:vipc_app/view/news/news_view.dart';

class HomeView extends StatefulWidget {
  HomeView({key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends StateMVC {
  _HomeViewState() : super(HomeController()) {
    _con = HomeController.con;
  }

  HomeController _con;

  // PIE CHART
  int key = 0;
  Map<String, double> dataMap = {
    "Week 1": 5,
    "Week 2": 3,
    "Week 3": 2,
    "Week 4": 2,
  };
  List<Color> colorList = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
  ];

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: new Text("News"),
            content: new Text("Announcement on CMCO October 2020"),
            actions: <Widget>[
              FlatButton(
                child: Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text('Read more...'),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return NewsView();
                  }));
                },
              ),
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    // BAR GRAPH
    var data = [
      MonthlyPointBarChart('Jan', 61, Colors.red),
      MonthlyPointBarChart('Feb', 24, Colors.yellow),
      MonthlyPointBarChart('Mar', 49, Colors.green),
      MonthlyPointBarChart('Apr', 30, Colors.blue),
    ];

    var series = [
      charts.Series(
        domainFn: (MonthlyPointBarChart clickData, _) => clickData.month,
        measureFn: (MonthlyPointBarChart clickData, _) => clickData.point,
        colorFn: (MonthlyPointBarChart clickData, _) => clickData.color,
        id: 'month',
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

    // LIST VIEW OF CARDS
    final List<Card> cards = [
      Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const ListTile(
                title: Text(
                  'Kris Wu',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                subtitle: Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text('Meeting at 11:30AM Suria KLCC Ben\'s'),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  const SizedBox(width: 8),
                  FlatButton(
                    child: const Text('More Info..'),
                    onPressed: () {/* ... */},
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ],
          ),
        ),
      ),
      Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const ListTile(
                title: Text(
                  'Hamid Hosseini',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                subtitle: Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text('Meeting at 12PM Pavilion Sukiya'),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  const SizedBox(width: 8),
                  FlatButton(
                    child: const Text('More Info..'),
                    onPressed: () {/* ... */},
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ],
          ),
        ),
      ),
      Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const ListTile(
                title: Text(
                  'Alex Raul',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                subtitle: Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text('Meeting at 12:40PM SS15 Starbucks'),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  const SizedBox(width: 8),
                  FlatButton(
                    child: const Text('More Info..'),
                    onPressed: () {/* ... */},
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ],
          ),
        ),
      ),
    ];

    return Scaffold(
      appBar: CustomAppBar(),
      drawer: CustomDrawer(),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(15),
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Hello, Tasfique Enam',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),

              // CHART AREA
              Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 2,
                    padding: EdgeInsets.all(15),
                    child: pieChartWidget,
                  ),
                  Container(
                    padding: EdgeInsets.all(15),
                    width: MediaQuery.of(context).size.width / 2,
                    child: barChartWidget,
                  ),
                ],
              ),
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 2,
                    alignment: Alignment.center,
                    child: Text(
                      "Weekly Performance Achievement",
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 2,
                    alignment: Alignment.center,
                    child: Text(
                      "Monthly Points",
                    ),
                  ),
                ],
              ),

              // BAR GRAPH OF POINTS TO GO AREA
              Padding(
                padding: EdgeInsets.all(25.0),
                child: new LinearPercentIndicator(
                  width: MediaQuery.of(context).size.width - 50,
                  animation: true,
                  lineHeight: 30.0,
                  animationDuration: 1000,
                  percent: 0.65,
                  center: Text("35 points to go!",
                      style: TextStyle(
                        color: Colors.white,
                      )),
                  linearStrokeCap: LinearStrokeCap.butt,
                  progressColor: Colors.blueAccent,
                ),
              ),

              // THREE BUTTONS
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RaisedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return SalesView();
                      }));
                    },
                    textColor: Colors.white,
                    padding: const EdgeInsets.all(0),
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width / 4,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: <Color>[
                            Color(0xFF0D47A1),
                            Color(0xFF1976D2),
                            Color(0xFF42A5F5),
                          ],
                        ),
                      ),
                      padding: const EdgeInsets.all(15),
                      child:
                          const Text('Sales', style: TextStyle(fontSize: 17)),
                    ),
                  ),
                  RaisedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return MonitorView();
                      }));
                    },
                    textColor: Colors.white,
                    padding: const EdgeInsets.all(0),
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width / 4,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: <Color>[
                            Color(0xFF0D47A1),
                            Color(0xFF1976D2),
                            Color(0xFF42A5F5),
                          ],
                        ),
                      ),
                      padding: const EdgeInsets.all(15),
                      child:
                          const Text('Monitor', style: TextStyle(fontSize: 17)),
                    ),
                  ),
                  RaisedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return NewsView();
                      }));
                    },
                    textColor: Colors.white,
                    padding: const EdgeInsets.all(0),
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width / 4,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: <Color>[
                            Color(0xFF0D47A1),
                            Color(0xFF1976D2),
                            Color(0xFF42A5F5),
                          ],
                        ),
                      ),
                      padding: const EdgeInsets.all(15),
                      child: const Text('News', style: TextStyle(fontSize: 17)),
                    ),
                  ),
                ],
              ),

              // CARDS
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                height: MediaQuery.of(context).size.height / 3.5,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: cards.length,
                  itemBuilder: (context, index) {
                    return Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: cards[index],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),

      // SizedBox(height: 30),
      // Row(
      //   children: [
      //     Container(
      //       padding: EdgeInsets.all(15),
      //       width: MediaQuery.of(context).size.width / 2,
      //       child: Image.asset(
      //         'assets/images/icon1.png',
      //       ),
      //     ),
      //     Container(
      //       padding: EdgeInsets.all(15),
      //       width: MediaQuery.of(context).size.width / 2,
      //       child: Image.asset(
      //         'assets/images/icon2.png',
      //       ),
      //     ),
      //   ],
      // ),
      // Row(
      //   children: [
      //     Container(
      //       padding: EdgeInsets.all(15),
      //       width: MediaQuery.of(context).size.width / 2,
      //       child: Image.asset(
      //         'assets/images/icon3.png',
      //       ),
      //     ),
      //     Container(
      //       padding: EdgeInsets.all(15),
      //       width: MediaQuery.of(context).size.width / 2,
      //       child: Image.asset(
      //         'assets/images/icon4.png',
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}
