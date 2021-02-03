// If the role is manager, there should be one more button 'monitor' in the middle.

import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:vipc_app/controller/prospect/prospect_controller.dart';
import 'package:vipc_app/view/appbar/appbar_view.dart';
import 'package:vipc_app/view/drawer/drawer_view.dart';
import 'package:vipc_app/model/prospect.dart';

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
          child: Padding(
            padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
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
                          ),
                        ),
                      ),
                    ),
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
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: EdgeInsets.only(left: 10, top: 30),
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
                          ),
                        ),
                      ),
                    ),
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
          itemCount: Prospect.prospectCards.length,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 25),
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
                    padding: EdgeInsets.only(top: 15),
                    child: Container(
                      alignment: Alignment.center,
                      child: Prospect.prospectCards[index],
                    ),
                  ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
        },
        child: Icon(
          Icons.add,
          size: 35,
        ),
      ),
    );
  }
}
