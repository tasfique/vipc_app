import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:vipc_app/model/news.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:vipc_app/view/admin_news_control/news_edit_view.dart';
import 'dart:math';

class NewsDetailsView extends StatefulWidget {
  final News oneNew;
  final String search;

  NewsDetailsView(this.oneNew, [this.search]);

  @override
  _NewsDetailsViewState createState() => _NewsDetailsViewState();
}

class _NewsDetailsViewState extends StateMVC<NewsDetailsView> {
  News newsDetail;
  bool check, pushP;

  @override
  void initState() {
    newsDetail = null;
    check = true;
    pushP = false;
    super.initState();
  }

  Future<void> _getNews() async {
    try {
      final news = await FirebaseFirestore.instance
          .collection("news")
          .doc(widget.oneNew.newsId)
          .get();

      if (news['images'] == null) {
        newsDetail = News(
          newsId: news.id,
          title: news.data()['title'],
          content: news.data()['content'],
        );
      } else {
        newsDetail = News(
          newsId: news.id,
          title: news.data()['title'],
          content: news.data()['content'],
          imageUrl: news.data()['images'],
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(error.toString()),
            backgroundColor: Theme.of(context).errorColor),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context);
    return WillPopScope(
      onWillPop: () async {
        if (pushP)
          Navigator.pop(context, true);
        else
          Navigator.pop(context, false);
        return;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('VIPC GROUP'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              if (pushP)
                Navigator.pop(context, true);
              else
                Navigator.pop(context, false);
            },
          ),
        ),
        body: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(25, 0, 25, 15),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          newsDetail == null
                              ? widget.oneNew.title
                              : newsDetail.title,
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.date_range_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5),
                            ),
                            Text(
                              DateFormat('dd/MM/yyyy   HH:mm')
                                  .format(DateTime.parse(widget.oneNew.newsId)),
                              style: TextStyle(
                                fontSize: 18,
                                fontStyle: FontStyle.italic,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                ),
                if (newsDetail == null &&
                    widget.oneNew.imageUrl != null &&
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
                        child: Image.network(widget.oneNew.imageUrl['0'],
                            fit: BoxFit.cover),
                      ),
                    ),
                    height: screenSize.size.height * 0.4,
                    width: screenSize.size.width * 0.9,
                    padding: EdgeInsets.only(bottom: 30),
                  )
                else if (newsDetail == null &&
                    widget.oneNew.imageUrl != null &&
                    widget.oneNew.imageUrl['length'] != 1)
                  CarouselSlider(
                    items: [
                      for (int i = 0; i < widget.oneNew.imageUrl['length']; i++)
                        Container(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HeroImage(
                                        widget.oneNew.imageUrl['$i'])),
                              );
                            },
                            child: Hero(
                              tag: '${Random().nextInt(100000)}$i',
                              child: Image.network(
                                widget.oneNew.imageUrl['$i'],
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                          ),
                          width: double.infinity,
                        )
                    ],
                    options: CarouselOptions(
                      height: 180.0,
                      enlargeCenterPage: true,
                      autoPlay: true,
                      aspectRatio: 16 / 9,
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enableInfiniteScroll: true,
                      autoPlayAnimationDuration: Duration(milliseconds: 800),
                      viewportFraction: 0.8,
                    ),
                  )
                else if (newsDetail != null &&
                    newsDetail.imageUrl != null &&
                    newsDetail.imageUrl['length'] == 1)
                  Container(
                    alignment: Alignment.bottomCenter,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  HeroImage(newsDetail.imageUrl['0'])),
                        );
                      },
                      child: Hero(
                        tag: 'Image',
                        child: Image.network(
                          newsDetail.imageUrl['0'],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    height: screenSize.size.height * 0.4,
                    width: screenSize.size.width * 0.9,
                    padding: EdgeInsets.only(bottom: 30),
                  )
                else if (newsDetail != null &&
                    newsDetail.imageUrl != null &&
                    newsDetail.imageUrl['length'] != 1)
                  CarouselSlider(
                    items: [
                      for (int i = 0; i < newsDetail.imageUrl['length']; i++)
                        Container(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        HeroImage(newsDetail.imageUrl['$i'])),
                              );
                            },
                            child: Hero(
                              tag: '${Random().nextInt(100000)}$i',
                              child: Image.network(
                                newsDetail.imageUrl['$i'],
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                          ),
                          width: double.infinity,
                        )
                    ],
                    options: CarouselOptions(
                      height: 180.0,
                      enlargeCenterPage: true,
                      autoPlay: true,
                      aspectRatio: 16 / 9,
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enableInfiniteScroll: true,
                      autoPlayAnimationDuration: Duration(milliseconds: 800),
                      viewportFraction: 0.8,
                    ),
                  ),
                if ((newsDetail == null &&
                        widget.oneNew.imageUrl != null &&
                        widget.oneNew.imageUrl['length'] != 1) ||
                    (newsDetail != null &&
                        newsDetail.imageUrl != null &&
                        newsDetail.imageUrl['length'] != 1))
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, top: 10, bottom: 30),
                  ),
                Padding(
                  padding:
                      EdgeInsets.only(top: 10, left: 30, right: 30, bottom: 55),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      newsDetail == null
                          ? widget.oneNew.content
                          : newsDetail.content,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: (widget.search == "Search" &&
                widget.search != null)
            ? Container(
                padding: EdgeInsets.all(10),
                child: FloatingActionButton(
                  onPressed: () async {
                    pushP = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditNews(
                                newsDetail == null ? widget.oneNew : newsDetail,
                                'newsDetail')));
                    if (pushP == null) {
                      Navigator.pop(context, true);
                    } else if (pushP) {
                      setState(() {
                        check = false;
                      });
                      await _getNews();
                      setState(() {
                        check = true;
                      });
                    }
                  },
                  child: Icon(
                    Icons.edit,
                    size: 30,
                  ),
                ),
              )
            : Container(),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}

class HeroImage extends StatefulWidget {
  final String imageUrl;
  HeroImage(this.imageUrl);

  @override
  _HeroImageState createState() => _HeroImageState();
}

class _HeroImageState extends State<HeroImage> {
  final _transformationController = TransformationController();

  TapDownDetails _doubleTapDetails;

  void _handleDoubleTapDown(TapDownDetails details) {
    _doubleTapDetails = details;
  }

  void _handleDoubleTap() {
    if (_transformationController.value != Matrix4.identity()) {
      _transformationController.value = Matrix4.identity();
    } else {
      final position = _doubleTapDetails.localPosition;
      _transformationController.value = Matrix4.identity()
        ..translate(-position.dx * 2, -position.dy * 2)
        ..scale(3.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Hero(
          tag: 'Image',
          child: GestureDetector(
            onDoubleTapDown: _handleDoubleTapDown,
            onDoubleTap: _handleDoubleTap,
            child: InteractiveViewer(
              transformationController: _transformationController,
              minScale: 0.5,
              maxScale: 4,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                alignment: Alignment.topCenter,
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: NetworkImage(
                    widget.imageUrl,
                  ),
                )),
              ),
            ),
          ),
        ));
  }
}
