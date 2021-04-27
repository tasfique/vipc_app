import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:vipc_app/controller/news/news_add_controller.dart';
import 'package:vipc_app/view/appbar/appbar_view.dart';
import 'package:vipc_app/view/drawer/drawer_view.dart';
import 'package:vipc_app/view/admin/admin_home_view.dart';

class AddNews extends StatefulWidget {
  @override
  _AddNewsState createState() => _AddNewsState();
}

class _AddNewsState extends StateMVC {
  _AddNewsState() : super(NewsAddController()) {
    _con = NewsAddController.con;
  }

  NewsAddController _con;

  @override
  void initState() {
    _con.clean();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context);

    return Scaffold(
      appBar: CustomAppBar(),
      drawer: CustomDrawer(),
      body: Center(
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
                      "Add New Article",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  _buildTitleTextField(),
                  SizedBox(height: 20),
                  _buildTextFormField(),
                  SizedBox(height: 20),
                  _buildImageUpload(screenSize),
                  SizedBox(height: 10),
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
            textInputAction: TextInputAction.next,
            controller: _con.titleController,
            keyboardType: TextInputType.text,
            style: TextStyle(
              color: Colors.white,
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter title.';
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
              contentPadding: EdgeInsets.fromLTRB(15, 7, 0, 7),
              hintText: 'Enter Title',
              hintStyle: TextStyle(
                color: Colors.white70,
              ),
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
                return 'Please enter article content.';
              }
              return null;
            },
            controller: _con.contentController,
            minLines: 15,
            keyboardType: TextInputType.text,
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
              border: InputBorder.none,
              contentPadding: EdgeInsets.fromLTRB(15, 7, 0, 7),
              hintText: 'Enter article content . . .',
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

  Widget _buildImageUpload(MediaQueryData screenSize) {
    return Column(
      children: [
        Row(
          children: [
            Container(
                // height: screenSize.size.height * 0.3,
                height: 220,
                width: screenSize.size.width * 0.58,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 0.1,
                    color: Colors.grey[350],
                  ),
                ),
                // child: FittedBox(
                //   child: Image.network(
                //     _imageURLController.text,
                //     fit: BoxFit.cover,
                //   ),
                // ),
                //
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
                        : null),
            SizedBox(
              width: screenSize.size.width * 0.33,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextButton.icon(
                    icon: Icon(Icons.photo_camera),
                    label: Text('Open Camera'),
                    onPressed: () => _con.pickImage(ImageSource.camera),
                  ),
                  TextButton.icon(
                    icon: Icon(Icons.image),
                    label: Text('Add Image'),
                    onPressed: () => _con.loadAssets(context),
                    // onPressed: () => _con.pickImage(ImageSource.gallery),
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
          // SizedBox(
          // height: 400,
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
                // width: (screenSize.size.width * 0.2).toInt(),
                // height: (screenSize.size.width * 0.2).toInt(),
                width: 500,
                height: 500,
              );
            }),
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
          elevation: 5.0,
          padding: const EdgeInsets.only(
            left: 40.0,
            top: 15.0,
            right: 40.0,
            bottom: 15.0,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          primary: Colors.amber[300],
        ),
        onPressed: () async {
          await _con.saveArticle(context);
          if (_con.addArticleSuccess)
            showDialog(
              context: context,
              builder: (_) => new AlertDialog(
                title: new Text("VIPC Message"),
                content: new Text("Successfully added new article!"),
                actions: <Widget>[
                  TextButton(
                    child: Text('Close'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();

                      // Navigator.push(context,
                      //     MaterialPageRoute(builder: (context) {
                      //   return AdminPage();
                      // }));
                    },
                  )
                ],
              ),
            );
        },
        child: _con.isLoading
            ? SizedBox(
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
          padding: const EdgeInsets.only(
            left: 40.0,
            top: 15.0,
            right: 40.0,
            bottom: 15.0,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          primary: Colors.amber[300],
        ),
        onPressed: () {
          Navigator.of(context).pop();
          // Navigator.push(context, MaterialPageRoute(builder: (context) {
          //   return AdminPage();
          // }));
        },
        child: Text(
          'Back',
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
