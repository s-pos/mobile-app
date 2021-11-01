import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:spos/constants/colors.dart';
import 'package:spos/constants/dimens.dart';
import 'package:spos/constants/snackbar.dart';
import 'package:spos/di/components/service_locator.dart';
import 'package:spos/di/module/navigation_module.dart';
import 'package:spos/routes/routes.dart';
import 'package:spos/stores/auth/login/login_store.dart';
import 'package:spos/ui/auth/login/components/field_email.dart';
import 'package:spos/ui/auth/login/components/field_password.dart';
import 'package:spos/utils/firebase/messaging.dart';
import 'package:spos/utils/locale/app_localization.dart';
import 'package:spos/widgets/button_widget.dart';
import 'package:spos/widgets/progress_indicator_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // variables
  TextTheme? textTheme;
  Size? size;
  AppLocalizations? localizations;

  // navigation
  final NavigationModule navigation = getIt<NavigationModule>();

  // store management
  late LoginStore _login;

  // focus node
  late FocusNode _passwordFocusNode;

  @override
  void initState() {
    super.initState();
    // set state for focus node password
    _passwordFocusNode = FocusNode();
    FirebaseMessagingUtil.getToken();
    FirebaseMessagingUtil.foregroundMessageHandler(
      getIt<FlutterLocalNotificationsPlugin>(),
      getIt<AndroidNotificationChannel>(),
    );
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    _login = Provider.of<LoginStore>(context);
  }

  @override
  void dispose() {
    super.dispose();

    // reset all instance
    _login.dispose();
  }

  @override
  Widget build(BuildContext context) {
    textTheme = Theme.of(context).textTheme;
    size = MediaQuery.of(context).size;
    localizations = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Material(
        child: Stack(
          children: <Widget>[
            Column(
              children: [
                SizedBox(
                  height: size!.height * .12,
                ),
                _build(),
              ],
            ),
            Observer(
              builder: (context) {
                return Visibility(
                  child: const CustomProgressIndicatorWidget(),
                  visible: _login.loading,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _build() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimens.defaultPadding),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              localizations!.translate("login_title")!,
              style: textTheme?.subtitle1,
            ),
            const SizedBox(
              height: Dimens.defaultHeight * 1.5,
            ),
            LoginFieldEmail(passwordFocusNode: _passwordFocusNode),
            LoginFieldPassword(passwordFocusNode: _passwordFocusNode),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: Dimens.defaultPadding * .5),
                  child: GestureDetector(
                    child: Text(
                      localizations!.translate("login_text_forgot_password")!,
                      style: textTheme?.bodyText2,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: Dimens.defaultHeight * .7,
            ),
            _buildButtonLogin(),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: Dimens.defaultPadding * .5,
                ),
                child: GestureDetector(
                  onTap: () => navigation.navigateTo(Routes.register),
                  child: RichText(
                    text: TextSpan(
                      text: localizations?.translate("login_text_register"),
                      style: textTheme?.bodyText2!
                          .copyWith(color: AppColors.grey.withOpacity(.7)),
                      children: <TextSpan>[
                        TextSpan(
                          text: localizations
                              ?.translate("login_text_register_link"),
                          style: textTheme?.bodyText2!.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildButtonLogin() {
    return Observer(
      name: "login-button",
      builder: (context) {
        return RoundedButtonWidget(
          buttonColor: _login.canLogin
              ? AppColors.primaryColor
              : AppColors.primaryColor.withOpacity(.5),
          buttonText: localizations!.translate("login_button")!,
          textColor: AppColors.white,
          onPressed: _login.canLogin ? () => doLogin() : null,
        );
      },
    );
  }

  void doLogin() async {
    await _login.doLogin(_login.email, _login.password);

    if (_login.success) {
      final snackBar = SnackbarCustom.snackBar(
          message: "Token mu adalah ${_login.token}", isError: false);

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      final snackBar = SnackbarCustom.snackBar(
          message: "${_login.token} ${_login.errorStore.errorMessage}",
          isError: true);

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
