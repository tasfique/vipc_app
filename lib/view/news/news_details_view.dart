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
    final screenSize = MediaQuery.of(context);
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, true);
        return false;
      },
      child: Scaffold(
        // appBar: CustomAppBar(),
        appBar: AppBar(
          title: Text('News Details'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ),
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
                if (widget.oneNew.imageUrl != null &&
                    widget.oneNew.imageUrl['length'] == 1)
                  Container(
                    alignment: Alignment.bottomCenter,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  HeroImage(widget.oneNew.imageUrl['0'])),
                        );
                      },
                      child: Hero(
                        tag: 'Image',
                        child: Image.network(
                          widget.oneNew.imageUrl['0'],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    height: screenSize.size.height * 0.4,
                    width: screenSize.size.width * 0.9,
                    padding: EdgeInsets.only(bottom: 30),
                  )
                else if (widget.oneNew.imageUrl != null &&
                    widget.oneNew.imageUrl['length'] != 1)
                  GridView.count(
                    primary: false,
                    padding: const EdgeInsets.all(10),
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    children: List.generate(widget.oneNew.imageUrl['length'],
                        (index) {
                      return Container(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HeroImage(
                                      widget.oneNew.imageUrl['$index'])),
                            );
                          },
                          child: Hero(
                            tag: '$index',
                            child: Image.network(
                              widget.oneNew.imageUrl['$index'],
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        ),
                        height: double.infinity,
                        width: double.infinity,
                      );
                    }),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HeroImage extends StatelessWidget {
  final String imageUrl;
  HeroImage(this.imageUrl);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Hero(
          tag: 'Image',
          child: Container(
            width: double.infinity,
            height: double.infinity,
            alignment: Alignment.topCenter,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(
                      imageUrl,
                    ),
                    fit: BoxFit.cover)),
          ),
        ));
  }
}
