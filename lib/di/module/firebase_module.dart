import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:spos/di/constants/firebase_di_constant.dart';

/// FirebaseModule
/// this class will be all module for firebase initialize
///
///   e.g : RemoteConfig
///         FirebaseCloudMessaging
///         DynamicLink
abstract class FirebaseModule {
  // initialize firebase remote config
  static Future<RemoteConfig> provideRemoteConfig() async {
    await Firebase.initializeApp();
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
