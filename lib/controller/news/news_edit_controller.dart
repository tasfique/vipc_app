import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class NewsEditController extends ControllerMVC {
  factory NewsEditController() {
    if (_this == null) _this = NewsEditController._();
    return _this;
  }
  static NewsEditController _this;
  NewsEditController._();

  static NewsEditController get con => _this;

  GlobalKey<FormState> formKey;
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  String nid;
  String title;
  String content;
  bool isValid;
  bool editSuccess;
  bool isLoading;
  bool loadImage;
  Map<String, dynamic> imageUrl;
  List<Asset> images;
  File imageFile;
  int imageCount;
  bool clearDone;
  bool changed;
  bool crossCheck;

  void setToDefault() {
    imageFile = null;
    crossCheck = false;
    changed = false;
    imageCount = null;
    clearDone = false;
    nid = null;
    title = null;
    content = null;
    images = <Asset>[];
    loadImage = false;
    isValid = false;
    editSuccess = false;
    isLoading = false;
    imageUrl = null;
    titleController.clear();
    contentController.clear();
  }

  void imageCheck() {
    if (imageUrl != null && imageUrl['length'] == 1) {
      imageCount = 0;
    } else if (imageUrl != null && imageUrl['length'] > 1) {
      imageCount = imageUrl['length'];
    }
  }

  setSearchParam(String searchString) {
    List<String> caseSearchList = [];
    String temp = "", temp2 = '';
    bool checkValue = false;
    for (int i = 0; i < searchString.length; i++) {
      if (searchString[i] == " ") {
        if (!checkValue) {
          temp = temp2;
          checkValue = true;
        }
        temp2 = "";
      } else {
        temp2 = temp2 + searchString[i];
        caseSearchList.add(temp2.toLowerCase());
      }
      if (checkValue) {
        temp = temp + searchString[i];
        caseSearchList.add(temp.toLowerCase());
      }
    }
    return caseSearchList;
  }

  Future<void> editNews(BuildContext context) async {
    FocusScope.of(context).unfocus();
    isValid = formKey.currentState.validate();

    if (isValid) {
      setState(() {
        isLoading = true;
      });

      try {
        List<String> caseSearchListSaveToFireBase =
            setSearchParam(titleController.text);

        await FirebaseFirestore.instance.collection('news').doc(nid).update({
          'title': titleController.text,
          'content': contentController.text,
        }).then((_) async {
          await FirebaseFirestore.instance
              .collection('search')
              .doc('adminSearch')
              .collection('search')
              .doc(nid)
              .update({
            'title': titleController.text,
            'searchCase': caseSearchListSaveToFireBase.toList()
          });
        });

        if (!clearDone && crossCheck) {
          List<File> file = [];
          final documentDirectory = await getApplicationDocumentsDirectory();

          for (int i = 0; i < imageCount; i++) {
            final response = await http.get(imageUrl['$i']);
            file.add(File(join(documentDirectory.path, 'image.jpg')));
            file[i].writeAsBytesSync(response.bodyBytes);
          }

          await FirebaseFirestore.instance
              .collection('news')
              .doc(nid)
              .update({'images': FieldValue.delete()});

          for (int i = 0; i < imageUrl['length']; i++)
            await FirebaseStorage.instance
                .ref()
                .child('news_images')
                .child(nid)
                .child('$i.jpg')
                .delete();

          await FirebaseFirestore.instance.collection('news').doc(nid).update({
            'images': {'length': imageCount}
          });

          for (int i = 0; i < imageCount; i++) {
            final ref = FirebaseStorage.instance
                .ref()
                .child('news_images')
                .child(nid)
                .child('$i.jpg');

            final tmpDir = (await getTemporaryDirectory()).path;

            final target =
                "$tmpDir/${DateTime.now().millisecondsSinceEpoch}-90.jpg";

            var compressedFile = await FlutterImageCompress.compressAndGetFile(
              file[i].absolute.path,
              target,
              minWidth: 1500,
              minHeight: 1500,
            );
            await ref.putFile(compressedFile);

            final url = await ref.getDownloadURL();

            await FirebaseFirestore.instance.collection('news').doc(nid).update(
              {
                'images.$i': url,
              },
            );
          }
          file = null;
        }

        if (imageUrl != null && clearDone) {
          await FirebaseFirestore.instance
              .collection('news')
              .doc(nid)
              .update({'images': FieldValue.delete()});

          for (int i = 0; i < imageUrl['length']; i++)
            await FirebaseStorage.instance
                .ref()
                .child('news_images')
                .child(nid)
                .child('$i.jpg')
                .delete();
        }

        if (imageCount == 0 && changed) {
          final ref = FirebaseStorage.instance
              .ref()
              .child('news_images')
              .child(nid)
              .child(imageCount.toString() + '.jpg');

          await ref.putFile(imageFile);

          final url = await ref.getDownloadURL();

          await FirebaseFirestore.instance.collection('news').doc(nid).update({
            'images': {'length': 1, '0': url},
          });
        } else if (imageCount != 0 && imageCount != null && changed) {
          await FirebaseFirestore.instance.collection('news').doc(nid).update({
            'images': {'length': imageCount}
          });
          for (int i = 0; i < imageCount; i++) {
            final ref = FirebaseStorage.instance
                .ref()
                .child('news_images')
                .child(nid)
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

            await FirebaseFirestore.instance.collection('news').doc(nid).update(
              {
                'images.$i': url,
              },
            );
          }
        } else if (clearDone) {}

        setState(() {
          editSuccess = true;
          isLoading = false;
        });
      } catch (err) {
        setState(() {
          editSuccess = false;
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
        editSuccess = false;
        isLoading = false;
      });
    }
  }

  Future<void> deleteNews(BuildContext context) async {
    try {
      await FirebaseFirestore.instance
          .collection('news')
          .doc(nid)
          .delete()
          .then((_) async {
        await FirebaseFirestore.instance
            .collection('search')
            .doc('adminSearch')
            .collection('search')
            .doc(nid)
            .delete();
      });

      if (imageUrl != null) {
        for (int i = 0; i < imageUrl['length']; i++)
          await FirebaseStorage.instance
              .ref()
              .child('news_images')
              .child(nid)
              .child('$i.jpg')
              .delete();
      }
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(err.message),
            backgroundColor: Theme.of(context).errorColor),
      );
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

    setState(() {
      changed = true;
      loadImage = false;
      clearDone = true;
      images.clear();
      imageFile = pickedImageFile;
      imageCount = 0;
    });
  }

  void clearImage() {
    setState(() {
      clearDone = true;
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
        changed = true;
        imageCount = images.length;
        imageFile = null;
        loadImage = true;
        clearDone = true;
      });
    } on NoImagesSelectedException catch (_) {} on Exception catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('${e.toString()}'),
            backgroundColor: Theme.of(context).errorColor),
      );
    }
  }
}
