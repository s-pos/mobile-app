import 'dart:async';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:spos/constants/colors.dart';
import 'package:spos/constants/dimens.dart';
import 'package:spos/data/repository/auth.dart';
import 'package:spos/di/components/service_locator.dart';
import 'package:spos/di/module/navigation_module.dart';
import 'package:spos/routes/routes.dart';
import 'package:spos/stores/auth/register/register_store.dart';
import 'package:spos/stores/auth/verification/verification_store.dart';
import 'package:spos/utils/locale/app_localization.dart';
import 'package:spos/widgets/button_widget.dart';
import 'package:spos/widgets/numeric_pad_widget.dart';

class VerificationScreen extends StatefulWidget {
  final String? otp;
  final String email;
  final String? password;
  final String? name;
  final String? phone;

  const VerificationScreen({
    required this.email,
    this.otp,
    this.phone,
    this.name,
    this.password,
    Key? key,
  }) : super(key: key);

  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  // navigation
  final NavigationModule navigation = getIt<NavigationModule>();

  // variables
  late Timer time;
  int start = 120;
  String startString = "02:00";
  bool wait = true;

  // store
  late VerificationStore _verification;
  late RegisterStore _register;

  @override
  void initState() {
    super.initState();

    _verification = VerificationStore(getIt<RepositoryAuth>(), widget.email);

    // start timer countdown
    startTimer();

    if (widget.otp != null) {
      // doing verification here for dynamic links
      _verification.setOtp(widget.otp!);
    }
  }

  @override
  void dispose() {
    super.dispose();
    time.cancel();

    _verification.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _register = Provider.of<RegisterStore>(context);
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        leading: GestureDetector(
          onTap: () => navigation.goBack(),
          child: const Icon(
            Icons.arrow_back,
            size: 25,
            color: AppColors.primaryColor,
          ),
        ),
        title: Text(
          localizations.translate("verification_code_scaffold")!,
          style: textTheme.headline4,
        ),
        elevation: 2,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: Container(
                color: AppColors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(
                      height: Dimens.defaultHeight * 2,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: Dimens.defaultPadding * .7,
                      ),
                      child: Text(
                        localizations.translate("verification_code_title")!,
                        style: textTheme.headline4,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: Dimens.defaultPadding * .5,
                        horizontal: Dimens.defaultPadding * 1.5,
                      ),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: localizations
                              .translate("verification_code_subtitle")!,
                          style: textTheme.bodyText1,
                          children: [
                            TextSpan(
                              text: widget.email,
                              style: textTheme.subtitle2,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          _buildCodeNumberBox(
                            _verification.otp.isNotEmpty
                                ? _verification.otp.substring(0, 1)
                                : "",
                          ),
                          _buildCodeNumberBox(
                            _verification.otp.length > 1
                                ? _verification.otp.substring(1, 2)
                                : "",
                          ),
                          _buildCodeNumberBox(
                            _verification.otp.length > 2
                                ? _verification.otp.substring(2, 3)
                                : "",
                          ),
                          _buildCodeNumberBox(
                            _verification.otp.length > 3
                                ? _verification.otp.substring(3, 4)
                                : "",
                          ),
                          _buildCodeNumberBox(
                            _verification.otp.length > 4
                                ? _verification.otp.substring(4, 5)
                                : "",
                          ),
                          _buildCodeNumberBox(
                            _verification.otp.length > 5
                                ? _verification.otp.substring(5, 6)
                                : "",
                          ),
                        ],
                      ),
                    ),
                    wait ? _countDown() : _textResendCode(),
                  ],
                ),
              ),
            ),
            _buttonVerification(),
            NumericPadWidget(
              onNumberSelected: (value) => setState(
                () => _verification.setOtp(value.toString()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buttonVerification() {
    final AppLocalizations localizations = AppLocalizations.of(context);

    return SizedBox(
      height: MediaQuery.of(context).size.height * .09,
      child: Padding(
        padding: const EdgeInsets.all(Dimens.defaultPadding),
        child: Observer(
          builder: (context) => RoundedButtonWidget(
            isLoading: _verification.loading,
            buttonColor: _verification.canVerification
                ? AppColors.primaryColor
                : AppColors.primaryColor.withOpacity(.5),
            buttonText: localizations.translate("verification_code_button")!,
            textColor: AppColors.white,
            onPressed: _verification.canVerification ? () => doRequest() : null,
          ),
        ),
      ),
    );
  }

  Widget _buildCodeNumberBox(String codeNumber) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimens.defaultPadding * .4,
      ),
      child: SizedBox(
        height: Dimens.defaultHeight * 2,
        width: Dimens.defaultWidth * 2,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: const BorderRadius.all(
              Radius.circular(Dimens.defaultRadius),
            ),
            border: Border.all(color: AppColors.grey),
          ),
          child: Center(
            child: Text(
              codeNumber,
              style: Theme.of(context).textTheme.headline3,
            ),
          ),
        ),
      ),
    );
  }

  Widget _countDown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimens.defaultPadding),
      child: RichText(
        text: TextSpan(
          text: AppLocalizations.of(context)
              .translate("verification_resend_code_wait"),
          style: Theme.of(context)
              .textTheme
              .bodyText1!
              .copyWith(color: AppColors.grey),
          children: <TextSpan>[
            TextSpan(
              text: startString,
              style: Theme.of(context).textTheme.subtitle2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _textResendCode() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimens.defaultPadding),
      child: RichText(
        text: TextSpan(
          text: AppLocalizations.of(context)
              .translate("verification_resend_code"),
          style: Theme.of(context)
              .textTheme
              .bodyText1!
              .copyWith(color: AppColors.grey),
          children: [
            TextSpan(
              text: AppLocalizations.of(context)
                  .translate("verification_resend_code_link"),
              style: Theme.of(context).textTheme.subtitle2,
              recognizer: TapGestureRecognizer()
                ..onTap = () => print('Tap Here onTap'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> doRequest() async {
    await _verification.otpRegister(widget.email, _verification.otp);

    if (_verification.success) {
      Fluttertoast.showToast(
          msg: _verification.res!.data!, gravity: ToastGravity.TOP);
      navigation.navigateTo(Routes.login);
    } else {
      Fluttertoast.showToast(
        msg: _verification.errorStore.errorMessage,
        gravity: ToastGravity.TOP,
      );
    }
  }

  void startTimer() {
    const sec = Duration(seconds: 1);
    time = Timer.periodic(sec, (timer) {
      if (start == 0) {
        setState(() {
          timer.cancel();
          wait = false;
        });
      } else {
        setState(() {
          start--;
          if (start >= 60) {
            int s = start % 60;
            if (s < 10) {
              startString = "01:0${s.toString()}";
            } else {
              startString = "01:${s.toString()}";
            }
          } else {
            if (start < 10) {
              startString = "00:0${start.toString()}";
            } else {
              startString = "00:${start.toString()}";
            }
          }
        });
      }
    });
  }
}
