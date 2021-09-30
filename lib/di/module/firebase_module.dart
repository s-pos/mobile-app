import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:package_info/package_info.dart';
import 'package:spos/constants/api_constant.dart';
import 'package:spos/di/constants/firebase_di_constant.dart';

/// FirebaseModule
/// this class will be all module for firebase initialize
///
///   e.g : RemoteConfig
///         FirebaseCloudMessaging
///         DynamicLink
abstract class FirebaseModule {
  static Future<FirebaseApp> initFirebase() async {
    return await Firebase.initializeApp();
  }

  // initialize firebase remote config
  static Future<RemoteConfig> provideRemoteConfig(
      Future<FirebaseApp> firebaseApp) async {
    await firebaseApp; // get firebase core
    final RemoteConfig remoteConfig = RemoteConfig.instance;

    // set default config instances
    await remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: FirebaseDiConstant.fetchTimeoutDuration,
        minimumFetchInterval: FirebaseDiConstant.minimumFetchInterval,
      ),
    );

    await remoteConfig.fetchAndActivate();
    return remoteConfig;
  }
}
