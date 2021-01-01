import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:vipc_app/view/appbar/appbar_view.dart';
import 'package:vipc_app/view/drawer/drawer_view.dart';
import 'package:vipc_app/controller/news/news_controller.dart';
import 'package:vipc_app/view/news/news_details_view.dart';

class NewsView extends StatefulWidget {
  NewsView({key}) : super(key: key);

  @override
  _NewsViewState createState() => _NewsViewState();
}

class _NewsViewState extends StateMVC {
  _NewsViewState() : super(NewsController()) {
    _con = NewsController.con;
  }

  NewsController _con;

  @override
  Widget build(BuildContext context) {
    _con.newsCards.clear();
    for (int i = 0; i < _con.newsTitles.length; i++) {
      _con.newsCards.add(
        Card(
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

    return Scaffold(
      appBar: CustomAppBar(),
      drawer: CustomDrawer(),
      body: Container(
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
        },
        child: Icon(
          Icons.add,
          size: 35,
        ),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
