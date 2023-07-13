import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationUtils {
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> initNotifications() async {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosInitializationSettings =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: androidInitializationSettings,
            iOS: iosInitializationSettings);

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static Future<void> showProgressNotification({
    required int taskId,
    required double progress,
  }) async {
    const int maxProgress = 100;

    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      taskId.toString(), //channel id
      'Showing channel', //channel name
      channelDescription: 'channel description',
      importance: Importance.high,
      priority: Priority.high,
      showProgress: true,
      playSound: true,
      enableVibration: false,
      maxProgress: maxProgress,
      onlyAlertOnce: true, //play sound on start done
      progress: progress.toInt(),
      ongoing: false, // Make the notification ongoing to prevent dismissal
      sound: const RawResourceAndroidNotificationSound(
          ''), // Set sound to an empty string
    );

    const DarwinNotificationDetails iosPlatformChannelSpecifics =
        DarwinNotificationDetails(
      presentSound: false,
      presentBadge: false,
      presentAlert: false,
    );

    final NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iosPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.show(
      taskId,
      'Download in progress',
      'Download progress: ${progress.toStringAsFixed(2)}%',
      platformChannelSpecifics,
    );
  }

  static Future<void> cancelNotification(int taskId) async {
    debugPrint('cance id $taskId');
    await _flutterLocalNotificationsPlugin.cancel(taskId);
  }
}
