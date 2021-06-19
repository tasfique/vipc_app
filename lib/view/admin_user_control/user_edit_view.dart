import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:vipc_app/controller/user/user_edit_controller.dart';
import 'package:vipc_app/model/user.dart';

class EditUser extends StatefulWidget {
  final Usr user;
  final String checkDetail;

  EditUser(this.user, [this.checkDetail]);
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
    _con.formKey = GlobalKey<FormState>(debugLabel: 'user_edit');
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
  void dispose() async {
    super.dispose();
    await _con.setToDefault();
    await _con.app.delete();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context);
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, false);
        return;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('VIPC GROUP'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.of(context).pop(false),
          ),
        ),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Center(
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
                      SizedBox(height: 25),
                      _buildEmployeeIdTextField(),
                      SizedBox(height: 20),
                      _buildEmailTextField(),
                      SizedBox(height: 20),
                      _buildUserFullNameTextField(),
                      SizedBox(height: 20),
                      _buildUserTypeDropdownList(),
                      SizedBox(height: 20),
                      (_con.isAdvisor)
                          ? _buildAssignUserDropdownList()
                          : SizedBox(),
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
        ),
      ),
    );
  }

  Widget _buildEmployeeIdTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'User ID (Uneditable)',
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
                color: Colors.white70,
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
                color: Colors.white70,
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
        SizedBox(height: 20.0),
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
      ],
    );
  }

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
                title: Text("Message"),
                content: Text("Successfully Saved!"),
                actions: <Widget>[
                  TextButton(
                    child: Text('Close'),
                    onPressed: () {
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
                width: 21,
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
              title: new Text("Message"),
              content:
                  new Text("Are you sure you want to DELETE this Account?"),
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
                    Navigator.of(context).pop();
                    if (widget.checkDetail == 'userDetail')
                      Navigator.of(context).pop(null);
                    else
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
        onPressed: () {
          Navigator.of(context).pop(false);
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
