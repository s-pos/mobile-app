import 'package:flutter/material.dart';
import 'package:spos/app_config.dart';
import 'package:spos/constants/api_constant.dart';
import 'package:spos/di/components/service_locator.dart';
import 'package:spos/ui/my_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final String env = ApiConstant.dev;
  await setupLocator(env);

  var configuredApp = AppConfig(
    appTitle: ApiConstant.appDev,
    buildFavor: env,
    child: MyApp(),
  );

  runApp(configuredApp);
}
