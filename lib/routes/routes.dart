import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spos/ui/auth/login/login_screen.dart';
import 'package:spos/ui/onboard/onboard_screen.dart';

class Routes {
  Routes._();

  static const String onBoard = "/on-boarding";
  static const String login = "/login";

  static Route<dynamic> routes(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (context) => const LoginScreen());
      case onBoard:
        return MaterialPageRoute(
            builder: (context) => const OnBoardingScreen());
      default:
        return MaterialPageRoute(
          builder: (context) => const Scaffold(
            body: Center(
              child: Text("Halaman tidak ditemukan"),
            ),
          ),
        );
    }
  }
}
