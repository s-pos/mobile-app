import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AppConfig extends InheritedWidget {
  final String appTitle;
  final String buildFavor;

  const AppConfig({
    required this.appTitle,
    required this.buildFavor,
    required Widget child,
    Key? key,
  }) : super(child: child, key: key);

  static AppConfig? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppConfig>();
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;
}
