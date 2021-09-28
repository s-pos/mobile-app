import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:spos/data/firebase/constants/remote_config_constant.dart';

class RemoteConfigHelper {
  final RemoteConfig _remoteConfig;

  RemoteConfigHelper(this._remoteConfig);

  String get apiKey => _remoteConfig.getString(RemoteConfigConstant.apiKey);
}
