import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class NewsAddController extends ControllerMVC {
  factory NewsAddController() {
    if (_this == null) _this = NewsAddController._();
    return _this;
  }
  static NewsAddController _this;
  NewsAddController._();

  static NewsAddController get con => _this;

  GlobalKey<FormState> formKey = GlobalKey<FormState>(debugLabel: 'news_add');
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  bool isValid;
  bool addArticleSuccess;
  bool isLoading;
  File imageFile;
  List<Asset> images;
  bool loadImage;

  void clean() {
    images = <Asset>[];
    loadImage = false;
    isValid = false;
    addArticleSuccess = false;
    isLoading = false;
    titleController.clear();
    contentController.clear();
    clearImage();
  }

  Future<void> saveArticle(BuildContext context) async {
    FocusScope.of(context).unfocus();
    isValid = formKey.currentState.validate();

    if (isValid) {
      setState(() {
        isLoading = true;
      });
      print('hello');
      print(titleController.text);
      print(contentController.text);

      setState(() {
        addArticleSuccess = true;
        isLoading = false;
      });
    } else {
      print('nono');
      setState(() {
        addArticleSuccess = false;
        isLoading = false;
      });
    }
  }

  Future<void> pickImage(ImageSource source) async {
    // imagePicker.getImage();
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(
      source: source,
    );
    final pickedImageFile = File(pickedImage.path);

    // File selected = await picker.getImage(
    //   source: source,
    // );
// imageQuality: 50, maxWidth: 150
    setState(() {
      imageFile = pickedImageFile;
    });
  }

  void clearImage() {
    setState(() {
      imageFile = null;
    });
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = <Asset>[];
    print('hee');
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 10,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Example App",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
      print('hee231');
    } on Exception catch (e) {
      // error = e.toString();
    }
    setState(() {
      images = resultList;
      loadImage = true;
    });
  }
}
