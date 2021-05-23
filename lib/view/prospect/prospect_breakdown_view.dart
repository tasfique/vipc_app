import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vipc_app/model/prospect.dart';
import 'package:vipc_app/view/prospect/prospect_view.dart';

class ProspectBreakDownView extends StatefulWidget {
  final int totalPoint;
  final int month;
  final String checkWeek;
  final String usrId;
  final String status;

  ProspectBreakDownView(this.totalPoint, this.month,
      {this.checkWeek, this.usrId, this.status});

  @override
  _ProspectBreakDownViewState createState() => _ProspectBreakDownViewState();
}

class _ProspectBreakDownViewState extends State<ProspectBreakDownView> {
  DateTime present = DateTime.now();
  int firstDate, lastDate, totalPoint;
  List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  List<String> weeks;

  List<String> stepsString = [
    'New Prospect',
    'Step 1 Make Appointment',
    'Step 2 Open Case',
    'Step 3 Presentation',
    'Step 4 Follow Up',
    'Step 5 Close',
    'Step 6 Referral/Servicing'
  ];

  Map<dynamic, List<Prospect>> prospectList;

  List<int> eachStepPoint;

  Future<void> calculateTotalPointWeekEarned() async {
    eachStepPoint = [0, 0, 0, 0, 0, 0, 0];
    prospectList = {
      'New Prospect': [],
      "Step 1 Make Appointment": [],
      "Step 2 Open Case": [],
      "Step 3 Presentation": [],
      'Step 4 Follow Up': [],
      'Step 5 Close': [],
      "Step 6 Referral/Servicing": []
    };

    try {
      String userId;
      if (widget.usrId == null || widget.usrId.isEmpty)
        userId = FirebaseAuth.instance.currentUser.uid;
      else
        userId = widget.usrId;

      print('asdf');
      print('user id: $userId');
      var prospects = await FirebaseFirestore.instance
          .collection("prospect")
          .doc(userId)
          .collection('prospects')
          .get();

      TimeOfDay t;
      var now;
      var time;

      prospects.docs.forEach((oneProspect) {
        DateTime createdTime =
            DateTime.parse(oneProspect.data()['steps']['0Time']);
        print(createdTime);
        print('date: ${createdTime.day}');

        if (createdTime.difference(present).inSeconds <= 0 &&
            createdTime.month == present.month &&
            createdTime.year == present.year &&
            createdTime.day <= lastDate &&
            createdTime.day >= firstDate) {
          eachStepPoint[0] += 1;
          prospectList['New Prospect'].add(Prospect(
            prospectId: oneProspect.id,
            prospectName: oneProspect.data()['prospectName'],
            phoneNo: oneProspect.data()['phone'],
            email: oneProspect.data()['email'],
            type: oneProspect.data()['type'],
            steps: oneProspect.data()['steps'],
            lastUpdate: oneProspect.data()['lastUpdate'],
            lastStep: oneProspect.data()['lastStep'],
            done: oneProspect.data()['done'],
          ));
        }

        for (int i = 1; i < oneProspect['steps']['length']; i++) {
          if (oneProspect['steps']['${i}meetingTime'] != '')
            t = TimeOfDay(
                hour: int.parse(
                    oneProspect['steps']['${i}meetingTime'].substring(0, 2)),
                minute: int.parse(
                    oneProspect['steps']['${i}meetingTime'].substring(3, 5)));
          else
            t = TimeOfDay(hour: 0, minute: 0);
          now = DateTime.parse(oneProspect['steps']['${i}meetingDate']);
          time = DateTime(now.year, now.month, now.day, t.hour, t.minute);
          if (time.difference(present).inSeconds <= 0 &&
              time.month == present.month &&
              time.year == present.year &&
              time.day <= lastDate &&
              time.day >= firstDate) {
            eachStepPoint[
                    int.parse(oneProspect['steps']['$i'].substring(5, 6))] +=
                oneProspect['steps']['${i}Point'];

            prospectList['${oneProspect['steps']['$i']}'].add(Prospect(
              prospectId: oneProspect.id,
              prospectName: oneProspect.data()['prospectName'],
              phoneNo: oneProspect.data()['phone'],
              email: oneProspect.data()['email'],
              type: oneProspect.data()['type'],
              steps: oneProspect.data()['steps'],
              lastUpdate: oneProspect.data()['lastUpdate'],
              lastStep: oneProspect.data()['lastStep'],
              done: oneProspect.data()['done'],
            ));
          }
        }
      });
      // print(prospectList['New Prospect'][0].prospectName);
      // print('test');
      // for (int i = 0; i < 7; i++) {
      //   print('length $i: ${prospectList["Step 3 Presentation"].length}');
      //   print('step $i: ${eachStepPoint[i]}');
      // }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(error.toString()),
            backgroundColor: Theme.of(context).errorColor),
      );
    }
  }

  Future<void> calculateTotalPointEarned() async {
    eachStepPoint = [0, 0, 0, 0, 0, 0, 0];
    prospectList = {
      'New Prospect': [],
      "Step 1 Make Appointment": [],
      "Step 2 Open Case": [],
      "Step 3 Presentation": [],
      'Step 4 Follow Up': [],
      'Step 5 Close': [],
      "Step 6 Referral/Servicing": []
    };

    try {
      // String userId = FirebaseAuth.instance.currentUser.uid;
      String userId;
      if (widget.usrId == null || widget.usrId.isEmpty)
        userId = FirebaseAuth.instance.currentUser.uid;
      else
        userId = widget.usrId;

      var prospects = await FirebaseFirestore.instance
          .collection("prospect")
          .doc(userId)
          .collection('prospects')
          .get();

      List<Prospect> newsProspectListTemp = [];
      TimeOfDay t;
      var now;
      var time;

      prospects.docs.forEach((oneProspect) {
        DateTime createdTime =
            DateTime.parse(oneProspect.data()['steps']['0Time']);

        if (createdTime.difference(present).inSeconds <= 0 &&
            createdTime.month == widget.month + 1 &&
            createdTime.year == present.year) {
          eachStepPoint[0] += 1;
          prospectList['New Prospect'].add(Prospect(
            prospectId: oneProspect.id,
            prospectName: oneProspect.data()['prospectName'],
            phoneNo: oneProspect.data()['phone'],
            email: oneProspect.data()['email'],
            type: oneProspect.data()['type'],
            steps: oneProspect.data()['steps'],
            lastUpdate: oneProspect.data()['lastUpdate'],
            lastStep: oneProspect.data()['lastStep'],
            done: oneProspect.data()['done'],
          ));
        }

        for (int i = 1; i < oneProspect['steps']['length']; i++) {
          if (oneProspect['steps']['${i}meetingTime'] != '')
            t = TimeOfDay(
                hour: int.parse(
                    oneProspect['steps']['${i}meetingTime'].substring(0, 2)),
                minute: int.parse(
                    oneProspect['steps']['${i}meetingTime'].substring(3, 5)));
          else
            t = TimeOfDay(hour: 0, minute: 0);
          now = DateTime.parse(oneProspect['steps']['${i}meetingDate']);
          time = DateTime(now.year, now.month, now.day, t.hour, t.minute);
          if (time.difference(present).inSeconds <= 0 &&
              time.month == widget.month + 1 &&
              time.year == present.year) {
            eachStepPoint[
                    int.parse(oneProspect['steps']['$i'].substring(5, 6))] +=
                oneProspect['steps']['${i}Point'];

            prospectList['${oneProspect['steps']['$i']}'].add(Prospect(
              prospectId: oneProspect.id,
              prospectName: oneProspect.data()['prospectName'],
              phoneNo: oneProspect.data()['phone'],
              email: oneProspect.data()['email'],
              type: oneProspect.data()['type'],
              steps: oneProspect.data()['steps'],
              lastUpdate: oneProspect.data()['lastUpdate'],
              lastStep: oneProspect.data()['lastStep'],
              done: oneProspect.data()['done'],
            ));
          }
        }

        // newsProspectListTemp.add(Prospect(
        //   prospectId: oneProspect.id,
        //   prospectName: oneProspect.data()['prospectName'],
        //   phoneNo: oneProspect.data()['phone'],
        //   email: oneProspect.data()['email'],
        //   type: oneProspect.data()['type'],
        //   steps: oneProspect.data()['steps'],
        //   lastUpdate: oneProspect.data()['lastUpdate'],
        //   lastStep: oneProspect.data()['lastStep'],
        //   done: oneProspect.data()['done'],
        // ));
      });
      // print(prospectList['New Prospect'][0].prospectName);
      // print('test');
      // for (int i = 0; i < 7; i++) {
      //   print('length $i: ${prospectList["Step 3 Presentation"].length}');
      //   print('step $i: ${eachStepPoint[i]}');
      // }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(error.toString()),
            backgroundColor: Theme.of(context).errorColor),
      );
    }
  }

  Future<void> calculatePointByStatus() async {
    eachStepPoint = [0, 0, 0, 0, 0, 0, 0];
    totalPoint = 0;
    prospectList = {
      'New Prospect': [],
      "Step 1 Make Appointment": [],
      "Step 2 Open Case": [],
      "Step 3 Presentation": [],
      'Step 4 Follow Up': [],
      'Step 5 Close': [],
      "Step 6 Referral/Servicing": []
    };

    try {
      String userId = widget.usrId;

      var prospects = await FirebaseFirestore.instance
          .collection("prospect")
          .doc(userId)
          .collection('prospects')
          .get();

      List<Prospect> newsProspectListTemp = [];
      TimeOfDay t;
      var now;
      var time;
      int currentMonth = present.month;
      int currentYear = present.year;

      prospects.docs.forEach((oneProspect) {
        int length = oneProspect.data()['steps']['length'] - 1;
        if (widget.status == 'Completed') {
          if (oneProspect.data()['steps']['$length'] ==
              'Step 6 Referral/Servicing') {
            if (oneProspect.data()['steps']['${length}meetingTime'] != '')
              t = TimeOfDay(
                  hour: int.parse(oneProspect
                      .data()['steps']['${length}meetingTime']
                      .substring(0, 2)),
                  minute: int.parse(oneProspect
                      .data()['steps']['${length}meetingTime']
                      .substring(3, 5)));
            else
              t = TimeOfDay(hour: 0, minute: 0);
            now = DateTime.parse(
                oneProspect.data()['steps']['${length}meetingDate']);
            time = DateTime(now.year, now.month, now.day, t.hour, t.minute);
            if (time.difference(present).inSeconds <= 0 &&
                now.year == currentYear &&
                now.month == currentMonth) {
              DateTime createdTime =
                  DateTime.parse(oneProspect.data()['steps']['0Time']);

              if (createdTime.difference(present).inSeconds <= 0 &&
                  createdTime.month == currentMonth &&
                  createdTime.year == present.year) {
                eachStepPoint[0] += 1;
                prospectList['New Prospect'].add(Prospect(
                  prospectId: oneProspect.id,
                  prospectName: oneProspect.data()['prospectName'],
                  phoneNo: oneProspect.data()['phone'],
                  email: oneProspect.data()['email'],
                  type: oneProspect.data()['type'],
                  steps: oneProspect.data()['steps'],
                  lastUpdate: oneProspect.data()['lastUpdate'],
                  lastStep: oneProspect.data()['lastStep'],
                  done: oneProspect.data()['done'],
                ));
              }

              for (int i = 1; i < oneProspect['steps']['length']; i++) {
                if (oneProspect['steps']['${i}meetingTime'] != '')
                  t = TimeOfDay(
                      hour: int.parse(oneProspect['steps']['${i}meetingTime']
                          .substring(0, 2)),
                      minute: int.parse(oneProspect['steps']['${i}meetingTime']
                          .substring(3, 5)));
                else
                  t = TimeOfDay(hour: 0, minute: 0);
                now = DateTime.parse(oneProspect['steps']['${i}meetingDate']);
                time = DateTime(now.year, now.month, now.day, t.hour, t.minute);
                if (time.difference(present).inSeconds <= 0 &&
                    time.month == currentMonth &&
                    time.year == currentYear) {
                  eachStepPoint[int.parse(
                          oneProspect['steps']['$i'].substring(5, 6))] +=
                      oneProspect['steps']['${i}Point'];

                  prospectList['${oneProspect['steps']['$i']}'].add(Prospect(
                    prospectId: oneProspect.id,
                    prospectName: oneProspect.data()['prospectName'],
                    phoneNo: oneProspect.data()['phone'],
                    email: oneProspect.data()['email'],
                    type: oneProspect.data()['type'],
                    steps: oneProspect.data()['steps'],
                    lastUpdate: oneProspect.data()['lastUpdate'],
                    lastStep: oneProspect.data()['lastStep'],
                    done: oneProspect.data()['done'],
                  ));
                }
              }
            }
          }
        } else if (widget.status == 'Incompleted') {
          print('length');
          print(length);
          if (length != 0) {
            if (oneProspect.data()['steps']['${length}meetingTime'] != '')
              t = TimeOfDay(
                  hour: int.parse(oneProspect
                      .data()['steps']['${length}meetingTime']
                      .substring(0, 2)),
                  minute: int.parse(oneProspect
                      .data()['steps']['${length}meetingTime']
                      .substring(3, 5)));
            else
              t = TimeOfDay(hour: 0, minute: 0);
            now = DateTime.parse(
                oneProspect.data()['steps']['${length}meetingDate']);
            time = DateTime(now.year, now.month, now.day, t.hour, t.minute);
            print('test point');

            if (!(time.difference(present).inSeconds <= 0 &&
                    oneProspect.data()['steps']['$length'] ==
                        'Step 6 Referral/Servicing') &&
                now.year == currentYear &&
                now.month == currentMonth) {
              DateTime createdTime =
                  DateTime.parse(oneProspect.data()['steps']['0Time']);

              if (createdTime.difference(present).inSeconds <= 0 &&
                  createdTime.month == currentMonth &&
                  createdTime.year == currentYear) {
                eachStepPoint[0] += 1;
                prospectList['New Prospect'].add(Prospect(
                  prospectId: oneProspect.id,
                  prospectName: oneProspect.data()['prospectName'],
                  phoneNo: oneProspect.data()['phone'],
                  email: oneProspect.data()['email'],
                  type: oneProspect.data()['type'],
                  steps: oneProspect.data()['steps'],
                  lastUpdate: oneProspect.data()['lastUpdate'],
                  lastStep: oneProspect.data()['lastStep'],
                  done: oneProspect.data()['done'],
                ));
              }

              for (int i = 1; i < oneProspect['steps']['length']; i++) {
                if (oneProspect['steps']['${i}meetingTime'] != '')
                  t = TimeOfDay(
                      hour: int.parse(oneProspect['steps']['${i}meetingTime']
                          .substring(0, 2)),
                      minute: int.parse(oneProspect['steps']['${i}meetingTime']
                          .substring(3, 5)));
                else
                  t = TimeOfDay(hour: 0, minute: 0);
                now = DateTime.parse(oneProspect['steps']['${i}meetingDate']);
                time = DateTime(now.year, now.month, now.day, t.hour, t.minute);
                if (time.difference(present).inSeconds <= 0 &&
                    time.month == currentMonth &&
                    time.year == currentYear) {
                  eachStepPoint[int.parse(
                          oneProspect['steps']['$i'].substring(5, 6))] +=
                      oneProspect['steps']['${i}Point'];

                  prospectList['${oneProspect['steps']['$i']}'].add(Prospect(
                    prospectId: oneProspect.id,
                    prospectName: oneProspect.data()['prospectName'],
                    phoneNo: oneProspect.data()['phone'],
                    email: oneProspect.data()['email'],
                    type: oneProspect.data()['type'],
                    steps: oneProspect.data()['steps'],
                    lastUpdate: oneProspect.data()['lastUpdate'],
                    lastStep: oneProspect.data()['lastStep'],
                    done: oneProspect.data()['done'],
                  ));
                }
              }
            }
          } else {
            print('............');
            DateTime createdTime =
                DateTime.parse(oneProspect.data()['steps']['0Time']);

            if (createdTime.difference(present).inSeconds <= 0 &&
                createdTime.month == currentMonth &&
                createdTime.year == currentYear) {
              eachStepPoint[0] += 1;
              prospectList['New Prospect'].add(Prospect(
                prospectId: oneProspect.id,
                prospectName: oneProspect.data()['prospectName'],
                phoneNo: oneProspect.data()['phone'],
                email: oneProspect.data()['email'],
                type: oneProspect.data()['type'],
                steps: oneProspect.data()['steps'],
                lastUpdate: oneProspect.data()['lastUpdate'],
                lastStep: oneProspect.data()['lastStep'],
                done: oneProspect.data()['done'],
              ));
            }
          }
        }
        // newsProspectListTemp.add(Prospect(
        //   prospectId: oneProspect.id,
        //   prospectName: oneProspect.data()['prospectName'],
        //   phoneNo: oneProspect.data()['phone'],
        //   email: oneProspect.data()['email'],
        //   type: oneProspect.data()['type'],
        //   steps: oneProspect.data()['steps'],
        //   lastUpdate: oneProspect.data()['lastUpdate'],
        //   lastStep: oneProspect.data()['lastStep'],
        //   done: oneProspect.data()['done'],
        // ));
      });
      // print(prospectList['New Prospect'][0].prospectName);
      // print('test');
      // for (int i = 0; i < 7; i++) {
      //   print('length $i: ${prospectList["Step 3 Presentation"].length}');
      //   print('step $i: ${eachStepPoint[i]}');
      // }
      print(eachStepPoint);
      for (int i = 0; i < 7; i++) totalPoint += eachStepPoint[i];
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
    if (widget.checkWeek == 'week') {
      weeks = [
        "01-07 " + DateFormat('MMMM yyyy').format(DateTime.now()),
        "15-21 " + DateFormat('MMMM yyyy').format(DateTime.now()),
        "08-14 " + DateFormat('MMMM yyyy').format(DateTime.now()),
        "22-" +
            DateTime(DateTime.now().year, DateTime.now().month + 1, 0)
                .day
                .toString() +
            ' ' +
            DateFormat('MMMM yyyy').format(DateTime.now()),
      ];
      if (widget.month == 0) {
        firstDate = 1;
        lastDate = 7;
      } else if (widget.month == 1) {
        firstDate = 15;
        lastDate = 21;
      } else if (widget.month == 2) {
        firstDate = 8;
        lastDate = 14;
      } else if (widget.month == 3) {
        firstDate = 22;
        lastDate =
            DateTime(DateTime.now().year, DateTime.now().month + 1, 0).day;
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context);
        return;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Point Breakdown'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: FutureBuilder(
          future: widget.checkWeek == 'week'
              ? calculateTotalPointWeekEarned()
              : widget.checkWeek == 'status'
                  ? calculatePointByStatus()
                  : calculateTotalPointEarned(),
          builder: (context, snapshot) => snapshot.connectionState ==
                  ConnectionState.waiting
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 25, left: 25),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: 15, top: 25),
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                widget.checkWeek == 'week'
                                    ? "Point Breakdown For " +
                                        weeks[widget.month]
                                    : widget.checkWeek == 'status'
                                        ? "Point Breakdown For " +
                                            DateFormat('yMMMM')
                                                .format(DateTime.now()) +
                                            '\n\n' +
                                            widget.status +
                                            ' Prospect(s)'
                                        : "Point Breakdown For " +
                                            months[widget.month] +
                                            ' ' +
                                            DateTime.now().year.toString(),
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                          Text(
                            'Total Point Earned: ' +
                                (widget.status == null || widget.status.isEmpty
                                    ? widget.totalPoint.toString()
                                    : totalPoint.toString()),
                            style: TextStyle(
                              color: Colors.amber,
                              fontSize: 22,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          widget.checkWeek == 'status'
                              ? SizedBox()
                              : Text(
                                  'KPI Summary: ' +
                                      (widget.checkWeek == 'week'
                                          ? (widget.totalPoint < 50
                                              ? 'Failed (Total Point < 50)'
                                              : 50 <= widget.totalPoint &&
                                                      widget.totalPoint < 100
                                                  ? 'Passed (Total Point > 50)'
                                                  : 'Standard (Total Point > 100)')
                                          : (widget.totalPoint < 100
                                              ? 'Failed (Total Point < 100)'
                                              : 100 <= widget.totalPoint &&
                                                      widget.totalPoint < 200
                                                  ? 'Passed (Total Point > 100)'
                                                  : 'Standard (Total Point > 200)')),
                                  style: TextStyle(
                                    color: Colors.amber,
                                    fontSize: 15,
                                  ),
                                ),
                          ListView.builder(
                              shrinkWrap: true,
                              // scrollDirection: Axis.vertical,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: 7,
                              itemBuilder: (context, index) {
                                if (eachStepPoint[index] != 0)
                                  return Column(
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            stepsString[index],
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white70),
                                          ),
                                          Text(
                                            'Point: ${eachStepPoint[index].toString()}',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.amber,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 14,
                                      ),
                                      // Text('${stepsString[index]}'),
                                      // Text(prospectList['${stepsString[index]}'][0]
                                      //     .prospectName),
                                      ListView(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        padding: const EdgeInsets.all(15),
                                        children: <Widget>[
                                          for (int i = 0;
                                              i <
                                                  prospectList[
                                                          '${stepsString[index]}']
                                                      .length;
                                              i++)
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 5),
                                              child: Card(
                                                color: Colors.amber[200],
                                                child: ListTile(
                                                  onTap: () async {
                                                    final pushPage3 = await Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                ProspectView(
                                                                    prospectList[
                                                                            '${stepsString[index]}']
                                                                        [i])));
                                                    if (pushPage3) {
                                                      await calculateTotalPointEarned();
                                                      setState(() {});
                                                    }
                                                  },
                                                  title: Text('Prospect Name:'),
                                                  subtitle: Text(
                                                    prospectList[
                                                            '${stepsString[index]}'][i]
                                                        .prospectName,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ],
                                  );
                                return SizedBox();
                              }),
                        ],
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
