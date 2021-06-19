import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

enum Choices { updateAdmin, updateSystem, updateManagementEmail }

class AdminConfigureView extends StatefulWidget {
  const AdminConfigureView();

  @override
  _AdminConfigureViewState createState() => _AdminConfigureViewState();
}

class _AdminConfigureViewState extends State<AdminConfigureView> {
  GlobalKey<FormState> formKey =
      GlobalKey<FormState>(debugLabel: 'admin_configure');
  Choices choice;
  bool editSuccess;
  bool isLoading;
  bool passwordVisible;
  bool passwordVisible2;
  bool isValid;
  final emailController = TextEditingController();
  final userPwdController = TextEditingController();
  final userPwdController2 = TextEditingController();
  final fullNameController = TextEditingController();
  final empIdController = TextEditingController();
  String name, id, systemEmail, managementEmail, email, password;
  FirebaseApp app;

  @override
  void initState() {
    name = 'Enter Full Name';
    id = 'Enter User ID';
    systemEmail = 'Enter Email';
    managementEmail = 'Enter Email';
    _getInfo();
    choice = Choices.updateAdmin;
    passwordVisible = false;
    passwordVisible2 = false;
    editSuccess = false;
    isLoading = false;
    emailController.clear();
    userPwdController.clear();
    userPwdController2.clear();
    fullNameController.clear();
    empIdController.clear();
    super.initState();
  }

  @override
  void dispose() async {
    super.dispose();
    await app.delete();
  }

  Future<void> _getInfo() async {
    final management = await FirebaseFirestore.instance
        .collection('managementEmail')
        .limit(1)
        .get();
    final sysMail =
        await FirebaseFirestore.instance.collection('email').limit(1).get();
    final admin = await FirebaseFirestore.instance
        .collection('users')
        .where('type', isEqualTo: 'Admin')
        .limit(1)
        .get();
    if (management.docs.length == 1)
      managementEmail = management.docs.first.data()['email'];
    if (sysMail.docs.length == 1)
      systemEmail = sysMail.docs.first.data()['userMail'];
    if (admin.docs.length == 1) {
      name = admin.docs.first.data()['fullName'];
      id = admin.docs.first.data()['empID'];
      email = admin.docs.first.data()['email'];
      password = admin.docs.first.data()['password'];
    }
    setState(() {});
  }

