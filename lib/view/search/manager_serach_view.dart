import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:vipc_app/controller/home/manager_controller.dart';
import 'package:vipc_app/model/prospect.dart';
import 'package:vipc_app/model/user.dart';
import 'package:vipc_app/view/admin_user_control/user_detail_view.dart';
import 'package:vipc_app/view/monitor/monitor_details_view.dart';
import 'package:vipc_app/view/prospect/prospect_view.dart';

class ManagerSearchView extends StatefulWidget {
  @override
  _ManagerSearchViewState createState() => _ManagerSearchViewState();
}

class _ManagerSearchViewState extends StateMVC<ManagerSearchView> {
  _ManagerSearchViewState() : super(ManagerController()) {
    _con = ManagerController.con;
  }

  ManagerController _con;

  TextEditingController _searchQueryController = TextEditingController();
  List<DocumentSnapshot> documentList = [];
  bool check = false;
  int weeklyPoint, monthlyPoint;

  @override
  void dispose() {
    super.dispose();
    // await _con.getRequestPasswordCount();
  }

  Future<void> searchData() async {
    FocusScope.of(context).unfocus();
    documentList = (await FirebaseFirestore.instance
            .collection('search')
            .doc('userSearch')
            .collection('${_con.userId}')
            .where("searchCase",
                arrayContains: _searchQueryController.text.toLowerCase())
            .get())
        .docs;

    if (documentList.length == 0)
      check = true;
    else
      check = false;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        _searchQueryController.clear();
        // dispose();
        Navigator.of(context).pop();
        return;
      },
      child: Scaffold(
        // drawer: null,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              _searchQueryController.clear();
              // dispose();
              Navigator.of(context).pop();
            },
          ),
          title: TextFormField(
            onEditingComplete: () => searchData(),
            controller: _searchQueryController,
            autofocus: true,
            decoration: InputDecoration(
              hintText: "Enter Data...",
              border: InputBorder.none,
            ),
            style: TextStyle(fontSize: 16.0),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                if (_searchQueryController == null ||
                    _searchQueryController.text.isEmpty) {
                  _searchQueryController.clear();
                  // dispose();
                  Navigator.pop(context);
                  return;
                }
                _clearSearchQuery();
              },
            ),
          ],
        ),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: _searchQueryController.text.isNotEmpty &&
                  _searchQueryController.text != null &&
                  !check
              ? SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: documentList.length,
                        itemBuilder: (context, index) {
                          var result = documentList[index];
                          return _itemCard(result);
                        },
                      ),
                    ],
                  ),
                )
              : _searchQueryController.text.isNotEmpty &&
                      _searchQueryController.text != null &&
                      check
                  ? Container(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        'No result found!',
                        style: TextStyle(fontSize: 20),
                      ),
                    )
                  : Container(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        'Enter keyword to search...',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
        ),
      ),
    );
  }

  void _clearSearchQuery() {
    setState(() {
      _searchQueryController.clear();
    });
  }

  Future<Prospect> getResultProspect(String id) async {
    DocumentSnapshot oneProspect = await FirebaseFirestore.instance
        .collection("prospect")
        .doc(_con.userId)
        .collection('prospects')
        .doc(id)
        .get();
    Prospect prospectTemp;
    prospectTemp = (Prospect(
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
    return prospectTemp;
  }

  Future<Usr> getResultUser(String id) async {
    DocumentSnapshot user =
        await FirebaseFirestore.instance.collection('users').doc(id).get();
    Usr userTemp;
    userTemp = Usr(
        userId: user.id,
        empID: user.data()['empID'],
        email: user.data()['email'],
        fullName: user.data()['fullName'],
        type: user.data()['type'],
        assignUnder: user.data()['assignUnder'],
        password: user.data()['password']);

    DateTime presentForAdvisor = DateTime.now();
    int currentYearForAdvisor = presentForAdvisor.year;
    int currentMonthForAdvisor = presentForAdvisor.month;
    monthlyPoint = 0;
    int firstDateForAdvisor, lastDateForAdvisor;
    weeklyPoint = 0;

    try {
      var prospects = await FirebaseFirestore.instance
          .collection("prospect")
          .doc(id)
          .collection('prospects')
          .get();

      TimeOfDay t;
      var now;
      var time;

      if (presentForAdvisor.day >= 1 && presentForAdvisor.day <= 7) {
        firstDateForAdvisor = 1;
        lastDateForAdvisor = 7;
      } else if (presentForAdvisor.day >= 8 && presentForAdvisor.day <= 14) {
        firstDateForAdvisor = 8;
        lastDateForAdvisor = 14;
      } else if (presentForAdvisor.day >= 15 && presentForAdvisor.day <= 21) {
        firstDateForAdvisor = 15;
        lastDateForAdvisor = 21;
      } else {
        firstDateForAdvisor = 22;
        lastDateForAdvisor =
            DateTime(DateTime.now().year, DateTime.now().month + 1, 0).day;
      }

      prospects.docs.forEach((oneProspect) {
        DateTime createdTime =
            DateTime.parse(oneProspect.data()['steps']['0Time']);
        if (createdTime.difference(presentForAdvisor).inSeconds <= 0 &&
            createdTime.year == currentYearForAdvisor &&
            createdTime.month == currentMonthForAdvisor) monthlyPoint++;

        if (createdTime.difference(presentForAdvisor).inSeconds <= 0 &&
            createdTime.year == currentYearForAdvisor &&
            createdTime.month == currentMonthForAdvisor &&
            createdTime.day >= firstDateForAdvisor &&
            createdTime.day <= lastDateForAdvisor) weeklyPoint++;

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
          if (time.difference(presentForAdvisor).inSeconds <= 0 &&
              now.year == currentYearForAdvisor &&
              now.month == currentMonthForAdvisor)
            monthlyPoint += oneProspect.data()['steps']['${i}Point'];

          if (time.difference(presentForAdvisor).inSeconds <= 0 &&
              now.year == currentYearForAdvisor &&
              now.month == currentMonthForAdvisor &&
              time.day >= firstDateForAdvisor &&
              time.day <= lastDateForAdvisor)
            weeklyPoint = oneProspect.data()['steps']['${i}Point'];
        }
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(error.toString()),
            backgroundColor: Theme.of(context).errorColor),
      );
    }
    return userTemp;
  }

  Widget _itemCard(DocumentSnapshot result) {
    return GestureDetector(
      onTap: () async {
        if (result['type'] == 'Prospect') {
          var prospect = await getResultProspect(result.id);
          final pushProspectDetail = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProspectView(prospect, "Search")));
          if (pushProspectDetail) {
            _clearSearchQuery();
          }
        } else if (result['type'] == 'Advisor') {
          var user = await getResultUser(result.id);
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      MonitorDetailsView(user, weeklyPoint, monthlyPoint)));
        }
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(16, 0, 16, 7),
        //  symmetric(horizontal: 16.0, vertical: 2.0),
        child: Card(
          color: Colors.amber[50],
          child: Padding(
            padding: const EdgeInsets.only(left: 3, right: 3, bottom: 5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        result['type'] == 'Prospect'
                            ? 'Full Name: ${result['prospectName']}'
                            : 'Full Name: ${result['fullName']}',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  subtitle: Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                      result['type'] == 'Prospect'
                          ? 'Phone Number: ${result['phone']}'
                          : 'Type: Advisor',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.end,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  // trailing: IconButton(
                  //   icon: Icon(Icons.read_more_sharp),
                  //   onPressed: () {
                  //     Navigator.push(context,
                  //         MaterialPageRoute(builder: (context) => null));
                  //   },
                  // )
                  // TextButton(
                  //   child: const Text('See Detail'),
                  //   onPressed: () {
                  //     Navigator.push(
                  //         context, MaterialPageRoute(builder: (context) => null));
                  //   },
                  // ),
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.end,
                //   children: <Widget>[
                //     const SizedBox(width: 8),
                //     TextButton(
                //       child: const Text('See Detail'),
                //       onPressed: () {
                //         Navigator.push(
                //             context, MaterialPageRoute(builder: (context) => null));
                //       },
                //     ),
                //     const SizedBox(width: 8),
                //   ],
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
