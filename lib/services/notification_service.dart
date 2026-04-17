import 'dart:math';

import 'package:flutter/material.dart';

import '../app/app.package.export.dart';

class NotificationService {
  AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'new_walls_notifications',
    'New Content Notifications',
    description: 'This channel is used for new content notifications.',
    playSound: true,
    importance: Importance.high,
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    await Permission.notification.request();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('ic_notification');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) {
        if (notificationResponse.notificationResponseType ==
            NotificationResponseType.selectedNotification) {
          onDidReceiveLocalNotification(notificationResponse.payload ?? "");
        }
      },
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    initFirebaseListeners();
  }

  void onDidReceiveLocalNotification(String payload) {
    if (payload.isNotEmpty) {
      launch(payload);
    }
  }

  void initFirebaseListeners() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      showNotifications(message: message);
    });
  }

  Future<void> showNotifications({required RemoteMessage message}) async {
    final RemoteNotification notification = message.notification!;
    final int id = Random().nextInt(900) + 10;
    await flutterLocalNotificationsPlugin.show(
        id: id,
        title: notification.title,
        body: notification.body,
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            channelShowBadge: true,
            playSound: true,
            color: Colors.blue,
            priority: Priority.high,
            importance: Importance.high,
            styleInformation: BigTextStyleInformation(notification.body!),
          ),
        ),
        payload: message.data["link"]);
  }

  void launch(String url) =>
      launchUrl(Uri.parse(url), mode: LaunchMode.externalNonBrowserApplication);
}
