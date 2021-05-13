import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:vipc_app/controller/prospect/prospect_edit_controller.dart';
import 'package:vipc_app/model/prospect.dart';

enum Choices { edit, update }

class EditProspect extends StatefulWidget {
  final Prospect prospect;

  EditProspect(this.prospect);
  @override
  _EditProspectState createState() => _EditProspectState();
}

class _EditProspectState extends StateMVC<EditProspect> {
  _EditProspectState() : super(ProspectEditController()) {
    _con = ProspectEditController.con;
  }
  ProspectEditController _con;

  String selectedType;
  String selectedStep;
  List<String> types = ["Cold", "Warm", "Hot"];
  List<String> steps = [
    "Step 1 Make Appointment",
    "Step 2 Open Case",
    "Step 3 Presentation",
    'Step 4 Follow Up',
    'Step 5 Close',
    "Step 6 Referral/Servicing",
  ];
  Choices _choice = Choices.edit;

  @override
  void initState() {
    super.initState();
    _con.dateController.text = "";
    _con.timeController.text = "";
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
          title: Text('Edit Prospect'),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: screenSize.size.width * 0.36,
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.only(left: 10),
                            child: Text(
                              "Edit Prospect",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            width: screenSize.size.width * 0.5,
                            child: Column(
                              children: [
                                ListTile(
                                  title: const Text(
                                    'Edit Current Step',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                    ),
                                  ),
                                  leading: Radio<Choices>(
                                    value: Choices.edit,
                                    groupValue: _choice,
                                    onChanged: (Choices value) {
                                      setState(() {
                                        _choice = value;
                                      });
                                    },
                                  ),
                                ),
                                ListTile(
                                  title: const Text(
                                    'Update New Step',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                    ),
                                  ),
                                  leading: Radio<Choices>(
                                    value: Choices.update,
                                    groupValue: _choice,
                                    onChanged: (Choices value) {
                                      setState(() {
                                        _choice = value;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      _buildProspectNameTextField(),
                      SizedBox(height: 15),
                      _buildProspectPhoneNoTextField(),
                      SizedBox(height: 15),
                      _buildProspectTypeDropdownList(),
                      SizedBox(height: 20),
                      _buildStepDropdownList(),
                      SizedBox(height: 20),
                      _buildPlaceTextField(),
                      SizedBox(height: 20),
                      _buildDatePicker(),
                      SizedBox(height: 20),
                      _buildTime(),
                      SizedBox(height: 20),
                      _buildMemoTextFormField(),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildDeleteBtn(screenSize),
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
            "Prospect Type",
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
            value: types[0],
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

  Widget _buildStepDropdownList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          child: Text(
            "Step Number",
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
                "Select The Step Number",
                style: TextStyle(color: Colors.white70),
              ),
            ),
            isExpanded: true,
            iconEnabledColor: Colors.white,
            //changed here
            value: steps[0],
            onChanged: (String value) {
              setState(() {
                selectedStep = value;
              });
            },
            items: steps.map((String prospectSteps) {
              return DropdownMenuItem(
                value: prospectSteps,
                child: Row(
                  children: <Widget>[
                    Text(
                      prospectSteps,
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

  Widget _buildPlaceTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Meeting Place',
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
              hintText: "Enter Meeting Meetup Location.",
              hintStyle: TextStyle(
                color: Colors.white70,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDatePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Meeting Date',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10.0),
        GestureDetector(
          onTap: () async {
            final DateTime picked = await showDatePicker(
              context: context,
              initialDate: _con.selectedDate,
              firstDate: DateTime(2015, 8),
              lastDate: DateTime(2101),
              builder: (BuildContext context, Widget child) {
                return Theme(
                  data: ThemeData.dark().copyWith(
                    dialogBackgroundColor: Colors.grey[800],
                    colorScheme: ColorScheme.dark(
                      surface: Colors.grey[800],
                      primary: Colors.amber[500],
                    ),
                  ),
                  child: child,
                );
              },
            );
            if (picked != null) {
              setState(() {
                _con.selectedDate = picked;
                _con.dateController.text = _con.selectedDate.toString();
              });
            }
          },
          child: Container(
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
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 15, right: 15),
                  child: Icon(
                    Icons.calendar_today,
                    color: Colors.white,
                  ),
                ),
                Container(
                  child: Text(
                    _con.dateController.text == "" ||
                            _con.dateController.text == null
                        ? "Select meeting date."
                        : _con.dateController.text.substring(0, 10),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTime() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Meeting Time',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10.0),
        GestureDetector(
          onTap: () async {
            final TimeOfDay pickedTime = await showTimePicker(
                context: context,
                initialTime: _con.selectedTime,
                builder: (BuildContext context, Widget child) {
                  return Theme(
                    data: ThemeData.dark().copyWith(
                      dialogBackgroundColor: Colors.grey[800],
                      colorScheme: ColorScheme.dark(
                        surface: Colors.grey[800],
                        primary: Colors.amber[500],
                      ),
                    ),
                    child: child,
                  );
                });
            if (pickedTime != null) {
              setState(() {
                _con.selectedTime = pickedTime;
                _con.timeController.text =
                    "${_con.selectedTime.hourOfPeriod}:${_con.selectedTime.minute == 0 ? "00" : _con.selectedTime.minute} ${_con.selectedTime.period.index == 0 ? 'AM' : 'PM'}";
              });
            }
          },
          child: Container(
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
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 15, right: 15),
                  child: Icon(
                    Icons.access_time,
                    color: Colors.white,
                  ),
                ),
                Container(
                  child: Text(
                    _con.timeController.text == "" ||
                            _con.timeController.text == null
                        ? "Select meeting time."
                        : _con.timeController.text,
                  ),
                ),
              ],
            ),
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

  Widget _buildSaveBtn(MediaQueryData screenSize) {
    return GestureDetector(
      onTap: () {
        print("Meeting Date: ${_con.dateController.text.substring(0, 10)}");
        print("Meeting Time: ${_con.timeController.text}");
        showDialog(
          context: context,
          builder: (_) => new AlertDialog(
            title: new Text("Message"),
            content: new Text("Successfully Saved!"),
            actions: <Widget>[
              TextButton(
                child: Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    // return ProspectView();
                  }));
                },
              )
            ],
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 25.0),
        child: Container(
          padding: EdgeInsets.all(15.0),
          decoration: BoxDecoration(
            color: Colors.amber[300],
            borderRadius: BorderRadius.circular(30),
          ),
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
      ),
    );
  }

  Widget _buildDeleteBtn(MediaQueryData screenSize) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (_) => new AlertDialog(
            title: new Text("Message"),
            content: new Text("Successfully Deleted!"),
            actions: <Widget>[
              TextButton(
                child: Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    // return ProspectView();
                  }));
                },
              )
            ],
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 25.0),
        child: Container(
          padding: EdgeInsets.all(15.0),
          decoration: BoxDecoration(
            color: Colors.deepOrange[500],
            borderRadius: BorderRadius.circular(30),
          ),
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
