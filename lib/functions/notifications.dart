import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:buffywalls_3/functions/persistence.dart';
import 'package:flutter/cupertino.dart';

class MyNotifications {
  static const titleString = 'Rate it if you are loving it ✌️';
  static const messageString = 'your RATINGS are really matter to us ☺️';

  sendRatingNotification() async {
    Future.delayed(const Duration(minutes: 3)).then((_) {
      AwesomeNotifications().createNotification(
          content: NotificationContent(
        id: 1,
        channelKey: 'rating',
        displayOnBackground: true,
        title: titleString,
        body: messageString,
      ));
    });
    RatingNotification().saveRatingNotify(true);
  }

  downloadNotification(
      {String? titleString,
      String? messageString,
      bool? isLocked,
      int? progress,
      int? id,
      BuildContext? context,
      String? path,
      NotificationLayout? layout}) async {
    AwesomeNotifications().createNotification(
        actionButtons: [NotificationActionButton(key: "key", label: "View")],
        content: NotificationContent(
          displayOnBackground: true,
          id: id!,
          locked: isLocked,
          category: NotificationCategory.Progress,
          notificationLayout: layout,
          channelKey: 'download',
          progress: progress,
          title: titleString,
          body: messageString,
          payload: isLocked! ? {'': ''} : {'download': path!},
        ));
  }
}
