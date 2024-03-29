import 'dart:convert';
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
import 'package:http/http.dart' as http;

class NewsAddController extends ControllerMVC {
  factory NewsAddController() {
    if (_this == null) _this = NewsAddController._();
    return _this;
  }
  static NewsAddController _this;
  NewsAddController._();

  static NewsAddController get con => _this;

  final String severToken =
      'AAAAQ2vv-_M:APA91bGWibt_2dMmTc7p32PD17hEt4aRzJlEKCUX62817BxxVYtPB2uSErpXiGECayd03rlLg2HqgGYMB9N6ugO5kyGnbPdVDskgHhNmmmTXIVNCzp8l9sjpnPiGE_NKCjHpcbhi--Df';
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

  Future<void> saveArticle(BuildContext context) async {
    FocusScope.of(context).unfocus();
    isValid = formKey.currentState.validate();

    if (isValid) {
      setState(() {
        isLoading = true;
      });

      String time = DateTime.now().toIso8601String().toString();

      try {
        List<String> caseSearchListSaveToFireBase =
            setSearchParam(titleController.text);

        await FirebaseFirestore.instance.collection('news').doc(time).set({
          'title': titleController.text,
          'content': contentController.text,
        }).then((_) async {
          await FirebaseFirestore.instance
              .collection('search')
              .doc('adminSearch')
              .collection('search')
              .doc(time)
              .set({
            'title': titleController.text,
            'type': 'News',
            'searchCase': caseSearchListSaveToFireBase.toList()
          });
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

        await FirebaseFirestore.instance
            .collection('users')
            .where("type", whereIn: ["Manager", "Advisor"])
            .get()
            .then((value) {
              value.docs.forEach((element) async {
                if (element.data()['token'] != null &&
                    element.data()['token'] != '')
                  await http.post('https://fcm.googleapis.com/fcm/send',
                      headers: <String, String>{
                        'Content-Type': 'application/json',
                        'Authorization': 'key=$severToken',
                      },
                      body: jsonEncode(
                        <String, dynamic>{
                          'notification': <String, dynamic>{
                            'title': titleController.text.length > 30
                                ? '${titleController.text.substring(0, 30)}...'
                                : titleController.text,
                            'body': contentController.text.length > 20
                                ? '${contentController.text.substring(0, 20)}...\nCheck News Page to read more.'
                                : '${contentController.text}\nCheck News Page to read more.',
                          },
                          'priority': 'high',
                          'data': <String, dynamic>{
                            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                            'status': 'done'
                          },
                          'to': element.data()['token'],
                        },
                      ));
              });
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
        imageFile = null;
        loadImage = true;
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
