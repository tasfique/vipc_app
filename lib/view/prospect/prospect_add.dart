import 'package:flutter/material.dart';
import 'package:vipc_app/view/appbar/appbar_view.dart';
import 'package:vipc_app/view/drawer/drawer_view.dart';
import 'package:vipc_app/view/prospect/prospect_view.dart';

String selectedType;
List<String> types = ["Suspect", "Cold", "Hot"];

class AddProspectStateless extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      drawer: CustomDrawer(),
      body: Center(
        child: AddProspect(),
      ),
    );
  }
}

class AddProspect extends StatefulWidget {
  @override
  _AddProspectState createState() => _AddProspectState();
}

class _AddProspectState extends State<AddProspect> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
                "Add New Prospect",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20),
            _buildProspectNameTextField(),
            SizedBox(height: 15),
            _buildProspectPhoneNoTextField(),
            SizedBox(height: 15),
            _buildProspectTypeDropdownList(),
            SizedBox(height: 30),
            _buildMemoTextFormField(),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCancelBtn(),
                _buildSaveBtn(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProspectNameTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Name',
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
          child: TextField(
            // controller: _usernameController,
            keyboardType: TextInputType.text,
            style: TextStyle(
              color: Colors.white,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.fromLTRB(15, 7, 0, 7),
              hintText: "Enter Prospect's Name.",
              hintStyle: TextStyle(
                color: Colors.white70,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProspectPhoneNoTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Phone No',
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
          child: TextField(
            // controller: _usernameController,
            keyboardType: TextInputType.text,
            style: TextStyle(
              color: Colors.white,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.fromLTRB(15, 7, 0, 7),
              hintText: "Enter Prospect's Phone No.",
              hintStyle: TextStyle(
                color: Colors.white70,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProspectTypeDropdownList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          child: Text(
            "Prospect Tyoe",
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
          height: 60.0,
          child: DropdownButton(
            hint: Container(
              child: Text(
                "Select the type",
                style: TextStyle(color: Colors.white70),
              ),
            ),
            isExpanded: true,
            iconEnabledColor: Colors.white,
            value: selectedType,
            onChanged: (String value) {
              setState(() {
                selectedType = value;
              });
            },
            items: types.map((String prospectTypes) {
              return DropdownMenuItem(
                value: prospectTypes,
                child: Row(
                  children: <Widget>[
                    Text(
                      prospectTypes,
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

  Widget _buildMemoTextFormField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
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
            // controller: _usernameController,
            minLines: 6,
            keyboardType: TextInputType.text,
            style: TextStyle(
              color: Colors.white,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.fromLTRB(15, 7, 0, 7),
              hintText: 'Memo . . .',
              hintStyle: TextStyle(
                color: Colors.white70,
              ),
            ),
            maxLines: null,
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
                      return ProspectView();
                    }));
                  },
                )
              ],
            ),
          );
        },
        padding: const EdgeInsets.only(
          left: 60.0,
          top: 15.0,
          right: 60.0,
          bottom: 15.0,
        ),
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

  Widget _buildCancelBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () {
          Navigator.of(context).pop();
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return ProspectView();
          }));
        },
        padding: const EdgeInsets.only(
          left: 60.0,
          top: 15.0,
          right: 60.0,
          bottom: 15.0,
        ),
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