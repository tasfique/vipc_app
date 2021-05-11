import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:vipc_app/constants/font_constants.dart';
import 'package:vipc_app/controller/home/advisor_controller.dart';
import 'package:vipc_app/model/chart_data.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:pie_chart/pie_chart.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter_gradient_colors/flutter_gradient_colors.dart';
import 'package:vipc_app/model/news.dart';
import 'package:vipc_app/view/appbar/appbar_view.dart';
import 'package:vipc_app/view/drawer/drawer_view.dart';
import 'package:vipc_app/view/monitor/monitor_view.dart';
import 'package:vipc_app/view/news/news_details_view.dart';
import 'package:vipc_app/view/news/news_view.dart';
import 'package:vipc_app/model/prospect.dart';
import 'package:vipc_app/view/prospect/prospect_view.dart';
import 'package:bouncing_widget/bouncing_widget.dart';

class AdvisorView extends StatefulWidget {
  AdvisorView({key}) : super(key: key);
  @override
  _AdvisorViewState createState() => _AdvisorViewState();
}

class _AdvisorViewState extends StateMVC {
  _AdvisorViewState() : super(AdvisorController()) {
    _con = AdvisorController.con;
  }
  AdvisorController _con;

  double responsiveFontSize = 18; // Default Font Size
  bool pieChartDisplayed;
  bool check = true;

  var series = [
    charts.Series(
      domainFn: (MonthlyPointBarChart clickData, _) => clickData.month,
      measureFn: (MonthlyPointBarChart clickData, _) => clickData.point,
      colorFn: (MonthlyPointBarChart clickData, _) => clickData.color,
      id: 'month',
      data: [
        MonthlyPointBarChart('Jan', 30, Colors.pink),
        MonthlyPointBarChart('Feb', 92, Colors.red),
        MonthlyPointBarChart('Mar', 49, Colors.orange),
        MonthlyPointBarChart('Apr', 30, Colors.orangeAccent),
        MonthlyPointBarChart('May', 20, Colors.limeAccent),
        MonthlyPointBarChart('Jun', 30, Colors.lightGreenAccent),
        MonthlyPointBarChart('Jul', 40, Colors.green),
        MonthlyPointBarChart('Aug', 25, Colors.cyan),
        MonthlyPointBarChart('Sep', 23, Colors.blue),
        MonthlyPointBarChart('Oct', 85, Colors.indigo),
        MonthlyPointBarChart('Nov', 30, Colors.deepPurple),
        MonthlyPointBarChart('Dec', 55, Colors.purple),
      ],
    ),
  ];

