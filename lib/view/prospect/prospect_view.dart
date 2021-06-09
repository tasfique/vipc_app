import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vipc_app/model/prospect.dart';
import 'package:vipc_app/view/prospect/prospect_edit.dart';

class ProspectView extends StatefulWidget {
  final Prospect prospect;
  final String search;

  ProspectView(this.prospect, [this.search]);

  @override
  _ProspectViewState createState() => _ProspectViewState();
}

class _ProspectViewState extends State<ProspectView> {
  int totalPoint;
  DateTime present = DateTime.now();
  bool check, pushP;
  Prospect prospectDetail;

  Future<void> getResultProspect() async {
    String userId = FirebaseAuth.instance.currentUser.uid;
    DocumentSnapshot oneProspect = await FirebaseFirestore.instance
        .collection("prospect")
        .doc(userId)
        .collection('prospects')
        .doc(widget.prospect.prospectId)
        .get();
    prospectDetail = Prospect(
      prospectId: oneProspect.id,
      prospectName: oneProspect.data()['prospectName'],
      phoneNo: oneProspect.data()['phone'],
      email: oneProspect.data()['email'],
      type: oneProspect.data()['type'],
      steps: oneProspect.data()['steps'],
      lastUpdate: oneProspect.data()['lastUpdate'],
      lastStep: oneProspect.data()['lastStep'],
      done: oneProspect.data()['done'],
    );
    calculateTotalPointEarned();
  }

  void calculateTotalPointEarned() {
    totalPoint = 1;
    Prospect prospect;
    if (prospectDetail == null) {
      prospect = widget.prospect;
    } else {
      prospect = prospectDetail;
    }
    TimeOfDay t;
    var now;
    var time;
    for (int i = 1; i < prospect.steps['length']; i++) {
      if (prospect.steps['${i}meetingTime'] != '')
        t = TimeOfDay(
            hour: int.parse(prospect.steps['${i}meetingTime'].substring(0, 2)),
            minute:
                int.parse(prospect.steps['${i}meetingTime'].substring(3, 5)));
      else
        t = TimeOfDay(hour: 0, minute: 0);
      now = DateTime.parse(prospect.steps['${i}meetingDate']);
      time = DateTime(now.year, now.month, now.day, t.hour, t.minute);
      if (time.difference(present).inSeconds <= 0)
        totalPoint += prospect.steps['${i}Point'];
    }
  }

