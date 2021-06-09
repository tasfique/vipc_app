import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:vipc_app/controller/admin/admin_controller.dart';
import 'package:vipc_app/model/user.dart';
import 'package:vipc_app/view/admin_user_control/user_reset_password_view.dart';

class AdminNotificationView extends StatefulWidget {
  @override
  _AdminNotificationViewState createState() => _AdminNotificationViewState();
}

class _AdminNotificationViewState extends StateMVC<AdminNotificationView> {
  _AdminNotificationViewState() : super(AdminController()) {
    _con = AdminController.con;
  }

  AdminController _con;
  bool _check = true;

  @override
  void initState() {
    _con.userListRequestPassword = [];
    super.initState();
  }

  @override
  void dispose() async {
    super.dispose();
    await _con.getRequestPasswordCount();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        dispose();
        Navigator.of(context).pop();
        return;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('VIPC GROUP'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: FutureBuilder(
          future: _con.getRequestedPasswordUser(context),
          builder: (context, snapshot) => snapshot.connectionState ==
                  ConnectionState.waiting
              ? Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: () async {
                    setState(() {
                      _check = false;
                    });
                    _con.getRequestedPasswordUser(context);
                    setState(() {
                      _check = true;
                    });
                  },
                  child: (_check)
                      ? SingleChildScrollView(
                          physics: AlwaysScrollableScrollPhysics(),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 24.0),
                            child: Column(
                              children: [
                                (_con.userListRequestPassword.length != 0)
                                    ? ListView.builder(
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        itemCount:
                                            _con.userListRequestPassword.length,
                                        itemBuilder: (context, index) {
                                          if (index == 0) {
                                            return Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      EdgeInsets.only(left: 25),
                                                  child: Container(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Text(
                                                      "User Request For Password Reset",
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      EdgeInsets.only(top: 15),
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    child: userItemCard(
                                                        context,
                                                        _con.userListRequestPassword[
                                                            index]),
                                                  ),
                                                ),
                                              ],
                                            );
                                          } else {
                                            return Padding(
                                              padding: EdgeInsets.only(top: 15),
                                              child: Container(
                                                alignment: Alignment.center,
                                                child: userItemCard(
                                                    context,
                                                    _con.userListRequestPassword[
                                                        index]),
                                              ),
                                            );
                                          }
                                        },
                                      )
                                    : Column(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(left: 25),
                                            child: Container(
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                "User Request For Password Reset",
                                                style: TextStyle(
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 25),
                                            child: ListView(
                                              shrinkWrap: true,
                                              scrollDirection: Axis.vertical,
                                              children: List.generate(
                                                  1,
                                                  (f) => Text(
                                                        'No User Request For Password Reset',
                                                        style: TextStyle(
                                                          fontSize: 20,
                                                        ),
                                                      )),
                                            ),
                                          ),
                                        ],
                                      )
                              ],
                            ),
                          ),
                        )
                      : Center(
                          child: CircularProgressIndicator(),
                        ),
                ),
        ),
      ),
    );
  }

  Widget userItemCard(BuildContext context, Usr oneUser) {
    return Card(
      color: Colors.amber[50],
      child: Padding(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Full Name: ${oneUser.fullName}',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'User ID: ${oneUser.empID}',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
              subtitle: Padding(
                padding: EdgeInsets.only(top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Email: ${oneUser.email}',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      'Request to change password',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: TextButton(
                    child: const Text('Change Password',
                        style: TextStyle(
                          fontSize: 16,
                        )),
                    onPressed: () async {
                      final pushResult = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ResetPassword(oneUser)));
                      if (pushResult) {
                        setState(() {
                          _check = false;
                        });
                        _con.getRequestedPasswordUser(context);
                        setState(() {
                          _check = true;
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
