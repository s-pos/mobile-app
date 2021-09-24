import 'package:flutter/cupertino.dart';

class Routes {
  Routes._();

  static const String onBoard = "/on-boarding";
  static const String login = "/login";

  static final routes = <String, WidgetBuilder>{
    onBoard: (BuildContext context) => const OnBoardingScreen(),
    login: (BuildContext context) => const LoginScreen(),
  };
}
