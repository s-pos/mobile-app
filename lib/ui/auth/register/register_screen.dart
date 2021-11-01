import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:spos/constants/colors.dart';
import 'package:spos/constants/dimens.dart';
import 'package:spos/di/components/service_locator.dart';
import 'package:spos/di/module/navigation_module.dart';
import 'package:spos/routes/routes.dart';
import 'package:spos/stores/form/register/register_store.dart';
import 'package:spos/ui/auth/register/components/field_email.dart';
import 'package:spos/ui/auth/register/components/field_name.dart';
import 'package:spos/ui/auth/register/components/field_password.dart';
import 'package:spos/ui/auth/register/components/field_phone.dart';
import 'package:spos/utils/locale/app_localization.dart';
import 'package:spos/widgets/button_widget.dart';
import 'package:spos/widgets/progress_indicator_widget.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // navigation
  final NavigationModule navigation = getIt<NavigationModule>();

  // focus node will be here
  late FocusNode _emailFocusNode;
  late FocusNode _passwordFocusNode;
  late FocusNode _phoneFocusNode;

  // store management will be here
  late RegisterStore _register;

  @override
  void initState() {
    super.initState();
    // focus node
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    _phoneFocusNode = FocusNode();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _register = Provider.of<RegisterStore>(context);
  }

  @override
  void dispose() {
    super.dispose();

    _register.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final AppLocalizations localizations = AppLocalizations.of(context);
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                SizedBox(
                  height: size.height * .12,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Dimens.defaultPadding,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: 400),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text(
                          localizations.translate("register_title")!,
                          style: textTheme.headline3,
                        ),
                        const SizedBox(
                          height: Dimens.defaultHeight,
                        ),
                        Text(
                          localizations.translate("register_subtitle")!,
                          style: textTheme.subtitle2,
                        ),
                        const SizedBox(
                          height: Dimens.defaultHeight,
                        ),
                        RegisterFieldName(emailFocusNode: _emailFocusNode),
                        RegisterFieldEmail(
                          emailFocusNode: _emailFocusNode,
                          passwordFocusNode: _passwordFocusNode,
                        ),
                        RegisterFieldPassword(
                            passwordFocusNode: _passwordFocusNode,
                            phoneFocusNode: _phoneFocusNode),
                        RegisterFieldPhone(phoneFocusNode: _phoneFocusNode),
                        Observer(
                          builder: (context) => RoundedButtonWidget(
                            buttonColor: _register.canRegister
                                ? AppColors.primaryColor
                                : AppColors.primaryColor.withOpacity(.5),
                            buttonText:
                                localizations.translate("register_button")!,
                            textColor: AppColors.white,
                            onPressed: _register.canRegister
                                ? () async => await doRegister()
                                : null,
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: Dimens.defaultPadding * .5,
                            ),
                            child: GestureDetector(
                              onTap: () => navigation.navigateTo(Routes.login),
                              child: RichText(
                                text: TextSpan(
                                  text: localizations
                                      .translate("register_text_login")!,
                                  style: textTheme.bodyText2!.copyWith(
                                      color: AppColors.grey.withOpacity(.7)),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: localizations.translate(
                                          "register_text_login_link")!,
                                      style: textTheme.bodyText2!.copyWith(
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
                ),
              ],
            ),
            Observer(
              builder: (context) {
                return SizedBox(
                  height: size.height,
                  child: Visibility(
                    child: const CustomProgressIndicatorWidget(),
                    visible: _register.loading,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> doRegister() async {
    await _register.register(
      _register.email,
      _register.password,
      _register.phone,
      _register.name,
    );

    if (_register.success) {
      final data = {
        "email": _register.email,
      };
      navigation.navigateTo(Routes.verificationRegister, arguments: data);
    } else {
      Fluttertoast.showToast(msg: _register.errorStore.errorMessage);
    }
  }
}
