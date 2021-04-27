import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:vipc_app/model/news.dart';
import 'package:vipc_app/view/appbar/appbar_view.dart';
import 'package:vipc_app/view/drawer/drawer_view.dart';

class NewsDetailsView extends StatefulWidget {
  final News oneNew;

  NewsDetailsView(this.oneNew);

  @override
  _NewsDetailsViewState createState() => _NewsDetailsViewState();
}

class _NewsDetailsViewState extends StateMVC<NewsDetailsView> {
  // _NewsDetailsViewState() : super(AdminController()) {
  //   _con = AdminController.con;
  // }

  // AdminController _con;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      // drawer: CustomDrawer(),
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
                padding: EdgeInsets.fromLTRB(25, 0, 25, 15),
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.oneNew.title,
                        style: TextStyle(
                          fontSize: 25,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        DateFormat('dd/MM/yyyy HH:mm')
                            .format(DateTime.parse(widget.oneNew.newsId)),
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(25),
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.oneNew.content,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              if (widget.oneNew.imageUrl != null) null
              //                 NetworkImage(widget.oneNew.imageUrl[i])

              // for (int i = 0; i < widget.oneNew.imageUrl['length']; i++)
              //   NetworkImage(widget.oneNew.imageUrl[i])
              // Text(widget.oneNew.imageUrl['length'].toString())
              // Text(widget.oneNew.imageUrl.toString()),
              // Text(widget.oneNew.imageUrl['0']),
            ],
          ),
        ),
      ),
    );
  }
}
