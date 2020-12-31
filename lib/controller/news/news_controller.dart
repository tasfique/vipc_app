import 'package:mvc_pattern/mvc_pattern.dart';

class NewsController extends ControllerMVC {
  factory NewsController() {
    if (_this == null) _this = NewsController._();
    return _this;
  }
  static NewsController _this;
  NewsController._();

  static NewsController get con => _this;
}
