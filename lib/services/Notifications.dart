

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initNotifications() async{
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('app_icon'); //nombre icono en android/app/src/main/res/drawable

  const DarwinInitializationSettings initializationSettingsIOS =
  DarwinInitializationSettings();

  const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}


///Show a notification with [title] and [body] in OS
Future<void> showNotification(String title, String body) async{

  const AndroidNotificationDetails androidPlatformChannelSpecifics =
  AndroidNotificationDetails(
      'your channel id', 'your channel name',
      importance: Importance.max, priority: Priority.max, ticker: 'ticker'
  );

  const DarwinNotificationDetails iosPlatformChannelSpecifics = DarwinNotificationDetails(
      presentAlert: true, presentBadge: true, presentSound: true
  );


  const NotificationDetails details =
  NotificationDetails(
      android: androidPlatformChannelSpecifics,
    iOS: iosPlatformChannelSpecifics
  );

  await flutterLocalNotificationsPlugin.show(
      1, title, body, details,
      payload: 'item x');
}

///Show a notification with [message] in app [context
Future<void> launchNotificationInApp(String message, BuildContext context)async {

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 4),
    ),
  );
}