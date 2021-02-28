import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:vipc_app/model/user_list.dart';
import 'package:vipc_app/view/appbar/appbar_view.dart';
import 'package:vipc_app/view/drawer/drawer_view.dart';
import 'package:vipc_app/controller/news/news_controller.dart';
import 'package:vipc_app/view/news/news_details_view.dart';

class AdminNewsView extends StatefulWidget {
  AdminNewsView({key}) : super(key: key);

  @override
  _AdminNewsViewState createState() => _AdminNewsViewState();
}

class _AdminNewsViewState extends StateMVC {
  _AdminNewsViewState() : super(NewsController()) {
    _con = NewsController.con;
  }

  NewsController _con;

  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
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
                  title: Text(
                    _con.newsTitles[i],
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 18,
                    ),
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
                    FlatButton(
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
      body: selectedIndex == 0 ? newsContainer() : userListContainer(),
      bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 10,
          child: BottomNavigationBar(
            currentIndex: selectedIndex,
            onTap: (val) {
              /// [SET STATE MEANS REBUILD WIDGET BUILD]
              setState(() => selectedIndex = val);
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.article,
                  color: selectedIndex == 0 ? Colors.amber[320] : Colors.white,
                ),
                title: SizedBox.shrink(),
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.person,
                  color: selectedIndex == 1 ? Colors.amber[320] : Colors.white,
                ),
                title: SizedBox.shrink(),
              ),
            ],
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) => AdminUserListView())); //NewArticle()
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
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: _con.userList.length,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Row(
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
                  padding: EdgeInsets.only(left: 210),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: Icon(Icons.sort),
                      color: Colors.white,
                      tooltip: 'Sort by Step Number',
                      onPressed: () {
                        //add code for sorting.
                      },
                    ),
                  ),
                ),
                //I think padding for prospect cards the below commented code
                // Padding(
                //   padding: EdgeInsets.only(top: 15),
                //   child: Container(
                //     alignment: Alignment.center,
                //     child: Prospect.prospectCards[index],
                //   ),
                // ),
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
    );
  }

  Widget userItemCard(int index, User user) {
    return Card(
      //Prospect Card background color
      color: Colors.amber[50],
      //
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
                      user.userFullName,
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
                    /// [EDIT ICON FOR USER]
                    onTap: () {},
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
                      user.username,
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
                      user.userType,
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
