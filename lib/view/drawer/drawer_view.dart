import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vipc_app/view/login/login_view.dart';
import 'package:vipc_app/view/home/advisor_view.dart';
import 'package:vipc_app/view/prospect/prospect_view.dart';
import 'package:vipc_app/view/settings/settings_view.dart';
import 'package:vipc_app/view/monitor/monitor_view.dart';
import 'package:vipc_app/view/news/news_view.dart';

class CustomDrawer extends StatefulWidget {
  CustomDrawer({Key key}) : super(key: key);

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text('Tasfique Enam'),
            decoration: BoxDecoration(
              color: Colors.amber,
            ),
            accountEmail: Text(
              "tasfiqueenam@gmail.com",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 30,
                child: Icon(
                  Icons.person,
                  color: Colors.black54,
                  size: 50,
                ),
              ),
            ),
          ),
          ListTile(
            title: Text(
              'Home',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return AdvisorView();
              }));
            },
          ),
          ListTile(
            title: Text(
              'Prospect',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                // return ProspectView();
              }));
            },
          ),
          ListTile(
            title: Text(
              'Monitor',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return MonitorView();
              }));
            },
          ),
          ListTile(
            title: Text(
              'News',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return NewsView();
              }));
            },
          ),
          ListTile(
            title: Text(
              'Settings',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return SettingsView();
              }));
            },
          ),
          ListTile(
            title: Text('Logout'),
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => new AlertDialog(
                  title: new Text("VIPC Message"),
                  content: new Text("Do you want to log out?"),
                  actions: <Widget>[
                    TextButton(
                      child: Text('No'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: Text('Yes'),
                      onPressed: () async {
                        Navigator.of(context).pop();
                        String userId = FirebaseAuth.instance.currentUser.uid;
                        FirebaseAuth.instance.signOut();
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(userId)
                            .update({'token': ''});
                      },
                    )
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
