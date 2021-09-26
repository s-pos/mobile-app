import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:spos/constants/colors.dart';
import 'package:spos/constants/dimens.dart';
import 'package:spos/stores/form/login/form_login_store.dart';
import 'package:spos/utils/locale/app_localization.dart';
import 'package:spos/widgets/button_widget.dart';
import 'package:spos/widgets/progress_indicator_widget.dart';
import 'package:spos/widgets/textfield_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // variables
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  TextTheme? textTheme;
  Size? size;
  AppLocalizations? localizations;

  // store management
  final _formLoginStore = FormLoginStore();

  // focus node
  late FocusNode _passwordFocusNode;

  @override
  void initState() {
    super.initState();
    // set state for focus node password
    _passwordFocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();

    // reset all instance
    _emailController.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    _formLoginStore.dispose();
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
                  height: size!.height * .1,
                ),
                _build(),
              ],
            ),
            Observer(
              builder: (context) {
                return const Visibility(
                  child: CustomProgressIndicatorWidget(),
                  visible: false,
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
            _formEmail(),
            const SizedBox(
              height: Dimens.defaultHeight * 1.5,
            ),
            _formPassword(),
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
                  onTap: () => print("daftar"),
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

  Widget _formEmail() {
    return Observer(
      name: "login-form-email",
      builder: (context) {
        return TextFieldWidget(
          label: localizations?.translate("login_field_email_label"),
          hint: localizations?.translate("login_field_email_hint"),
          icon: Icons.email,
          iconColor: AppColors.accentColor,
          textController: _emailController,
          inputType: TextInputType.emailAddress,
          inputAction: TextInputAction.next,
          onChanged: (value) => _formLoginStore.setEmail(_emailController.text),
          onFieldSubmitted: (value) =>
              FocusScope.of(context).requestFocus(_passwordFocusNode),
          errorText: localizations?.translate(_formLoginStore.formError.email),
        );
      },
    );
  }

  Widget _formPassword() {
    return Observer(
      name: "login-form-password",
      builder: (context) {
        return TextFieldWidget(
          label: localizations?.translate("login_field_password_label"),
          hint: localizations?.translate("login_field_password_hint"),
          isObscure: true,
          icon: Icons.lock,
          iconColor: AppColors.accentColor,
          textController: _passwordController,
          inputAction: TextInputAction.done,
          inputType: TextInputType.visiblePassword,
          focusNode: _passwordFocusNode,
          onChanged: (value) =>
              _formLoginStore.setPassword(_passwordController.text),
          errorText:
              localizations?.translate(_formLoginStore.formError.password),
        );
      },
    );
  }

  Widget _buildButtonLogin() {
    return Observer(
      name: "login-button",
      builder: (context) {
        return _formLoginStore.canLogin
            ? RoundedButtonWidget(
                buttonColor: AppColors.primaryColor,
                buttonText: localizations!.translate("login_button")!,
                textColor: AppColors.white,
                onPressed: () => print("masuk"),
              )
            : RoundedButtonWidget(
                buttonColor: AppColors.primaryColor.withOpacity(.5),
                buttonText: localizations!.translate("login_button")!,
                textColor: AppColors.white,
              );
      },
    );
  }
}
