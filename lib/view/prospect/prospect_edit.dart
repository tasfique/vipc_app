import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:vipc_app/controller/prospect/prospect_edit_controller.dart';
import 'package:vipc_app/model/prospect.dart';

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

  List<String> types = ["Cold", "Warm", "Hot"];
  List<String> steps = [
    "Step 1 Make Appointment",
    "Step 2 Open Case",
    "Step 3 Follow Up",
    "Step 4 Presentation Zoom/Meet Up",
    'Step 5 Closing',
    "Step 6 Referral/Servicing"
  ];

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);

  @override
  void initState() {
    super.initState();
    _con.start();
    _con.prospect = widget.prospect;
    _con.length = widget.prospect.steps['length'] - 1;
    print('${_con.length + 1}');
    if (_con.prospect.lastStep > 0)
      steps.removeRange(0, _con.prospect.lastStep);
  }

  @override
  void dispose() async {
    super.dispose();
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
                                    groupValue: _con.choice,
                                    onChanged: (Choices value) {
                                      setState(() {
                                        _con.choice = value;
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
                                    groupValue: _con.choice,
                                    onChanged: (Choices value) {
                                      setState(() {
                                        _con.choice = value;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      _con.choice == Choices.edit
                          ? _buildProspectNameTextField()
                          : SizedBox(),
                      _con.choice == Choices.edit
                          ? _buildProspectPhoneNoTextField()
                          : SizedBox(),
                      _con.choice == Choices.edit
                          ? _buildProspectEmailTextField()
                          : SizedBox(),
                      _con.choice == Choices.edit
                          ? _buildProspectTypeDropdownList()
                          : SizedBox(),
                      _con.choice == Choices.update
                          ? _buildStepDropdownList()
                          : SizedBox(),
                      _con.length == 0 && _con.choice == Choices.edit
                          ? SizedBox()
                          : _buildPlaceTextField(),
                      _con.length == 0 && _con.choice == Choices.edit
                          ? SizedBox()
                          : _buildDatePicker(),
                      _con.length == 0 && _con.choice == Choices.edit
                          ? SizedBox()
                          : _buildTime(),
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
          child: TextFormField(
            validator: (value) {
              if (value.isNotEmpty && value.length < 2) {
                return 'Please enter valid name.';
              }
              return null;
            },
            controller: _con.nameController,
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
              hintText: widget.prospect.prospectName,
              hintStyle: TextStyle(
                color: Colors.white70,
              ),
            ),
          ),
        ),
        SizedBox(height: 15),
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
          child: TextFormField(
            validator: (value) {
              if (value.isNotEmpty && value.length < 2) {
                return 'Please enter valid phone No.';
              }
              return null;
            },
            controller: _con.phoneController,
            keyboardType: TextInputType.phone,
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
              hintText: widget.prospect.phoneNo,
              hintStyle: TextStyle(
                color: Colors.white70,
              ),
            ),
          ),
        ),
        SizedBox(height: 15),
      ],
    );
  }

  Widget _buildProspectEmailTextField() {
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
              contentPadding: EdgeInsets.fromLTRB(15, 11, 0, 7),
              hintText:
                  widget.prospect.email == null || widget.prospect.email.isEmpty
                      ? "Enter Email"
                      : widget.prospect.email,
              hintStyle: TextStyle(
                color: Colors.white70,
              ),
            ),
          ),
        ),
        SizedBox(height: 15),
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
          height: 63.0,
          child: DropdownButtonFormField(
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
                widget.prospect.type,
                style: TextStyle(color: Colors.white),
              ),
            ),
            isExpanded: true,
            iconEnabledColor: Colors.white,
            value: _con.selectedType,
            onChanged: (String value) {
              setState(() {
                _con.selectedType = value;
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
        SizedBox(height: 15),
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
          height: 63.0,
          child: DropdownButtonFormField(
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
              if (value == null || value == 'Select The Step Number') {
                return 'Please select step number.';
              }
              return null;
            },
            hint: Container(
              child: Text(
                "Select Step Number",
                style: TextStyle(color: Colors.white),
              ),
            ),
            isExpanded: true,
            iconEnabledColor: Colors.white,
            value: _con.selectedStep,
            onChanged: (String value) {
              setState(() {
                _con.selectedStep = value;
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
        SizedBox(height: 15),
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
          child: TextFormField(
            controller: _con.placeController,
            keyboardType: TextInputType.text,
            style: TextStyle(
              color: Colors.white,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.fromLTRB(15, 7, 0, 7),
              hintText: _con.choice == Choices.update
                  ? "Enter Meetup Location"
                  : widget.prospect.steps['${_con.length}meetingPlace'] ==
                              null ||
                          widget.prospect.steps['${_con.length}meetingPlace']
                              .isEmpty
                      ? "Enter Meetup Location"
                      : widget.prospect.steps['${_con.length}meetingPlace'],
              hintStyle: TextStyle(
                color: Colors.white70,
              ),
            ),
          ),
        ),
        SizedBox(height: 15)
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
            validator: (_) {
              if ((_con.dateController.text.isEmpty &&
                      widget.prospect.steps['${_con.length}meetingDate'] ==
                          '' &&
                      _con.choice == Choices.edit) ||
                  (_con.dateController.text.isEmpty &&
                      _con.choice == Choices.update))
                return 'Please choose a meeting date.';
              return null;
            },
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
              hintText: _con.choice == Choices.update &&
                      _con.dateController.text == ''
                  ? "Select Meeting Date"
                  : (widget.prospect.steps['${_con.length}meetingDate'] ==
                                  null ||
                              widget.prospect.steps['${_con.length}meetingDate']
                                  .isEmpty) &&
                          (_con.dateController.text == "" ||
                              _con.dateController.text == null)
                      ? "Select Meeting Date"
                      : _con.dateController.text.isEmpty
                          ? DateFormat('yyyy-MM-dd').format(DateTime.parse(
                              widget
                                  .prospect.steps['${_con.length}meetingDate']))
                          : _con.dateController.text.substring(0, 10),
              hintStyle: TextStyle(
                color: Colors.white,
              ),
            ),
            onTap: () async {
              final DateTime picked = await showDatePicker(
                context: context,
                initialDate: selectedDate,
                firstDate:
                    DateTime(DateTime.now().year, DateTime.now().month - 1),
                lastDate:
                    DateTime(DateTime.now().year, DateTime.now().month + 4),
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
                  _con.dateController.text = picked.toIso8601String();
                });
              }
            },
          ),
        ),
        // GestureDetector(
        //   onTap: () async {
        //     final DateTime picked = await showDatePicker(
        //       context: context,
        //       initialDate: selectedDate,
        //       firstDate:
        //           DateTime(DateTime.now().year, DateTime.now().month - 1),
        //       lastDate: DateTime(DateTime.now().year, DateTime.now().month + 4),
        //       builder: (BuildContext context, Widget child) {
        //         return Theme(
        //           data: ThemeData.dark().copyWith(
        //             dialogBackgroundColor: Colors.grey[800],
        //             colorScheme: ColorScheme.dark(
        //               surface: Colors.grey[800],
        //               primary: Colors.amber[500],
        //             ),
        //           ),
        //           child: child,
        //         );
        //       },
        //     );
        //     if (picked != null) {
        //       setState(() {
        //         _con.dateController.text = picked.toString().substring(0, 10);
        //       });
        //     }
        //   },
        //   child: Container(
        //     alignment: Alignment.centerLeft,
        //     decoration: BoxDecoration(
        //       color: Colors.white24,
        //       borderRadius: BorderRadius.circular(10.0),
        //       boxShadow: [
        //         BoxShadow(
        //           color: Colors.black12,
        //           blurRadius: 6.0,
        //           offset: Offset(0, 2),
        //         ),
        //       ],
        //     ),
        //     height: 60.0,
        //     child: Row(
        //       children: [
        //         Container(
        //           padding: EdgeInsets.only(left: 15, right: 15),
        //           child: Icon(
        //             Icons.calendar_today,
        //             color: Colors.white,
        //           ),
        //         ),
        //         Container(
        //           child: Text(
        //             (widget.prospect.steps['${_con.length}meetingDate'] ==
        //                             null ||
        //                         widget
        //                             .prospect
        //                             .steps['${_con.length}meetingDate']
        //                             .isEmpty) &&
        //                     (_con.dateController.text == "" ||
        //                         _con.dateController.text == null)
        //                 ? "Select Meeting Date"
        //                 : _con.dateController.text.isEmpty
        //                     ? widget.prospect.steps['${_con.length}meetingDate']
        //                     : _con.dateController.text,
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        SizedBox(height: 15),
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
                initialTime: selectedTime,
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
                _con.timeController.text =
                    "${pickedTime.hour < 10 ? "0${pickedTime.hour}" : pickedTime.hour}:${pickedTime.minute == 0 ? "00" : pickedTime.minute}";
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
                    _con.choice == Choices.update &&
                            _con.timeController.text == ''
                        ? "Select Meeting Date"
                        : (widget.prospect.steps['${_con.length}meetingTime'] ==
                                        null ||
                                    widget
                                        .prospect
                                        .steps['${_con.length}meetingTime']
                                        .isEmpty) &&
                                (_con.timeController.text == "" ||
                                    _con.timeController.text == null)
                            ? "Select Meeting Date"
                            : _con.timeController.text.isEmpty
                                ? widget
                                    .prospect.steps['${_con.length}meetingTime']
                                : _con.timeController.text,
                    style: TextStyle(fontSize: 15),
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
        _con.choice == Choices.edit && _con.length == 0
            ? SizedBox(height: 5)
            : SizedBox(height: 20),
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
            controller: _con.memoController,
            minLines: 8,
            keyboardType: TextInputType.multiline,
            textCapitalization: TextCapitalization.sentences,
            textInputAction: TextInputAction.newline,
            style: TextStyle(
              color: Colors.white,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.fromLTRB(15, 7, 0, 7),
              hintText: _con.choice == Choices.update
                  ? 'Memo . . .'
                  : widget.prospect.steps['${_con.length}memo'] == null ||
                          widget.prospect.steps['${_con.length}memo'].isEmpty
                      ? 'Memo . . .'
                      : widget.prospect.steps['${_con.length}memo'],
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
          await _con.editProspect(context);
          if (_con.editSuccess) {
            showDialog(
              context: context,
              builder: (_) => new AlertDialog(
                title: Text("VIPC Message"),
                content: Text("Successfully saved!"),
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
              title: new Text("VIPC Message"),
              content: new Text("Confirm deleting this prospect!"),
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
                    await _con.deleteProspect(context);
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
