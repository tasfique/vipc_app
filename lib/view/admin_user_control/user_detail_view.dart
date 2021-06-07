import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:vipc_app/model/news.dart';
import 'package:vipc_app/model/user.dart';
import 'package:vipc_app/view/admin_user_control/user_edit_view.dart';
// import 'package:vipc_app/view/appbar/appbar_view.dart';
// import 'package:vipc_app/view/drawer/drawer_view.dart';

class UserDetailsView extends StatefulWidget {
  final Usr oneUser;

  UserDetailsView(this.oneUser);

  @override
  _UserDetailsViewState createState() => _UserDetailsViewState();
}

class _UserDetailsViewState extends StateMVC<UserDetailsView> {
  // _UserDetailsViewState() : super(AdminController()) {
  //   _con = AdminController.con;
  // }

  // AdminController _con;

  Usr userDetail;
  bool check, pushP;
  int currentMonthPoint;
  int currentWeekPoint;

  Future<void> _getUser() async {
    try {
      final users = await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.oneUser.userId)
          .get();

      userDetail = Usr(
          userId: users.id,
          empID: users['empID'],
          email: users['email'],
          fullName: users['fullName'],
          type: users['type'],
          assignUnder: users['assignUnder'],
          password: users['password']);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(error.toString()),
            backgroundColor: Theme.of(context).errorColor),
      );
    }
  }

  Future<void> getPoints(BuildContext context) async {
    DateTime present = DateTime.now();
    int currentYear = present.year;
    int currentMonth = present.month;
    int firstDate, lastDate;
    currentMonthPoint = 0;
    currentWeekPoint = 0;

    try {
      var prospects;
      prospects = await FirebaseFirestore.instance
          .collection("prospect")
          .doc(widget.oneUser.userId)
          .collection('prospects')
          .get();

      if (present.day >= 1 && present.day <= 7) {
        firstDate = 1;
        lastDate = 7;
      } else if (present.day >= 8 && present.day <= 14) {
        firstDate = 8;
        lastDate = 14;
      } else if (present.day >= 15 && present.day <= 21) {
        firstDate = 15;
        lastDate = 21;
      } else {
        firstDate = 22;
        lastDate =
            DateTime(DateTime.now().year, DateTime.now().month + 1, 0).day;
      }

      TimeOfDay t;
      var now;
      var time;
      prospects.docs.forEach((oneProspect) {
        DateTime createdTime =
            DateTime.parse(oneProspect.data()['steps']['0Time']);
        if (createdTime.difference(present).inSeconds <= 0 &&
            createdTime.year == currentYear &&
            createdTime.month == currentMonth) currentMonthPoint++;

        if (createdTime.difference(present).inSeconds <= 0 &&
            createdTime.year == currentYear &&
            createdTime.month == currentMonth &&
            createdTime.day >= firstDate &&
            createdTime.day <= lastDate) currentWeekPoint++;

        for (int i = 1; i < oneProspect.data()['steps']['length']; i++) {
          if (oneProspect.data()['steps']['${i}meetingTime'] != '')
            t = TimeOfDay(
                hour: int.parse(oneProspect
                    .data()['steps']['${i}meetingTime']
                    .substring(0, 2)),
                minute: int.parse(oneProspect
                    .data()['steps']['${i}meetingTime']
                    .substring(3, 5)));
          else
            t = TimeOfDay(hour: 0, minute: 0);
          now = DateTime.parse(oneProspect.data()['steps']['${i}meetingDate']);
          time = DateTime(now.year, now.month, now.day, t.hour, t.minute);
          if (time.difference(present).inSeconds <= 0 &&
              now.year == currentYear &&
              now.month == currentMonth)
            currentMonthPoint += oneProspect.data()['steps']['${i}Point'];

          if (time.difference(present).inSeconds <= 0 &&
              now.year == currentYear &&
              now.month == currentMonth &&
              time.day >= firstDate &&
              time.day <= lastDate)
            currentWeekPoint += oneProspect.data()['steps']['${i}Point'];
        }
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(error.toString()),
            backgroundColor: Theme.of(context).errorColor),
      );
    }
  }

  @override
  void initState() {
    userDetail = null;
    check = true;
    pushP = false;
    print('heelo');
    print(widget.oneUser.type);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (pushP)
          Navigator.pop(context, true);
        else
          Navigator.pop(context, false);
        return;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('VIPC GROUP'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              if (pushP)
                Navigator.pop(context, true);
              else
                Navigator.pop(context, false);
            },
          ),
        ),
        body: FutureBuilder(
          future: getPoints(context),
          builder: (context, snapshot) => snapshot.connectionState ==
                  ConnectionState.waiting
              ? Center(child: CircularProgressIndicator())
              : (check)
                  ? ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: 38, top: 40),
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                "User Detail",
                                style: TextStyle(
                                  fontSize: 22,
                                  //decoration: TextDecoration.underline,
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
                                    padding: EdgeInsets.only(
                                        right: 10,
                                        left: 10,
                                        bottom: 10,
                                        top: 20),
                                    child: Text(
                                      userDetail == null
                                          ? 'Name: ${widget.oneUser.fullName}'
                                          : 'Name: ${userDetail.fullName}',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: TextStyle(
                                        fontSize: 22,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: 10, right: 10),
                                    child: Text(
                                      userDetail == null
                                          ? 'Employee ID: ${widget.oneUser.empID}'
                                          : 'Employee ID: ${userDetail.empID}',
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
                                    child: Text(
                                        userDetail == null
                                            ? 'Email: ${widget.oneUser.email}'
                                            : 'Email: ${userDetail.email}',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: TextStyle(
                                            fontSize: 22, color: Colors.black)),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        right: 10, left: 10, bottom: 10),
                                    child: Text(
                                        userDetail == null
                                            ? 'User Type: ${widget.oneUser.type}'
                                            : 'User Type: ${userDetail.type}',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: TextStyle(
                                            fontSize: 22, color: Colors.black)),
                                  ),
                                  if (userDetail == null &&
                                      widget.oneUser.type == 'Advisor')
                                    Padding(
                                        padding: EdgeInsets.only(
                                            right: 10, left: 10, bottom: 10),
                                        child: Text(
                                            'Assigned Manager:  ${widget.oneUser.assignUnder}',
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: TextStyle(
                                                fontSize: 22,
                                                color: Colors.black)))
                                  else if (userDetail != null &&
                                      userDetail.type == 'Advisor')
                                    Padding(
                                        padding: EdgeInsets.only(
                                            right: 10, left: 10, bottom: 10),
                                        child: Text(
                                            'Assigned Manager:  ${widget.oneUser.assignUnder}',
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: TextStyle(
                                                fontSize: 22,
                                                color: Colors.black))),
                                  SizedBox(height: 10)
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 15, bottom: 10, left: 25, right: 25),
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
                                      DateFormat('MMMM')
                                              .format(DateTime.now()) +
                                          " Total Points: " +
                                          currentMonthPoint.toString(),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                                100 <= currentMonthPoint
                                    ? Container(
                                        padding: EdgeInsets.only(bottom: 10),
                                        alignment: Alignment.topRight,
                                        child: Text(
                                            100 <= currentMonthPoint &&
                                                    currentMonthPoint < 200
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
                                  child: Text(
                                    DateFormat('MMMM').format(DateTime.now()) +
                                        " Weekly Points: " +
                                        currentWeekPoint.toString(),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                50 <= currentWeekPoint
                                    ? Container(
                                        alignment: Alignment.topRight,
                                        child: Text(
                                            50 <= currentWeekPoint &&
                                                    currentWeekPoint < 100
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
                        ],
                      ),
                    )
                  : Center(child: CircularProgressIndicator()),
        ),
        floatingActionButton: Container(
          padding: EdgeInsets.all(10),
          child: FloatingActionButton(
            onPressed: () async {
              pushP = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          EditUser(widget.oneUser, 'userDetail')));
              if (pushP == null) {
                Navigator.pop(context, true);
              } else if (pushP) {
                setState(() {
                  check = false;
                });
                await _getUser();
                setState(() {
                  check = true;
                });
              }
            },
            child: Icon(
              Icons.edit,
              size: 30,
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}
