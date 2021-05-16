import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vipc_app/model/prospect.dart';

class ProspectView extends StatefulWidget {
  final Prospect prospect;

  ProspectView(this.prospect);

  @override
  _ProspectViewState createState() => _ProspectViewState();
}

class _ProspectViewState extends State<ProspectView> {
  int totalPoint = 1;
  DateTime present = DateTime.now();

  void calculateTotalPointEarned() {
    TimeOfDay t;
    var now;
    var time;
    for (int i = 1; i < widget.prospect.steps['length']; i++) {
      if (widget.prospect.steps['${i}meetingTime'] != '')
        t = TimeOfDay(
            hour: int.parse(
                widget.prospect.steps['${i}meetingTime'].substring(0, 2)),
            minute: int.parse(
                widget.prospect.steps['${i}meetingTime'].substring(3, 5)));
      else
        t = TimeOfDay(hour: 0, minute: 0);
      now = DateTime.parse(widget.prospect.steps['${i}meetingDate']);
      time = DateTime(now.year, now.month, now.day, t.hour, t.minute);
      if (time.difference(present).inSeconds <= 0)
        totalPoint += widget.prospect.steps['${i}Point'];
    }
  }

  bool checkStepState() {
    int neededIndex = widget.prospect.steps['length'] - 1;
    TimeOfDay t;
    var now;
    var time;
    if (widget.prospect.steps['${neededIndex}meetingTime'] != '')
      t = TimeOfDay(
          hour: int.parse(widget.prospect.steps['${neededIndex}meetingTime']
              .substring(0, 2)),
          minute: int.parse(widget.prospect.steps['${neededIndex}meetingTime']
              .substring(3, 5)));
    else
      t = TimeOfDay(hour: 0, minute: 0);
    now = DateTime.parse(widget.prospect.steps['${neededIndex}meetingDate']);
    time = DateTime(now.year, now.month, now.day, t.hour, t.minute);
    if (time.difference(present).inSeconds <= 0) return true;
    return false;
  }

  void finishServiceWithProspect() async {
    String userId = FirebaseAuth.instance.currentUser.uid;
    await FirebaseFirestore.instance
        .collection('prospect')
        .doc(userId)
        .collection('prospects')
        .doc(widget.prospect.prospectId)
        .update({'done': 1});
  }

  @override
  void initState() {
    super.initState();
    calculateTotalPointEarned();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, false);
        return;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Prospect Detail'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.of(context).pop(false),
          ),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 25, left: 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 25, top: 25),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Prospect Detail",
                        style: TextStyle(
                          fontSize: 25,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    'Name: ${widget.prospect.prospectName}',
                    style: TextStyle(
                      fontSize: 22,
                    ),
                  ),
                  SizedBox(
                    height: 14,
                  ),
                  Text('Phone: ${widget.prospect.phoneNo}',
                      style: TextStyle(fontSize: 22)
                      // DateFormat('dd/MM/yyyy HH:mm')
                      // .format(DateTime.parse(widget.oneNew.newsId)),
                      // style: TextStyle(
                      //   fontSize: 18,
                      //   color: Colors.white70,
                      // ),
                      ),
                  SizedBox(
                    height: 14,
                  ),
                  widget.prospect.email != ''
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: Text('Email: ${widget.prospect.email}',
                              style: TextStyle(fontSize: 22)),
                        )
                      : SizedBox(),
                  Text(
                    'The Process:',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Total Point Earned:  $totalPoint',
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: 22,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(widget.prospect.steps['0'],
                      style: TextStyle(fontSize: 22)),
                  Text(
                    'Point: ${widget.prospect.steps['0Point']}',
                    style: TextStyle(color: Colors.amberAccent),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Date Added:  ' +
                        DateFormat('dd/MM/yyyy HH:mm').format(
                            DateTime.parse(widget.prospect.steps['0Time'])),
                    style: TextStyle(fontSize: 16),
                  ),
                  widget.prospect.steps['0memo'] != ''
                      ? Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            'Memo: ' + widget.prospect.steps['0memo'],
                            style: TextStyle(fontSize: 16),
                          ),
                        )
                      : SizedBox(),
                  widget.prospect.steps['length'] != 1
                      ? ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: widget.prospect.steps['length'],
                          itemBuilder: (context, index) {
                            if (index != 0) {
                              return Container(
                                  child: _displayProgress(index, present));
                            } else
                              return SizedBox();
                          })
                      : SizedBox(),
                  widget.prospect.done == 0 &&
                          widget.prospect.lastStep == 6 &&
                          checkStepState()
                      ? Padding(
                          padding: EdgeInsets.only(bottom: 25, right: 25),
                          child: Container(
                            alignment: Alignment.bottomRight,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 5.0,
                                padding: EdgeInsets.all(15.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                primary: Colors.amber[300],
                              ),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (_) => new AlertDialog(
                                    title: new Text("VIPC Message"),
                                    content: new Text(
                                        "Finish service with this prospect!\nProspect will be disappeared from the prospect list.\nYou still can see the prospect detail through search."),
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
                                          finishServiceWithProspect();
                                          Navigator.of(context).pop();
                                          Navigator.of(context).pop(true);
                                        },
                                      )
                                    ],
                                  ),
                                );
                              },
                              child: Text(
                                'Finish',
                                style: TextStyle(
                                  color: Colors.black,
                                  letterSpacing: 1.5,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        )
                      : SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _displayProgress(int index, DateTime present) {
    TimeOfDay t;
    if (widget.prospect.steps['${index}meetingTime'] != '')
      t = TimeOfDay(
          hour: int.parse(
              widget.prospect.steps['${index}meetingTime'].substring(0, 2)),
          minute: int.parse(
              widget.prospect.steps['${index}meetingTime'].substring(3, 5)));
    else
      t = TimeOfDay(hour: 0, minute: 0);
    final now = DateTime.parse(widget.prospect.steps['${index}meetingDate']);
    final time = DateTime(now.year, now.month, now.day, t.hour, t.minute);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 10,
        ),
        Text(widget.prospect.steps['$index'], style: TextStyle(fontSize: 22)),
        time.difference(present).inSeconds <= 0
            ? Text(
                'Point: ${widget.prospect.steps['${index}Point']}',
                style: TextStyle(color: Colors.amberAccent),
              )
            : Text(
                'Point About To Earn: ${widget.prospect.steps['${index}Point']}',
                style: TextStyle(color: Colors.amberAccent),
              ),
        SizedBox(
          height: 5,
        ),
        widget.prospect.steps['${index}meetingPlace'] != ''
            ? Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Text(
                  'Meet at: ' + widget.prospect.steps['${index}meetingPlace'],
                  style: TextStyle(fontSize: 16),
                ),
              )
            : SizedBox(),
        Text(
          DateFormat('HH:mm').format(time) != '00:00'
              ? 'Finish Date:  ' + DateFormat('dd/MM/yyyy HH:mm').format(time)
              : 'Finish Date:  ' + DateFormat('dd/MM/yyyy').format(time),
          style: TextStyle(fontSize: 16),
        ),
        widget.prospect.steps['${index}memo'] != ''
            ? Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text(
                  'Memo: ' + widget.prospect.steps['${index}memo'],
                  style: TextStyle(fontSize: 16),
                ),
              )
            : SizedBox(),
      ],
    );
  }
}
