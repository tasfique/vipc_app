import 'package:flutter/material.dart';
import 'package:vipc_app/view/login/login_view.dart';
import 'package:vipc_app/view/home/home_view.dart';
import 'package:vipc_app/view/prospect/prospect_view.dart';
import 'package:vipc_app/view/settings/settings_view.dart';

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
                return HomeView();
              }));
            },
          ),
          ListTile(
            title: Text(
              'Prospects',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return ProspectView();
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
                  content: new Text("Successfully logged out!"),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Close'),
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return LoginView();
                        }));
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
