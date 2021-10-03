import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spos/ui/auth/login/login_screen.dart';
import 'package:spos/ui/auth/register/register_screen.dart';
import 'package:spos/ui/auth/verification/verification_screen.dart';
import 'package:spos/ui/onboard/onboard_screen.dart';

class Routes {
  Routes._();

  static const String onBoard = "/on-boarding";
  static const String login = "/login";
  static const String register = "/register";
  static const String verificationRegister = "/v";

  static Route<dynamic> routes(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (context) => const LoginScreen());
      case register:
        return MaterialPageRoute(builder: (context) => const RegisterScreen());
      case onBoard:
        return MaterialPageRoute(
            builder: (context) => const OnBoardingScreen());
      case verificationRegister:
        final data = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (context) => VerificationScreen(
            otp: data["otp"],
            email: data["email"],
          ),
        );
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