  @override
  void initState() {
    _con.selectedIndex = 0;
    _con.newsList = [];

    pieChartDisplayed = true;
    super.initState();

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
                      TextButton(
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
  }

  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('testAdvisor');
    return Scaffold(
      appBar: CustomAppBar(),
      drawer: CustomDrawer(),
      bottomNavigationBar: BottomAppBar(
        child: BottomNavigationBar(
          currentIndex: _con.selectedIndex,
          onTap: (val) {
            setState(() => _con.selectedIndex = val);
          },
          showSelectedLabels: true,
          showUnselectedLabels: false,
          items: [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                  color: _con.selectedIndex == 0
                      ? Colors.amber[320]
                      : Colors.white,
                ),
                label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.star,
                  color: _con.selectedIndex == 1
                      ? Colors.amber[320]
                      : Colors.white,
                ),
                label: 'Prospect'),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.my_library_books,
                  color: _con.selectedIndex == 2
                      ? Colors.amber[320]
                      : Colors.white,
                ),
                label: 'News'),
          ],
        ),
      ),
      body: _con.selectedIndex == 0
          ? home()
          : _con.selectedIndex == 1
              ? prospect()
              : news(),
    );
  }

  Widget home() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: GradientColors.lightBlack,
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
                    style: TextStyle(fontSize: FontConstants.fontMediumSize),
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
                                width: MediaQuery.of(context).size.width * 0.9,
                                padding: EdgeInsets.all(15),
                                child: PieChart(
                                  dataMap: {
                                    "Week 1": 5,
                                    "Week 2": 3,
                                    "Week 3": 2,
                                    "Week 4": 2,
                                  },
                                  animationDuration:
                                      Duration(milliseconds: 1500),
                                  chartLegendSpacing: 20,
                                  // chartRadius: MediaQuery.of(context).size.width / 2,
                                  colorList: [
                                    Colors.red,
                                    Colors.green,
                                    Colors.blue,
                                    Colors.yellow,
                                  ],
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
                                    chartValueStyle: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                        backgroundColor: Colors.transparent),
                                    showChartValueBackground: true,
                                    showChartValues: true,
                                    showChartValuesInPercentage: true,
                                    showChartValuesOutside: false,
                                  ),
                                ),
                              ),
                              //for pie chart
                              Container(
                                padding: EdgeInsets.all(1),
                                width: MediaQuery.of(context).size.width,
                                alignment: Alignment.center,
                                child: Text("Weekly Performance Achievement",
                                    style: TextStyle(
                                      fontSize: FontConstants.fontMediumSize,
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
                                  child: Container(
                                    child: SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              1.8,
                                      child: charts.BarChart(
                                        series,
                                        animate: true,
                                        vertical: false,
                                        animationDuration:
                                            Duration(milliseconds: 750),
                                        //not sure what this is code is supposed to do below.
                                        //defaultRenderer: charts.BarRendererConfig(strokeWidthPx: 20.0),

                                        // barGroupingType: charts.BarGroupingType.stacked,
                                        domainAxis: new charts.OrdinalAxisSpec(
                                            renderSpec: new charts
                                                    .SmallTickRendererSpec(

                                                // Tick and Label styling here.
                                                labelStyle:
                                                    new charts.TextStyleSpec(
                                                        fontSize:
                                                            16, // size in Pts.
                                                        color: charts
                                                            .MaterialPalette
                                                            .white),

                                                // Change the line colors to match text color.
                                                lineStyle:
                                                    new charts.LineStyleSpec(
                                                        color: charts
                                                            .MaterialPalette
                                                            .white))),
                                        // Assign a custom style for the measure axis.
                                        primaryMeasureAxis: new charts
                                                .NumericAxisSpec(
                                            renderSpec: new charts
                                                    .GridlineRendererSpec(

                                                // Tick and Label styling here. for 0 to 100
                                                labelStyle:
                                                    new charts.TextStyleSpec(
                                                        fontSize:
                                                            16, // size in Pts.
                                                        color: charts
                                                            .MaterialPalette
                                                            .white),

                                                // Change the line colors to match text color.
                                                lineStyle:
                                                    new charts.LineStyleSpec(
                                                        color: charts
                                                            .MaterialPalette
                                                            .white))),
                                      ),
                                    ),
                                  ),
                                ),
                                //For bar chart
                                Container(
                                  padding: EdgeInsets.all(5),
                                  width: MediaQuery.of(context).size.width,
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Monthly Performance Achievement",
                                    style: TextStyle(
                                      fontSize: FontConstants.fontMediumSize,
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
                              if (pieChartDisplayed) pieChartDisplayed = false;
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
                              if (!pieChartDisplayed) pieChartDisplayed = true;
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
    );
  }

  Widget prospect() {}

  Widget news() {
    return FutureBuilder(
      future: _con.getNews(context),
      builder: (context, snapshot) => snapshot.connectionState ==
              ConnectionState.waiting
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  check = false;
                });
                _con.getNews(context);
                setState(() {
                  check = true;
                });
              },
              child: (check)
                  ? Container(
                      padding:
                          EdgeInsets.only(left: 10.0, right: 10.0, top: 20.0),
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: _con.newsList.length,
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Company News",
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 15),
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: newsItemCard(
                                        context, _con.newsList[index]),
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return Padding(
                              padding: EdgeInsets.only(top: 15),
                              child: Container(
                                alignment: Alignment.center,
                                child:
                                    newsItemCard(context, _con.newsList[index]),
                              ),
                            );
                          }
                        },
                      ),
                    )
                  : Center(
                      child: CircularProgressIndicator(),
                    ),
            ),
    );
  }
}

Widget newsItemCard(BuildContext context, News oneNew) {
  return Card(
    color: Colors.amber[50],
    child: Padding(
      padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  oneNew.title,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                Text(
                  DateFormat('dd/MM/yyyy HH:mm')
                      .format(DateTime.parse(oneNew.newsId)),
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            subtitle: Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text(
                oneNew.content,
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
                style: TextStyle(
                  color: Colors.black87,
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              const SizedBox(width: 8),
              TextButton(
                child: const Text('Read more...'),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return NewsDetailsView(oneNew);
                  }));
                },
              ),
              const SizedBox(width: 8),
            ],
          ),
        ],
      ),
    ),
  );
}
