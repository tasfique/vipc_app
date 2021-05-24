import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:vipc_app/controller/news/news_edit_controller.dart';
import 'package:vipc_app/model/news.dart';

class EditNews extends StatefulWidget {
  final News oneNew;

  EditNews(this.oneNew);
  @override
  _EditNewsState createState() => _EditNewsState();
}

class _EditNewsState extends StateMVC<EditNews> {
  _EditNewsState() : super(NewsEditController()) {
    _con = NewsEditController.con;
  }

  NewsEditController _con;

  @override
  void initState() {
    _con.setToDefault();
    _con.formKey = GlobalKey<FormState>(debugLabel: 'news_edit');
    _con.nid = widget.oneNew.newsId;
    _con.titleController.text = widget.oneNew.title;
    _con.title = widget.oneNew.title;
    _con.content = widget.oneNew.content;
    _con.contentController.text = widget.oneNew.content;
    if (widget.oneNew.imageUrl != null) _con.imageUrl = widget.oneNew.imageUrl;
    _con.imageCheck();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context);
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, true);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('VIPC GROUP'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ),
        // appBar: CustomAppBar(),
        // drawer: CustomDrawer(),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
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
                        "Edit News",
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
                    SizedBox(height: 20),
                    _buildImageEdit(screenSize),
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
            validator: (value) {
              if (value.isEmpty) return 'Please enter title';
              return null;
            },
            controller: _con.titleController,
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.sentences,
            textInputAction: TextInputAction.next,
            style: TextStyle(
              color: Colors.white,
            ),
            maxLines: 2,
            decoration: InputDecoration(
              errorBorder: InputBorder.none,
              helperText: '',
              errorStyle: TextStyle(
                color: Colors.orange[400],
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
              hintStyle: TextStyle(
                color: Colors.white,
              ),
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
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter news content.';
              }
              return null;
            },
            textCapitalization: TextCapitalization.sentences,
            controller: _con.contentController,
            minLines: 12,
            maxLines: null,
            keyboardType: TextInputType.multiline,
            style: TextStyle(
              color: Colors.white,
            ),
            decoration: InputDecoration(
              helperText: '',
              errorBorder: InputBorder.none,
              errorStyle: TextStyle(
                color: Colors.orange[400],
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
              hintStyle: TextStyle(
                color: Colors.white70,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.fromLTRB(15, 7, 0, 7),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImageEdit(MediaQueryData screenSize) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              height: screenSize.size.height * 0.3,
              width: screenSize.size.width * 0.57,
              decoration: BoxDecoration(
                border: Border.all(
                  width: 0.1,
                  color: Colors.grey[350],
                ),
              ),
              child: _con.imageCount != 0 && _con.imageCount != null
                  ? Center(
                      child: Text(
                        'You chose ${_con.imageCount} images',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    )
                  : (_con.imageFile != null)
                      ? Image.file(
                          _con.imageFile,
                          fit: BoxFit.cover,
                        )
                      : (_con.imageUrl != null &&
                              !_con.clearDone &&
                              _con.imageUrl['0'] != 'NoImage')
                          ? Image.network(
                              _con.imageUrl['0'],
                              fit: BoxFit.cover,
                            )
                          : null,
            ),
            SizedBox(
              width: screenSize.size.width * 0.35,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextButton.icon(
                    icon: Icon(Icons.photo_camera),
                    label: Text('Open Camera'),
                    onPressed: () =>
                        _con.pickImage(ImageSource.camera, context),
                  ),
                  TextButton.icon(
                    icon: Icon(Icons.image),
                    label: Text('Add Image'),
                    onPressed: () => _con.loadAssets(context),
                  ),
                  TextButton.icon(
                    icon: Icon(Icons.refresh),
                    label: Text('Clear Image'),
                    onPressed: () => _con.clearImage(),
                  )
                ],
              ),
            )
          ],
        ),
        SizedBox(height: 20),
        if (_con.loadImage)
          GridView.count(
            primary: false,
            padding: const EdgeInsets.all(8),
            mainAxisSpacing: 5,
            crossAxisSpacing: 5,
            shrinkWrap: true,
            crossAxisCount: 2,
            children: List.generate(_con.images.length, (index) {
              Asset asset = _con.images[index];
              return AssetThumb(
                asset: asset,
                width: 500,
                height: 500,
              );
            }),
          ),
        if (!_con.clearDone && _con.imageCount != null && _con.imageCount >= 1)
          GridView.count(
            primary: false,
            padding: const EdgeInsets.all(8),
            mainAxisSpacing: 5,
            crossAxisSpacing: 5,
            shrinkWrap: true,
            crossAxisCount: 2,
            children: imageGenerator(),
          ),
      ],
    );
  }

  List<Widget> imageGenerator() {
    return List.generate(_con.imageCount, (index) {
      return Stack(
        children: [
          Image.network(
            _con.imageUrl['$index'],
            width: 500,
            height: 500,
            fit: BoxFit.cover,
          ),
          IconButton(
            icon: Icon(Icons.cancel_outlined),
            onPressed: () {
              _con.crossCheck = true;
              setState(() {
                for (int i = index; i < _con.imageCount - 1; i++) {
                  _con.imageUrl['$i'] = _con.imageUrl['${i + 1}'];
                }
                _con.imageCount -= 1;
                if (_con.imageCount == 0) _con.imageUrl['0'] = 'NoImage';
              });
            },
          ),
        ],
      );
    });
  }

  Widget _buildSaveBtn(MediaQueryData screenSize) {
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
          await _con.editNews(context);
          if (_con.editSuccess) {
            showDialog(
              context: context,
              builder: (_) => new AlertDialog(
                title: new Text("VIPC Message"),
                content: new Text("Successfully saved!"),
                actions: <Widget>[
                  TextButton(
                    child: Text('Close'),
                    onPressed: () async {
                      // await _con.setToDefault();
                      Navigator.of(context).pop();
                      Navigator.of(context).pop(true);
                      // Navigator.of(context).pop();
                      // Navigator.push(context,
                      //     MaterialPageRoute(builder: (context) {
                      //   return AdminPage();
                      // }));
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
              content: new Text("Confirm deleting this news!"),
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
                    await _con.deleteNews(context);

                    // await _con.setToDefault();
                    Navigator.of(context).pop();
                    Navigator.of(context).pop(true);
                  },
                ),
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
          // await _con.setToDefault();
          Navigator.of(context).pop(true);
          // // _con.selectedIndex = 0;
          // Navigator.pushReplacement(
          //     context, MaterialPageRoute(builder: (context) => AdminPage()));
          // // Navigator.push(context, MaterialPageRoute(builder: (context) {
          // //   return AdminPage();
          // // }));
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
