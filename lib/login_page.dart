import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:passwordfield/passwordfield.dart';
import 'main_page.dart';
import 'signUp_page.dart';

//the login page is completed with password field dependency added.
class LoginScreen extends StatefulWidget {
  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {

  final _usernameController = TextEditingController();
  final _userPwdController = TextEditingController();

  Widget _buildUsernameTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Username',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
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
          child: TextField(
            controller: _usernameController,
            keyboardType: TextInputType.text,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.fromLTRB(15.0, 7.0, 0.0, 7.0),
              hintText: 'Enter your username.',
              hintStyle: TextStyle(
                color: Colors.white70,
                fontFamily: 'OpenSans',
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUserPwdTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Password',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
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
          child: Padding(
            padding: EdgeInsets.fromLTRB(15.0, 7.0, 0.0, 7.0),
            child: PasswordField(
              controller: _userPwdController,
              inputStyle: TextStyle(
                color: Colors.white70,
                fontFamily: 'OpenSans',
              ),
              border: InputBorder.none,

              hintText: 'Enter your password.',
              hintStyle: TextStyle(
                color: Colors.white70,
                fontFamily: 'OpenSans',
              ),
            ),
          ),

        ),
      ],
    );
  }

  Widget _buildLoginBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () => MainPageScreen1(),
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'LOGIN',
          style: TextStyle(
            color: Color(0xFF527DAA),
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  Widget _buildAccountText() {
    return GestureDetector(
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Don\'t have an Account? ',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignupBtn() {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return SignUpScreen();
        }));
      },
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Sign Up',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Stack(
              children: <Widget>[
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black,
                        Colors.black87,
                        Colors.brown,
                        Colors.orangeAccent,
                      ],
                    ),
                  ),
                ),
                Container(
                    height: double.infinity,
                    child: SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 120.0),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.asset('assets/images/logo.png'),
                              SizedBox(height: 50.0),
                              _buildUsernameTextField(),
                              SizedBox(height: 30.0),
                              _buildUserPwdTextField(),
                              SizedBox(height: 30.0),
                              _buildLoginBtn(),
                              SizedBox(height: 10.0),
                              _buildAccountText(),
                              SizedBox(height: 10.0),
                              _buildSignupBtn(),
                            ]
                        )
                    )
                )
              ],
            ),
          ),
        )
    );
  }
}