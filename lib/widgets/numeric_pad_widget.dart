import 'package:flutter/material.dart';
import 'package:spos/constants/colors.dart';
import 'package:spos/constants/dimens.dart';

class NumericPadWidget extends StatelessWidget {
  final Function(int) onNumberSelected;

  const NumericPadWidget({
    required this.onNumberSelected,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double defaultSizeHeightNumeric = size.height * .08;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final TextStyle textStyle = textTheme.headline3!;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SizedBox(
          height: defaultSizeHeightNumeric,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildNumber(1, textStyle),
              _buildNumber(2, textStyle),
              _buildNumber(3, textStyle),
            ],
          ),
        ),
        SizedBox(
          height: defaultSizeHeightNumeric,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildNumber(4, textStyle),
              _buildNumber(5, textStyle),
              _buildNumber(6, textStyle),
            ],
          ),
        ),
        SizedBox(
          height: defaultSizeHeightNumeric,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildNumber(7, textStyle),
              _buildNumber(8, textStyle),
              _buildNumber(9, textStyle),
            ],
          ),
        ),
        SizedBox(
          height: defaultSizeHeightNumeric,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildEmptySpace(),
              _buildNumber(0, textStyle),
              _buildBackSpace(textStyle.fontSize!, textStyle.color!),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNumber(int number, TextStyle textStyle) {
    return Expanded(
      child: GestureDetector(
        onTap: () => onNumberSelected(number),
        child: Padding(
          padding: const EdgeInsets.all(Dimens.defaultPadding * .5),
          child: Container(
            decoration: const BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(Dimens.defaultRadius),
              ),
            ),
            child: Center(
              child: Text(number.toString(), style: textStyle),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackSpace(double iconSize, Color iconColor) {
    return Expanded(
      child: GestureDetector(
        onTap: () => onNumberSelected(-1),
        child: Padding(
          padding: const EdgeInsets.all(Dimens.defaultPadding * .5),
          child: Container(
            decoration: const BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(Dimens.defaultRadius),
              ),
            ),
            child: Center(
              child: Icon(
                Icons.backspace,
                size: iconSize,
                color: iconColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptySpace() {
    return Expanded(
      child: Container(),
    );
  }
}
