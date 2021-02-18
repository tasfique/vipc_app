import 'package:mvc_pattern/mvc_pattern.dart';

class SearchController extends ControllerMVC {
  factory SearchController() {
    if (_this == null) _this = SearchController._();
    return _this;
  }
  static SearchController _this;
  SearchController._();

  static SearchController get con => _this;
}
