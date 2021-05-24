import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:vipc_app/controller/admin/admin_controller.dart';
import 'package:vipc_app/model/news.dart';
import 'package:vipc_app/model/user.dart';
import 'package:vipc_app/view/admin_news_control/news_edit_view.dart';
import 'package:vipc_app/view/admin_user_control/user_detail_view.dart';
import 'package:vipc_app/view/appbar/appbar_admin_view.dart';
import 'package:vipc_app/view/news/news_details_view.dart';
import 'package:vipc_app/view/admin_news_control/news_upload_view.dart';
import 'package:vipc_app/view/admin_user_control/user_edit_view.dart';
import 'package:vipc_app/view/admin_user_control/user_add_view.dart';
import 'package:vipc_app/view/search/admin_search_view.dart';

class AdminPage extends StatefulWidget {
  AdminPage({key}) : super(key: key);

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends StateMVC {
  _AdminPageState() : super(AdminController()) {
    _con = AdminController.con;
  }

  AdminController _con;
  bool check = true;
  bool check2 = true;
  // int selectedIndex = 0;
  //

  Future<void> saveTokenToDatabase(String token) async {
    String userId = FirebaseAuth.instance.currentUser.uid;

    await FirebaseFirestore.instance
        .collection('users')
        .where('token', isEqualTo: token)
        .get()
        .then((value) {
      value.docs.forEach((element) async {
        if (element.id != userId)
          await FirebaseFirestore.instance
              .collection('users')
              .doc(element.id)
              .update({'token': ''});
      });
    });

    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'token': token,
    });
  }

  _saveDeviceToken() async {
    String token = await FirebaseMessaging.instance.getToken();
    await saveTokenToDatabase(token);
    FirebaseMessaging.instance.onTokenRefresh.listen(saveTokenToDatabase);
    // String fcmToken = await _fcm.getToken();
  }

  @override
  void initState() {
    _con.userList = [];
    _con.newsList = [];
    // _con.requestPasswordCount = 0;
    // _con.managers = [];
    _con.getRequestPasswordCount();
    _saveDeviceToken();
    // _con.getAdminDetail();
    super.initState();
    // _con.getNews(context);
    // _con.getUser(context);
    // _con.isLoadingUser = false;
  }

  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AdminAppBar(),
      drawer: FutureBuilder(
          future: _con.getAdminDetail(),
          builder: (context, snapshot) =>
              snapshot.connectionState == ConnectionState.waiting
                  ? Center(child: CircularProgressIndicator())
                  : _drawer()),
      body: _con.selectedIndex == 0 ? newsContainer() : userListContainer(),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        child: BottomNavigationBar(
          currentIndex: _con.selectedIndex,
          onTap: (val) {
            setState(() => _con.selectedIndex = val);
          },
          showSelectedLabels: true,
          showUnselectedLabels: false,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.my_library_books,
                color:
                    _con.selectedIndex == 0 ? Colors.amber[320] : Colors.white,
              ),
              label: 'News',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                color:
                    _con.selectedIndex == 1 ? Colors.amber[320] : Colors.white,
              ),
              label: 'User',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (_con.selectedIndex == 0) {
            final pushP = await Navigator.push(
                context, MaterialPageRoute(builder: (context) => AddNews()));
            if (pushP) {
              setState(() {
                check = false;
              });
              await _con.getNews(context);
              setState(() {
                check = true;
              });
            }
          } else {
            final pushP2 = await Navigator.push(
                context, MaterialPageRoute(builder: (context) => AddUser()));
            if (pushP2) {
              setState(() {
                check2 = false;
              });
              await _con.getUser(context);
              setState(() {
                check2 = true;
              });
            }
          }
        },
        child: Icon(
          Icons.add,
          size: 35,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget newsContainer() {
    return FutureBuilder(
      future: _con.getNews(context),
      builder: (context, snapshot) => snapshot.connectionState ==
              ConnectionState.waiting
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  check = false;
                });
                await _con.getNews(context);
                setState(() {
                  check = true;
                });
              },
              child: (check)
                  ? Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 24.0),
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: _con.newsList.length,
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 25),
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "VIPC News",
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 15),
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: newsItemCard(_con.newsList[index]),
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return Padding(
                              padding: EdgeInsets.only(top: 15),
                              child: Container(
                                alignment: Alignment.center,
                                child: newsItemCard(_con.newsList[index]),
                              ),
                            );
                          }
                        },
                      ),
                    )
                  : Center(child: CircularProgressIndicator()),
            ),
    );
  }

  Widget newsItemCard(News oneNew) {
    return Card(
      color: Colors.amber[50],
      child: Padding(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: Row(
                children: [
                  Expanded(
                    flex: 8,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          oneNew.title,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          DateFormat('dd/MM/yyyy HH:mm')
                              .format(DateTime.parse(oneNew.newsId)),
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: GestureDetector(
                      onTap: () async {
                        _con.getRequestPasswordCount();
                        final pushPage = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditNews(oneNew)));
                        if (pushPage) {
                          setState(() {
                            check = false;
                          });
                          await _con.getNews(context);
                          setState(() {
                            check = true;
                          });
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Icon(
                          Icons.edit,
                          size: 30,
                          color: Colors.brown,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              subtitle: Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text(
                  oneNew.content,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                  style: TextStyle(
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                const SizedBox(width: 8),
                TextButton(
                  child: const Text('Read more...'),
                  onPressed: () async {
                    // await _con.getRequestPasswordCount();
                    final pushDetailResult = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NewsDetailsView(oneNew)));
                    if (pushDetailResult) {
                      await _con.getRequestPasswordCount();
                    }
                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (context) {
                    //   return NewsDetailsAdminView(oneNew);
                    // }));
                  },
                ),
                const SizedBox(width: 8),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget userListContainer() {
    return FutureBuilder(
      future: _con.getUser(context),
      builder: (context, snapshot) => snapshot.connectionState ==
              ConnectionState.waiting
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  check2 = false;
                });
                await _con.getUser(context);
                setState(() {
                  check2 = true;
                });
              },
              child: (check2)
                  ? Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 24.0),
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: _con.userList.length,
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 25),
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "User List",
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                UserDetailsView(
                                                    _con.userList[index])));
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 15),
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: userItemCard(_con.userList[index]),
                                    ),
                                  ),
                                )
                              ],
                            );
                          } else {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => UserDetailsView(
                                            _con.userList[index])));
                              },
                              child: Padding(
                                padding: EdgeInsets.only(top: 15),
                                child: Container(
                                  alignment: Alignment.center,
                                  child: userItemCard(_con.userList[index]),
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    )
                  : Center(child: CircularProgressIndicator()),
            ),
    );
  }

  Widget userItemCard(Usr user) {
    return Card(
      color: Colors.amber[50],
      child: Padding(
        padding: EdgeInsets.fromLTRB(10, 0, 10, 15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children: [
                Expanded(
                  flex: 8,
                  child: Container(
                    padding: EdgeInsets.only(left: 5, top: 5),
                    child: Text(
                      user.fullName,
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
                Expanded(
                  flex: 2,
                  child: GestureDetector(
                    onTap: () async {
                      _con.getRequestPasswordCount();
                      final pushPage2 = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditUser(user)));
                      if (pushPage2) {
                        setState(() {
                          check2 = false;
                        });
                        await _con.getUser(context);
                        setState(() {
                          check2 = true;
                        });
                      }
                    },
                    child: Container(
                      alignment: Alignment.topRight,
                      padding: EdgeInsets.all(10),
                      child: Icon(
                        Icons.edit,
                        size: 30,
                        color: Colors.brown,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  flex: 7,
                  child: Container(
                    padding: EdgeInsets.only(left: 10, top: 5),
                    child: Text(
                      user.empID,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(left: 10, top: 5, right: 5),
                    child: Text(
                      user.type,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(_con.adminDetail.fullName),
            decoration: BoxDecoration(
              color: Colors.amber,
            ),
            accountEmail: Text(
              _con.adminDetail.email,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Image.asset(
                ('assets/images/logo.png'),
              ),
            ),
          ),
          ListTile(
            title: Text(
              'Home',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            title: Text(
              'Search',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AdminSearchView()));
            },
          ),
          ListTile(
            title: Text(
              'News',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onTap: () {
              Navigator.of(context).pop();
              setState(() {
                _con.selectedIndex = 0;
              });
            },
          ),
          ListTile(
            title: Text(
              'User',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onTap: () {
              Navigator.of(context).pop();
              setState(() {
                _con.selectedIndex = 1;
              });
            },
          ),
          ListTile(
            title: Text('Logout'),
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => new AlertDialog(
                  title: new Text("VIPC Message"),
                  content: new Text("Do you want to log out?"),
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
                        Navigator.of(context).pop();
                        String userId = FirebaseAuth.instance.currentUser.uid;
                        FirebaseAuth.instance.signOut();
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(userId)
                            .update({'token': ''});
                      },
                    )
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
