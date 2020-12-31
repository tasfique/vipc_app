import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:vipc_app/view/appbar/appbar_view.dart';
import 'package:vipc_app/view/drawer/drawer_view.dart';
import 'package:vipc_app/controller/settings/settings_controller.dart';

class SettingsView extends StatefulWidget {
  SettingsView({key}) : super(key: key);

  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends StateMVC {
  _SettingsViewState() : super(SettingsController()) {
    _con = SettingsController.con;
  }

  SettingsController _con;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      drawer: CustomDrawer(),
      body: Container(
        padding: EdgeInsets.all(15),
        child: Text("SETTINGS"),
      ),
    );
  }
}
