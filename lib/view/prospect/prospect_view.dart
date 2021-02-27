// If the role is manager, there should be one more button 'monitor' in the middle.

import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:vipc_app/controller/prospect/prospect_controller.dart';
import 'package:vipc_app/view/appbar/appbar_view.dart';
import 'package:vipc_app/view/drawer/drawer_view.dart';
import 'package:vipc_app/model/prospect.dart';
import 'package:vipc_app/view/prospect/prospect_add.dart';
import 'package:vipc_app/view/prospect/prospect_edit.dart';

class ProspectView extends StatefulWidget {
  ProspectView({key}) : super(key: key);

  @override
  _ProspectViewState createState() => _ProspectViewState();
}

class _ProspectViewState extends StateMVC {
  _ProspectViewState() : super(ProspectController()) {
    _con = ProspectController.con;
  }

  ProspectController _con;

  @override
  Widget build(BuildContext context) {
    Prospect.prospectCards.clear();
    for (int i = 0; i < Prospect.prospectNames.length; i++) {
      Prospect.prospectCards.add(
        Card(
          //Prospect Card background color
          color: Colors.amber[50],
          //
          child: Padding(
            padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: EdgeInsets.only(left: 10, top: 5),
                        child: Text(
                          Prospect.prospectNames[i],
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    ButtonBar(
                      children: <Widget>[
                        FlatButton(
                          child: const Icon(
                            Icons.edit,
                            size: 30,
                            color: Colors.brown,
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        EditProspectStateless()));
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: EdgeInsets.only(left: 10, top: 5),
                        child: Text(
                          Prospect.prospectTypes[i],
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: EdgeInsets.only(left: 10, top: 5),
                        child: Text(
                          Prospect.prospectSteps[i],
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
                      flex: 1,
                      child: Container(
                        padding: EdgeInsets.only(left: 30, top: 30),
                        child: Text(
                          "Meeting at " +
                              Prospect.prospectSchedules[i]
                                  .toString()
                                  .substring(11, 16) +
                              "\n" +
                              Prospect.prospectLocations[i],
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // ButtonBar(
                //   children: <Widget>[
                //     FlatButton(
                //       child: const Icon(
                //         Icons.edit,
                //         size: 30,
                //       ),
                //       onPressed: () {
                //         Navigator.push(
                //             context,
                //             MaterialPageRoute(
                //                 builder: (context) => EditProspectStateless()));
                //       },
                //     ),
                //   ],
                // ),
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
          itemCount: Prospect.prospectCards.length,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Prospects",
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
                  child: Prospect.prospectCards[index],
                ),
              );
            }
          },
        ),
      ),

      //enable this code later on
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddProspectStateless()));
        },
        child: Icon(
          Icons.add,
          size: 40,
        ),
      ),
    );
  }
}
