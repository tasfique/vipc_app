import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vipc_app/model/prospect.dart';
import 'package:vipc_app/view/prospect/prospect_view.dart';

class ProspectBreakDownView extends StatefulWidget {
  final int totalPoint;
  final int month;

  ProspectBreakDownView(this.totalPoint, this.month);

  @override
  _ProspectBreakDownViewState createState() => _ProspectBreakDownViewState();
}

class _ProspectBreakDownViewState extends State<ProspectBreakDownView> {
  DateTime present = DateTime.now();
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
      String userId = FirebaseAuth.instance.currentUser.uid;
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
            createdTime.year == DateTime.now().year) {
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
              time.year == DateTime.now().year) {
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

  @override
  void initState() {
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
          future: calculateTotalPointEarned(),
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
                                "Point Breakdown For " +
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
                                widget.totalPoint.toString(),
                            style: TextStyle(
                              color: Colors.amber,
                              fontSize: 22,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'KPI Summary: ' +
                                (widget.totalPoint < 100
                                    ? 'Failed (Total Point < 100)'
                                    : 100 <= widget.totalPoint &&
                                            widget.totalPoint <= 200
                                        ? 'Passed (Total Point > 100)'
                                        : 'Standard (Total Point > 200)'),
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
                                      // GridView.count(
                                      //     shrinkWrap: true,
                                      //     // primary: false,
                                      //     physics: const NeverScrollableScrollPhysics(),
                                      //     padding: const EdgeInsets.all(10),
                                      //     crossAxisSpacing: 10,
                                      //     // mainAxisSpacing: 10,
                                      //     crossAxisCount: 2,
                                      //     children: <Widget>[
                                      //       for (int i = 0;
                                      //           i <
                                      //               prospectList[
                                      //                       '${stepsString[index]}']
                                      //                   .length;
                                      //           i++)
                                      //         Card(
                                      //           color: Colors.amber[50],
                                      //           child: ListTile(
                                      //             // leading: FlutterLogo(),
                                      //             subtitle: null,
                                      //             title: Text(
                                      //               'Prospect:\n' +
                                      //                   prospectList[
                                      //                           '${stepsString[index]}'][i]
                                      //                       .prospectName,
                                      //               maxLines: 4,
                                      //               overflow: TextOverflow.ellipsis,
                                      //             ),
                                      //           ),
                                      //         ),
                                      //       // Text(prospectList['${stepsString[index]}']
                                      //       //         [i]
                                      //       //     .prospectName),
                                      //       // ListView.builder(
                                      //       //     shrinkWrap: true,
                                      //       //     physics:
                                      //       //         const NeverScrollableScrollPhysics(),

                                      //       //     // scrollDirection: Axis.vertical,
                                      //       //     itemCount: prospectList[
                                      //       //             '${stepsString[index]}']
                                      //       //         .length,
                                      //       //     itemBuilder: (context, indexProspect) {
                                      //       //       return Text(prospectList[
                                      //       //                   '${stepsString[index]}']
                                      //       //               [indexProspect]
                                      //       //           .prospectName);
                                      //       //       // return Text(
                                      //       //       //     'Prospect Name: ${prospectList[{
                                      //       //       //   stepsString[index]
                                      //       //       // }]}.prospectName');
                                      //       //     }),
                                      //     ]),
                                    ],
                                  );
                                return SizedBox();
                              }),
                          // Text(
                          //   'Name: ${widget.prospect.prospectName}',
                          //   style: TextStyle(
                          //     fontSize: 22,
                          //   ),
                          // ),
                          // SizedBox(
                          //   height: 14,
                          // ),
                          // Text('Phone: ${widget.prospect.phoneNo}',
                          //     style: TextStyle(fontSize: 22)
                          //     // DateFormat('dd/MM/yyyy HH:mm')
                          //     // .format(DateTime.parse(widget.oneNew.newsId)),
                          //     // style: TextStyle(
                          //     //   fontSize: 18,
                          //     //   color: Colors.white70,
                          //     // ),
                          //     ),
                          // SizedBox(
                          //   height: 14,
                          // ),
                          // widget.prospect.email != ''
                          //     ? Padding(
                          //         padding: const EdgeInsets.only(bottom: 14),
                          //         child: Text('Email: ${widget.prospect.email}',
                          //             style: TextStyle(fontSize: 22)),
                          //       )
                          //     : SizedBox(),
                          // Text(
                          //   'The Process:',
                          //   style: TextStyle(
                          //     color: Colors.white70,
                          //     fontSize: 24,
                          //   ),
                          // ),
                          // SizedBox(
                          //   height: 10,
                          // ),
                          // Text(
                          //   'Total Point Earned:  $totalPoint',
                          //   style: TextStyle(
                          //     color: Colors.amber,
                          //     fontSize: 22,
                          //   ),
                          // ),
                          // SizedBox(
                          //   height: 10,
                          // ),
                          // Text(widget.prospect.steps['0'],
                          //     style: TextStyle(fontSize: 22)),
                          // Text(
                          //   'Point: ${widget.prospect.steps['0Point']}',
                          //   style: TextStyle(color: Colors.amberAccent),
                          // ),
                          // SizedBox(
                          //   height: 5,
                          // ),
                          // Text(
                          //   'Date Added:  ' +
                          //       DateFormat('dd/MM/yyyy HH:mm').format(
                          //           DateTime.parse(widget.prospect.steps['0Time'])),
                          //   style: TextStyle(fontSize: 16),
                          // ),
                          // widget.prospect.steps['0memo'] != ''
                          //     ? Padding(
                          //         padding: const EdgeInsets.only(top: 5),
                          //         child: Text(
                          //           'Memo: ' + widget.prospect.steps['0memo'],
                          //           style: TextStyle(fontSize: 16),
                          //         ),
                          //       )
                          //     : SizedBox(),
                          // widget.prospect.steps['length'] != 1
                          //     ? ListView.builder(
                          //         physics: const NeverScrollableScrollPhysics(),
                          //         shrinkWrap: true,
                          //         itemCount: widget.prospect.steps['length'],
                          //         itemBuilder: (context, index) {
                          //           if (index != 0) {
                          //             return Container(
                          //                 child: _displayProgress(index, present));
                          //           } else
                          //             return SizedBox();
                          //         })
                          //     : SizedBox(),
                          // widget.prospect.done == 0 &&
                          //         widget.prospect.lastStep == 6 &&
                          //         checkStepState()
                          //     ? Padding(
                          //         padding: EdgeInsets.only(bottom: 25, right: 25),
                          //         child: Container(
                          //           alignment: Alignment.bottomRight,
                          //           child: ElevatedButton(
                          //             style: ElevatedButton.styleFrom(
                          //               elevation: 5.0,
                          //               padding: EdgeInsets.all(15.0),
                          //               shape: RoundedRectangleBorder(
                          //                 borderRadius: BorderRadius.circular(30.0),
                          //               ),
                          //               primary: Colors.amber[300],
                          //             ),
                          //             onPressed: () {
                          //               showDialog(
                          //                 context: context,
                          //                 builder: (_) => new AlertDialog(
                          //                   title: new Text("VIPC Message"),
                          //                   content: new Text(
                          //                       "Finish service with this prospect!\nProspect will be disappeared from the prospect list.\nYou still can see the prospect detail through search."),
                          //                   actions: <Widget>[
                          //                     TextButton(
                          //                       child: Text('No'),
                          //                       onPressed: () {
                          //                         Navigator.of(context).pop();
                          //                       },
                          //                     ),
                          //                     TextButton(
                          //                       child: Text('Yes'),
                          //                       onPressed: () async {
                          //                         finishServiceWithProspect();
                          //                         Navigator.of(context).pop();
                          //                         Navigator.of(context).pop(true);
                          //                       },
                          //                     )
                          //                   ],
                          //                 ),
                          //               );
                          //             },
                          //             child: Text(
                          //               'Finish',
                          //               style: TextStyle(
                          //                 color: Colors.black,
                          //                 letterSpacing: 1.5,
                          //                 fontSize: 18.0,
                          //                 fontWeight: FontWeight.bold,
                          //               ),
                          //             ),
                          //           ),
                          //         ),
                          //       )
                          //     : SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  // Widget _displayProgress(int index, DateTime present) {
  //   TimeOfDay t;
  //   if (widget.prospect.steps['${index}meetingTime'] != '')
  //     t = TimeOfDay(
  //         hour: int.parse(
  //             widget.prospect.steps['${index}meetingTime'].substring(0, 2)),
  //         minute: int.parse(
  //             widget.prospect.steps['${index}meetingTime'].substring(3, 5)));
  //   else
  //     t = TimeOfDay(hour: 0, minute: 0);
  //   final now = DateTime.parse(widget.prospect.steps['${index}meetingDate']);
  //   final time = DateTime(now.year, now.month, now.day, t.hour, t.minute);
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       SizedBox(
  //         height: 10,
  //       ),
  //       Text(widget.prospect.steps['$index'], style: TextStyle(fontSize: 22)),
  //       time.difference(present).inSeconds <= 0
  //           ? Text(
  //               'Point: ${widget.prospect.steps['${index}Point']}',
  //               style: TextStyle(color: Colors.amberAccent),
  //             )
  //           : Text(
  //               'Point About To Earn: ${widget.prospect.steps['${index}Point']}',
  //               style: TextStyle(color: Colors.amberAccent),
  //             ),
  //       SizedBox(
  //         height: 5,
  //       ),
  //       widget.prospect.steps['${index}meetingPlace'] != ''
  //           ? Padding(
  //               padding: const EdgeInsets.only(bottom: 5),
  //               child: Text(
  //                 'Meet at: ' + widget.prospect.steps['${index}meetingPlace'],
  //                 style: TextStyle(fontSize: 16),
  //               ),
  //             )
  //           : SizedBox(),
  //       Text(
  //         DateFormat('HH:mm').format(time) != '00:00'
  //             ? 'Finish Date:  ' + DateFormat('dd/MM/yyyy HH:mm').format(time)
  //             : 'Finish Date:  ' + DateFormat('dd/MM/yyyy').format(time),
  //         style: TextStyle(fontSize: 16),
  //       ),
  //       widget.prospect.steps['${index}memo'] != ''
  //           ? Padding(
  //               padding: const EdgeInsets.only(top: 5),
  //               child: Text(
  //                 'Memo: ' + widget.prospect.steps['${index}memo'],
  //                 style: TextStyle(fontSize: 16),
  //               ),
  //             )
  //           : SizedBox(),
  //     ],
  //   );
  // }
}
