import 'package:spos/data/firebase/remote_config_helper.dart';

class FirebaseRepository {
  final RemoteConfigHelper _remoteConfig;

  FirebaseRepository(this._remoteConfig);

  String get apiKey => _remoteConfig.apiKey;
}
