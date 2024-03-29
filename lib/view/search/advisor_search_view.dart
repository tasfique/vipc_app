import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:vipc_app/controller/home/advisor_controller.dart';
import 'package:vipc_app/model/prospect.dart';
import 'package:vipc_app/view/prospect/prospect_view.dart';

class AdvisorSearchView extends StatefulWidget {
  @override
  _AdvisorSearchViewState createState() => _AdvisorSearchViewState();
}

class _AdvisorSearchViewState extends StateMVC<AdvisorSearchView> {
  _AdvisorSearchViewState() : super(AdvisorController()) {
    _con = AdvisorController.con;
  }

  AdvisorController _con;

  TextEditingController _searchQueryController = TextEditingController();
  List<DocumentSnapshot> documentList = [];
  bool check = false;

  @override
  void dispose() {
    super.dispose();
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
        Navigator.of(context).pop();
        return;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              _searchQueryController.clear();
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

  Widget _itemCard(DocumentSnapshot result) {
    return GestureDetector(
      onTap: () async {
        var prospect = await getResultProspect(result.id);
        final pushProspectDetail = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProspectView(prospect, "Search")));
        if (pushProspectDetail) {
          _clearSearchQuery();
        }
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(16, 0, 16, 7),
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
                        'Full Name: ${result['prospectName']}',
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
                      'Phone Number: ${result['phone']}',
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
