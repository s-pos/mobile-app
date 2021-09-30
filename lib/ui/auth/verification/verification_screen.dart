import 'package:another_flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';

class VerificationScreen extends StatefulWidget {
  final String? registerMessage;
  final String? tokenEmail;

  const VerificationScreen({
    this.registerMessage,
    this.tokenEmail,
    Key? key,
  }) : super(key: key);

  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  @override
  void initState() {
    super.initState();

    if (widget.registerMessage != null) {
      FlushbarHelper.createSuccess(
        message: widget.registerMessage!,
        duration: const Duration(seconds: 3),
      );
    }

    if (widget.tokenEmail != null) {
      // doing verification here for dynamic links
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
    );
  }
}
