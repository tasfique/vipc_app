import 'package:flutter/material.dart';
import 'package:vipc_app/view/notifications/notifications_view.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  CustomAppBar({Key key})
      : preferredSize = Size.fromHeight(56),
        super(key: key);

  @override
  final Size preferredSize; // default is 56.0

  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('VIPC'),
      actions: [
        IconButton(
          tooltip: 'Notifications',
          icon: const Icon(
            Icons.notifications,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return NotificationsView();
            }));
          },
        ),
        IconButton(
          tooltip: 'Search',
          icon: const Icon(
            Icons.search,
            color: Colors.black,
          ),
          onPressed: () {},
        ),
      ],
    );
  }
}