  Future<void> _configureProcess() async {
    FocusScope.of(context).unfocus();
    isValid = formKey.currentState.validate();

    if (isValid) {
      setState(() {
        isLoading = true;
      });
      try {
        if (choice == Choices.updateAdmin) {
          final admin = await FirebaseFirestore.instance
              .collection('users')
              .where('type', isEqualTo: 'Admin')
              .limit(1)
              .get();
          await FirebaseFirestore.instance
              .collection('users')
              .doc(admin.docs.first.id)
              .update({
            'fullName': fullNameController.text.trim(),
            'empID': empIdController.text.trim(),
            'password': userPwdController.text.trim()
          });

          app = await Firebase.initializeApp(
              name: 'AdminUser', options: Firebase.app().options);

          await FirebaseAuth.instanceFor(app: app)
              .signInWithEmailAndPassword(email: email, password: password)
              .then((value) {
            value.user.updatePassword(userPwdController.text.trim());
          });
        } else if (choice == Choices.updateSystem) {
          final mail = await FirebaseFirestore.instance
              .collection('email')
              .limit(1)
              .get();

          if (mail.docs.length == 1) {
            await FirebaseFirestore.instance
                .collection('email')
                .doc(mail.docs.first.id)
                .update({
              'userMail': emailController.text.trim(),
              'passwordMail': userPwdController.text.trim()
            });
          } else {
            await FirebaseFirestore.instance.collection('email').add({
              'userMail': emailController.text.trim(),
              'passwordMail': userPwdController.text.trim()
            });
          }
        } else if (choice == Choices.updateManagementEmail) {
          final managementMail = await FirebaseFirestore.instance
              .collection('managementEmail')
              .limit(1)
              .get();

          if (managementMail.docs.length == 1) {
            await FirebaseFirestore.instance
                .collection('managementEmail')
                .doc(managementMail.docs.first.id)
                .update({'email': emailController.text.trim()});
          } else {
            await FirebaseFirestore.instance.collection('managementEmail').add({
              'email': emailController.text.trim(),
            });
          }
        }

        setState(() {
          isLoading = false;
          editSuccess = true;
        });
      } catch (error) {
        setState(() {
          editSuccess = false;
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(error.message),
              backgroundColor: Theme.of(context).errorColor),
        );
      }
    }
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
                  key: formKey,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: screenSize.size.width * 0.3,
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.only(left: 10),
                            child: Text(
                              "Update",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            width: screenSize.size.width * 0.6,
                            child: Column(
                              children: [
                                ListTile(
                                  title: const Text(
                                    'Admin Info',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                  subtitle: TextButton(
                                    onPressed: () => showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                        title: const Text('Admin Info'),
                                        content: const Text(
                                            'You can update the current Admin\'s information. Such as Name, ID, and Password.'),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, 'OK'),
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      ),
                                    ),
                                    style: ButtonStyle(
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap),
                                    child: const Text(
                                      'more details...',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 11,
                                          fontStyle: FontStyle.italic),
                                    ),
                                  ),
                                  leading: Radio<Choices>(
                                    value: Choices.updateAdmin,
                                    groupValue: choice,
                                    onChanged: (Choices value) {
                                      setState(() {
                                        choice = value;
                                      });
                                    },
                                  ),
                                ),
                                ListTile(
                                  title: const Text(
                                    'System Mail',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                  subtitle: TextButton(
                                    onPressed: () => showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                        title: const Text('System Mail'),
                                        content: const Text(
                                            'You can change the Sender email that the User receives for Password Reset Request. \n\nOnly supports Gmail Accounts.'),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, 'OK'),
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      ),
                                    ),
                                    style: ButtonStyle(
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap),
                                    child: const Text(
                                      'more details...',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 11,
                                          fontStyle: FontStyle.italic),
                                    ),
                                  ),
                                  leading: Radio<Choices>(
                                    value: Choices.updateSystem,
                                    groupValue: choice,
                                    onChanged: (Choices value) {
                                      setState(() {
                                        choice = value;
                                      });
                                    },
                                  ),
                                ),
                                ListTile(
                                  title: const Text(
                                    'Support Mail',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                  subtitle: TextButton(
                                    onPressed: () => showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                        title: const Text('Support Mail'),
                                        content: const Text(
                                            'You can change the Support email that the Users contacts for Help and Queries.'),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, 'OK'),
                                            child: const Text('OK'),
                                          ),
                                        ],
                                        elevation: 24.0,
                                      ),
                                    ),
                                    style: ButtonStyle(
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap),
                                    child: const Text(
                                      'more details...',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 11,
                                          fontStyle: FontStyle.italic),
                                    ),
                                  ),
                                  leading: Radio<Choices>(
                                    value: Choices.updateManagementEmail,
                                    groupValue: choice,
                                    onChanged: (Choices value) {
                                      setState(() {
                                        choice = value;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 15),
                      choice == Choices.updateAdmin
                          ? _buildUserFullNameTextField()
                          : SizedBox(),
                      choice == Choices.updateAdmin
                          ? _buildEmployeeIdTextField()
                          : _buildEmailTextField(),
                      SizedBox(height: 20),
                      choice != Choices.updateManagementEmail
                          ? _buildUserPasswordField()
                          : SizedBox(),
                      SizedBox(height: 20),
                      choice != Choices.updateManagementEmail
                          ? _buildUserConfirmPasswordField()
                          : SizedBox(),
                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildCancelBtn(screenSize),
                          _buildSaveBtn(screenSize)
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
          'Admin\'s User ID*',
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
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter user ID.';
              }
              return null;
            },
            controller: empIdController,
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
              contentPadding: EdgeInsets.fromLTRB(15, 11, 0, 7),
              hintText: id,
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
          'Admin\'s Full Name*',
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
            textCapitalization: TextCapitalization.words,
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter full name.';
              }
              return null;
            },
            controller: fullNameController,
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
              contentPadding: EdgeInsets.fromLTRB(15, 11, 0, 7),
              hintText: name,
              hintStyle: TextStyle(
                color: Colors.white70,
              ),
            ),
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildEmailTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Email',
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
            validator: (value) {
              if (value.isEmpty || !value.contains('@')) {
                return 'Please enter valid email address.';
              }
              return null;
            },
            controller: emailController,
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
              contentPadding: EdgeInsets.fromLTRB(15, 11, 0, 7),
              hintText: choice == Choices.updateSystem
                  ? systemEmail
                  : choice == Choices.updateManagementEmail
                      ? managementEmail
                      : 'Enter Email',
              hintStyle: TextStyle(
                color: Colors.white70,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUserPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Enter New Password*',
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
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter correct password.';
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
              hintText: 'Enter Password',
              hintStyle: TextStyle(
                color: Colors.white70,
              ),
              suffixIcon: IconButton(
                padding: const EdgeInsets.all(5),
                icon: Icon(
                  passwordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.white70,
                ),
                onPressed: () {
                  setState(() {
                    passwordVisible = !passwordVisible;
                  });
                },
              ),
            ),
            obscureText: !passwordVisible,
            controller: userPwdController,
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
          'Confirm New Password*',
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
            textInputAction: TextInputAction.done,
            style: TextStyle(color: Colors.white),
            validator: (value) {
              if (value.isEmpty || value != userPwdController.text) {
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
                  passwordVisible2 ? Icons.visibility : Icons.visibility_off,
                  color: Colors.white70,
                ),
                onPressed: () {
                  setState(() {
                    passwordVisible2 = !passwordVisible2;
                  });
                },
              ),
            ),
            obscureText: !passwordVisible2,
            controller: userPwdController2,
          ),
        ),
      ],
    );
  }

  Widget _buildSaveBtn(MediaQueryData screenSize) {
    return Container(
      width: screenSize.size.width * 0.4,
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
          await _configureProcess();
          if (editSuccess) {
            if (choice == Choices.updateAdmin) {
              showDialog(
                context: context,
                builder: (_) => new AlertDialog(
                  title: Text("Message"),
                  content: Text(
                      "Successfully Saved new Admin Details.\nYou will be Signed Out...\nPlease Log In Again."),
                  actions: <Widget>[
                    TextButton(
                      child: Text('Close'),
                      onPressed: () async {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        String userId = FirebaseAuth.instance.currentUser.uid;
                        FirebaseAuth.instance.signOut();
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(userId)
                            .update({'token': ''});
                      },
                    )
                  ],
                ),
              );
            } else
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
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ),
              );
          }
        },
        child: isLoading
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
      width: screenSize.size.width * 0.4,
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
