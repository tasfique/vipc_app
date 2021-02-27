import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:vipc_app/view/appbar/appbar_view.dart';
import 'package:vipc_app/view/drawer/drawer_view.dart';
import 'package:vipc_app/controller/news/news_controller.dart';

class NewsDetailsView extends StatefulWidget {
  NewsDetailsView({key}) : super(key: key);

  @override
  _NewsDetailsViewState createState() => _NewsDetailsViewState();
}

class _NewsDetailsViewState extends StateMVC {
  _NewsDetailsViewState() : super(NewsController()) {
    _con = NewsController.con;
  }

  NewsController _con;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      drawer: CustomDrawer(),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(25),
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "News Details",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(25),
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _con.newsTitles[_con.selectedIndex],
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(25),
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _con.newsContents[_con.selectedIndex],
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
