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
import 'package:vipc_app/model/line_graph.dart';
import 'package:vipc_app/model/news.dart';
import 'package:vipc_app/view/appbar/appbar_view.dart';
import 'package:vipc_app/view/drawer/drawer_view.dart';
import 'package:vipc_app/view/news/news_details_view.dart';
import 'package:vipc_app/model/prospect.dart';
import 'package:vipc_app/view/prospect/prospect_add.dart';
import 'package:vipc_app/view/prospect/prospect_breakdown_view.dart';
import 'package:vipc_app/view/prospect/prospect_edit.dart';
import 'package:vipc_app/view/prospect/prospect_view.dart';
import 'package:bouncing_widget/bouncing_widget.dart';
// for line graph
import 'dart:math';
//import 'package:syncfusion_flutter_charts/charts.dart';

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

  // double responsiveFontSize = 18; // Default Font Size
  int chartIndex;
  bool check = true;
  bool checkHome = true;
  bool checkProspect = true;
  var series;

  Future<void> declare() async {
    await _con.getMonthlyPoint(context);
    series = [
      charts.Series(
          domainFn: (MonthlyPointBarChart clickData, _) => clickData.month,
          measureFn: (MonthlyPointBarChart clickData, _) => clickData.point,
          colorFn: (MonthlyPointBarChart clickData, _) => clickData.color,
          id: 'month',
          data: [
            MonthlyPointBarChart('Jan', _con.monthlyPoint[0], Colors.pink),
            MonthlyPointBarChart('Feb', _con.monthlyPoint[1], Colors.red),
            MonthlyPointBarChart('Mar', _con.monthlyPoint[2], Colors.orange),
            MonthlyPointBarChart(
                'Apr', _con.monthlyPoint[3], Colors.orangeAccent),
            MonthlyPointBarChart(
                'May', _con.monthlyPoint[4], Colors.limeAccent),
            MonthlyPointBarChart(
                'Jun', _con.monthlyPoint[5], Colors.lightGreenAccent),
            MonthlyPointBarChart('Jul', _con.monthlyPoint[6], Colors.green),
            MonthlyPointBarChart('Aug', _con.monthlyPoint[7], Colors.cyan),
            MonthlyPointBarChart('Sep', _con.monthlyPoint[8], Colors.blue),
            MonthlyPointBarChart('Oct', _con.monthlyPoint[9], Colors.indigo),
            MonthlyPointBarChart(
                'Nov', _con.monthlyPoint[10], Colors.deepPurple),
            MonthlyPointBarChart('Dec', _con.monthlyPoint[11], Colors.purple),
          ],
          labelAccessorFn: (MonthlyPointBarChart row, _) =>
              row.point != 0 ? '${row.point}' : ''),
    ];
  }

