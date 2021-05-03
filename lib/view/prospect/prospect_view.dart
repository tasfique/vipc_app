// If the role is manager, there should be one more button 'monitor' in the middle.

import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:vipc_app/controller/prospect/prospect_controller.dart';
import 'package:vipc_app/view/appbar/appbar_view.dart';
import 'package:vipc_app/view/bottomnavbar/bottomnavbar.dart';
import 'package:vipc_app/view/drawer/drawer_view.dart';
import 'package:vipc_app/model/prospect.dart';
import 'package:vipc_app/view/prospect/prospect_add.dart';
import 'package:vipc_app/view/prospect/prospect_edit.dart';

class ProspectView extends StatefulWidget {
  ProspectView({key}) : super(key: key);
  @override
  _ProspectViewState createState() => _ProspectViewState();
  String dropdownValue = 'Sort by Time';
}

//This class is declared for the dropdown menu
// class ListItem {
//   int value;
//   String name;

//   ListItem(this.value, this.name);
// }

class _ProspectViewState extends StateMVC {
  _ProspectViewState() : super(ProspectController()) {
    _con = ProspectController.con;
  }

  ProspectController _con;
  String dropdownValue = 'Sort by Time';
  @override
  Widget build(BuildContext context) {
    //to store the current state of the drop down menu _value.
    //int _value = 1;

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

    //String dropdownValue = 'Sort by Time';
    return Scaffold(
      appBar: CustomAppBar(),
      bottomNavigationBar: CustomNavBar(),
      drawer: CustomDrawer(),
      body: Container(
        padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 20.0),
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
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 180),
                    child: DropdownButton<String>(
                      value: dropdownValue,
                      icon: const Icon(Icons.sort_rounded),
                      iconSize: 24,
                      dropdownColor: Colors.grey[800],
                      iconEnabledColor: Colors.white,
                      elevation: 16,
                      style: const TextStyle(color: Colors.white),
                      underline: Container(
                        height: 2,
                        color: Colors.white,
                      ),
                      onChanged: (String newValue) {
                        setState(() {
                          dropdownValue = newValue;
                        });
                      },
                      items: <String>[
                        'Sort by Time',
                        'Sort by Step',
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
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
