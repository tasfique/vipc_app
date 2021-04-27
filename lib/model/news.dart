import 'package:flutter/foundation.dart';

class News {
  String newsId;
  String title;
  String content;
  DateTime dateCreated;
  Map<String, String> imageUrl;
  News(
      {@required this.newsId,
      @required this.title,
      @required this.content,
      @required this.dateCreated,
      @required this.imageUrl});
}
