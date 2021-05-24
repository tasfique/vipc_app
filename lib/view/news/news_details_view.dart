import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:vipc_app/model/news.dart';
// import 'package:vipc_app/view/appbar/appbar_view.dart';
// import 'package:vipc_app/view/drawer/drawer_view.dart';
import 'package:drop_cap_text/drop_cap_text.dart';
import 'package:carousel_slider/carousel_slider.dart';

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
          title: Text('VIPC GROUP'),
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
                // Padding(
                //   padding: EdgeInsets.all(25),
                //   child: Container(
                //     alignment: Alignment.centerLeft,
                //     child: Text(
                //       "News Detail",
                //       style: TextStyle(
                //         fontSize: 20,
                //       ),
                //     ),
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.all(15),
                ),
                // Padding(
                //   padding: EdgeInsets.only(bottom: 38, top: 40),
                //   child: Container(
                //     alignment: Alignment.center,
                //     child: Text(
                //       "News Detail",
                //       style: TextStyle(
                //         fontSize: 22,
                //         //decoration: TextDecoration.underline,
                //         decorationThickness: 1.5,
                //         fontWeight: FontWeight.w400,
                //         shadows: [
                //           Shadow(
                //             blurRadius: 10.0,
                //             color: Colors.grey,
                //             offset: Offset(3.0, 4.0),
                //           ),
                //         ],
                //       ),
                //     ),
                //   ),
                // ),
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
                              tag: '$i',
                              child: Image.network(
                                widget.oneNew.imageUrl['$i'],
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                          ),
                          height: double.infinity,
                          width: double.infinity,
                        )

                      //GridView.count(
                      // primary: false,
                      // padding: const EdgeInsets.all(10),
                      // mainAxisSpacing: 10,
                      // crossAxisSpacing: 10,
                      // shrinkWrap: true,
                      // crossAxisCount: 4,
                      // children:
                      // ListView.builder(
                      //     itemCount: widget.oneNew.imageUrl['length'],
                      //     itemBuilder: (context, index)
                      //         // widget.oneNew.imageUrl['length'], (index) {
                      //         {
                      //       print('test');
                      //       return Container(
                      //         child: GestureDetector(
                      //           onTap: () {
                      //             Navigator.push(
                      //               context,
                      //               MaterialPageRoute(
                      //                   builder: (context) => HeroImage(
                      //                       widget.oneNew.imageUrl['$index'])),
                      //             );
                      //           },
                      //           child: Hero(
                      //             tag: '$index',
                      //             child: Image.network(
                      //               widget.oneNew.imageUrl['$index'],
                      //               fit: BoxFit.fitWidth,
                      //             ),
                      //           ),
                      //         ),
                      //         height: double.infinity,
                      //         width: double.infinity,
                      //       );
                      //     }),
                      //),
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

                // if (widget.oneNew.imageUrl != null &&
                //     widget.oneNew.imageUrl['length'] == 1)
                //   Container(
                //     alignment: Alignment.bottomCenter,
                //     child: GestureDetector(
                //       onTap: () {
                //         Navigator.push(
                //           context,
                //           MaterialPageRoute(
                //               builder: (context) =>
                //                   HeroImage(widget.oneNew.imageUrl['0'])),
                //         );
                //       },
                //       child: Hero(
                //         tag: 'Image',
                //         child: Image.network(
                //           widget.oneNew.imageUrl['0'],
                //           fit: BoxFit.cover,
                //         ),
                //       ),
                //     ),
                //     height: screenSize.size.height * 0.4,
                //     width: screenSize.size.width * 0.9,
                //     padding: EdgeInsets.only(bottom: 30),
                //   )
                // else if (widget.oneNew.imageUrl != null &&
                //     widget.oneNew.imageUrl['length'] != 1)
                //   GridView.count(
                //     primary: false,
                //     padding: const EdgeInsets.all(10),
                //     mainAxisSpacing: 10,
                //     crossAxisSpacing: 10,
                //     shrinkWrap: true,
                //     crossAxisCount: 2,
                //     children: List.generate(widget.oneNew.imageUrl['length'],
                //         (index) {
                //       return Container(
                //         child: GestureDetector(
                //           onTap: () {
                //             Navigator.push(
                //               context,
                //               MaterialPageRoute(
                //                   builder: (context) => HeroImage(
                //                       widget.oneNew.imageUrl['$index'])),
                //             );
                //           },
                //           child: Hero(
                //             tag: '$index',
                //             child: Image.network(
                //               widget.oneNew.imageUrl['$index'],
                //               fit: BoxFit.fitWidth,
                //             ),
                //           ),
                //         ),
                //         height: double.infinity,
                //         width: double.infinity,
                //       );
                //     }),
                //   ),

                // DropCapText(
                //   loremIpsumText,
                //   dropCap: DropCap(
                //     width: 200,
                //     height: 300,
                //     child: widget.oneNew.imageUrl != null &&
                //             widget.oneNew.imageUrl['length'] == 1
                //         ? Container(
                //             alignment: Alignment.bottomCenter,
                //             child: GestureDetector(
                //               onTap: () {
                //                 Navigator.push(
                //                   context,
                //                   MaterialPageRoute(
                //                       builder: (context) => HeroImage(
                //                           widget.oneNew.imageUrl['0'])),
                //                 );
                //               },
                //               child: Hero(
                //                 tag: 'Image',
                //                 child: Image.network(
                //                   widget.oneNew.imageUrl['0'],
                //                   fit: BoxFit.cover,
                //                 ),
                //               ),
                //             ),
                //             height: screenSize.size.height * 0.4,
                //             width: screenSize.size.width * 0.9,
                //             padding: EdgeInsets.only(bottom: 30),
                //           )
                //         : GridView.count(
                //             primary: false,
                //             padding: const EdgeInsets.all(10),
                //             mainAxisSpacing: 10,
                //             crossAxisSpacing: 10,
                //             shrinkWrap: true,
                //             crossAxisCount: 2,
                //             children: List.generate(
                //                 widget.oneNew.imageUrl['length'], (index) {
                //               return Container(
                //                 child: GestureDetector(
                //                   onTap: () {
                //                     Navigator.push(
                //                       context,
                //                       MaterialPageRoute(
                //                           builder: (context) => HeroImage(widget
                //                               .oneNew.imageUrl['$index'])),
                //                     );
                //                   },
                //                   child: Hero(
                //                     tag: '$index',
                //                     child: Image.network(
                //                       widget.oneNew.imageUrl['$index'],
                //                       fit: BoxFit.fitWidth,
                //                     ),
                //                   ),
                //                 ),
                //                 height: double.infinity,
                //                 width: double.infinity,
                //               );
                //             }),
                //           ),
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.all(10),
                ),
                Padding(
                  padding: EdgeInsets.all(30),
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
