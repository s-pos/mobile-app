import 'package:flutter/material.dart';
import 'package:spos/app_config.dart';
import 'package:spos/constants/api_constant.dart';
import 'package:spos/ui/my_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var configuredApp = const AppConfig(
    appTitle: ApiConstant.appDev,
    buildFavor: ApiConstant.dev,
    child: MyApp(),
  );

  runApp(configuredApp);
}
