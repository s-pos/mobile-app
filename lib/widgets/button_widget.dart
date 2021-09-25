import 'package:flutter/material.dart';

class RoundedButtonWidget extends StatelessWidget {
  final String buttonText;
  final Color buttonColor;
  final Color textColor;
  final VoidCallback? onPressed;

  const RoundedButtonWidget({
    required this.buttonColor,
    required this.buttonText,
    required this.textColor,
    this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(
        buttonText,
        style:
            Theme.of(context).textTheme.subtitle1!.copyWith(color: textColor),
      ),
    );
  }
}
