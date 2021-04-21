import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:vipc_app/controller/news/admin_controller.dart';
import 'package:vipc_app/view/appbar/appbar_view.dart';
import 'package:vipc_app/view/drawer/drawer_view.dart';
import 'package:vipc_app/view/admin/admin_home.dart';

class EditArticle extends StatefulWidget {
  @override
  _EditArticleState createState() => _EditArticleState();
}

class _EditArticleState extends StateMVC<EditArticle> {
  _EditArticleState() : super(AdminController()) {
    _con = AdminController.con;
  }

  AdminController _con;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      drawer: CustomDrawer(),
      body: Container(
        height: double.infinity,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.all(10),
                child: Text(
                  "Add New Article",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 20),
              _buildTitleTextField(),
              SizedBox(height: 20),
              _buildTextFormField(),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildDeleteBtn(),
                  _buildCancelBtn(),
                  _buildSaveBtn(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Title',
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
            controller: TextEditingController(
                text: _con.newsTitles[_con.selectedNewsIndex].toString()),
            maxLines: null,
            keyboardType: TextInputType.multiline,
            style: TextStyle(
              color: Colors.white,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.fromLTRB(15, 7, 0, 7),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextFormField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Content',
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
          child: TextFormField(
            controller: TextEditingController(
                text: _con.newsContents[_con.selectedNewsIndex].toString()),

            // controller: _con.newsContentController,
            maxLines: 10,
            keyboardType: TextInputType.multiline,
            style: TextStyle(
              color: Colors.white,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.fromLTRB(15, 7, 0, 7),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => new AlertDialog(
              title: new Text("VIPC Message"),
              content: new Text("Successfully saved!"),
              actions: <Widget>[
                FlatButton(
                  child: Text('Close'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return AdminPage();
                    }));
                  },
                )
              ],
            ),
          );
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.amber[300],
        child: Text(
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

  Widget _buildDeleteBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => new AlertDialog(
              title: new Text("Message"),
              content: new Text("Successfully Deleted!"),
              actions: <Widget>[
                FlatButton(
                  child: Text('Close'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return AdminPage();
                    }));
                  },
                )
              ],
            ),
          );
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.deepOrange[500],
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

  Widget _buildCancelBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () {
          _con.selectedIndex = 0;
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => AdminPage()));
          // Navigator.push(context, MaterialPageRoute(builder: (context) {
          //   return AdminPage();
          // }));
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.amber[300],
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
