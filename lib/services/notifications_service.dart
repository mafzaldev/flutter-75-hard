// import 'dart:math';

// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:seventy_five_hard/Utils/utils.dart';
import 'dart:math';
import 'dart:developer' as dev;

import 'package:seventy_five_hard/utils/utils.dart';
import 'package:timezone/data/latest_all.dart' as tz;

// class NotificationService {
//   static Future<void> scheduleNotification() async {
//     tz.initializeTimeZones();
//     const initializationSettingsAndroid =
//         AndroidInitializationSettings('app_icon');
//     final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//         FlutterLocalNotificationsPlugin();
//     const AndroidNotificationDetails androidNotificationDetails =
//         AndroidNotificationDetails('75', '75Hard');
//     const NotificationDetails notificationDetails =
//         NotificationDetails(android: androidNotificationDetails);
//     await flutterLocalNotificationsPlugin.periodicallyShow(
//       75,
//       '75 Hard',
//       Utils.quoteCategories[Random().nextInt(Utils.quoteCategories.length)],
//       RepeatInterval.everyMinute,
//       notificationDetails,
//     );
//   }

//   static Future<void> scheduleDailyTenAMNotification() async {
//     tz.initializeTimeZones();
//     final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//         FlutterLocalNotificationsPlugin();
//     await flutterLocalNotificationsPlugin.zonedSchedule(
//         0,
//         'daily scheduled notification title',
//         'daily scheduled notification body',
//         _nextInstanceOfTenAM(),
//         const NotificationDetails(
//           android: AndroidNotificationDetails(
//             'daily notification channel id',
//             'daily notification channel name',
//             channelDescription: 'daily notification description',
//             icon: "ic_notification",
//           ),
//         ),
//         androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//         uiLocalNotificationDateInterpretation:
//             UILocalNotificationDateInterpretation.absoluteTime,
//         matchDateTimeComponents: DateTimeComponents.time);
//   }

//   static tz.TZDateTime _nextInstanceOfTenAM() {
//     final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
//     tz.TZDateTime scheduledDate =
//         tz.TZDateTime(tz.local, now.year, now.month, now.day, 19, 5);
//     if (scheduledDate.isBefore(now)) {
//       scheduledDate = scheduledDate.add(const Duration(days: 1));
//     }
//     return scheduledDate;
//   }
// }

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
        AndroidNotificationDetails('75', '75Hard');
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    dev.log(Random().nextInt(Utils.reminders.length).toString());
    await notificationsPlugin.periodicallyShow(
      Random().nextInt(Utils.reminders.length),
      '75 Hard',
      Utils.reminders[Random().nextInt(Utils.reminders.length)],
      RepeatInterval.everyMinute,
      notificationDetails,
    );
  }
}
