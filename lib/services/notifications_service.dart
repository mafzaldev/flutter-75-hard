import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:seventy_five_hard/utils/utils.dart';
import 'package:timezone/data/latest_all.dart' as tz;

class NotificationService {
  static Future<void> scheduleNotification() async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    tz.initializeTimeZones();
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('75', '75Hard');
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.periodicallyShow(
      Utils.generateRandomNumber(1, 100),
      '75 Hard',
      'Keep Grinding!!!',
      RepeatInterval.hourly,
      notificationDetails,
    );
  }
}
