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
    final Size size = MediaQuery.of(context).size;

    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(buttonColor),
        shape: MaterialStateProperty.all(const StadiumBorder()),
        animationDuration: const Duration(milliseconds: 700),
        padding: MaterialStateProperty.all(
          EdgeInsets.symmetric(
            vertical: size.width * .03,
            horizontal: size.width * .25,
          ),
        ),
      ),
      child: Text(
        buttonText,
        style:
            Theme.of(context).textTheme.subtitle1!.copyWith(color: textColor),
      ),
    );
  }
}

class OutlinedButtonWidget extends StatelessWidget {
  final String buttonText;
  final Color buttonColor;
  final Color textColor;
  final VoidCallback? onPressed;

  const OutlinedButtonWidget({
    required this.buttonColor,
    required this.buttonText,
    required this.textColor,
    this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return OutlinedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        side: MaterialStateProperty.all(
          BorderSide(
            color: buttonColor,
          ),
        ),
        shape: MaterialStateProperty.all(const StadiumBorder()),
        animationDuration: const Duration(milliseconds: 700),
        padding: MaterialStateProperty.all(
          EdgeInsets.symmetric(
            vertical: size.width * .03,
            horizontal: size.width * .25,
          ),
        ),
      ),
      child: Text(
        buttonText,
        style:
            Theme.of(context).textTheme.bodyText1!.copyWith(color: textColor),
      ),
    );
  }
}
