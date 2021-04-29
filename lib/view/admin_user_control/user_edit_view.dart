import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:vipc_app/controller/user/user_edit_controller.dart';
import 'package:vipc_app/model/user.dart';
import 'package:vipc_app/view/appbar/appbar_view.dart';
import 'package:vipc_app/view/drawer/drawer_view.dart';

class EditUser extends StatefulWidget {
  final Usr user;

  EditUser(this.user);
  @override
  _EditUserState createState() => _EditUserState();
}

class _EditUserState extends StateMVC<EditUser> {
  _EditUserState() : super(UserEditController()) {
    _con = UserEditController.con;
  }
  UserEditController _con;

  List<String> types = ["Manager", "Advisor"];

  @override
  void initState() {
    _con.formKey = GlobalKey<FormState>();
    _con.uid = widget.user.userId;
    _con.type = widget.user.type;
    _con.assignManager = (widget.user.assignUnder == '' ||
            widget.user.assignUnder == null ||
            widget.user.assignUnder.isEmpty)
        ? ""
        : widget.user.assignUnder;
    _con.email = widget.user.email;
    _con.password = widget.user.password;
    _con.fullName = widget.user.fullName;
    _con.managers.clear();
    _con.start(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context);
    return Scaffold(
      appBar: CustomAppBar(),
      // drawer: CustomDrawer(),
      body: Center(
        child: Container(
          height: double.infinity,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(15),
            child: Form(
              key: _con.formKey,
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "Edit User",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  _buildEmployeeIdTextField(),
                  SizedBox(height: 15),
                  _buildEmailTextField(),
                  SizedBox(height: 15),
                  _buildUserFullNameTextField(),
                  SizedBox(height: 15),
                  _buildUserTypeDropdownList(),
                  SizedBox(height: 15),
                  (_con.isAdvisor)
                      ? _buildAssignUserDropdownList()
                      : SizedBox(),
                  _buildUserChangePasswordField(),
                  // SizedBox(height: 15),
                  // _buildUserConfirmPasswordField(),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildDeleteBtn(screenSize),
                      _buildCancelBtn(screenSize),
                      _buildSaveBtn(screenSize),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmployeeIdTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Employee ID (Uneditable)',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Colors.white24,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6.0,
                offset: Offset(0, 2),
              ),
            ],
          ),
          height: 60.0,
          child: TextFormField(
            readOnly: true,
            style: TextStyle(
              color: Colors.white,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.fromLTRB(15, 7, 0, 7),
              hintText: widget.user.empID,
              hintStyle: TextStyle(
                color: Colors.white70,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmailTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Change Email',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Colors.white24,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6.0,
                offset: Offset(0, 2),
              ),
            ],
          ),
          height: 60.0,
          child: TextFormField(
            validator: (value) {
              if (value.isNotEmpty && !value.contains('@')) {
                return 'Please enter valid email address.';
              }
              return null;
            },
            controller: _con.emailController,
            keyboardType: TextInputType.text,
            style: TextStyle(
              color: Colors.white,
            ),
            decoration: InputDecoration(
              helperText: '',
              errorBorder: InputBorder.none,
              errorStyle: TextStyle(
                color: Colors.orange[400],
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.fromLTRB(15, 7, 0, 7),
              hintText: widget.user.email,
              hintStyle: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUserFullNameTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Change Full Name',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Colors.white24,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6.0,
                offset: Offset(0, 2),
              ),
            ],
          ),
          height: 60.0,
          child: TextFormField(
            validator: (value) {
              if (value.isNotEmpty && value.length < 2) {
                return 'Please enter valid name.';
              }
              return null;
            },
            controller: _con.fullNameController,
            keyboardType: TextInputType.text,
            style: TextStyle(
              color: Colors.white,
            ),
            decoration: InputDecoration(
              errorBorder: InputBorder.none,
              helperText: '',
              errorStyle: TextStyle(
                color: Colors.orange[400],
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.fromLTRB(15, 7, 0, 7),
              hintText: widget.user.fullName,
              hintStyle: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUserTypeDropdownList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          child: Text(
            "Change User Type",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 15, right: 15),
          decoration: BoxDecoration(
            color: Colors.white24,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6.0,
                offset: Offset(0, 2),
              ),
            ],
          ),
          height: 63.0,
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              errorBorder: InputBorder.none,
              helperText: '',
              errorStyle: TextStyle(
                color: Colors.orange[400],
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            hint: Container(
              child: Text(
                widget.user.type,
                style: TextStyle(color: Colors.white),
              ),
            ),
            isExpanded: true,
            iconEnabledColor: Colors.white,
            value: _con.selectedType,
            onChanged: (String value) {
              if (value == 'Advisor') {
                setState(() {
                  _con.isAdvisor = true;
                  _con.selectedType = value;
                });
              } else {
                setState(() {
                  _con.isAdvisor = false;
                  _con.selectedType = value;
                });
              }
            },
            items: types.map((String useType) {
              return DropdownMenuItem<String>(
                value: useType,
                child: Row(
                  children: <Widget>[
                    Text(
                      useType,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildAssignUserDropdownList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          child: Text(
            "Change Manager To Assign",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 15, right: 15),
          decoration: BoxDecoration(
            color: Colors.white24,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6.0,
                offset: Offset(0, 2),
              ),
            ],
          ),
          height: 63.0,
          child: FutureBuilder(
            future: Future.delayed(Duration(milliseconds: 1000)),
            builder: (context, snapshot) => DropdownButtonFormField<String>(
              decoration: InputDecoration(
                errorBorder: InputBorder.none,
                helperText: '',
                errorStyle: TextStyle(
                  color: Colors.orange[400],
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              validator: (value) {
                if (_con.managers.isEmpty || _con.managers == null) return null;
                if (value == null && _con.selectedType == "Advisor") {
                  return 'Please select a manager to assign.';
                }
                return null;
              },
              hint: Container(
                child: Text(
                  (widget.user.assignUnder == '' ||
                          widget.user.assignUnder == null ||
                          widget.user.assignUnder.isEmpty)
                      ? ""
                      : widget.user.assignUnder,
                  style: TextStyle(color: Colors.white),
                ),
              ),
              isExpanded: true,
              iconEnabledColor: Colors.white,
              value: _con.selectedManager,
              onChanged: (String value) {
                setState(() {
                  _con.selectedManager = value;
                });
                FocusScope.of(context).unfocus();
              },
              items: _con.managers.map((String selectedManager) {
                return DropdownMenuItem<String>(
                  value: selectedManager,
                  child: Row(
                    children: <Widget>[
                      Text(
                        selectedManager,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        SizedBox(height: 15),
      ],
    );
  }

  Widget _buildUserChangePasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Enter Password',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Colors.white24,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6.0,
                offset: Offset(0, 2),
              ),
            ],
          ),
          height: 60.0,
          padding: EdgeInsets.fromLTRB(15.0, 8, 0, 7),
          child: TextFormField(
            textInputAction: TextInputAction.next,
            style: TextStyle(color: Colors.white),
            // validator: (value) {
            //   if (value.isEmpty || value.length < 8) {
            //     return 'Please enter password with at least 8 characters long.';
            //   }
            //   return null;
            // },
            decoration: InputDecoration(
              errorBorder: InputBorder.none,
              errorStyle: TextStyle(
                color: Colors.orange[400],
                height: 0.1,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              border: InputBorder.none,
              hintText: 'Enter Password',
              hintStyle: TextStyle(
                color: Colors.white70,
              ),
              suffixIcon: IconButton(
                padding: const EdgeInsets.all(5),
                icon: Icon(
                  _con.passwordVisible
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: Colors.white70,
                ),
                onPressed: () {
                  setState(() {
                    _con.passwordVisible = !_con.passwordVisible;
                  });
                },
              ),
            ),
            obscureText: !_con.passwordVisible,
            controller: _con.userPwdController,
          ),
        ),
      ],
    );
  }

  // Widget _buildUserConfirmPasswordField() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: <Widget>[
  //       Text(
  //         'Confirm Password',
  //         style: TextStyle(
  //           color: Colors.white,
  //           fontWeight: FontWeight.bold,
  //         ),
  //       ),
  //       SizedBox(height: 10.0),
  //       Container(
  //         alignment: Alignment.centerLeft,
  //         decoration: BoxDecoration(
  //           color: Colors.white24,
  //           borderRadius: BorderRadius.circular(10.0),
  //           boxShadow: [
  //             BoxShadow(
  //               color: Colors.black12,
  //               blurRadius: 6.0,
  //               offset: Offset(0, 2),
  //             ),
  //           ],
  //         ),
  //         height: 60.0,
  //         padding: EdgeInsets.fromLTRB(15.0, 8, 0, 7),
  //         child: TextFormField(
  //           textInputAction: TextInputAction.done,
  //           style: TextStyle(color: Colors.white),
  //           validator: (value) {
  //             if (value.isEmpty || value != _con.userPwdController.text) {
  //               return 'Please enter password identical with password above.';
  //             }
  //             return null;
  //           },
  //           decoration: InputDecoration(
  //             errorBorder: InputBorder.none,
  //             errorStyle: TextStyle(
  //               color: Colors.orange[400],
  //               height: 0.1,
  //               fontSize: 14,
  //               fontWeight: FontWeight.bold,
  //             ),
  //             border: InputBorder.none,
  //             hintText: 'Enter Confirm Password',
  //             hintStyle: TextStyle(
  //               color: Colors.white70,
  //             ),
  //             suffixIcon: IconButton(
  //               padding: const EdgeInsets.all(5),
  //               icon: Icon(
  //                 _con.passwordVisible2
  //                     ? Icons.visibility
  //                     : Icons.visibility_off,
  //                 color: Colors.white70,
  //               ),
  //               onPressed: () {
  //                 setState(() {
  //                   _con.passwordVisible2 = !_con.passwordVisible2;
  //                 });
  //               },
  //             ),
  //           ),
  //           obscureText: !_con.passwordVisible2,
  //           controller: _con.userPwdController2,
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget _buildSaveBtn(MediaQueryData screenSize) {
    return Container(
      width: screenSize.size.width * 0.25,
      padding: EdgeInsets.symmetric(vertical: 25.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 5,
          padding: EdgeInsets.all(15.0),
          primary: Colors.amber[300],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        onPressed: () async {
          await _con.editUser(context);
          if (_con.editSuccess) {
            showDialog(
              context: context,
              builder: (_) => new AlertDialog(
                title: Text("VIPC Message"),
                content: Text("Successfully saved!"),
                actions: <Widget>[
                  TextButton(
                    child: Text('Close'),
                    onPressed: () async {
                      await _con.setToDefault();
                      Navigator.of(context).pop();
                      Navigator.of(context).pop(true);
                    },
                  )
                ],
              ),
            );
          }
        },
        child: _con.isLoading
            ? SizedBox(
                height: 21,
                child: CircularProgressIndicator(
                  backgroundColor: Colors.white,
                ),
              )
            : Text(
                'Save',
                style: TextStyle(
                  color: Colors.black,
                  letterSpacing: 1.5,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  Widget _buildDeleteBtn(MediaQueryData screenSize) {
    return Container(
      width: screenSize.size.width * 0.25,
      padding: EdgeInsets.symmetric(vertical: 25.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 5.0,
          padding: EdgeInsets.all(15.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          primary: Colors.deepOrange[500],
        ),
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => new AlertDialog(
              title: new Text("VIPC Message"),
              content: new Text("Confirm deleting this account!"),
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
                    await _con.deleteUser(context);
                    await _con.setToDefault();
                    Navigator.of(context).pop();
                    Navigator.of(context).pop(true);
                  },
                )
              ],
            ),
          );
        },
        child: Text(
          'Delete',
          style: TextStyle(
            color: Colors.black,
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildCancelBtn(MediaQueryData screenSize) {
    return Container(
      width: screenSize.size.width * 0.25,
      padding: EdgeInsets.symmetric(vertical: 25.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 5.0,
          padding: EdgeInsets.all(15.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          primary: Colors.amber[300],
        ),
        onPressed: () async {
          await _con.setToDefault();
          Navigator.of(context).pop(true);
        },
        child: Text(
          'Cancel',
          style: TextStyle(
            color: Colors.black,
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
