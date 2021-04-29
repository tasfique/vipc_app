import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:vipc_app/view/appbar/appbar_view.dart';
import 'package:vipc_app/view/bottomnavbar/bottomnavbar.dart';
import 'package:vipc_app/view/drawer/drawer_view.dart';
import 'package:vipc_app/controller/monitor/monitor_controller.dart';
import 'package:vipc_app/view/monitor/monitor_details_view.dart';

class MonitorView extends StatefulWidget {
  MonitorView({key}) : super(key: key);

  @override
  _MonitorViewState createState() => _MonitorViewState();
}

class _MonitorViewState extends StateMVC {
  _MonitorViewState() : super(MonitorController()) {
    _con = MonitorController.con;
  }

  MonitorController _con;

  @override
  Widget build(BuildContext context) {
    _con.monitorCards.clear();
    for (int i = 0; i < _con.monitorNames.length; i++) {
      _con.monitorCards.add(
        Card(
          color: Colors.amber[50],
          child: Padding(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  title: Text(
                    _con.monitorNames[i],
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 22,
                    ),
                  ),
                ),
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(15, 10, 0, 10),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "October weekly points: " +
                            _con.weeklyAvgPoints[i].toString() +
                            " pts",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(15, 10, 0, 10),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "October total points: " +
                            _con.totalPoints[i].toString() +
                            " pts",
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

    return Scaffold(
      appBar: CustomAppBar(),
      bottomNavigationBar: CustomNavBar(),
      drawer: CustomDrawer(),
      body: Container(
        padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 20.0),
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: _con.monitorCards.length,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Monitor",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _con.selectedIndex = index;
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return MonitorDetailsView();
                      }));
                    },
                    child: Padding(
                      padding: EdgeInsets.only(top: 15),
                      child: Container(
                        alignment: Alignment.center,
                        child: _con.monitorCards[index],
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return GestureDetector(
                onTap: () {
                  _con.selectedIndex = index;
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return MonitorDetailsView();
                  }));
                },
                child: Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: Container(
                    alignment: Alignment.center,
                    child: _con.monitorCards[index],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
