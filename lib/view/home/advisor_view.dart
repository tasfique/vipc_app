import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:vipc_app/controller/home/advisor_controller.dart';
import 'package:vipc_app/model/chart_data.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter_gradient_colors/flutter_gradient_colors.dart';
import 'package:vipc_app/model/line_graph.dart';
import 'package:vipc_app/model/news.dart';
import 'package:vipc_app/model/pie_chart.dart';
import 'package:vipc_app/view/news/news_details_view.dart';
import 'package:vipc_app/model/prospect.dart';
import 'package:vipc_app/view/notifications/advisor_notification_view.dart';
import 'package:vipc_app/view/prospect/prospect_add.dart';
import 'package:vipc_app/view/prospect/prospect_breakdown_view.dart';
import 'package:vipc_app/view/prospect/prospect_edit.dart';
import 'package:vipc_app/view/prospect/prospect_view.dart';
import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:vipc_app/view/search/advisor_search_view.dart';

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
  var series, series2, series3;
  bool checkPieChart = false;
  bool checkBarChart = false;

  Future<void> declare() async {
    await _con.getMonthlyPoint(context);
    for (int i = 0; i < _con.monthlyPoint.length; i++)
      if (_con.monthlyPoint[i] != 0) checkBarChart = true;
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

  Future<void> declareLineGraph() async {
    await _con.getRangePoint(context);
    series2 = [
      charts.Series(
        domainFn: (YearlyPointLineGraph clickData, _) => clickData.time,
        measureFn: (YearlyPointLineGraph clickData, _) => clickData.point,
        colorFn: (YearlyPointLineGraph clickData, _) => clickData.color,
        id: 'time',
        data: [
          for (int i = 0; i <= _con.numIndex; i++)
            YearlyPointLineGraph(
                _con.rangeTime[i],
                _con.rangePoint[
                    '${DateFormat('MM/yyyy').format(DateTime(_con.rangeTime[i].year, _con.rangeTime[i].month, 1, 0, 0, 0))}'],
                Colors.yellow),
          // YearlyPointLineGraph(new DateTime(2012, 04, 4), 30, Colors.yellow),
          // YearlyPointLineGraph(new DateTime(2012, 06, 01), 100, Colors.yellow),
          // YearlyPointLineGraph(new DateTime(2012, 05, 9), 80, Colors.yellow),
          // YearlyPointLineGraph(new DateTime(2012, 06, 10), 50, Colors.yellow),
          // YearlyPointLineGraph(new DateTime(2012, 07, 4), 30, Colors.yellow),
          // YearlyPointLineGraph(new DateTime(2012, 10, 01), 100, Colors.yellow),
          // YearlyPointLineGraph(new DateTime(2012, 11, 9), 80, Colors.yellow),
          // YearlyPointLineGraph(new DateTime(2013, 05, 10), 50, Colors.yellow),
        ],
      )
    ];
  }

  Future<void> declarePieChart() async {
    await _con.getWeeklyPoint(context);
    for (int i = 0; i < _con.weeklyPoint.length; i++)
      if (_con.weeklyPoint[i] != 0) checkPieChart = true;
    series3 = [
      charts.Series(
          domainFn: (WeeklyPointPieChart clickData, _) => clickData.week,
          measureFn: (WeeklyPointPieChart clickData, _) => clickData.point,
          colorFn: (WeeklyPointPieChart clickData, _) => clickData.color,
          id: 'week',
          data: [
            WeeklyPointPieChart(
                " 01-07 " + DateFormat('MMMM').format(DateTime.now()),
                _con.weeklyPoint[0],
                Colors.red),
            WeeklyPointPieChart(
                " 15-21 " + DateFormat('MMMM').format(DateTime.now()),
                _con.weeklyPoint[2],
                Colors.blue),
            WeeklyPointPieChart(
                " 08-14 " + DateFormat('MMMM').format(DateTime.now()),
                _con.weeklyPoint[1],
                Colors.green),
            WeeklyPointPieChart(
                " 22-" +
                    DateTime(DateTime.now().year, DateTime.now().month + 1, 0)
                        .day
                        .toString() +
                    ' ' +
                    DateFormat('MMMM').format(DateTime.now()),
                _con.weeklyPoint[3],
                Colors.orangeAccent),
            // YearlyPointLineGraph(new DateTime(2012, 07, 4), 30, Colors.yellow),
            // YearlyPointLineGraph(new DateTime(2012, 10, 01), 100, Colors.yellow),
            // YearlyPointLineGraph(new DateTime(2012, 11, 9), 80, Colors.yellow),
            // YearlyPointLineGraph(new DateTime(2013, 05, 10), 50, Colors.yellow),
          ],
          labelAccessorFn: (WeeklyPointPieChart row, _) =>
              row.point != 0 ? '${row.point}' : ''),
    ];
  }

  Future<void> saveTokenToDatabase(String token) async {
    String userId = FirebaseAuth.instance.currentUser.uid;

    await FirebaseFirestore.instance
        .collection('users')
        .where('token', isEqualTo: token)
        .get()
        .then((value) {
      value.docs.forEach((element) async {
        if (element.id != userId)
          await FirebaseFirestore.instance
              .collection('users')
              .doc(element.id)
              .update({'token': ''});
      });
    });

    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'token': token,
    });
  }

  _saveDeviceToken() async {
    String token = await FirebaseMessaging.instance.getToken();
    await saveTokenToDatabase(token);
    FirebaseMessaging.instance.onTokenRefresh.listen(saveTokenToDatabase);
    // String fcmToken = await _fcm.getToken();
  }

  @override
  void initState() {
    _con.selectedIndex = 0;
    chartIndex = 0;
    _con.newsList = [];
    _saveDeviceToken();

    // _con.getProspect(context);
    // _con.getTodayMeeting(context);
    // _con.getMeetingCount(context);
    for (int i = 0; i < 4; i++) _con.weeklyPoint.add(0);
    for (int i = 0; i < 12; i++) _con.monthlyPoint.add(0);
    super.initState();
  }

  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context);
    return Scaffold(
      appBar: appBarWidget(),
      // appBar: CustomAppBar(),
      // drawer: CustomDrawer(),
      drawer: FutureBuilder(
          future: _con.getAdvisorDetail(),
          builder: (context, snapshot) =>
              snapshot.connectionState == ConnectionState.waiting
                  ? Center(child: CircularProgressIndicator())
                  : _drawer()),
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
    // _con.getMeetingCount(context);
    return FutureBuilder(
      future: _con.getAdvisorDetail(),
      builder: (context, snapshot) => snapshot.connectionState ==
              ConnectionState.waiting
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  checkHome = false;
                });
                // _con.getNews(context);
                await _con.getAdvisorDetail();
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
                                  'Hello, ' + _con.advisorDetail.fullName,
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
                                        ? FutureBuilder(
                                            future: declarePieChart(),
                                            // _con.getWeeklyPoint(context),
                                            builder: (context, snapshot) =>
                                                snapshot.connectionState ==
                                                        ConnectionState.waiting
                                                    ? Center(
                                                        child:
                                                            CircularProgressIndicator())
                                                    : Center(
                                                        child: Column(
                                                            children: [
                                                              checkPieChart
                                                                  ? Container(
                                                                      height: screenSize
                                                                              .size
                                                                              .height *
                                                                          0.5,
                                                                      width: screenSize
                                                                              .size
                                                                              .width *
                                                                          0.9,
                                                                      // padding:
                                                                      //     EdgeInsets.only(
                                                                      //         left: 10,
                                                                      //         right: 10),
                                                                      //Pie chart here.
                                                                      child: charts
                                                                          .PieChart(
                                                                        series3,
                                                                        animate:
                                                                            true,
                                                                        animationDuration:
                                                                            Duration(milliseconds: 700),
                                                                        defaultRenderer:
                                                                            charts.ArcRendererConfig(
                                                                          arcRendererDecorators: [
                                                                            new charts.ArcLabelDecorator(
                                                                                insideLabelStyleSpec: charts.TextStyleSpec(
                                                                                  fontSize: 20,
                                                                                  color: charts.Color.white,
                                                                                ),
                                                                                labelPosition: charts.ArcLabelPosition.inside)
                                                                          ],
                                                                        ),
                                                                        selectionModels: [
                                                                          new charts.SelectionModelConfig(changedListener:
                                                                              (charts.SelectionModel model) {
                                                                            if (model.selectedSeries[0].measureFn(model.selectedDatum[0].index) !=
                                                                                0)
                                                                              Navigator.push(context, MaterialPageRoute(builder: (context) => ProspectBreakDownView(model.selectedSeries[0].measureFn(model.selectedDatum[0].index), model.selectedDatum[0].index, checkWeek: 'week')));
                                                                          })
                                                                        ],
                                                                        behaviors: [
                                                                          new charts
                                                                              .DatumLegend(
                                                                            outsideJustification:
                                                                                charts.OutsideJustification.middleDrawArea,
                                                                            position:
                                                                                charts.BehaviorPosition.bottom,
                                                                            horizontalFirst:
                                                                                false,
                                                                            desiredMaxRows:
                                                                                2,
                                                                            cellPadding:
                                                                                new EdgeInsets.only(
                                                                              left: 20,
                                                                              bottom: 7,
                                                                            ),
                                                                            entryTextStyle:
                                                                                charts.TextStyleSpec(
                                                                              fontSize: 20,
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    )
                                                                  : Container(
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      height: screenSize
                                                                              .size
                                                                              .height *
                                                                          0.5,
                                                                      width: screenSize
                                                                              .size
                                                                              .width *
                                                                          0.9,
                                                                      child:
                                                                          Text(
                                                                        // 'No Point Earned So Far',
                                                                        "No Data Available To Display",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                20,
                                                                            color:
                                                                                Colors.amber),
                                                                      )),
                                                              Container(
                                                                padding: EdgeInsets.only(
                                                                    top: screenSize
                                                                            .size
                                                                            .height *
                                                                        0.02),
                                                                width:
                                                                    screenSize
                                                                        .size
                                                                        .width,
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: Text(
                                                                    "Weekly Performance Achievement\nFor " +
                                                                        DateFormat('yMMMM').format(DateTime
                                                                            .now()),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          20,
                                                                    )),
                                                              )
                                                            ]),
                                                      ))
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
                                                                checkBarChart
                                                                    ? Container(
                                                                        padding: EdgeInsets.fromLTRB(
                                                                            15,
                                                                            0,
                                                                            15,
                                                                            0),
                                                                        width: screenSize.size.width *
                                                                            0.9,
                                                                        child:
                                                                            Container(
                                                                          child:
                                                                              SizedBox(
                                                                            height:
                                                                                screenSize.size.height * 0.5,
                                                                            //Barchart here
                                                                            child:
                                                                                charts.BarChart(
                                                                              series,
                                                                              animate: true,
                                                                              vertical: false,
                                                                              animationDuration: Duration(milliseconds: 700),
                                                                              // defaultRenderer: charts.BarRendererConfig(strokeWidthPx: 20.0),
                                                                              barRendererDecorator: new charts.BarLabelDecorator<String>(
                                                                                labelPosition: charts.BarLabelPosition.inside,
                                                                                // labelPadding: 0,
                                                                                labelAnchor: charts.BarLabelAnchor.end,

                                                                                insideLabelStyleSpec: charts.TextStyleSpec(
                                                                                  fontSize: 18,
                                                                                  color: charts.Color.black,
                                                                                ),
                                                                                // outsideLabelStyleSpec: new charts.TextStyleSpec(
                                                                                //   fontSize: 12,
                                                                                //   color: charts.Color.white,
                                                                                // ),
                                                                              ),
                                                                              selectionModels: [
                                                                                new charts.SelectionModelConfig(changedListener: (charts.SelectionModel model) {
                                                                                  if (model.selectedSeries[0].measureFn(model.selectedDatum[0].index) != 0) Navigator.push(context, MaterialPageRoute(builder: (context) => ProspectBreakDownView(model.selectedSeries[0].measureFn(model.selectedDatum[0].index), model.selectedDatum[0].index)));
                                                                                })
                                                                              ],
                                                                              domainAxis: new charts.OrdinalAxisSpec(
                                                                                renderSpec: new charts.SmallTickRendererSpec(
                                                                                  labelStyle: new charts.TextStyleSpec(fontSize: 16, color: charts.MaterialPalette.white),
                                                                                  lineStyle: new charts.LineStyleSpec(color: charts.MaterialPalette.white),
                                                                                ),
                                                                              ),
                                                                              primaryMeasureAxis: new charts.NumericAxisSpec(
                                                                                renderSpec: new charts.GridlineRendererSpec(
                                                                                  labelStyle: new charts.TextStyleSpec(fontSize: 16, color: charts.MaterialPalette.white),
                                                                                  lineStyle: new charts.LineStyleSpec(color: charts.MaterialPalette.white),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      )
                                                                    : Container(
                                                                        alignment:
                                                                            Alignment
                                                                                .center,
                                                                        padding: EdgeInsets.fromLTRB(
                                                                            15,
                                                                            0,
                                                                            15,
                                                                            0),
                                                                        width: screenSize.size.width *
                                                                            0.9,
                                                                        height: screenSize.size.height *
                                                                            0.5,
                                                                        child:
                                                                            Text(
                                                                          // 'No Point Earned So Far',
                                                                          "No Data Available To Display",
                                                                          style: TextStyle(
                                                                              fontSize: 20,
                                                                              color: Colors.amber),
                                                                        )),
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
                                                child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        'From:',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      TextButton(
                                                          child: _con.fromDate ==
                                                                  null
                                                              ? Icon(Icons
                                                                  .date_range)
                                                              : Text(DateFormat(
                                                                      'yMMMM')
                                                                  .format(_con
                                                                      .fromDate)
                                                                  .toString()),
                                                          // icon: Icon(Icons.add),
                                                          onPressed: () {
                                                            showMonthPicker(
                                                              context: context,
                                                              firstDate: _con
                                                                  .minimumDate,
                                                              lastDate:
                                                                  _con.toDate ==
                                                                          null
                                                                      ? DateTime
                                                                          .now()
                                                                      : _con
                                                                          .toDate,
                                                              initialDate:
                                                                  DateTime
                                                                      .now(),
                                                              locale:
                                                                  Locale("en"),
                                                            ).then((date) {
                                                              if (date !=
                                                                  null) {
                                                                setState(() {
                                                                  _con.fromDate =
                                                                      date;
                                                                });
                                                              }
                                                            });
                                                          }),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text(
                                                        'To:',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      TextButton(
                                                          child: _con.toDate ==
                                                                  null
                                                              ? Icon(Icons
                                                                  .date_range)
                                                              : Text(DateFormat(
                                                                      'yMMMM')
                                                                  .format(_con
                                                                      .toDate)
                                                                  .toString()),
                                                          // icon: Icon(Icons.add),
                                                          onPressed: () {
                                                            showMonthPicker(
                                                              context: context,
                                                              firstDate: _con
                                                                          .fromDate ==
                                                                      null
                                                                  ? _con
                                                                      .minimumDate
                                                                  : _con
                                                                      .fromDate,
                                                              lastDate: DateTime
                                                                  .now(),
                                                              initialDate:
                                                                  DateTime
                                                                      .now(),
                                                              locale:
                                                                  Locale("en"),
                                                            ).then((date) {
                                                              if (date !=
                                                                  null) {
                                                                setState(() {
                                                                  _con.toDate =
                                                                      date;
                                                                });
                                                              }
                                                            });
                                                          }),
                                                    ],
                                                  ),
                                                  (_con.fromDate != null &&
                                                          _con.toDate != null)
                                                      ? Container(
                                                          padding: EdgeInsets
                                                              .fromLTRB(
                                                                  15, 0, 15, 0),
                                                          width: screenSize
                                                                  .size.width *
                                                              0.9,
                                                          child: Container(
                                                            child: SizedBox(
                                                              height: screenSize
                                                                      .size
                                                                      .height *
                                                                  0.45,
                                                              //line graph here
                                                              child: _con.fromDate !=
                                                                          null &&
                                                                      _con.toDate !=
                                                                          null
                                                                  ? FutureBuilder(
                                                                      future:
                                                                          declareLineGraph(),
                                                                      builder: (context, snapshot) => snapshot.connectionState ==
                                                                              ConnectionState.waiting
                                                                          ? Center(child: CircularProgressIndicator())
                                                                          : Center(
                                                                              child: charts.TimeSeriesChart(series2,
                                                                                  animate: true,
                                                                                  animationDuration: Duration(milliseconds: 700),
                                                                                  defaultRenderer: charts.LineRendererConfig(
                                                                                    includePoints: true,
                                                                                    includeLine: true,
                                                                                  ),
                                                                                  dateTimeFactory: const charts.LocalDateTimeFactory(),
                                                                                  domainAxis: new charts.DateTimeAxisSpec(
                                                                                    tickFormatterSpec: new charts.AutoDateTimeTickFormatterSpec(
                                                                                      day: new charts.TimeFormatterSpec(format: 'd', transitionFormat: 'MMM yyyy'),
                                                                                      month: new charts.TimeFormatterSpec(
                                                                                        format: 'M',
                                                                                        transitionFormat: 'MMM yyyy',
                                                                                      ),
                                                                                    ),
                                                                                    renderSpec: charts.SmallTickRendererSpec(
                                                                                      axisLineStyle: charts.LineStyleSpec(
                                                                                        thickness: 2,
                                                                                      ),
                                                                                      labelRotation: 30,
                                                                                      tickLengthPx: 4,
                                                                                      minimumPaddingBetweenLabelsPx: 0,
                                                                                      labelStyle: new charts.TextStyleSpec(fontSize: 10, color: charts.MaterialPalette.white),
                                                                                      lineStyle: new charts.LineStyleSpec(color: charts.MaterialPalette.white),
                                                                                    ),
                                                                                  ),
                                                                                  primaryMeasureAxis: new charts.NumericAxisSpec(
                                                                                      renderSpec: charts.GridlineRendererSpec(
                                                                                          labelStyle: new charts.TextStyleSpec(fontSize: 16, color: charts.MaterialPalette.white),
                                                                                          lineStyle: charts.LineStyleSpec(
                                                                                            color: charts.MaterialPalette.white,
                                                                                            dashPattern: [4, 4],
                                                                                          ))))))
                                                                  : SizedBox(),
                                                            ),
                                                          ),
                                                        )
                                                      : Container(
                                                          padding: EdgeInsets
                                                              .fromLTRB(
                                                                  25, 0, 25, 0),
                                                          width: screenSize
                                                                  .size.width *
                                                              0.9,
                                                          height: screenSize
                                                                  .size.height *
                                                              0.45,
                                                          alignment:
                                                              Alignment.center,
                                                          child: Text(
                                                            'Please Select Date Range To Generate The Chart',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                fontSize: 20,
                                                                color: Colors
                                                                    .amber),
                                                          ),
                                                        ),
                                                  Container(
                                                    padding: EdgeInsets.only(
                                                        top: screenSize
                                                                .size.height *
                                                            0.04),
                                                    width:
                                                        screenSize.size.width,
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                        "Performance Achievement In Range",
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
                            chartIndex == 0
                                ? Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(30, 15, 30, 20),
                                    child: FutureBuilder(
                                      future: _con.getWeeklyPoint(context),
                                      builder: (context, snapshot) => snapshot
                                                  .connectionState ==
                                              ConnectionState.waiting
                                          ? SizedBox()
                                          : LinearPercentIndicator(
                                              width: screenSize.size.width - 60,
                                              animation: true,
                                              lineHeight: 30.0,
                                              animationDuration: 700,
                                              percent: _con.currentWeekPoint <
                                                      50
                                                  ? _con.currentWeekPoint / 50.0
                                                  : _con.currentWeekPoint == 50
                                                      ? 1.0
                                                      : _con.currentWeekPoint >
                                                                  50 &&
                                                              _con.currentWeekPoint <
                                                                  100
                                                          ? _con.currentWeekPoint /
                                                              100.0
                                                          : 1.0,
                                              center: Text(
                                                  _con.currentWeekPoint < 50
                                                      ? (50 - _con.currentWeekPoint)
                                                              .toString() +
                                                          ' More Points To Pass'
                                                      : _con.currentWeekPoint ==
                                                              50
                                                          ? 'Congratulation! You Passed.'
                                                          : _con.currentWeekPoint >
                                                                      50 &&
                                                                  _con.currentWeekPoint <
                                                                      100
                                                              ? (100 - _con.currentWeekPoint)
                                                                      .toString() +
                                                                  ' More Points To Reach Standard'
                                                              : 'Standard',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w700,
                                                  )),
                                              linearStrokeCap:
                                                  LinearStrokeCap.roundAll,
                                              progressColor:
                                                  Colors.yellowAccent,
                                            ),
                                    ),
                                  )
                                : chartIndex == 1
                                    ? Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(30, 15, 30, 20),
                                        child: FutureBuilder(
                                          future: _con
                                              .getCurrentMonthPoint(context),
                                          builder: (context, snapshot) =>
                                              snapshot.connectionState ==
                                                      ConnectionState.waiting
                                                  ? SizedBox()
                                                  : LinearPercentIndicator(
                                                      width: screenSize
                                                              .size.width -
                                                          60,
                                                      animation: true,
                                                      lineHeight: 30.0,
                                                      animationDuration: 700,
                                                      percent: _con
                                                                  .currentMonthPoint <
                                                              100
                                                          ? _con.currentMonthPoint /
                                                              100.0
                                                          : _con.currentMonthPoint ==
                                                                  100
                                                              ? 1.0
                                                              : _con.currentMonthPoint >
                                                                          100 &&
                                                                      _con.currentMonthPoint <
                                                                          200
                                                                  ? _con.currentMonthPoint /
                                                                      200.0
                                                                  : 1.0,
                                                      // _con.currentMonthPoint >=
                                                      //         200
                                                      //     ? 1.0
                                                      //     : 1.0,
                                                      center: Text(
                                                          _con.currentMonthPoint <
                                                                  100
                                                              ? (100 - _con.currentMonthPoint)
                                                                      .toString() +
                                                                  ' More Points To Pass'
                                                              : _con.currentMonthPoint ==
                                                                      100
                                                                  ? 'Congratulation! You Passed.'
                                                                  : _con.currentMonthPoint >
                                                                              100 &&
                                                                          _con.currentMonthPoint <
                                                                              200
                                                                      ? (200 - _con.currentMonthPoint)
                                                                              .toString() +
                                                                          ' More Points To Reach Standard'
                                                                      : 'Standard',
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                          )),
                                                      linearStrokeCap:
                                                          LinearStrokeCap
                                                              .roundAll,
                                                      progressColor:
                                                          Colors.yellowAccent,
                                                    ),
                                        ),
                                      )
                                    : SizedBox(),
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
                                      child: _con.prospectCardList.length == 0
                                          ? Container(
                                              child: Text(
                                              '\n\nNo Incoming Meeting',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.amber),
                                            ))
                                          : ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount:
                                                  _con.prospectCardList.length,
                                              itemBuilder: (context, index) {
                                                return Container(
                                                  alignment: Alignment.center,
                                                  width: screenSize.size.width *
                                                      0.5,
                                                  child: prospectCard(_con
                                                      .prospectCardList[index]),
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

  Widget appBarWidget() {
    return AppBar(
      title: const Text('VIPC GROUP'),
      actions: [
        FutureBuilder(
          future: _con.getTodayMeeting(context),
          builder: (context, snapshot) => snapshot.connectionState ==
                  ConnectionState.waiting
              ? Stack(children: [
                  IconButton(
                    padding: EdgeInsets.only(top: 4),
                    tooltip: 'Notifications',
                    icon: const Icon(
                      Icons.notifications,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AdvisorNotificationView()));
                    },
                  ),
                  Container()
                ])
              : Stack(
                  children: [
                    IconButton(
                      padding: EdgeInsets.only(top: 4),
                      tooltip: 'Notifications',
                      icon: const Icon(
                        Icons.notifications,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    AdvisorNotificationView()));
                      },
                    ),
                    _con.meetingCount != 0
                        ? Positioned(
                            right: 11,
                            top: 11,
                            child: Container(
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              constraints: BoxConstraints(
                                minWidth: 14,
                                minHeight: 14,
                              ),
                              child: Text(
                                '${_con.meetingCount}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                        : Container()
                  ],
                ),
        ),
        IconButton(
          tooltip: 'Search',
          icon: const Icon(
            Icons.search,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AdvisorSearchView()));
          },
        ),
      ],
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
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
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
              child: const Text('More Info'),
              onPressed: () async {
                final pushPage4 = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProspectView(oneProspect)));
                if (pushPage4) {
                  setState(() {
                    checkProspect = false;
                  });
                  await _con.getProspectCard(context);
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
                await _con.getProspect(context);
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
          await _con.getProspect(context);
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
                      padding: EdgeInsets.only(
                          left: 10, bottom: 15, top: 8, right: 3),
                      child: Text(
                        oneProspect.prospectName,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text(
                      oneProspect.type,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black54,
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
                        await _con.getProspect(context);
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
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.only(left: 10, bottom: 5),
                      child: Text(
                        oneProspect.steps['${intValue}meetingPlace'] == ''
                            ? ''
                            : 'Meeting at ${oneProspect.steps["${intValue}meetingPlace"]}',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
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
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 10),
                    child: Text(
                      intValue == 0
                          ? 'Created at ' +
                              DateFormat('dd/MM/yyyy').format(
                                  DateTime.parse(oneProspect.lastUpdate))
                          : 'Date:\n' +
                              DateFormat('dd/MM/yyyy').format(
                                  DateTime.parse(oneProspect.lastUpdate)),
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
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
                await _con.getNews(context);
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
                                    child: newsItemCard(_con.newsList[index]),
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return Padding(
                              padding: EdgeInsets.only(top: 15),
                              child: Container(
                                alignment: Alignment.center,
                                child: newsItemCard(_con.newsList[index]),
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

  Widget newsItemCard(News oneNew) {
    return Card(
      color: Colors.amber[50],
      child: Padding(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
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
                      fontWeight: FontWeight.bold,
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
                  child: const Text('Read More...'),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
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

  Widget _drawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(_con.advisorDetail.fullName),
            decoration: BoxDecoration(
              color: Colors.amber,
            ),
            accountEmail: Text(
              _con.advisorDetail.email,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Image.asset(
                ('assets/images/logo.png'),
              ),
            ),
          ),
          ListTile(
            title: Text(
              'Home',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onTap: () {
              Navigator.of(context).pop();
              setState(() {
                _con.selectedIndex = 0;
              });
            },
          ),
          ListTile(
            title: Text(
              'Search',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AdvisorSearchView()));
            },
          ),
          ListTile(
            title: Text(
              'Prospect',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onTap: () {
              Navigator.of(context).pop();
              setState(() {
                _con.selectedIndex = 1;
              });
            },
          ),
          ListTile(
            title: Text(
              'News',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onTap: () {
              Navigator.of(context).pop();
              setState(() {
                _con.selectedIndex = 2;
              });
            },
          ),
          ListTile(
            title: Text('Logout'),
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => new AlertDialog(
                  title: new Text("VIPC Message"),
                  content: new Text("Do you want to log out?"),
                  actions: <Widget>[
                    TextButton(
                      child: Text('No'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: Text('Yes'),
                      onPressed: () async {
                        Navigator.of(context).pop();
                        String userId = FirebaseAuth.instance.currentUser.uid;
                        FirebaseAuth.instance.signOut();
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(userId)
                            .update({'token': ''});
                      },
                    )
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
