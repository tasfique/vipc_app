import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:path_provider/path_provider.dart';

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
  int imageCount;

  void clean() {
    imageCount = null;
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

      String time = DateTime.now().toIso8601String().toString();

      try {
        await FirebaseFirestore.instance.collection('news').doc(time).set({
          'title': titleController.text,
          'content': contentController.text,
        });
        if (imageCount == 0) {
          final ref = FirebaseStorage.instance
              .ref()
              .child('news_images')
              .child(time)
              .child(imageCount.toString() + '.jpg');
          await ref.putFile(imageFile);

          final url = await ref.getDownloadURL();

          await FirebaseFirestore.instance.collection('news').doc(time).update({
            'images': {'length': 1, '0': url},
          });
        } else if (imageCount != 0 && imageCount != null) {
          await FirebaseFirestore.instance.collection('news').doc(time).update({
            'images': {'length': imageCount}
          });
          for (int i = 0; i < imageCount; i++) {
            final ref = FirebaseStorage.instance
                .ref()
                .child('news_images')
                .child(time)
                .child(i.toString() + '.jpg');
            final filePath =
                await FlutterAbsolutePath.getAbsolutePath(images[i].identifier);
            final tmpDir = (await getTemporaryDirectory()).path;

            final target =
                "$tmpDir/${DateTime.now().millisecondsSinceEpoch}-90.jpg";

            var compressedFile = await FlutterImageCompress.compressAndGetFile(
              File(filePath).absolute.path,
              target,
              minWidth: 1500,
              minHeight: 1500,
            );
            await ref.putFile(compressedFile);

            final url = await ref.getDownloadURL();

            await FirebaseFirestore.instance
                .collection('news')
                .doc(time)
                .update(
              {
                'images.$i': url,
              },
            );
          }
        }

        setState(() {
          addArticleSuccess = true;
          isLoading = false;
        });
      } catch (err) {
        setState(() {
          addArticleSuccess = false;
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Error! ${err.toString()}'),
              backgroundColor: Theme.of(context).errorColor),
        );
      }
    } else {
      setState(() {
        addArticleSuccess = false;
        isLoading = false;
      });
    }
  }

  Future<void> pickImage(ImageSource source, BuildContext context) async {
    FocusScope.of(context).unfocus();

    final picker = ImagePicker();
    final pickedImage = await picker.getImage(
      maxHeight: 1500.0,
      source: source,
      maxWidth: 1500.0,
    );
    final pickedImageFile = File(pickedImage.path);

    // File selected = await picker.getImage(
    //   source: source,
    // );
// imageQuality: 50, maxWidth: 150
    setState(() {
      loadImage = false;
      images.clear();
      imageFile = pickedImageFile;
      imageCount = 0;
    });
  }

  void clearImage() {
    setState(() {
      loadImage = false;
      imageFile = null;
      imageCount = null;
      images.clear();
    });
  }

  Future<void> loadAssets(BuildContext context) async {
    FocusScope.of(context).unfocus();

    try {
      images = await MultiImagePicker.pickImages(
        maxImages: 10,
        enableCamera: true,
        selectedAssets: images,
        materialOptions: MaterialOptions(
          actionBarColor: "#ffc928",
          actionBarTitle: "VIPC App",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#ffc928",
        ),
      );

      setState(() {
        imageCount = images.length;
        // images = resultList;
        imageFile = null;
        loadImage = true;
      });
    } on Exception catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Error! ${e.toString()}'),
            backgroundColor: Theme.of(context).errorColor),
      );
    }
  }
}
