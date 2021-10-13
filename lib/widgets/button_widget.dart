import 'package:flutter/material.dart';
import 'package:spos/constants/colors.dart';
import 'package:spos/constants/dimens.dart';

class RoundedButtonWidget extends StatelessWidget {
  final String buttonText;
  final Color buttonColor;
  final Color textColor;
  final VoidCallback? onPressed;
  final bool isLoading;

  const RoundedButtonWidget({
    required this.buttonColor,
    required this.buttonText,
    required this.textColor,
    this.onPressed,
    this.isLoading = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: Dimens.defaultHeight * 2,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(buttonColor),
          shape: MaterialStateProperty.all(const StadiumBorder()),
          animationDuration: const Duration(milliseconds: 700),
        ),
        child: isLoading
            ? Container(
                padding: const EdgeInsets.all(Dimens.defaultPadding * .3),
                width: Dimens.defaultWidth * 1.5,
                height: Dimens.defaultWidth * 1.5,
                child: CircularProgressIndicator(
                  color: textColor,
                  strokeWidth: 3,
                ),
              )
            : Text(
                buttonText,
                style: Theme.of(context)
                    .textTheme
                    .subtitle1!
                    .copyWith(color: textColor),
              ),
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
    return SizedBox(
      width: double.infinity,
      height: Dimens.defaultHeight * 2,
      child: OutlinedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          side: MaterialStateProperty.all(
            BorderSide(color: buttonColor, width: 1.5),
          ),
          shape: MaterialStateProperty.all(const StadiumBorder()),
          animationDuration: const Duration(milliseconds: 700),
        ),
        child: Text(
          buttonText,
          style:
              Theme.of(context).textTheme.subtitle1!.copyWith(color: textColor),
        ),
      ),
    );
  }
}
