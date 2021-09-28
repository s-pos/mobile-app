import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:spos/di/components/service_locator.dart';
import 'package:spos/di/module/navigation_module.dart';
import 'package:spos/models/firebase/messaging_model.dart';
import 'package:spos/routes/routes.dart';

class FirebaseMessagingUtil {
  FirebaseMessagingUtil._();

  static void getToken() {
    final messaging = FirebaseMessaging.instance;
    messaging.getToken().then((value) => print(value));
  }

  // handle foreground push notification message
  static void foregroundMessageHandler(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
    AndroidNotificationChannel channel,
  ) {
    FirebaseMessaging.onMessage.listen((message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = notification?.android;

      // for android create notification channel
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          1,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channel.description,
            ),
          ),
        );
      }
    });
  }

  // handle background firebase messaging (fcm)
  static Future<void> backgroundMessageHandler(
    RemoteMessage message,
  ) async {
    print(message);
  }

  // handle when push notification clicked
  static void clickedMessageHandler(RemoteMessage message) {
    final NavigationModule navigation = getIt<NavigationModule>();
    final FirebaseMessagingModel? data =
        FirebaseMessagingModel.fromJson(message.data);
    print("message clicked $data");
    if (data?.type == "explore") {
      navigation.navigateToAndRemove(Routes.onBoard);
    }
  }
}
