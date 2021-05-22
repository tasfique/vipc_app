import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:vipc_app/controller/admin/admin_controller.dart';
import 'package:vipc_app/controller/home/advisor_controller.dart';
import 'package:vipc_app/controller/home/manager_controller.dart';
import 'package:vipc_app/model/prospect.dart';
import 'package:vipc_app/model/user.dart';
import 'package:vipc_app/view/admin_user_control/user_reset_password_view.dart';
import 'package:vipc_app/view/appbar/appbar_admin_view.dart';
import 'package:intl/intl.dart';
import 'package:vipc_app/view/prospect/prospect_edit.dart';
import 'package:vipc_app/view/prospect/prospect_view.dart';

class ManagerNotificationView extends StatefulWidget {
  @override
  _ManagerNotificationViewState createState() =>
      _ManagerNotificationViewState();
}

class _ManagerNotificationViewState extends StateMVC<ManagerNotificationView> {
  _ManagerNotificationViewState() : super(ManagerController()) {
    _con = ManagerController.con;
  }

  ManagerController _con;
  bool _check = true;
  bool checkProspect = true;

  @override
  void initState() {
    _con.prospectListRequestPassword = [];
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    // await _con.getRequestPasswordCount();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        dispose();
        Navigator.of(context).pop();
        return;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Today\'s Meeting'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: FutureBuilder(
          future: _con.getTodayMeeting(context),
          builder: (context, snapshot) => snapshot.connectionState ==
                  ConnectionState.waiting
              ? Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: () async {
                    setState(() {
                      _check = false;
                    });
                    _con.getTodayMeeting(context);
                    setState(() {
                      _check = true;
                    });
                  },
                  child: (_check)
                      ? SingleChildScrollView(
                          physics: AlwaysScrollableScrollPhysics(),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 24.0),
                            child: Column(
                              children: [
                                (_con.prospectListRequestPassword.length != 0)
                                    ? ListView.builder(
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        itemCount: _con
                                            .prospectListRequestPassword.length,
                                        itemBuilder: (context, index) {
                                          if (index == 0) {
                                            return Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      EdgeInsets.only(left: 25),
                                                  child: Container(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Text(
                                                      "Today's Meeting With Prospect",
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      EdgeInsets.only(top: 15),
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    child: prospectItemCard(
                                                        _con.prospectListRequestPassword[
                                                            index]),
                                                  ),
                                                ),
                                              ],
                                            );
                                          } else {
                                            return Padding(
                                              padding: EdgeInsets.only(top: 15),
                                              child: Container(
                                                alignment: Alignment.center,
                                                child: prospectItemCard(
                                                    _con.prospectListRequestPassword[
                                                        index]),
                                              ),
                                            );
                                          }
                                        },
                                      )
                                    : Column(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(left: 25),
                                            child: Container(
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                "Today's Meeting With Prospect",
                                                style: TextStyle(
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 25),
                                            child: ListView(
                                              shrinkWrap: true,
                                              scrollDirection: Axis.vertical,
                                              children: List.generate(
                                                  1,
                                                  (f) => Text(
                                                        'No Meeting Today With Prospect',
                                                        style: TextStyle(
                                                          fontSize: 20,
                                                        ),
                                                      )),
                                            ),
                                          ),
                                        ],
                                      )
                              ],
                            ),
                          ),
                        )
                      : Center(
                          child: CircularProgressIndicator(),
                        ),
                ),
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
}
