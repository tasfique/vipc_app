import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:provider/provider.dart';
import 'package:vipc_app/model/chart_data.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:vipc_app/model/line_graph.dart';
import 'package:vipc_app/model/pie_chart.dart';
import 'package:vipc_app/model/user.dart';
import 'package:vipc_app/controller/monitor/monitor_controller.dart';
import 'package:intl/intl.dart';
import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:vipc_app/view/prospect/prospect_breakdown_view.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class MonitorDetailsView extends StatefulWidget {
  final Usr advisor;
  final int weekPoint;
  final int monthPoint;

  MonitorDetailsView(this.advisor, this.weekPoint, this.monthPoint);

  @override
  _MonitorDetailsViewState createState() => _MonitorDetailsViewState();
}

class _MonitorDetailsViewState extends StateMVC<MonitorDetailsView> {
  _MonitorDetailsViewState() : super(MonitorController()) {
    _con = MonitorController.con;
  }

  MonitorController _con;
  int chartIndex;
  var series, series2, series3, series4;
  bool check = true;
  bool checkHome = true;
  bool checkProspect = true;
  bool checkPieChart = false;
  bool checkPieChartStatus = false;
  bool checkBarChart = false;

  @override
  void initState() {
    chartIndex = 0;
    _con.userId = widget.advisor.userId;
    _con.fromDate = null;
    _con.toDate = null;
    for (int i = 0; i < 4; i++) _con.weeklyPoint.add(0);
    for (int i = 0; i < 12; i++) _con.monthlyPoint.add(0);
    super.initState();
  }

