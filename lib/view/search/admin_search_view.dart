import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:vipc_app/controller/admin/admin_controller.dart';

class AdminSearchView extends StatefulWidget {
  @override
  _AdminSearchViewState createState() => _AdminSearchViewState();
}

class _AdminSearchViewState extends StateMVC<AdminSearchView> {
  _AdminSearchViewState() : super(AdminController()) {
    _con = AdminController.con;
  }

  AdminController _con;

  TextEditingController _searchQueryController = TextEditingController();
  List<DocumentSnapshot> documentList = [];

  // @override
  void disposeMethod() {
    _con.getRequestPasswordCount();
    // super.dispose();
  }

  Future<void> searchData() async {
    FocusScope.of(context).unfocus();
// final users = await FirebaseFirestore.instance
//           .collection("users")
//           .where("requestChangingPassword", isEqualTo: '1')
//           .get();

    // users.docs.forEach((user) {
    //   userListRequestTemp.add(Usr(
    //       userId: user.id,
    //       empID: user.data()['empID'],
    //       email: user.data()['email'],
    //       fullName: user.data()['fullName'],
    //       type: user.data()['type'],
    //       assignUnder: user.data()['assignUnder'],
    //       password: user.data()['password']));
    // });
    // userListRequestPassword = userListRequestTemp;

    documentList = (await FirebaseFirestore.instance
            .collection('search')
            .doc('adminSearch')
            .collection('search')
            .where("searchCase",
                arrayContains: _searchQueryController.text.toLowerCase())
            .get())
        .docs;

    setState(() {});
    //     .document(await firestoreProvider.getUid())
    //     .collection(caseCategory)
    //     .where("caseNumber", isGreaterThanOrEqualTo: query)
    //     .getDocuments())
    // .documents;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        print('test1');
        _searchQueryController.clear();
        disposeMethod();
        Navigator.of(context).pop(true);
        return;
      },
      child: Scaffold(
        drawer: null,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              _searchQueryController.clear();
              disposeMethod();
              print('test2');
              Navigator.of(context).pop(true);
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
                  disposeMethod();
                  print('test3');
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
                  documentList.length != 0
              ? Column(
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: documentList.length,
                      itemBuilder: (context, index) {
                        var result = documentList[index];
                        return _itemCard(result);
                        // return ListTile(
                        //   title: result['type'] == 'News'
                        //       ? Text(result['title'])
                        //       : Text(result['fullName']),
                        //   subtitle: Text(result['type']),
                        //   trailing: IconButton(
                        //     onPressed: null,
                        //     icon: Icon(Icons.read_more),
                        //   ),
                        // );
                      },
                    ),
                  ],
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

  Widget _itemCard(DocumentSnapshot result) {
    print(result['type']);
    return Container(
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
                        result['type'] == 'User'
                            ? 'Full Name: ${result['fullName']}'
                            : 'Title: ${result['title']}',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  subtitle: Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                      'Type: ${result['type']}',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.read_more_sharp),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => null));
                    },
                  )
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
    );
  }
}