//for line graph
  var series2 = [
    charts.Series(
        domainFn: (YearlyPointLineGraph clickData, _) => clickData.time,
        measureFn: (YearlyPointLineGraph clickData, _) => clickData.point,
        colorFn: (YearlyPointLineGraph clickData, _) => clickData.color,
        id: 'time',
        data: [
          YearlyPointLineGraph(new DateTime(2017, 01, 01), 30, Colors.yellow),
          YearlyPointLineGraph(new DateTime(2018, 01, 01), 100, Colors.yellow),
          YearlyPointLineGraph(new DateTime(2019, 01, 01), 80, Colors.yellow),
          YearlyPointLineGraph(new DateTime(2020, 01, 01), 50, Colors.yellow),
        ],
        labelAccessorFn: (YearlyPointLineGraph row, _) =>
            row.point != 0 ? '${row.point}' : ''),
  ];

  //code for line graph.

  @override
  void initState() {
    _con.selectedIndex = 0;
    chartIndex = 0;
    _con.newsList = [];
    _con.getProspect(context);
    for (int i = 0; i < 12; i++) _con.monthlyPoint.add(0);
    super.initState();
    // // LIST VIEW OF CARDS
    // Prospect.prospectCardsForHome.clear();
    // for (int i = 0; i < Prospect.prospectNames.length; i++) {
    //   Prospect.prospectCardsForHome.add(
    //     Card(
    //       color: Colors.amber[50],
    //       child: Padding(
    //         padding: EdgeInsets.all(8.0),
    //         child: Column(
    //           mainAxisSize: MainAxisSize.min,
    //           children: <Widget>[
    //             Container(
    //               child: ListTile(
    //                 title: Text(
    //                   Prospect.prospectNames[i],
    //                   style: TextStyle(
    //                     fontSize: 18,
    //                   ),
    //                 ),
    //                 subtitle: Padding(
    //                   padding: EdgeInsets.only(top: 10),
    //                   child: Text(
    //                     "Meeting at " +
    //                         Prospect.prospectSchedules[i]
    //                             .toString()
    //                             .substring(11, 16) +
    //                         "\n" +
    //                         Prospect.prospectLocations[i],
    //                   ),
    //                 ),
    //               ),
    //             ),
    //             Container(
    //               child: Row(
    //                 mainAxisAlignment: MainAxisAlignment.end,
    //                 children: <Widget>[
    //                   const SizedBox(width: 8),
    //                   TextButton(
    //                     child: const Text('More Info..'),
    //                     onPressed: () {
    //                       Navigator.push(
    //                         context,
    //                         MaterialPageRoute(
    //                           builder: (context) {
    //                             return ProspectView();
    //                           },
    //                         ),
    //                       );
    //                     },
    //                   ),
    //                   const SizedBox(width: 8),
    //                 ],
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //     ),
    //   );
    // }

    // // Prospect
    // Prospect.prospectCards.clear();
    // for (int i = 0; i < Prospect.prospectNames.length; i++) {
    //   Prospect.prospectCards.add(
    //     Card(
    //       //Prospect Card background color
    //       color: Colors.amber[50],
    //       //
    //       child: Padding(
    //         padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
    //         child: Column(
    //           mainAxisSize: MainAxisSize.min,
    //           children: <Widget>[
    //             Row(
    //               children: [
    //                 Expanded(
    //                   flex: 1,
    //                   child: Container(
    //                     padding: EdgeInsets.only(left: 10, top: 5),
    //                     child: Text(
    //                       Prospect.prospectNames[i],
    //                       overflow: TextOverflow.ellipsis,
    //                       maxLines: 1,
    //                       style: TextStyle(
    //                         fontSize: 20,
    //                         color: Colors.black,
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //                 ButtonBar(
    //                   children: <Widget>[
    //                     TextButton(
    //                       child: const Icon(
    //                         Icons.edit,
    //                         size: 30,
    //                         color: Colors.brown,
    //                       ),
    //                       onPressed: () {
    //                         Navigator.push(
    //                             context,
    //                             MaterialPageRoute(
    //                                 builder: (context) =>
    //                                     EditProspectStateless()));
    //                       },
    //                     ),
    //                   ],
    //                 ),
    //               ],
    //             ),
    //             Row(
    //               children: [
    //                 Expanded(
    //                   flex: 1,
    //                   child: Container(
    //                     padding: EdgeInsets.only(left: 10, top: 5),
    //                     child: Text(
    //                       Prospect.prospectTypes[i],
    //                       overflow: TextOverflow.ellipsis,
    //                       maxLines: 1,
    //                       style: TextStyle(
    //                         fontSize: 20,
    //                         color: Colors.black54,
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //               ],
    //             ),
    //             Row(
    //               children: [
    //                 Expanded(
    //                   flex: 1,
    //                   child: Container(
    //                     padding: EdgeInsets.only(left: 10, top: 5),
    //                     child: Text(
    //                       Prospect.prospectSteps[i],
    //                       overflow: TextOverflow.ellipsis,
    //                       maxLines: 1,
    //                       style: TextStyle(
    //                         fontSize: 18,
    //                         color: Colors.black,
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //                 Expanded(
    //                   flex: 1,
    //                   child: Container(
    //                     padding: EdgeInsets.only(left: 30, top: 30),
    //                     child: Text(
    //                       "Meeting at " +
    //                           Prospect.prospectSchedules[i]
    //                               .toString()
    //                               .substring(11, 16) +
    //                           "\n" +
    //                           Prospect.prospectLocations[i],
    //                       overflow: TextOverflow.ellipsis,
    //                       maxLines: 3,
    //                       style: TextStyle(
    //                         fontSize: 18,
    //                         color: Colors.black,
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //               ],
    //             ),
    //             // ButtonBar(
    //             //   children: <Widget>[
    //             //     FlatButton(
    //             //       child: const Icon(
    //             //         Icons.edit,
    //             //         size: 30,
    //             //       ),
    //             //       onPressed: () {
    //             //         Navigator.push(
    //             //             context,
    //             //             MaterialPageRoute(
    //             //                 builder: (context) => EditProspectStateless()));
    //             //       },
    //             //     ),
    //             //   ],
    //             // ),
    //           ],
    //         ),
    //       ),
    //     ),
    //   );
    // }
  }

  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context);
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
          ? home(screenSize)
          : _con.selectedIndex == 1
              ? prospect()
              : news(),
    );
  }

  Widget home(MediaQueryData screenSize) {
    return FutureBuilder(
      // TODO : fix this
      future: null,
      // future: _con.getNews(context),
      builder: (context, snapshot) => snapshot.connectionState ==
              ConnectionState.waiting
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  checkHome = false;
                });
                _con.getNews(context);
                setState(() {
                  checkHome = true;
                });
              },
              child: (checkHome)
                  ? Container(
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
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(15),
                              child: Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Hello, Tasfique Enam',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    // fontSize: FontConstants.fontMediumSize
                                  ),
                                ),
                              ),
                            ),
                            // CHART and BAR GRAPHS VIEW
                            GestureDetector(
                              onHorizontalDragEnd: (DragEndDetails details) {
                                if (details.primaryVelocity > 0) {
                                  setState(() {
                                    if (chartIndex == 0)
                                      chartIndex = 2;
                                    else
                                      chartIndex -= 1;
                                  });
                                } else if (details.primaryVelocity < 0) {
                                  setState(() {
                                    if (chartIndex == 2)
                                      chartIndex = 0;
                                    else
                                      chartIndex += 1;
                                  });
                                }
                              },
                              child: Container(
                                width: screenSize.size.width,
                                height: screenSize.size.height * 0.6,
                                // height: 500,
                                padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                                child: Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: GestureDetector(
                                        child: BouncingWidget(
                                          scaleFactor: 1.5,
                                          onPressed: () {
                                            setState(() {
                                              if (chartIndex == 0)
                                                chartIndex = 2;
                                              else
                                                chartIndex -= 1;
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
                                    chartIndex == 0
                                        ? Center(
                                            child: Column(children: [
                                              Container(
                                                height: screenSize.size.height *
                                                    0.5,
                                                width:
                                                    screenSize.size.width * 0.9,
                                                padding: EdgeInsets.all(10),
                                                //Pie chart here.
                                                child: PieChart(
                                                  dataMap: {
                                                    " Week 1 ": 5,
                                                    " Week 2 ": 3,
                                                    " Week 3 ": 2,
                                                    " Week 4 ": 2,
                                                  },

                                                  animationDuration: Duration(
                                                      milliseconds: 700),
                                                  chartLegendSpacing: 20,
                                                  // chartRadius:
                                                  //     MediaQuery.of(context).size.width / 2,
                                                  colorList: [
                                                    Colors.red,
                                                    Colors.green,
                                                    Colors.blue,
                                                    Colors.yellow,
                                                  ],
                                                  initialAngleInDegree: 0,
                                                  // chartType: ChartType.disc,
                                                  // ringStrokeWidth: 50,
                                                  // centerText: "Performance",
                                                  legendOptions: LegendOptions(
                                                    showLegendsInRow: true,
                                                    legendPosition:
                                                        LegendPosition.bottom,
                                                    showLegends: true,
                                                    // legendShape: _BoxShape.circle,
                                                    legendTextStyle: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        wordSpacing: 10,
                                                        fontSize: 18),
                                                  ),
                                                  chartValuesOptions:
                                                      ChartValuesOptions(
                                                    chartValueStyle: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.black,
                                                        backgroundColor:
                                                            Colors.transparent),
                                                    showChartValueBackground:
                                                        true,
                                                    showChartValues: true,
                                                    showChartValuesInPercentage:
                                                        false,
                                                    // showChartValuesOutside: false,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                padding: EdgeInsets.only(
                                                    top:
                                                        screenSize.size.height *
                                                            0.02),
                                                width: screenSize.size.width,
                                                alignment: Alignment.center,
                                                child: Text(
                                                    "Weekly Performance Achievement",
                                                    // TODO: replace this Weekly performance achievment for May 2021"
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                    )),
                                              )
                                            ]),
                                          )
                                        : chartIndex == 1
                                            ? FutureBuilder(
                                                future: declare(),
                                                builder: (context, snapshot) =>
                                                    snapshot.connectionState ==
                                                            ConnectionState
                                                                .waiting
                                                        ? Center(
                                                            child:
                                                                CircularProgressIndicator())
                                                        : Center(
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                Container(
                                                                  padding: EdgeInsets
                                                                      .fromLTRB(
                                                                          15,
                                                                          0,
                                                                          15,
                                                                          0),
                                                                  width: screenSize
                                                                          .size
                                                                          .width *
                                                                      0.9,
                                                                  child:
                                                                      Container(
                                                                    child:
                                                                        SizedBox(
                                                                      height: screenSize
                                                                              .size
                                                                              .height *
                                                                          0.5,
                                                                      //Barchart here
                                                                      child: charts
                                                                          .BarChart(
                                                                        series,
                                                                        animate:
                                                                            true,
                                                                        vertical:
                                                                            false,
                                                                        animationDuration:
                                                                            Duration(milliseconds: 700),
                                                                        // defaultRenderer: charts.BarRendererConfig(strokeWidthPx: 20.0),
                                                                        barRendererDecorator:
                                                                            new charts.BarLabelDecorator<String>(
                                                                          labelPosition: charts
                                                                              .BarLabelPosition
                                                                              .outside,
                                                                          labelPadding:
                                                                              0,
                                                                          // insideLabelStyleSpec:
                                                                          //     charts.TextStyleSpec(
                                                                          //   fontSize:
                                                                          //       20,
                                                                          //   color:
                                                                          //       charts.Color.black,
                                                                          // ),
                                                                          outsideLabelStyleSpec:
                                                                              new charts.TextStyleSpec(
                                                                            fontSize:
                                                                                14,
                                                                            color:
                                                                                charts.Color.white,
                                                                          ),
                                                                        ),
                                                                        selectionModels: [
                                                                          new charts.SelectionModelConfig(changedListener:
                                                                              (charts.SelectionModel model) {
                                                                            print(model.selectedSeries[0].measureFn(model.selectedDatum[0].index));
                                                                            print(model.selectedSeries[0].domainFn(model.selectedDatum[0].index));
                                                                            print(model.selectedDatum[0].index);
                                                                            if (model.selectedSeries[0].measureFn(model.selectedDatum[0].index) !=
                                                                                0)
                                                                              Navigator.push(context, MaterialPageRoute(builder: (context) => ProspectBreakDownView(model.selectedSeries[0].measureFn(model.selectedDatum[0].index), model.selectedDatum[0].index)));
                                                                          })
                                                                        ],
                                                                        domainAxis:
                                                                            new charts.OrdinalAxisSpec(
                                                                          renderSpec:
                                                                              new charts.SmallTickRendererSpec(
                                                                            labelStyle:
                                                                                new charts.TextStyleSpec(fontSize: 16, color: charts.MaterialPalette.white),
                                                                            lineStyle:
                                                                                new charts.LineStyleSpec(color: charts.MaterialPalette.white),
                                                                          ),
                                                                        ),
                                                                        primaryMeasureAxis:
                                                                            new charts.NumericAxisSpec(
                                                                          renderSpec:
                                                                              new charts.GridlineRendererSpec(
                                                                            labelStyle:
                                                                                new charts.TextStyleSpec(fontSize: 16, color: charts.MaterialPalette.white),
                                                                            lineStyle:
                                                                                new charts.LineStyleSpec(color: charts.MaterialPalette.white),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Container(
                                                                  padding: EdgeInsets.only(
                                                                      top: screenSize
                                                                              .size
                                                                              .height *
                                                                          0.023),
                                                                  width:
                                                                      screenSize
                                                                          .size
                                                                          .width,
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  child: Text(
                                                                      "Monthly Performance Achievement",
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            20,
                                                                      )),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                              )
                                            : Center(
                                                // TODO: line graph
                                                child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Container(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            15, 0, 15, 0),
                                                    width:
                                                        screenSize.size.width *
                                                            0.9,
                                                    child: Container(
                                                      child: SizedBox(
                                                        height: screenSize
                                                                .size.height *
                                                            0.5,
                                                        //Barchart here
                                                        child: charts
                                                            .TimeSeriesChart(
                                                          series2,
                                                          animate: true,
                                                          animationDuration:
                                                              Duration(
                                                                  milliseconds:
                                                                      700),
                                                          dateTimeFactory:
                                                              const charts
                                                                  .LocalDateTimeFactory(),
                                                          // domainAxis: new charts
                                                          //     .OrdinalAxisSpec(
                                                          //   renderSpec: new charts
                                                          //       .SmallTickRendererSpec(
                                                          //     labelStyle: new charts
                                                          //             .TextStyleSpec(
                                                          //         fontSize: 16,
                                                          //         color: charts
                                                          //             .MaterialPalette
                                                          //             .white),
                                                          //     lineStyle: new charts
                                                          //             .LineStyleSpec(
                                                          //         color: charts
                                                          //             .MaterialPalette
                                                          //             .white),
                                                          //   ),
                                                          // ),
                                                          primaryMeasureAxis:
                                                              new charts
                                                                  .NumericAxisSpec(
                                                            renderSpec: new charts
                                                                .GridlineRendererSpec(
                                                              labelStyle: new charts
                                                                      .TextStyleSpec(
                                                                  fontSize: 16,
                                                                  color: charts
                                                                      .MaterialPalette
                                                                      .white),
                                                              lineStyle: new charts
                                                                      .LineStyleSpec(
                                                                  color: charts
                                                                      .MaterialPalette
                                                                      .white),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.only(
                                                        top: screenSize
                                                                .size.height *
                                                            0.023),
                                                    width:
                                                        screenSize.size.width,
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                        "Yearly Performance Achievement",
                                                        style: TextStyle(
                                                          fontSize: 20,
                                                        )),
                                                  )
                                                ],
                                              )),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: GestureDetector(
                                        child: BouncingWidget(
                                          scaleFactor: 1.5,
                                          onPressed: () {
                                            setState(() {
                                              if (chartIndex == 2)
                                                chartIndex = 0;
                                              else
                                                chartIndex += 1;
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
                            ),
                            // BAR GRAPH OF POINTS TO GO AREA
                            Padding(
                              padding: EdgeInsets.fromLTRB(20, 15, 20, 20),
                              child: new LinearPercentIndicator(
                                width: screenSize.size.width - 40,
                                animation: true,
                                lineHeight: 30.0,
                                animationDuration: 700,
                                percent: 0.65,
                                center: Text("35 points to go!",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                    )),
                                linearStrokeCap: LinearStrokeCap.butt,
                                progressColor: Colors.yellowAccent,
                              ),
                            ),
                            // CARDS
                            FutureBuilder(
                              future: _con.getProspectCard(context),
                              builder: (context, snapshot) => snapshot
                                          .connectionState ==
                                      ConnectionState.waiting
                                  ? Center(child: CircularProgressIndicator())
                                  : Container(
                                      padding:
                                          EdgeInsets.fromLTRB(16, 0, 16, 0),
                                      height: screenSize.size.height * 0.23,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: _con.prospectCardList.length,
                                        itemBuilder: (context, index) {
                                          return Container(
                                            alignment: Alignment.center,
                                            width: screenSize.size.width * 0.5,
                                            child: prospectCard(
                                                _con.prospectCardList[index]),
                                          );
                                        },
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Center(
                      child: CircularProgressIndicator(),
                    ),
            ),
    );
  }

  Widget prospectCard(Prospect oneProspect) {
    int intValue = oneProspect.steps['length'] - 1;

    return Card(
      color: Colors.amber[50],
      child: Padding(
        padding: EdgeInsets.only(top: 8.0, right: 8, left: 8, bottom: 3),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            ListTile(
              title: Text(
                oneProspect.prospectName,
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              subtitle: Padding(
                padding: EdgeInsets.only(top: 5),
                child: Text(
                  (DateFormat('HH:mm').format(
                                  DateTime.parse(oneProspect.lastUpdate)) !=
                              '00:00'
                          ? DateFormat('dd/MM/yyyy HH:mm')
                              .format(DateTime.parse(oneProspect.lastUpdate))
                          : DateFormat('dd/MM/yyyy')
                              .format(DateTime.parse(oneProspect.lastUpdate))) +
                      (oneProspect.steps['${intValue}meetingPlace'] == ''
                          ? '\n\n'
                          : '\nMeeting at ${oneProspect.steps["${intValue}meetingPlace"]}\n'),
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                ),
              ),
            ),
            TextButton(
              child: const Text('More Info..'),
              onPressed: () async {
                final pushPage4 = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProspectView(oneProspect)));
                if (pushPage4) {
                  setState(() {
                    checkProspect = false;
                  });
                  _con.getProspectCard(context);
                  setState(() {
                    checkProspect = true;
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget prospect() {
    return FutureBuilder(
      future: _con.getProspect(context),
      builder: (context, snapshot) => snapshot.connectionState ==
              ConnectionState.waiting
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  checkProspect = false;
                });
                _con.getNews(context);
                setState(() {
                  checkProspect = true;
                });
              },
              child: (checkProspect)
                  ? Container(
                      padding:
                          EdgeInsets.only(left: 10.0, right: 10.0, top: 15.0),
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: _con.prospectList.length,
                            itemBuilder: (context, index) {
                              if (index == 0) {
                                return Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(left: 10),
                                          child: Container(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              "Prospects",
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(right: 10),
                                          child: Row(
                                            children: [
                                              IconButton(
                                                  highlightColor: Colors.white,
                                                  color: Colors.white,
                                                  iconSize: 25,
                                                  icon: Icon(
                                                      _con.sort == 'up'
                                                          ? Icons.arrow_upward
                                                          : Icons
                                                              .arrow_downward,
                                                      color: Colors.white),
                                                  onPressed: () {
                                                    setState(() {
                                                      if (_con.sort == 'up')
                                                        _con.sort = 'down';
                                                      else
                                                        _con.sort = 'up';
                                                    });
                                                  }),
                                              DropdownButton<String>(
                                                value: _con.dropdownValue,
                                                icon: const Icon(
                                                    Icons.sort_rounded),
                                                iconSize: 24,
                                                dropdownColor: Colors.grey[800],
                                                iconEnabledColor: Colors.white,
                                                elevation: 16,
                                                style: const TextStyle(
                                                    color: Colors.white),
                                                underline: Container(
                                                  height: 2,
                                                  color: Colors.white,
                                                ),
                                                onChanged: (String newValue) {
                                                  setState(() {
                                                    _con.dropdownValue =
                                                        newValue;
                                                  });
                                                },
                                                items: <String>[
                                                  'Sort by Time',
                                                  'Sort by Step',
                                                ].map<DropdownMenuItem<String>>(
                                                    (String value) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: value,
                                                    child: Text(value),
                                                  );
                                                }).toList(),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 15),
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: prospectItemCard(
                                            _con.prospectList[index]),
                                      ),
                                    )
                                  ],
                                );
                              } else if (index ==
                                  _con.prospectList.length - 1) {
                                return Padding(
                                  padding: EdgeInsets.only(top: 15, bottom: 52),
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: prospectItemCard(
                                        _con.prospectList[index]),
                                  ),
                                );
                              } else {
                                return Padding(
                                  padding: EdgeInsets.only(top: 15),
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: prospectItemCard(
                                        _con.prospectList[index]),
                                  ),
                                );
                              }
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                right: 8, left: 8, bottom: 8),
                            child: FloatingActionButton(
                              onPressed: () async {
                                final pushP = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AddProspect()));
                                if (pushP) {
                                  setState(() {
                                    checkProspect = false;
                                  });
                                  await _con.getProspect(context);
                                  setState(() {
                                    checkProspect = true;
                                  });
                                }
                              },
                              child: Icon(
                                Icons.add,
                                size: 40,
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  : Center(
                      child: CircularProgressIndicator(),
                    ),
            ),
    );
  }

  Widget prospectItemCard(Prospect oneProspect) {
    int intValue = oneProspect.steps['length'] - 1;
    // String neededValue = oneProspect.steps['$intValue'];
    return GestureDetector(
      onTap: () async {
        final pushPage3 = await Navigator.push(context,
            MaterialPageRoute(builder: (context) => ProspectView(oneProspect)));
        if (pushPage3) {
          setState(() {
            checkProspect = false;
          });
          _con.getProspect(context);
          setState(() {
            checkProspect = true;
          });
        }
      },
      child: Card(
        color: Colors.amber[50],
        child: Padding(
          padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        oneProspect.prospectName,
                        // overflow: TextOverflow.ellipsis,
                        // maxLines: 1,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    child: const Icon(
                      Icons.edit,
                      size: 30,
                      color: Colors.brown,
                    ),
                    onPressed: () async {
                      final pushPage2 = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditProspect(oneProspect)));
                      if (pushPage2) {
                        setState(() {
                          checkProspect = false;
                        });
                        _con.getProspect(context);
                        setState(() {
                          checkProspect = true;
                        });
                      }
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  // Expanded(
                  // flex: 1,
                  // child:
                  Container(
                    padding: EdgeInsets.only(left: 10, top: 5),
                    child: Text(
                      oneProspect.type,
                      // overflow: TextOverflow.ellipsis,
                      // maxLines: 1,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  // ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.only(left: 50),
                      child: Text(
                        oneProspect.steps['${intValue}meetingPlace'] == ''
                            ? ''
                            : 'Meeting at ${oneProspect.steps["${intValue}meetingPlace"]}',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                        // overflow: TextOverflow.ellipsis,
                        // maxLines: 2,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.only(left: 10, top: 5),
                      child: Text(
                        oneProspect.steps['$intValue'],
                        // overflow: TextOverflow.ellipsis,
                        // maxLines: 2,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        intValue == 0
                            ? 'Created at ' +
                                DateFormat('dd/MM/yyyy HH:mm').format(
                                    DateTime.parse(oneProspect.lastUpdate))
                            : DateFormat('HH:mm').format(DateTime.parse(
                                        oneProspect.lastUpdate)) !=
                                    '00:00'
                                ? 'Date\n' +
                                    DateFormat('dd/MM/yyyy HH:mm').format(
                                        DateTime.parse(oneProspect.lastUpdate))
                                : 'Date\n' +
                                    DateFormat('dd/MM/yyyy').format(
                                        DateTime.parse(oneProspect.lastUpdate))

                        //     DateFormat('dd/MM/yyyy HH:mm')
                        // .format(DateTime.parse(oneNew.newsId))
                        // +
                        // Prospect.prospectSchedules[i]
                        //     .toString()
                        //     .substring(11, 16) +
                        // "\n" +
                        // Prospect.prospectLocations[i]
                        ,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // ButtonBar(
              //   children: <Widget>[
              //     FlatButton(
              //       child: const Icon(
              //         Icons.edit,
              //         size: 30,
              //       ),
              //       onPressed: () {
              //         Navigator.push(
              //             context,
              //             MaterialPageRoute(
              //                 builder: (context) => EditProspectStateless()));
              //       },
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }

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
                                        fontWeight: FontWeight.bold,
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
