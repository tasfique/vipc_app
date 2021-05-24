import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:vipc_app/controller/admin/admin_controller.dart';
import 'package:vipc_app/model/news.dart';
import 'package:vipc_app/model/user.dart';
import 'package:vipc_app/view/admin_user_control/user_detail_view.dart';
import 'package:vipc_app/view/news/news_details_view.dart';

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
  bool check = false;

  @override
  void dispose() async {
    super.dispose();
    await _con.getRequestPasswordCount();
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
        dispose();
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
              dispose();
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
                  dispose();
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

  Future<Usr> getResultUser(String id) async {
    DocumentSnapshot user =
        await FirebaseFirestore.instance.collection('users').doc(id).get();
    Usr userTemp;
    userTemp = (Usr(
        userId: user.id,
        empID: user.data()['empID'],
        email: user.data()['email'],
        fullName: user.data()['fullName'],
        type: user.data()['type'],
        assignUnder: user.data()['assignUnder'],
        password: user.data()['password']));

    return userTemp;
  }

  Future<News> getResultNews(String id) async {
    DocumentSnapshot news =
        await FirebaseFirestore.instance.collection('news').doc(id).get();
    News newsTemp;
    if (news.data()['images'] == null) {
      newsTemp = (News(
        newsId: news.id,
        title: news.data()['title'],
        content: news.data()['content'],
        // dateCreated: oneNew.id,
        // imageUrl: oneNew.data()['images'],
      ));
    } else {
      newsTemp = (News(
        newsId: news.id,
        title: news.data()['title'],
        content: news.data()['content'],
        // dateCreated: oneNew.id,
        imageUrl: news.data()['images'],
      ));
    }

    return newsTemp;
  }

  Widget _itemCard(DocumentSnapshot result) {
    return GestureDetector(
      onTap: () async {
        if (result['type'] == 'User') {
          var user = await getResultUser(result.id);
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => UserDetailsView(user)));
        } else if (result['type'] == 'News') {
          var news = await getResultNews(result.id);
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => NewsDetailsView(news)));
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
                        result['type'] == 'User'
                            ? 'Full Name: ${result['fullName']}'
                            : 'Title: ${result['title']}',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
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
                      'Type: ${result['type']}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                      textAlign: TextAlign.end,
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
