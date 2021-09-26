import 'package:flutter/material.dart';
import 'package:spos/constants/colors.dart';
import 'package:spos/constants/dimens.dart';

class CustomProgressIndicatorWidget extends StatelessWidget {
  const CustomProgressIndicatorWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        height: Dimens.defaultHeight * 5,
        constraints: const BoxConstraints.expand(),
        child: FittedBox(
          fit: BoxFit.none,
          child: SizedBox(
            height: Dimens.defaultHeight * 5,
            width: Dimens.defaultWidth * 5,
            child: Card(
              child: const Padding(
                padding: EdgeInsets.all(Dimens.defaultPadding),
                child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Dimens.defaultRadius),
              ),
            ),
          ),
        ),
        decoration: const BoxDecoration(
          color: Color.fromARGB(200, 105, 105, 105),
        ),
      ),
    );
  }
}
