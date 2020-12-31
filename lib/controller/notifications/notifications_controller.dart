import 'package:mvc_pattern/mvc_pattern.dart';

class NotificationsController extends ControllerMVC {
  factory NotificationsController() {
    if (_this == null) _this = NotificationsController._();
    return _this;
  }
  static NotificationsController _this;
  NotificationsController._();

  static NotificationsController get con => _this;
}