  Future<void> declarePieChartStatus() async {
    await _con.getProspectStatus(context);
    for (int i = 0; i < _con.prospectStatus.length; i++)
      if (_con.prospectStatus[i] != 0) checkPieChartStatus = true;
    series4 = [
      charts.Series(
          domainFn: (WeeklyPointPieChart clickData, _) => clickData.week,
          measureFn: (WeeklyPointPieChart clickData, _) => clickData.point,
          colorFn: (WeeklyPointPieChart clickData, _) => clickData.color,
          id: 'week',
          data: [
            WeeklyPointPieChart(
                'Completed', _con.prospectStatus[0], Colors.green),
            WeeklyPointPieChart(
                'Incompleted', _con.prospectStatus[1], Colors.red),
          ],
          labelAccessorFn: (WeeklyPointPieChart row, _) =>
              row.point != 0 ? '${row.point}' : ''),
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
          ],
          labelAccessorFn: (WeeklyPointPieChart row, _) =>
              row.point != 0 ? '${row.point}' : ''),
    ];
  }

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

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context);
    return WillPopScope(
        onWillPop: () {
          Navigator.pop(context);
          return;
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text('VIPC GROUP'),
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 18, top: 20),
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        'Advisor Detail',
                        style: TextStyle(
                          fontSize: 22,
                          decorationThickness: 1.5,
                          fontWeight: FontWeight.w400,
                          shadows: [
                            Shadow(
                              blurRadius: 10.0,
                              color: Colors.grey,
                              offset: Offset(3.0, 4.0),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 25, right: 25),
                    width: 400,
                    child: Card(
                      semanticContainer: true,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      color: Colors.amber[50],
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              'Name: ${widget.advisor.fullName}',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                fontSize: 22,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            child: Text(
                              'Employee ID: ${widget.advisor.empID}',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                fontSize: 22,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Text('Email: ${widget.advisor.email}',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: TextStyle(
                                    fontSize: 22, color: Colors.black)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 10, bottom: 10, left: 25, right: 25),
                    child: const Divider(
                      height: 20,
                      thickness: 2,
                      indent: 1,
                      endIndent: 1,
                      color: Colors.amber,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 25, right: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Text(
                              DateFormat('MMMM').format(DateTime.now()) +
                                  " Total Points: " +
                                  widget.monthPoint.toString(),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                        100 <= widget.monthPoint
                            ? Container(
                                padding: EdgeInsets.only(bottom: 10),
                                alignment: Alignment.topRight,
                                child: Text(
                                    // widget.monthPoint < 100
                                    //     ? 'Failed'
                                    //     :
                                    100 <= widget.monthPoint &&
                                            widget.monthPoint < 200
                                        ? 'Passed'
                                        : 'Standard',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.amber,
                                      fontWeight: FontWeight.w600,
                                    )),
                              )
                            : SizedBox(),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 25, right: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            DateFormat('MMMM').format(DateTime.now()) +
                                " Weekly Points: " +
                                widget.weekPoint.toString(),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                        50 <= widget.weekPoint
                            ? Container(
                                alignment: Alignment.topRight,
                                child: Text(
                                    // widget.weekPoint < 50
                                    //     ? 'Failed'
                                    //     :
                                    50 <= widget.weekPoint &&
                                            widget.weekPoint < 100
                                        ? 'Passed'
                                        : 'Standard',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.amber,
                                      fontWeight: FontWeight.w600,
                                    )),
                              )
                            : SizedBox(),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 10, bottom: 0, left: 20, right: 20),
                    child: const Divider(
                      height: 20,
                      thickness: 0.5,
                      indent: 1,
                      endIndent: 1,
                      color: Colors.amber,
                    ),
                  ),
                  GestureDetector(
                    onHorizontalDragEnd: (DragEndDetails details) {
                      if (details.primaryVelocity > 0) {
                        setState(() {
                          if (chartIndex == 0)
                            chartIndex = 3;
                          else
                            chartIndex -= 1;
                        });
                      } else if (details.primaryVelocity < 0) {
                        setState(() {
                          if (chartIndex == 3)
                            chartIndex = 0;
                          else
                            chartIndex += 1;
                        });
                      }
                    },
                    child: Container(
                      width: screenSize.size.width,
                      height: screenSize.size.height * 0.6,
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
                                      chartIndex = 3;
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
                                  future: declarePieChartStatus(),
                                  builder: (context, snapshot) => snapshot
                                              .connectionState ==
                                          ConnectionState.waiting
                                      ? Center(
                                          child: CircularProgressIndicator())
                                      : Center(
                                          child: Column(children: [
                                            checkPieChartStatus
                                                ? Container(
                                                    height:
                                                        screenSize.size.height *
                                                            0.5,
                                                    width:
                                                        screenSize.size.width *
                                                            0.9,
                                                    child: charts.PieChart(
                                                      series4,
                                                      animate: true,
                                                      animationDuration:
                                                          Duration(
                                                              milliseconds:
                                                                  700),
                                                      defaultRenderer: charts
                                                          .ArcRendererConfig(
                                                        arcRendererDecorators: [
                                                          new charts
                                                                  .ArcLabelDecorator(
                                                              insideLabelStyleSpec:
                                                                  charts
                                                                      .TextStyleSpec(
                                                                fontSize: 20,
                                                                color: charts
                                                                    .Color
                                                                    .white,
                                                              ),
                                                              labelPosition: charts
                                                                  .ArcLabelPosition
                                                                  .inside)
                                                        ],
                                                      ),
                                                      selectionModels: [
                                                        new charts
                                                                .SelectionModelConfig(
                                                            changedListener:
                                                                (charts.SelectionModel
                                                                    model) {
                                                          if (model
                                                                  .selectedSeries[
                                                                      0]
                                                                  .measureFn(model
                                                                      .selectedDatum[
                                                                          0]
                                                                      .index) !=
                                                              0)
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            ProspectBreakDownView(
                                                                              model.selectedSeries[0].measureFn(model.selectedDatum[0].index),
                                                                              model.selectedDatum[0].index,
                                                                              checkWeek: 'status',
                                                                              usrId: widget.advisor.userId,
                                                                              status: model.selectedSeries[0].domainFn(model.selectedDatum[0].index),
                                                                            )));
                                                        })
                                                      ],
                                                      behaviors: [
                                                        new charts.DatumLegend(
                                                          outsideJustification: charts
                                                              .OutsideJustification
                                                              .middleDrawArea,
                                                          position: charts
                                                              .BehaviorPosition
                                                              .bottom,
                                                          horizontalFirst:
                                                              false,
                                                          desiredMaxRows: 1,
                                                          cellPadding:
                                                              new EdgeInsets
                                                                  .only(
                                                            left: 20,
                                                            bottom: 7,
                                                          ),
                                                          entryTextStyle: charts
                                                              .TextStyleSpec(
                                                            fontSize: 20,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                : Container(
                                                    alignment: Alignment.center,
                                                    height:
                                                        screenSize.size.height *
                                                            0.5,
                                                    width:
                                                        screenSize.size.width *
                                                            0.9,
                                                    child: Text(
                                                      'No Prospect So Far',
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          color: Colors.amber),
                                                    )),
                                          ]),
                                        ))
                              : chartIndex == 1
                                  ? FutureBuilder(
                                      future: declarePieChart(),
                                      // _con.getWeeklyPoint(context),
                                      builder: (context, snapshot) => snapshot
                                                  .connectionState ==
                                              ConnectionState.waiting
                                          ? Center(
                                              child:
                                                  CircularProgressIndicator())
                                          : Center(
                                              child: Column(children: [
                                                checkPieChart
                                                    ? Container(
                                                        height: screenSize
                                                                .size.height *
                                                            0.5,
                                                        width: screenSize
                                                                .size.width *
                                                            0.9,
                                                        child: charts.PieChart(
                                                          series3,
                                                          animate: true,
                                                          animationDuration:
                                                              Duration(
                                                                  milliseconds:
                                                                      700),
                                                          defaultRenderer: charts
                                                              .ArcRendererConfig(
                                                            arcRendererDecorators: [
                                                              new charts
                                                                      .ArcLabelDecorator(
                                                                  insideLabelStyleSpec:
                                                                      charts
                                                                          .TextStyleSpec(
                                                                    fontSize:
                                                                        20,
                                                                    color: charts
                                                                        .Color
                                                                        .white,
                                                                  ),
                                                                  labelPosition:
                                                                      charts
                                                                          .ArcLabelPosition
                                                                          .inside)
                                                            ],
                                                          ),
                                                          selectionModels: [
                                                            new charts
                                                                    .SelectionModelConfig(
                                                                changedListener:
                                                                    (charts.SelectionModel
                                                                        model) {
                                                              if (model
                                                                      .selectedSeries[
                                                                          0]
                                                                      .measureFn(model
                                                                          .selectedDatum[
                                                                              0]
                                                                          .index) !=
                                                                  0)
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (context) => ProspectBreakDownView(
                                                                            model.selectedSeries[0].measureFn(model.selectedDatum[0].index),
                                                                            model.selectedDatum[0].index,
                                                                            checkWeek: 'week',
                                                                            usrId: widget.advisor.userId)));
                                                            })
                                                          ],
                                                          behaviors: [
                                                            new charts
                                                                .DatumLegend(
                                                              outsideJustification: charts
                                                                  .OutsideJustification
                                                                  .middleDrawArea,
                                                              position: charts
                                                                  .BehaviorPosition
                                                                  .bottom,
                                                              horizontalFirst:
                                                                  false,
                                                              desiredMaxRows: 2,
                                                              cellPadding:
                                                                  new EdgeInsets
                                                                      .only(
                                                                left: 20,
                                                                bottom: 7,
                                                              ),
                                                              entryTextStyle: charts
                                                                  .TextStyleSpec(
                                                                fontSize: 20,
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      )
                                                    : Container(
                                                        alignment:
                                                            Alignment.center,
                                                        height: screenSize
                                                                .size.height *
                                                            0.5,
                                                        width: screenSize
                                                                .size.width *
                                                            0.9,
                                                        child: Text(
                                                          'No Point Earned So Far',
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              color:
                                                                  Colors.amber),
                                                        )),
                                                Container(
                                                  padding: EdgeInsets.only(
                                                      top: screenSize
                                                              .size.height *
                                                          0.02),
                                                  width: screenSize.size.width,
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                      "Weekly Performance Achievement\nFor " +
                                                          DateFormat('yMMMM')
                                                              .format(DateTime
                                                                  .now()),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                      )),
                                                )
                                              ]),
                                            ))
                                  : chartIndex == 2
                                      ? FutureBuilder(
                                          future: declare(),
                                          builder: (context, snapshot) => snapshot
                                                      .connectionState ==
                                                  ConnectionState.waiting
                                              ? Center(
                                                  child:
                                                      CircularProgressIndicator())
                                              : Center(
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      checkBarChart
                                                          ? Container(
                                                              padding:
                                                                  EdgeInsets
                                                                      .fromLTRB(
                                                                          15,
                                                                          0,
                                                                          15,
                                                                          0),
                                                              width: screenSize
                                                                      .size
                                                                      .width *
                                                                  0.9,
                                                              child: Container(
                                                                child: SizedBox(
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
                                                                        Duration(
                                                                            milliseconds:
                                                                                700),
                                                                    // defaultRenderer: charts.BarRendererConfig(strokeWidthPx: 20.0),
                                                                    barRendererDecorator:
                                                                        new charts
                                                                            .BarLabelDecorator<String>(
                                                                      labelPosition: charts
                                                                          .BarLabelPosition
                                                                          .inside,
                                                                      // labelPadding: 0,
                                                                      labelAnchor: charts
                                                                          .BarLabelAnchor
                                                                          .end,

                                                                      insideLabelStyleSpec:
                                                                          charts
                                                                              .TextStyleSpec(
                                                                        fontSize:
                                                                            18,
                                                                        color: charts
                                                                            .Color
                                                                            .black,
                                                                      ),
                                                                      // outsideLabelStyleSpec: new charts.TextStyleSpec(
                                                                      //   fontSize: 12,
                                                                      //   color: charts.Color.white,
                                                                      // ),
                                                                    ),
                                                                    selectionModels: [
                                                                      new charts
                                                                          .SelectionModelConfig(changedListener: (charts
                                                                              .SelectionModel
                                                                          model) {
                                                                        if (model.selectedSeries[0].measureFn(model.selectedDatum[0].index) !=
                                                                            0)
                                                                          Navigator.push(
                                                                              context,
                                                                              MaterialPageRoute(builder: (context) => ProspectBreakDownView(model.selectedSeries[0].measureFn(model.selectedDatum[0].index), model.selectedDatum[0].index, usrId: widget.advisor.userId)));
                                                                      })
                                                                    ],
                                                                    domainAxis:
                                                                        new charts
                                                                            .OrdinalAxisSpec(
                                                                      renderSpec:
                                                                          new charts
                                                                              .SmallTickRendererSpec(
                                                                        labelStyle: new charts.TextStyleSpec(
                                                                            fontSize:
                                                                                16,
                                                                            color:
                                                                                charts.MaterialPalette.white),
                                                                        lineStyle:
                                                                            new charts.LineStyleSpec(color: charts.MaterialPalette.white),
                                                                      ),
                                                                    ),
                                                                    primaryMeasureAxis:
                                                                        new charts
                                                                            .NumericAxisSpec(
                                                                      renderSpec:
                                                                          new charts
                                                                              .GridlineRendererSpec(
                                                                        labelStyle: new charts.TextStyleSpec(
                                                                            fontSize:
                                                                                16,
                                                                            color:
                                                                                charts.MaterialPalette.white),
                                                                        lineStyle:
                                                                            new charts.LineStyleSpec(color: charts.MaterialPalette.white),
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
                                                              padding:
                                                                  EdgeInsets.fromLTRB(
                                                                      15, 0, 15, 0),
                                                              width: screenSize
                                                                      .size
                                                                      .width *
                                                                  0.9,
                                                              height: screenSize
                                                                      .size
                                                                      .height *
                                                                  0.5,
                                                              child: Text(
                                                                'No Point Earned So Far',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        20,
                                                                    color: Colors
                                                                        .amber),
                                                              )),
                                                      Container(
                                                        padding: EdgeInsets.only(
                                                            top: screenSize.size
                                                                    .height *
                                                                0.023),
                                                        width: screenSize
                                                            .size.width,
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                            "Monthly Performance Achievement",
                                                            style: TextStyle(
                                                              fontSize: 20,
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
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'From:',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                TextButton(
                                                    child: _con.fromDate == null
                                                        ? Icon(Icons.date_range)
                                                        : Text(DateFormat(
                                                                'yMMMM')
                                                            .format(
                                                                _con.fromDate)
                                                            .toString()),
                                                    // icon: Icon(Icons.add),
                                                    onPressed: () {
                                                      showMonthPicker(
                                                        context: context,
                                                        firstDate:
                                                            _con.minimumDate,
                                                        lastDate:
                                                            _con.toDate == null
                                                                ? DateTime.now()
                                                                : _con.toDate,
                                                        initialDate:
                                                            DateTime.now(),
                                                        locale: Locale("en"),
                                                      ).then((date) {
                                                        if (date != null) {
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
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                TextButton(
                                                    child: _con.toDate == null
                                                        ? Icon(Icons.date_range)
                                                        : Text(DateFormat(
                                                                'yMMMM')
                                                            .format(_con.toDate)
                                                            .toString()),
                                                    // icon: Icon(Icons.add),
                                                    onPressed: () {
                                                      showMonthPicker(
                                                        context: context,
                                                        firstDate: _con
                                                                    .fromDate ==
                                                                null
                                                            ? _con.minimumDate
                                                            : _con.fromDate,
                                                        lastDate:
                                                            DateTime.now(),
                                                        initialDate:
                                                            DateTime.now(),
                                                        locale: Locale("en"),
                                                      ).then((date) {
                                                        if (date != null) {
                                                          setState(() {
                                                            _con.toDate = date;
                                                          });
                                                        }
                                                      });
                                                    }),
                                              ],
                                            ),
                                            (_con.fromDate != null &&
                                                    _con.toDate != null)
                                                ? Container(
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
                                                            0.45,
                                                        //line graph here
                                                        child: _con.fromDate !=
                                                                    null &&
                                                                _con.toDate !=
                                                                    null
                                                            ? FutureBuilder(
                                                                future:
                                                                    declareLineGraph(),
                                                                builder: (context, snapshot) => snapshot
                                                                            .connectionState ==
                                                                        ConnectionState
                                                                            .waiting
                                                                    ? Center(
                                                                        child:
                                                                            CircularProgressIndicator())
                                                                    : Center(
                                                                        child: charts.TimeSeriesChart(
                                                                            series2,
                                                                            animate:
                                                                                true,
                                                                            animationDuration:
                                                                                Duration(milliseconds: 700),
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
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            25, 0, 25, 0),
                                                    width:
                                                        screenSize.size.width *
                                                            0.9,
                                                    height:
                                                        screenSize.size.height *
                                                            0.45,
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      'Please Select Date Range To Generate The Chart',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          color: Colors.amber),
                                                    ),
                                                  ),
                                            Container(
                                              padding: EdgeInsets.only(
                                                  top: screenSize.size.height *
                                                      0.04),
                                              width: screenSize.size.width,
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
                                    if (chartIndex == 3)
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
                ],
              ),
            ),
          ),
        ));
  }
}
