import 'package:flutter/cupertino.dart';
import 'package:spos/ui/auth/login/login_screen.dart';
import 'package:spos/ui/onboard/onboard_screen.dart';

class Routes {
  Routes._();

  static const String onBoard = "/on-boarding";
  static const String login = "/login";

  static final routes = <String, WidgetBuilder>{
    onBoard: (BuildContext context) => const OnBoardingScreen(),
    login: (BuildContext context) => const LoginScreen(),
  };
}
