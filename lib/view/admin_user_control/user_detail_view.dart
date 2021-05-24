import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:vipc_app/model/news.dart';
import 'package:vipc_app/model/user.dart';
// import 'package:vipc_app/view/appbar/appbar_view.dart';
// import 'package:vipc_app/view/drawer/drawer_view.dart';

class UserDetailsView extends StatefulWidget {
  final Usr oneUser;

  UserDetailsView(this.oneUser);

  @override
  _UserDetailsViewState createState() => _UserDetailsViewState();
}

class _UserDetailsViewState extends StateMVC<UserDetailsView> {
  // _UserDetailsViewState() : super(AdminController()) {
  //   _con = AdminController.con;
  // }

  // AdminController _con;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context);
        return;
      },
      child: Scaffold(
        // appBar: CustomAppBar(),
        appBar: AppBar(
          title: Text('VIPC GROUP'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        // drawer: CustomDrawer(),
        body: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(25),
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "User Detail",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(25, 0, 25, 15),
                child: Container(
                  alignment: Alignment.center,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(Icons.account_box_outlined),
                            onPressed: () {},
                          ),
                          Text(
                            widget.oneUser.fullName,
                            style: TextStyle(
                              fontSize: 25,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(Icons.vpn_key_outlined),
                            onPressed: () {},
                          ),
                          Text(
                            widget.oneUser.empID,
                            style: TextStyle(
                              fontSize: 18,
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
                padding: EdgeInsets.all(25),
                child: Text(
                  'Get In Touch:  ${widget.oneUser.email}',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white70,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(25, 10, 25, 25),
                child: Text(
                  'User Type:  ${widget.oneUser.type}',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white70,
                  ),
                ),
              ),
              if (widget.oneUser.type == 'Advisor')
                Padding(
                  padding: EdgeInsets.fromLTRB(25, 10, 25, 10),
                  child: Text(
                    'Under Manager:  ${widget.oneUser.assignUnder}',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white70,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
