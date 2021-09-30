import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:spos/app_config.dart';
import 'package:spos/constants/api_constant.dart';
import 'package:spos/di/components/service_locator.dart';
import 'package:spos/di/module/firebase_module.dart';
import 'package:spos/ui/my_app.dart';
import 'package:spos/utils/firebase/dynamic_links.dart';
import 'package:spos/utils/firebase/messaging.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final String env = ApiConstant.dev;
  // init all dependencies needed for the first time
  await setupLocator(env);

  // firebase messaging init background handler
  FirebaseMessaging.onBackgroundMessage(
    FirebaseMessagingUtil.backgroundMessageHandler,
  );

  // handle message clicked on notification channel
  FirebaseMessaging.onMessageOpenedApp.listen(
    FirebaseMessagingUtil.clickedMessageHandler,
  );

  // firebase init dynamic links
  await FirebaseDynamicLinksUtil.initDynamicLinks();

  // firebase messaging for set foreground notification
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  // running configuration for flavor
  var configuredApp = AppConfig(
    appTitle: ApiConstant.appDev,
    buildFavor: env,
    child: MyApp(),
  );

  return runZonedGuarded(() => runApp(configuredApp), (error, stack) {
    print(error);
    print(stack);
  });
}
