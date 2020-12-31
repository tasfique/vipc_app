import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:vipc_app/controller/home/home_controller.dart';
import 'package:vipc_app/model/member.dart';
import 'package:vipc_app/view/login/login_view.dart';
import 'package:vipc_app/model/chart_data.dart';
import 'package:vipc_app/model/bar_chart.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:pie_chart/pie_chart.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:vipc_app/view/appbar/appbar_view.dart';
import 'package:vipc_app/view/drawer/drawer_view.dart';
import 'package:vipc_app/controller/sales/sales_controller.dart';

class SalesView extends StatefulWidget {
  SalesView({key}) : super(key: key);

  @override
  _SalesViewState createState() => _SalesViewState();
}

class _SalesViewState extends StateMVC {
  _SalesViewState() : super(SalesController()) {
    _con = SalesController.con;
  }

  SalesController _con;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      drawer: CustomDrawer(),
      body: Container(
        padding: EdgeInsets.all(15),
        child: Text("SALES"),
      ),
    );
  }
}
