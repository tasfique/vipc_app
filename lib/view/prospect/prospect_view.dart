import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:vipc_app/controller/prospect/prospect_view_controller.dart';
import 'package:vipc_app/view/appbar/appbar_view.dart';
import 'package:vipc_app/view/bottomnavbar/bottomnavbar.dart';
import 'package:vipc_app/view/drawer/drawer_view.dart';
import 'package:vipc_app/model/prospect.dart';
import 'package:vipc_app/view/prospect/prospect_add.dart';
import 'package:vipc_app/view/prospect/prospect_edit.dart';

class ProspectView extends StatefulWidget {
  final Prospect prospect;
  ProspectView(this.prospect);
  @override
  _ProspectViewState createState() => _ProspectViewState();
}

class _ProspectViewState extends StateMVC {
  _ProspectViewState() : super(ProspectViewController()) {
    _con = ProspectViewController.con;
  }

  ProspectViewController _con;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, false);
        return;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Prospect Detail'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.of(context).pop(false),
          ),
        ),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Center(
            child: Container(
                padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 20.0),
                child: Column(
                  children: [],
                )
                // child: ListView.builder(
                //   scrollDirection: Axis.vertical,
                //   itemCount: Prospect.prospectCards.length,
                //   itemBuilder: (context, index) {
                //     if (index == 0) {
                //       return Row(
                //         children: [
                //           Padding(
                //             padding: EdgeInsets.only(left: 10),
                //             child: Container(
                //               alignment: Alignment.centerLeft,
                //               child: Text(
                //                 "Prospects",
                //                 style: TextStyle(
                //                   fontSize: 20,
                //                   fontWeight: FontWeight.bold,
                //                 ),
                //               ),
                //             ),
                //           ),
                //           Padding(
                //             padding: EdgeInsets.only(left: 180),
                //             child: DropdownButton<String>(
                //               value: dropdownValue,
                //               icon: const Icon(Icons.sort_rounded),
                //               iconSize: 24,
                //               dropdownColor: Colors.grey[800],
                //               iconEnabledColor: Colors.white,
                //               elevation: 16,
                //               style: const TextStyle(color: Colors.white),
                //               underline: Container(
                //                 height: 2,
                //                 color: Colors.white,
                //               ),
                //               onChanged: (String newValue) {
                //                 setState(() {
                //                   dropdownValue = newValue;
                //                 });
                //               },
                //               items: <String>[
                //                 'Sort by Time',
                //                 'Sort by Step',
                //               ].map<DropdownMenuItem<String>>((String value) {
                //                 return DropdownMenuItem<String>(
                //                   value: value,
                //                   child: Text(value),
                //                 );
                //               }).toList(),
                //             ),
                //           ),
                //         ],
                //       );
                //     } else {
                //       return Padding(
                //         padding: EdgeInsets.only(top: 15),
                //         child: Container(
                //           alignment: Alignment.center,
                //           child: Prospect.prospectCards[index],
                //         ),
                //       );
                //     }
                //   },
                // ),
                ),
          ),
        ),
      ),
    );
  }
}
