import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:vipc_app/controller/login/login_controller.dart';
import 'package:vipc_app/view/forgotPwd/forgotPwd_view.dart';

class LoginView extends StatefulWidget {
  LoginView({key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends StateMVC {
  _LoginViewState() : super(LoginController()) {
    _con = LoginController.con;
  }
  LoginController _con;
  bool _passwordVisible;

  @override
  void initState() {
    _con.formKey = GlobalKey<FormState>(debugLabel: 'login');
    _con.isLoading = false;
    _passwordVisible = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 120),
                  child: Form(
                    key: _con.formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset('assets/images/logo.png'),
                        SizedBox(height: 50),
                        _buildEmployeeIDTextField(),
                        SizedBox(height: 30),
                        _buildUserPwdTextField(),
                        SizedBox(height: 30),
                        _buildLoginBtn(),
                        SizedBox(height: 10),
                        _buildForgotPwdBtn(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmployeeIDTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'UserID',
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
            textInputAction: TextInputAction.next,
            controller: _con.employeeIdController,
            keyboardType: TextInputType.text,
            style: TextStyle(
              color: Colors.white,
            ),
            autocorrect: false,
            textCapitalization: TextCapitalization.none,
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter user ID.';
              }
              return null;
            },
            decoration: InputDecoration(
              errorBorder: InputBorder.none,
              helperText: '',
              errorStyle: TextStyle(
                color: Colors.orange[400],
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.fromLTRB(15, 6, 0, 0),
              hintText: 'Enter your userID.',
              hintStyle: TextStyle(
                color: Colors.white70,
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
            padding: EdgeInsets.fromLTRB(15, 8, 0, 3),
            child: TextFormField(
              textInputAction: TextInputAction.done,
              style: TextStyle(color: Colors.white),
              validator: (value) {
                if (value.isEmpty || value.length < 6) {
                  return 'Please enter password.';
                }
                return null;
              },
              decoration: InputDecoration(
                errorBorder: InputBorder.none,
                errorStyle: TextStyle(
                  height: 0.1,
                  color: Colors.orange[400],
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                ),
                hintText: 'Enter your password.',
                border: InputBorder.none,
                hintStyle: TextStyle(
                  color: Colors.white70,
                ),
                suffixIcon: IconButton(
                  padding: const EdgeInsets.all(5),
                  icon: Icon(
                    _passwordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.white70,
                  ),
                  onPressed: () {
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                    });
                  },
                ),
              ),
              obscureText: !_passwordVisible,
              controller: _con.userPwdController,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      height: 105,
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 5.0,
          padding: EdgeInsets.all(15.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          primary: Colors.white,
        ),
        onPressed: () {
          _con.loginUser(context);
        },
        child: _con.isLoading
            ? Container(
                height: 40,
                width: 30,
                child: Center(child: CircularProgressIndicator()),
              )
            : Text(
                'LOGIN',
                style: TextStyle(
                  color: Color(0xFF527DAA),
                  letterSpacing: 1.5,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  Widget _buildForgotPwdBtn() {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ForgotPasswordView();
        }));
      },
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Forgot Password?',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
