import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:vipc_app/model/news.dart';
import 'package:vipc_app/model/user.dart';
import 'package:vipc_app/view/admin_user_control/user_edit_view.dart';
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

  Usr userDetail;
  Future<void> _getUser(BuildContext context) async {
    // setState(() {
    //   isLoadingUser = true;
    // });
    //

    print('kk');
    try {
      // setState(() {
      //   userList.clear();
      // });
      final users = await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.oneUser.userId)
          .get();

      userDetail = Usr(
          userId: users.id,
          empID: users['empID'],
          email: users['email'],
          fullName: users['fullName'],
          type: users['type'],
          assignUnder: users['assignUnder'],
          password: users['password']);
      // });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(error.toString()),
            backgroundColor: Theme.of(context).errorColor),
      );
    }

    // setState(() {
    //   isLoadingUser = false;
    // });
  }

  bool check, pushP;
  @override
  void initState() {
    userDetail = null;
    check = true;
    pushP = false;
    print('heelo');
    print(widget.oneUser.type);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (pushP)
          Navigator.pop(context, true);
        else
          Navigator.pop(context, false);
        return;
      },
      child: Scaffold(
        // appBar: CustomAppBar(),
        appBar: AppBar(
          title: Text('VIPC GROUP'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              if (pushP)
                Navigator.pop(context, true);
              else
                Navigator.pop(context, false);
            },
          ),
        ),
        // drawer: CustomDrawer(),
        body: (check)
            ? ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 38, top: 40),
                      // padding: EdgeInsets.only(bottom: 18, top: 20),
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          "User Detail",
                          style: TextStyle(
                            fontSize: 22,
                            //decoration: TextDecoration.underline,
                            decorationThickness: 1.5,
                            fontWeight: FontWeight.w400,
                            shadows: [
                              Shadow(
                                blurRadius: 10.0,
                                color: Colors.grey,
                                offset: Offset(3.0, 4.0),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Padding(
                    //   padding: EdgeInsets.all(25),
                    //   child: Container(
                    //     alignment: Alignment.centerLeft,
                    //     child: Text(
                    //       "User Detail",
                    //       style: TextStyle(
                    //         fontSize: 20,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    Container(
                      padding: EdgeInsets.only(left: 25, right: 25),
                      width: 400,
                      child: Card(
                        semanticContainer: true,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        color: Colors.amber[50],
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  right: 10, left: 10, bottom: 10, top: 20),
                              child: Text(
                                userDetail == null
                                    ? 'Name: ${widget.oneUser.fullName}'
                                    : 'Name: ${userDetail.fullName}',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: TextStyle(
                                  fontSize: 22,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 10, right: 10),
                              child: Text(
                                userDetail == null
                                    ? 'Employee ID: ${widget.oneUser.empID}'
                                    : 'Employee ID: ${userDetail.empID}',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: TextStyle(
                                  fontSize: 22,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: Text(
                                  userDetail == null
                                      ? 'Email: ${widget.oneUser.email}'
                                      : 'Email: ${userDetail.email}',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: TextStyle(
                                      fontSize: 22, color: Colors.black)),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  right: 10, left: 10, bottom: 10),
                              child: Text(
                                  userDetail == null
                                      ? 'User Type: ${widget.oneUser.type}'
                                      : 'User Type: ${userDetail.type}',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontSize: 22, color: Colors.black)),
                            ),
                            if (userDetail == null &&
                                widget.oneUser.type == 'Advisor')
                              Padding(
                                  padding: EdgeInsets.only(
                                      right: 10, left: 10, bottom: 10),
                                  child: Text(
                                      'Assigned Manager:  ${widget.oneUser.assignUnder}',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: TextStyle(
                                          fontSize: 22, color: Colors.black)))
                            else if (userDetail != null &&
                                userDetail.type == 'Advisor')
                              Padding(
                                  padding: EdgeInsets.only(
                                      right: 10, left: 10, bottom: 10),
                                  child: Text(
                                      'Assigned Manager:  ${widget.oneUser.assignUnder}',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: TextStyle(
                                          fontSize: 22, color: Colors.black))),
                            SizedBox(height: 10)
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 15, bottom: 10, left: 25, right: 25),
                      child: const Divider(
                        height: 20,
                        thickness: 2,
                        indent: 1,
                        endIndent: 1,
                        color: Colors.amber,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 25, right: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: Text(
                                DateFormat('MMMM').format(DateTime.now()) +
                                    " Total Points: " +
                                    // widget.monthPoint.toString(),
                                    '234',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(bottom: 10),
                            alignment: Alignment.topRight,
                            child: Text(
                                // 100 <= widget.monthPoint &&
                                //         widget.monthPoint < 200
                                //     ? 'Passed'
                                //     :
                                'Standard',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.amber,
                                  fontWeight: FontWeight.w600,
                                )),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 10, bottom: 10, left: 25, right: 25),
                      child: const Divider(
                        height: 20,
                        thickness: 2,
                        indent: 1,
                        endIndent: 1,
                        color: Colors.amber,
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 25, right: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              DateFormat('MMMM').format(DateTime.now()) +
                                  " Weekly Points: " +
                                  // widget.weekPoint.toString(),
                                  '1789',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.topRight,
                            child: Text(
                                // 50 <= widget.weekPoint && widget.weekPoint < 100
                                //     ? 'Passed'
                                //     :
                                'Standard',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.amber,
                                  fontWeight: FontWeight.w600,
                                )),
                          ),
                        ],
                      ),
                    ),

                    // Padding(
                    //   padding: EdgeInsets.fromLTRB(25, 0, 25, 15),
                    //   child: Container(
                    //     alignment: Alignment.center,
                    //     child: Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         Row(
                    //           mainAxisAlignment: MainAxisAlignment.center,
                    //           children: [
                    //             IconButton(
                    //               icon: Icon(Icons.account_box_outlined),
                    //               onPressed: () {},
                    //             ),
                    //             Text(
                    //               widget.oneUser.fullName,
                    //               style: TextStyle(
                    //                 fontSize: 25,
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //         SizedBox(
                    //           height: 10,
                    //         ),
                    //         Row(
                    //           mainAxisAlignment: MainAxisAlignment.center,
                    //           children: [
                    //             IconButton(
                    //               icon: Icon(Icons.vpn_key_outlined),
                    //               onPressed: () {},
                    //             ),
                    //             Text(
                    //               widget.oneUser.empID,
                    //               style: TextStyle(
                    //                 fontSize: 18,
                    //                 color: Colors.white70,
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    // Padding(
                    //   padding: EdgeInsets.all(25),
                    //   child: Text(
                    //     'Get In Touch:  ${widget.oneUser.email}',
                    //     style: TextStyle(
                    //       fontSize: 18,
                    //       color: Colors.white70,
                    //     ),
                    //   ),
                    // ),
                    // Padding(
                    //   padding: EdgeInsets.fromLTRB(25, 10, 25, 25),
                    //   child: Text(
                    //     'User Type:  ${widget.oneUser.type}',
                    //     style: TextStyle(
                    //       fontSize: 18,
                    //       color: Colors.white70,
                    //     ),
                    //   ),
                    // ),
                    // if (widget.oneUser.type == 'Advisor')
                    //   Padding(
                    //     padding: EdgeInsets.fromLTRB(25, 10, 25, 10),
                    //     child: Text(
                    //       'Under Manager:  ${widget.oneUser.assignUnder}',
                    //       style: TextStyle(
                    //         fontSize: 18,
                    //         color: Colors.white70,
                    //       ),
                    //     ),
                    //   ),
                  ],
                ),
              )
            : Center(child: CircularProgressIndicator()),
        floatingActionButton: Container(
          padding: EdgeInsets.all(10),
          child: FloatingActionButton(
            onPressed: () async {
              pushP = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          EditUser(widget.oneUser, 'userDetail')));
              if (pushP == null) {
                Navigator.pop(context, true);
              } else if (pushP) {
                setState(() {
                  check = false;
                });
                await _getUser(context);
                setState(() {
                  check = true;
                });
              }
            },
            child: Icon(
              Icons.edit,
              size: 30,
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}
