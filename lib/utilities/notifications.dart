import 'package:flutter/material.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  static const channel_id = "123";

  Future<void> init() async {
    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('ic_launcher');

    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
      onDidReceiveLocalNotification: (id, title, body, payload) => null,
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS,
            macOS: null);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
  }

  Future selectNotification(String payload) async {
    //Handle notification tapped logic here
  }

  void showNotification(String message, String notificationMessage) async {
    await flutterLocalNotificationsPlugin.show(
        1,
        "Foodenie",
        notificationMessage,
        const NotificationDetails(
            android: AndroidNotificationDetails(channel_id, "Foodenie",
                'To send notifications about Food and Restaurants',
                importance: Importance.defaultImportance,
                priority: Priority.defaultPriority,
                styleInformation: BigTextStyleInformation('')
                ),
            iOS: IOSNotificationDetails(
              presentAlert: true,
              presentBadge: true,
              presentSound: true,
              sound: "",
              badgeNumber: 1,
              subtitle: "YEP",
            )),
        payload: message);
  }
}
