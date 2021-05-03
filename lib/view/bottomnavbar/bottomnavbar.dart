import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:vipc_app/controller/home/home_controller.dart';
import 'package:vipc_app/view/notifications/notifications_view.dart';
import 'package:vipc_app/view/search/search_view.dart';
import 'package:vipc_app/view/home/home_view.dart';
import 'package:vipc_app/view/prospect/prospect_view.dart';
import 'package:vipc_app/view/settings/settings_view.dart';
import 'package:vipc_app/view/monitor/monitor_view.dart';
import 'package:vipc_app/view/news/news_view.dart';

class CustomNavBar extends StatefulWidget implements PreferredSizeWidget {
  CustomNavBar({Key key})
      : preferredSize = Size.fromHeight(56),
        super(key: key);

  @override
  final Size preferredSize; // default is 56.0

  @override
  _CustomNavBarState createState() => _CustomNavBarState();
}

class _CustomNavBarState extends StateMVC {
  _CustomNavBarState() : super(HomeController()) {
    _con = HomeController.con;
  }
  HomeController _con;
  // _con.selectedIndex = 0;
  // static const TextStyle optionStyle =
  //     TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  List<Widget> _widgetOptions = <Widget>[
    HomeView(),
    ProspectView(),
    MonitorView(),
    NewsView(),
  ];

  @override
  Widget build(BuildContext context) {
    print('sfd');

    Center(child: _widgetOptions.elementAt(_con.selectedIndex));
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.star),
          label: 'Prospect',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.supervisor_account),
          label: 'Monitor',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.my_library_books),
          label: 'News',
        ),
      ],
      currentIndex: _con.selectedIndex,
      selectedItemColor: Colors.amber,
      onTap:
          // widget.func,
          _con.onItemTapped,
    );
  }
}
