import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spos/constants/dimens.dart';
import 'package:spos/models/onboarding/onboarding_model.dart';
import 'package:spos/utils/locale/app_localization.dart';

class PageOnBoardingComponent extends StatelessWidget {
  final OnBoardingModel data;
  final bool last;

  const PageOnBoardingComponent({
    required this.data,
    required this.last,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.all(Dimens.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: Dimens.defaultHeight),
          Center(
            child: SvgPicture.asset(
              data.image,
              height: size.height * .4,
              width: size.width,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: Dimens.defaultHeight),
          Center(
            child: Text(
              AppLocalizations.of(context).translate(data.transalation)!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
        ],
      ),
    );
  }
}
