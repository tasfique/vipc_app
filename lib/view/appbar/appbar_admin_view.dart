import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:vipc_app/controller/admin/admin_controller.dart';
import 'package:vipc_app/view/notifications/admin_notification_view.dart';
import 'package:vipc_app/view/search/admin_search_view.dart';

class AdminAppBar extends StatefulWidget implements PreferredSizeWidget {
  AdminAppBar({Key key})
      : preferredSize = Size.fromHeight(56),
        super(key: key);

  @override
  final Size preferredSize; // default is 56.0

  @override
  _AdminAppBarState createState() => _AdminAppBarState();
}

class _AdminAppBarState extends StateMVC {
  _AdminAppBarState() : super(AdminController()) {
    _con = AdminController.con;
  }

  AdminController _con;

  // refreshState() {
  //   _con.getRequestPasswordCount();
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('VIPC GROUP'),
      actions: [
        Stack(
          children: [
            IconButton(
              padding: EdgeInsets.only(top: 4),
              tooltip: 'Notifications',
              icon: const Icon(
                Icons.notifications,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AdminNotificationView()));
              },
            ),
            _con.requestPasswordCount != 0
                ? Positioned(
                    right: 11,
                    top: 11,
                    child: Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      constraints: BoxConstraints(
                        minWidth: 14,
                        minHeight: 14,
                      ),
                      child: Text(
                        '${_con.requestPasswordCount}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : Container()
          ],
        ),
        IconButton(
          tooltip: 'Search',
          icon: const Icon(
            Icons.search,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AdminSearchView()));
          },
        ),
      ],
    );
  }
}
