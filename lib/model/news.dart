import 'package:flutter/foundation.dart';

class News {
  String newsId;
  String title;
  String content;
  Map<String, dynamic> imageUrl;
  News(
      {@required this.newsId,
      @required this.title,
      @required this.content,
      this.imageUrl});
}
