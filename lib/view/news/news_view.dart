import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:vipc_app/controller/admin/admin_controller.dart';
import 'package:vipc_app/model/news.dart';
import 'package:vipc_app/view/appbar/appbar_view.dart';
import 'package:vipc_app/view/bottomnavbar/bottomnavbar.dart';
import 'package:vipc_app/view/drawer/drawer_view.dart';
import 'package:vipc_app/view/news/news_details_view.dart';

class NewsView extends StatefulWidget {
  NewsView({key}) : super(key: key);

  @override
  _NewsViewState createState() => _NewsViewState();
}

class _NewsViewState extends StateMVC<NewsView> {
  _NewsViewState() : super(AdminController()) {
    _con = AdminController.con;
  }

  AdminController _con;

  @override
  Widget build(BuildContext context) {
    bool check = true;
    return Scaffold(
      appBar: CustomAppBar(),
      drawer: CustomDrawer(),
      body: FutureBuilder(
        future: _con.getNews(context),
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: () async {
                      setState(() {
                        check = false;
                      });
                      _con.getNews(context);
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
                                          child: newsItemCard(
                                              context, _con.newsList[index]),
                                        ),
                                      ),
                                    ],
                                  );
                                } else {
                                  return Padding(
                                    padding: EdgeInsets.only(top: 15),
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: newsItemCard(
                                          context, _con.newsList[index]),
                                    ),
                                  );
                                }
                              },
                            ),
                          )
                        : Center(
                            child: CircularProgressIndicator(),
                          ),
                  ),
      ),
    );
  }
}

Widget newsItemCard(BuildContext context, News oneNew) {
  return Card(
    color: Colors.amber[50],
    child: Padding(
      padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  oneNew.title,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 18,
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
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return NewsDetailsView(oneNew);
                  }));
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
