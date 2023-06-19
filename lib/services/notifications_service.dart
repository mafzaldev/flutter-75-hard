import 'package:seventy_five_hard/utils/utils.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('ic_launcher');

    var initializationSettingsIOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification:
            (int id, String? title, String? body, String? payload) async {});

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await notificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {});
  }

  notificationDetails() {
    return const NotificationDetails(
        android: AndroidNotificationDetails('75', '75Hard',
            importance: Importance.max),
        iOS: DarwinNotificationDetails());
  }

  Future<void> scheduleNotification() async {
    tz.initializeTimeZones();

    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      '75',
      '75Hard',
      styleInformation: BigTextStyleInformation(''),
    );
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await notificationsPlugin.periodicallyShow(
      75,
      '75 Hard',
      Utils.notificationMessage,
      RepeatInterval.everyMinute,
      notificationDetails,
    );
  }
}
