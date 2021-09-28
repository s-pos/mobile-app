import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spos/di/constants/notification_di_constant.dart';

abstract class LocalModule {
  // singleton shared preferences
  static Future<SharedPreferences> provideSharedPreferences() {
    return SharedPreferences.getInstance();
  }

  // singleton android notification channel
  static AndroidNotificationChannel provideAndroidNotificationChannel() {
    return const AndroidNotificationChannel(
      NotificationDiConstant.channelId,
      NotificationDiConstant.channelName,
      NotificationDiConstant.channelDesc,
      importance: Importance.high,
    );
  }

  // singleton flutter local notification default
  static Future<FlutterLocalNotificationsPlugin>
      provideLocalNotificationsPlugin(
          AndroidNotificationChannel channel) async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    var initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/launcher_icon');
    var initializationSettingsIOS = const IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    return flutterLocalNotificationsPlugin;
  }
}
