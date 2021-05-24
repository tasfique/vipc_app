import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:vipc_app/controller/user/user_reset_password_controller.dart';
import 'package:vipc_app/model/user.dart';

class ResetPassword extends StatefulWidget {
  final Usr user;

  ResetPassword(this.user);
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends StateMVC<ResetPassword> {
  _ResetPasswordState() : super(UserResetPasswordController()) {
    _con = UserResetPasswordController.con;
  }
  UserResetPasswordController _con;

  @override
  void initState() {
    _con.formKey = GlobalKey<FormState>(debugLabel: 'password_reset');
    _con.uid = widget.user.userId;
    _con.email = widget.user.email;
    _con.password = widget.user.password;
    _con.start();
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
        // dispose();
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
                          "Reset Password For User",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 40),
                      _buildUserChangePasswordField(),
                      SizedBox(height: 30),
                      _buildUserConfirmPasswordField(),
                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
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

  Widget _buildUserChangePasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'New Password',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 15.0),
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
          height: 66.0,
          padding: EdgeInsets.fromLTRB(15.0, 8, 0, 7),
          child: TextFormField(
            textInputAction: TextInputAction.next,
            style: TextStyle(color: Colors.white),
            validator: (value) {
              if (value.isEmpty || value.length < 6) {
                return 'Please enter password with at least 6 characters long.';
              }
              return null;
            },
            decoration: InputDecoration(
              errorBorder: InputBorder.none,
              errorStyle: TextStyle(
                color: Colors.orange[400],
                height: 0.1,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              border: InputBorder.none,
              hintText: 'Enter New Password',
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

  Widget _buildUserConfirmPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Confirm New Password',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 15.0),
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
          height: 66.0,
          padding: EdgeInsets.fromLTRB(15.0, 8, 0, 7),
          child: TextFormField(
            textInputAction: TextInputAction.done,
            style: TextStyle(color: Colors.white),
            validator: (value) {
              if (value.isEmpty || value != _con.userPwdController.text) {
                return 'Please enter password identical with password above.';
              }
              return null;
            },
            decoration: InputDecoration(
              errorBorder: InputBorder.none,
              errorStyle: TextStyle(
                color: Colors.orange[400],
                height: 0.1,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              border: InputBorder.none,
              hintText: 'Enter Confirm Password',
              hintStyle: TextStyle(
                color: Colors.white70,
              ),
              suffixIcon: IconButton(
                padding: const EdgeInsets.all(5),
                icon: Icon(
                  _con.passwordVisible2
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: Colors.white70,
                ),
                onPressed: () {
                  setState(() {
                    _con.passwordVisible2 = !_con.passwordVisible2;
                  });
                },
              ),
            ),
            obscureText: !_con.passwordVisible2,
            controller: _con.userPwdController2,
          ),
        ),
      ],
    );
  }

  Widget _buildSaveBtn(MediaQueryData screenSize) {
    return Container(
      width: screenSize.size.width * 0.35,
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
          await _con.resetPasswordUser(context);
          if (_con.resetSuccess) {
            showDialog(
              context: context,
              builder: (_) => new AlertDialog(
                title: Text("VIPC Message"),
                content: Text("Successfully Reset Password!"),
                actions: <Widget>[
                  TextButton(
                    child: Text('Close'),
                    onPressed: () {
                      // await _con.setToDefault();
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

  Widget _buildCancelBtn(MediaQueryData screenSize) {
    return Container(
      width: screenSize.size.width * 0.35,
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
          // await _con.setToDefault();
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
