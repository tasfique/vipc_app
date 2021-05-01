// If the role is manager, there should be one more button 'monitor' in the middle.

import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:vipc_app/constants/font_constants.dart';
import 'package:vipc_app/controller/home/home_controller.dart';
// import for charts.
import 'package:vipc_app/model/chart_data.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:pie_chart/pie_chart.dart';
import 'package:percent_indicator/percent_indicator.dart';
//
// import of gradient colour
import 'package:flutter_gradient_colors/flutter_gradient_colors.dart';
//
import 'package:vipc_app/view/appbar/appbar_view.dart';
import 'package:vipc_app/view/bottomnavbar/bottomnavbar.dart';
import 'package:vipc_app/view/drawer/drawer_view.dart';
import 'package:vipc_app/view/monitor/monitor_view.dart';
import 'package:vipc_app/view/news/news_view.dart';
import 'package:vipc_app/model/prospect.dart';
import 'package:vipc_app/view/prospect/prospect_view.dart';
import 'package:bouncing_widget/bouncing_widget.dart';

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
  double responsiveFontSize = 18; // Default Font Size
  bool pieChartDisplayed = true;

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

  @override
  void initState() {
    super.initState();
    pieChartDisplayed = true;

    // LIST VIEW OF CARDS
    Prospect.prospectCardsForHome.clear();
    for (int i = 0; i < Prospect.prospectNames.length; i++) {
      Prospect.prospectCardsForHome.add(
        Card(
          color: Colors.amber[50],
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  child: ListTile(
                    title: Text(
                      Prospect.prospectNames[i],
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Text(
                        "Meeting at " +
                            Prospect.prospectSchedules[i]
                                .toString()
                                .substring(11, 16) +
                            "\n" +
                            Prospect.prospectLocations[i],
                      ),
                    ),
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      const SizedBox(width: 8),
                      FlatButton(
                        child: const Text('More Info..'),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return ProspectView();
                              },
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    //!
  }

  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).size.width);

    // CHECKING SCREEN SIZE
    if (MediaQuery.of(context).size.width > 1024) {
      responsiveFontSize = FontConstants.fontLargeSize;
    } else {
      responsiveFontSize = FontConstants.fontMediumSize;
    }
    // BAR GRAPH DATA
    var data = [
      MonthlyPointBarChart('Jn', 30, Colors.pink),
      MonthlyPointBarChart('Fb', 92, Colors.red),
      MonthlyPointBarChart('Mc', 49, Colors.orange),
      MonthlyPointBarChart('Ap', 30, Colors.orangeAccent),
      MonthlyPointBarChart('My', 20, Colors.limeAccent),
      MonthlyPointBarChart('Ju', 30, Colors.lightGreenAccent),
      MonthlyPointBarChart('Jl', 40, Colors.green),
      MonthlyPointBarChart('Au', 25, Colors.cyan),
      MonthlyPointBarChart('Se', 23, Colors.blue),
      MonthlyPointBarChart('Oc', 85, Colors.indigo),
      MonthlyPointBarChart('Nv', 30, Colors.deepPurple),
      MonthlyPointBarChart('Dc', 55, Colors.purple),
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

    //changing text color for bar chart
    var chart = charts.BarChart(
      series,
      animate: true,
      vertical: false,
      animationDuration: Duration(milliseconds: 750),
      //not sure what this is code is supposed to do below.
      //defaultRenderer: charts.BarRendererConfig(strokeWidthPx: 20.0),

      // barGroupingType: charts.BarGroupingType.stacked,
      domainAxis: new charts.OrdinalAxisSpec(
          renderSpec: new charts.SmallTickRendererSpec(

              // Tick and Label styling here.
              labelStyle: new charts.TextStyleSpec(
                  fontSize: 16, // size in Pts.
                  color: charts.MaterialPalette.white),

              // Change the line colors to match text color.
              lineStyle: new charts.LineStyleSpec(
                  color: charts.MaterialPalette.white))),
      // Assign a custom style for the measure axis.
      primaryMeasureAxis: new charts.NumericAxisSpec(
          renderSpec: new charts.GridlineRendererSpec(

              // Tick and Label styling here. for 0 to 100
              labelStyle: new charts.TextStyleSpec(
                  fontSize: 16, // size in Pts.
                  color: charts.MaterialPalette.white),

              // Change the line colors to match text color.
              lineStyle: new charts.LineStyleSpec(
                  color: charts.MaterialPalette.white))),
    );

    var pieChartWidget = PieChart(
      dataMap: dataMap,
      animationDuration: Duration(milliseconds: 1500),
      chartLegendSpacing: 20,
      // chartRadius: MediaQuery.of(context).size.width / 2,
      colorList: colorList,
      initialAngleInDegree: 0,
      chartType: ChartType.disc,
      //ringStrokeWidth: 50,
      //centerText: "Performance",
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

    //bar widget sizing settings
    var barChartWidget = Container(
      child: SizedBox(
        height: MediaQuery.of(context).size.height / 1.8,
        child: chart,
      ),
    );

    return Scaffold(
      appBar: CustomAppBar(),
      bottomNavigationBar: CustomNavBar(),
      drawer: CustomDrawer(),

      body: Container(
        // MediaQuery.of(context).size.width
        // MediaQuery.of(context).size.height
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: GradientColors.lightBlack,
            // stop:[
            // 0.6,
            // 0.7
            // ]
          ),
        ),
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: Column(
              children: [
                // maybe here
                Padding(
                  padding: EdgeInsets.all(15),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Hello, Tasfique Enam',
                      style: TextStyle(fontSize: responsiveFontSize),
                    ),
                  ),
                ),

                // CHART and BAR GRAPHS VIEW
                Container(
                  width: MediaQuery.of(context).size.width,
                  //height: MediaQuery.of(context).size.height,
                  height: 500,
                  padding: EdgeInsets.all(20),
                  child: Stack(
                    children: [
                      //condition
                      pieChartDisplayed == true
                          //if
                          ? Center(
                              child: Column(children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  padding: EdgeInsets.all(15),
                                  child: pieChartWidget,
                                ),
                                //for pie chart
                                Container(
                                  padding: EdgeInsets.all(1),
                                  width: MediaQuery.of(context).size.width,
                                  alignment: Alignment.center,
                                  child: Text("Weekly Performance Achievement",
                                      style: TextStyle(
                                        fontSize: responsiveFontSize,
                                      )),
                                )
                              ]),
                            )
                          //else
                          : Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  //need to remove maybe
                                  SizedBox(height: 5),
                                  Container(
                                    padding: EdgeInsets.all(15),
                                    width: MediaQuery.of(context).size.width,
                                    child: barChartWidget,
                                  ),
                                  //For bar chart
                                  Container(
                                    padding: EdgeInsets.all(5),
                                    width: MediaQuery.of(context).size.width,
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Monthly Performance Achievement",
                                      style: TextStyle(
                                        fontSize: responsiveFontSize,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              if (pieChartDisplayed) pieChartDisplayed = false;
                            });
                          },
                          child: BouncingWidget(
                            // duration: Duration(milliseconds: 100),
                            scaleFactor: 1.5,
                            onPressed: () {
                              setState(() {
                                if (pieChartDisplayed)
                                  pieChartDisplayed = false;
                              });
                            },
                            child: Container(
                              child: Icon(
                                Icons.arrow_back_ios,
                                size: 30,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              if (!pieChartDisplayed) pieChartDisplayed = true;
                            });
                          },
                          child: BouncingWidget(
                            // duration: Duration(milliseconds: 100),
                            scaleFactor: 1.5,
                            onPressed: () {
                              setState(() {
                                if (!pieChartDisplayed)
                                  pieChartDisplayed = true;
                              });
                            },
                            child: Container(
                              child: Icon(
                                Icons.arrow_forward_ios,
                                size: 30,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // BAR GRAPH OF POINTS TO GO AREA
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: new LinearPercentIndicator(
                    width: MediaQuery.of(context).size.width - 40,
                    animation: true,
                    lineHeight: 30.0,
                    animationDuration: 2000,
                    percent: 0.65,
                    center: Text("35 points to go!",
                        style: TextStyle(
                          color: Colors.black,
                        )),
                    linearStrokeCap: LinearStrokeCap.butt,
                    progressColor: Colors.yellowAccent,
                  ),
                ),

                // THREE BUTTONS
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return ProspectView();
                          }));
                        },
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(5),
                          child: const Text('Prospect',
                              style: TextStyle(
                                fontSize: 17,
                              )),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return MonitorView();
                          }));
                        },
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(5),
                          child: const Text('Monitor',
                              style: TextStyle(fontSize: 17)),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return NewsView();
                          }));
                        },
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(5),
                          child: const Text('News',
                              style: TextStyle(fontSize: 17)),
                        ),
                      ),
                    ],
                  ),
                ),

                // CARDS
                Container(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                  height: MediaQuery.of(context).size.height / 4.5,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: Prospect.prospectCardsForHome.length,
                    itemBuilder: (context, index) {
                      return Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Prospect.prospectCardsForHome[index],
                      );
                    },
                  ),
                ),
              ],
            ),
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