  bool checkStepState() {
    Prospect prospect;
    if (prospectDetail == null) {
      prospect = widget.prospect;
    } else {
      prospect = prospectDetail;
    }
    int neededIndex = prospect.steps['length'] - 1;
    TimeOfDay t;
    var now;
    var time;
    if (prospect.steps['${neededIndex}meetingTime'] != '')
      t = TimeOfDay(
          hour: int.parse(
              prospect.steps['${neededIndex}meetingTime'].substring(0, 2)),
          minute: int.parse(
              prospect.steps['${neededIndex}meetingTime'].substring(3, 5)));
    else
      t = TimeOfDay(hour: 0, minute: 0);
    now = DateTime.parse(prospect.steps['${neededIndex}meetingDate']);
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
    prospectDetail = null;
    check = true;
    pushP = false;
    super.initState();
    calculateTotalPointEarned();
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
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 25, left: 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 38, top: 40),
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        "Prospect Detail",
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
                              prospectDetail == null
                                  ? 'Name: ${widget.prospect.prospectName}'
                                  : 'Name: ${prospectDetail.prospectName}',
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
                                prospectDetail == null
                                    ? 'Phone: ${widget.prospect.phoneNo}'
                                    : 'Phone: ${prospectDetail.phoneNo}',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: TextStyle(
                                    fontSize: 22, color: Colors.black)),
                          ),
                          widget.prospect.email != '' && prospectDetail == null
                              ? Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Text('Email: ${widget.prospect.email}',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: TextStyle(
                                          fontSize: 22, color: Colors.black)),
                                )
                              : prospectDetail != null &&
                                      prospectDetail.email != ''
                                  ? Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Text(
                                          'Email: ${prospectDetail.email}',
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          style: TextStyle(
                                              fontSize: 22,
                                              color: Colors.black)),
                                    )
                                  : SizedBox(),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                                prospectDetail == null
                                    ? 'Type: ${widget.prospect.type}'
                                    : 'Type: ${prospectDetail.type}',
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
                    padding: const EdgeInsets.all(10),
                    child: const Divider(
                      height: 20,
                      thickness: 2,
                      indent: 1,
                      endIndent: 1,
                      color: Colors.amber,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Text(
                      'Total Point(s) Earned:  ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 35,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5),
                  ),
                  Center(
                    child: Text(
                      '$totalPoint',
                      style: TextStyle(
                        color: Colors.amber,
                        fontSize: 35,
                      ),
                    ),
                  ),
                  const Divider(
                    height: 20,
                    thickness: 2,
                    indent: 1,
                    endIndent: 1,
                    color: Colors.amber,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                      prospectDetail == null
                          ? widget.prospect.steps['0']
                          : prospectDetail.steps['0'],
                      style: TextStyle(fontSize: 22)),
                  Text(
                    prospectDetail == null
                        ? 'Point(s): ${widget.prospect.steps['0Point']}'
                        : 'Point(s): ${prospectDetail.steps['0Point']}',
                    style: TextStyle(color: Colors.amberAccent),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Date Added:  ' +
                        DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(
                            prospectDetail == null
                                ? widget.prospect.steps['0Time']
                                : prospectDetail.steps['0Time'])),
                    style: TextStyle(fontSize: 16),
                  ),
                  const Divider(
                    height: 20,
                    thickness: 0.5,
                    indent: 1,
                    endIndent: 1,
                    color: Colors.amber,
                  ),
                  widget.prospect.steps['0memo'] != '' && prospectDetail == null
                      ? Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            'Memo: ' + widget.prospect.steps['0memo'],
                            style: TextStyle(fontSize: 16),
                          ),
                        )
                      : prospectDetail != null &&
                              prospectDetail.steps['0memo'] != ''
                          ? Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                'Memo: ' + prospectDetail.steps['0memo'],
                                style: TextStyle(fontSize: 16),
                              ),
                            )
                          : SizedBox(),
                  Padding(
                    padding: const EdgeInsets.all(10),
                  ),
                  widget.prospect.steps['length'] != 1 && prospectDetail == null
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
                      : prospectDetail != null &&
                              prospectDetail.steps['length'] != 1
                          ? ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: prospectDetail.steps['length'],
                              itemBuilder: (context, index) {
                                if (index != 0) {
                                  return Container(
                                      child: _displayProgress(index, present));
                                } else
                                  return SizedBox();
                              })
                          : SizedBox(),
                  ((widget.prospect.done == 0 &&
                              widget.prospect.lastStep == 6 &&
                              checkStepState() &&
                              prospectDetail == null) ||
                          (prospectDetail != null &&
                              prospectDetail.done == 0 &&
                              prospectDetail.lastStep == 6 &&
                              checkStepState()))
                      ? Padding(
                          padding: EdgeInsets.only(bottom: 25, right: 25),
                          child: Container(
                            alignment: Alignment.bottomCenter,
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
        floatingActionButton:
            (widget.search == "Search" && widget.search != null)
                ? Container(
                    padding: EdgeInsets.all(10),
                    child: FloatingActionButton(
                      onPressed: () async {
                        pushP = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditProspect(
                                    prospectDetail == null
                                        ? widget.prospect
                                        : prospectDetail,
                                    'prospectDetail')));
                        if (pushP == null) {
                          Navigator.pop(context, true);
                        } else if (pushP) {
                          setState(() {
                            check = false;
                          });
                          await getResultProspect();
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
                  )
                : Container(),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }

  Widget _displayProgress(int index, DateTime present) {
    Prospect prospect;
    if (prospectDetail == null) {
      prospect = widget.prospect;
    } else {
      prospect = prospectDetail;
    }
    TimeOfDay t;
    if (prospect.steps['${index}meetingTime'] != '')
      t = TimeOfDay(
          hour:
              int.parse(prospect.steps['${index}meetingTime'].substring(0, 2)),
          minute:
              int.parse(prospect.steps['${index}meetingTime'].substring(3, 5)));
    else
      t = TimeOfDay(hour: 0, minute: 0);
    final now = DateTime.parse(prospect.steps['${index}meetingDate']);
    final time = DateTime(now.year, now.month, now.day, t.hour, t.minute);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 10,
        ),
        Text(prospect.steps['$index'], style: TextStyle(fontSize: 22)),
        time.difference(present).inSeconds <= 0
            ? Text(
                'Point(s): ${prospect.steps['${index}Point']}',
                style: TextStyle(color: Colors.amberAccent),
              )
            : Text(
                'Pending Point(s): ${prospect.steps['${index}Point']}',
                style: TextStyle(color: Colors.amberAccent),
              ),
        SizedBox(
          height: 5,
        ),
        Text(
          DateFormat('HH:mm').format(time) != '00:00'
              ? 'Finish Date:  ' + DateFormat('dd/MM/yyyy HH:mm').format(time)
              : 'Finish Date:  ' + DateFormat('dd/MM/yyyy').format(time),
          style: TextStyle(fontSize: 16),
        ),
        const Divider(
          height: 20,
          thickness: 0.5,
          indent: 1,
          endIndent: 1,
          color: Colors.amber,
        ),
        prospect.steps['${index}meetingPlace'] != ''
            ? Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Text(
                  'Meet at: ' + prospect.steps['${index}meetingPlace'],
                  style: TextStyle(fontSize: 16),
                ),
              )
            : SizedBox(),
        prospect.steps['${index}memo'] != ''
            ? Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text(
                  'Memo: ' + prospect.steps['${index}memo'],
                  style: TextStyle(fontSize: 16),
                ),
              )
            : SizedBox(),
        Padding(
          padding: const EdgeInsets.all(10),
        ),
      ],
    );
  }
}
