import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spos/constants/colors.dart';
import 'package:spos/constants/dimens.dart';
import 'package:spos/models/onboarding/onboarding_model.dart';
import 'package:spos/ui/onboard/components/page_onboard.dart';
import 'package:spos/utils/locale/app_localization.dart';
import 'package:spos/widgets/button_widget.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: AnnotatedRegion(
        value: SystemUiOverlayStyle.light,
        child: Container(
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(
                height: size.height * .15,
              ),
              SizedBox(
                height: size.height * .7,
                child: PageView.builder(
                  itemCount: items.length,
                  physics: const ClampingScrollPhysics(),
                  controller: _pageController,
                  onPageChanged: (value) => setState(
                    () => _currentPage = value,
                  ),
                  itemBuilder: (context, index) => PageOnBoardingComponent(
                    data: items[index],
                    last: items.length - 1 == index,
                  ),
                ),
              ),
              SizedBox(
                height: size.height * .1,
                child: _currentPage == items.length - 1
                    ? Center(
                        child: RoundedButtonWidget(
                          buttonColor: AppColors.primaryColor,
                          buttonText: AppLocalizations.of(context)
                              .translate("onboard_button_login"),
                          textColor: AppColors.white,
                          onPressed: () => print("masuk"),
                        ),
                      )
                    : null,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _pageIndicator(),
              )
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _pageIndicator() {
    List<Widget> pages = [];

    for (int i = 0; i < items.length; i++) {
      pages.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }

    return pages;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      margin: const EdgeInsets.symmetric(horizontal: Dimens.defaultMargin * .2),
      height: Dimens.defaultHeight * .4,
      width: isActive ? Dimens.defaultWidth * 1.5 : Dimens.defaultWidth * .4,
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.primaryColor
            : AppColors.primaryColor.withOpacity(.3),
        borderRadius: const BorderRadius.all(
          Radius.circular(Dimens.defaultRadius),
        ),
      ),
    );
  }

  List<OnBoardingModel> items = <OnBoardingModel>[
    OnBoardingModel(
      transalation: "onboard_offline_store",
      image: "assets/images/offline_store.svg",
    ),
    OnBoardingModel(
      transalation: "onboard_product_management",
      image: "assets/images/product_management.svg",
    ),
    OnBoardingModel(
      transalation: "onboard_recent_transaction",
      image: "assets/images/recent_transaction.svg",
    ),
  ];
}
