import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:local_notification/controllers/motivation_controller.dart';
import 'package:timezone/data/latest_all.dart' as tzl;
import 'package:timezone/timezone.dart' as tz;

class LocalNotificationService {
  static final _localNotification = FlutterLocalNotificationsPlugin();
  static bool notificarionEnabled = false;

  static Future<void> requestPermission() async {
    if (Platform.isIOS || Platform.isMacOS) {
      // IOS uchun
      notificarionEnabled = await _localNotification
              .resolvePlatformSpecificImplementation<
                  IOSFlutterLocalNotificationsPlugin>()
              ?.requestPermissions(
                alert: true,
                badge: true,
                sound: true,
              ) ??
          false;

      // MacOS uchun
      await _localNotification
          .resolvePlatformSpecificImplementation<
              MacOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    } else if (Platform.isAndroid) {
      // agar android bo'lsa shu kodni yozamiz.
      final androidImplemention =
          _localNotification.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      // va bu yerga darhol xabarnomasiga ruxsat so'raymiz.
      final bool? grantedNotificationPermisson =
          await androidImplemention?.requestExactAlarmsPermission();

      // bu yerda esa rejali xabarnomaga ruxsat so'raymiz.
      final bool? grantedScheduledNotificationPermisson =
          await androidImplemention?.requestExactAlarmsPermission();

      // bu yerda o'zgaruvchiga belgilab qo'yamiz.
      notificarionEnabled = grantedNotificationPermisson ?? false;
      notificarionEnabled = grantedScheduledNotificationPermisson ?? false;
    }
  }

  static Future<void> start() async {
    // hozirgi joylashuv (timezone) bilan vaqtni olish.
    final currentTimeZone = await FlutterTimezone.getLocalTimezone();
    tzl.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation(currentTimeZone));

    //android va IOS uchun sozlamalarni to'g'irlaymiz.
    const androidInit = AndroidInitializationSettings("mipmap/ic_launcher");
    final iosInit = DarwinInitializationSettings(
      notificationCategories: [
        DarwinNotificationCategory(
          "demoCategory",
          actions: [
            DarwinNotificationAction.plain('id_1', 'Action 1'),
            DarwinNotificationAction.plain(
              'id_2',
              'Action 2',
              options: <DarwinNotificationActionOption>{
                DarwinNotificationActionOption.destructive,
              },
            ),
            DarwinNotificationAction.plain(
              'id_3',
              'Action 3',
              options: <DarwinNotificationActionOption>{
                DarwinNotificationActionOption.foreground,
              },
            ),
          ],
          options: <DarwinNotificationCategoryOption>{
            DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
          },
        ),
      ],
    );
    final notificationInit = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    // va FlutterNotification klasiga sozlamalarni yuboramiz.
    // u esa kerakli qurilma sozlamalarini  to'g'irlaydi.
    await _localNotification.initialize(notificationInit);
  }

  static void showNotification() async {
    const androidDetails = AndroidNotificationDetails(
      'goodChannelId', 'goodChannelName',
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
      // sound: RawResourceAndroidNotificationSound('notification'),
      actions: [
        AndroidNotificationAction('id_1', "Ko'rish"),
        AndroidNotificationAction('id_1', "O'chirish"),
        AndroidNotificationAction('id_1', "O'qildi deb belgilash"),
      ],
    );

    const iosDetails = DarwinNotificationDetails(
      // sound: "notification.aiff",
      categoryIdentifier: "demoCategory",
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotification.show(
      0,
      "Pomodoro",
      "Dam olish vaqtingiz keldi.",
      notificationDetails,
    );
  }

  static Future<void> motivationNotification() async {
    await start();

    final MotivationController motivationController = MotivationController();
    final String motivationText =
        await motivationController.getRandomMotivation().toString();

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'motivationChannelId',
      'Motivation Channel',
      importance: Importance.max,
      priority: Priority.high,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final tz.TZDateTime scheduledDate = _getMotivationTime();
    await _localNotification.zonedSchedule(
      0,
      'Motivation',
      motivationText,
      scheduledDate,
      notificationDetails,
      matchDateTimeComponents: DateTimeComponents.time,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.wallClockTime,
    );
  }

  static tz.TZDateTime _getMotivationTime() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, 8);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  static Future<void> pomodoroNotification() async {
    await LocalNotificationService.start();

    await _localNotification.zonedSchedule(
      0,
      "Pomodoro",
      "Dam olish vaqtingiz bo'ldi brodar!",
      tz.TZDateTime.now(tz.local).add(const Duration(seconds: 1)),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'repeatingChannelId',
          'Repeating Notifications',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.wallClockTime,
    );
  }
}
