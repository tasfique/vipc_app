import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:vipc_app/model/user.dart';
import 'package:vipc_app/view/admin_news_control/news_edit.dart';
import 'package:vipc_app/view/appbar/appbar_view.dart';
import 'package:vipc_app/view/drawer/drawer_view.dart';
import 'package:vipc_app/controller/news/admin_controller.dart';
import 'package:vipc_app/view/news/news_details_view.dart';
import 'package:vipc_app/view/admin_news_control/news_upload_view.dart';
import 'package:vipc_app/view/admin_user_control/user_edit.dart';
import 'package:vipc_app/view/admin_user_control/user_add.dart';

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

  // int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _con.userList = [];
    // _con.getUser(context);
    // _con.isLoadingUser = false;
    _con.newsCards.clear();
    for (int i = 0; i < _con.newsTitles.length; i++) {
      _con.newsCards.add(
        Card(
          color: Colors.amber[50],
          child: Padding(
            padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  title: Row(
                    children: [
                      Expanded(
                        flex: 8,
                        child: Text(
                          _con.newsTitles[i],
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: GestureDetector(
                          onTap: () {
                            _con.selectedNewsIndex = i;
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditArticle()));
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: Icon(
                              Icons.edit,
                              size: 30,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  subtitle: Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Text(
                      _con.newsContents[i],
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    const SizedBox(width: 8),
                    TextButton(
                      child: const Text('Read more...'),
                      onPressed: () {
                        _con.selectedIndex = i;
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return NewsDetailsView();
                        }));
                      },
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      drawer: CustomDrawer(),
      body: _con.selectedIndex == 0 ? newsContainer() : userListContainer(),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        child: BottomNavigationBar(
          currentIndex: _con.selectedIndex,
          onTap: (val) {
            setState(() => _con.selectedIndex = val);
          },
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.article,
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
        onPressed: () {
          _con.selectedIndex == 0
              ? Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddArticle()))
              : Navigator.push(
                  context, MaterialPageRoute(builder: (context) => AddUser()));
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
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: _con.newsCards.length,
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
                    child: _con.newsCards[index],
                  ),
                ),
              ],
            );
          } else {
            return Padding(
              padding: EdgeInsets.only(top: 15),
              child: Container(
                alignment: Alignment.center,
                child: _con.newsCards[index],
              ),
            );
          }
        },
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
              onRefresh: () async => await _con.getUser(context),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: _con.userList.length,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 10),
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
                          Padding(
                            padding: EdgeInsets.only(top: 15),
                            child: Container(
                              alignment: Alignment.center,
                              child: userItemCard(index, _con.userList[index]),
                            ),
                          )
                        ],
                      );
                    } else {
                      return Padding(
                        padding: EdgeInsets.only(top: 15),
                        child: Container(
                          alignment: Alignment.center,
                          child: userItemCard(index, _con.userList[index]),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
    );
  }

  Widget userItemCard(int index, Usr user) {
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
                    padding: EdgeInsets.only(left: 5),
                    child: Text(
                      user.fullName,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditUser(user)));
                    },
                    child: Container(
                      alignment: Alignment.topRight,
                      padding: EdgeInsets.all(10),
                      child: Icon(
                        Icons.edit,
                        size: 30,
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
}
