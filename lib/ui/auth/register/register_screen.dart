import 'package:another_flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:spos/constants/colors.dart';
import 'package:spos/constants/dimens.dart';
import 'package:spos/data/repository/auth.dart';
import 'package:spos/di/components/service_locator.dart';
import 'package:spos/di/module/navigation_module.dart';
import 'package:spos/models/auth/register_model.dart';
import 'package:spos/routes/routes.dart';
import 'package:spos/stores/auth/register_store.dart';
import 'package:spos/stores/form/register/form_register_store.dart';
import 'package:spos/utils/locale/app_localization.dart';
import 'package:spos/widgets/button_widget.dart';
import 'package:spos/widgets/progress_indicator_widget.dart';
import 'package:spos/widgets/textfield_widget.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // navigation
  final NavigationModule navigation = getIt<NavigationModule>();

  // list text controller will be here
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  // focus node will be here
  late FocusNode _emailFocusNode;
  late FocusNode _passwordFocusNode;
  late FocusNode _phoneFocusNode;

  // store management will be here
  late RegisterStore _register;
  final FormRegisterStore _form = FormRegisterStore();

  @override
  void initState() {
    super.initState();
    // init store
    _register = RegisterStore(getIt<RepositoryAuth>());
    // focus node
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    _phoneFocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();

    _register.dispose();
    _form.dispose();
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    phoneController.dispose();
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
                        _formName(),
                        const SizedBox(
                          height: Dimens.defaultHeight * 1.5,
                        ),
                        _formEmail(),
                        const SizedBox(
                          height: Dimens.defaultHeight * 1.5,
                        ),
                        _formPassword(),
                        const SizedBox(
                          height: Dimens.defaultHeight * 1.5,
                        ),
                        _formPhone(),
                        const SizedBox(
                          height: Dimens.defaultHeight * 2,
                        ),
                        Observer(
                          builder: (context) => RoundedButtonWidget(
                            buttonColor: _form.canRegister
                                ? AppColors.primaryColor
                                : AppColors.primaryColor.withOpacity(.5),
                            buttonText:
                                localizations.translate("register_button")!,
                            textColor: AppColors.white,
                            onPressed: _form.canRegister
                                // ? () async => await doRegister()
                                ? () => navigation.navigateTo(
                                      Routes.verificationRegister,
                                      arguments: {
                                        "email": _form.email,
                                        "password": _form.password,
                                        "phone": _form.phone,
                                        "name": _form.name,
                                      },
                                    )
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
                  height: 600,
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

  Widget _formName() {
    final localizations = AppLocalizations.of(context);
    return Observer(
      name: "form-register-name",
      builder: (context) => TextFieldWidget(
        errorText: localizations.translate(_form.formError.name),
        icon: Icons.account_circle_rounded,
        textController: nameController,
        hint: localizations.translate("register_field_name_hint")!,
        label: localizations.translate("register_field_name_label")!,
        inputAction: TextInputAction.next,
        inputType: TextInputType.name,
        isIcon: true,
        onChanged: (value) => _form.setName(value),
        onFieldSubmitted: (value) =>
            FocusScope.of(context).requestFocus(_emailFocusNode),
      ),
    );
  }

  Widget _formEmail() {
    final localizations = AppLocalizations.of(context);
    return Observer(
      name: "form-register-email",
      builder: (context) => TextFieldWidget(
        errorText: localizations.translate(_form.formError.email),
        icon: Icons.email,
        textController: emailController,
        hint: localizations.translate("register_field_email_hint")!,
        label: localizations.translate("register_field_email_label")!,
        inputAction: TextInputAction.next,
        inputType: TextInputType.emailAddress,
        isIcon: true,
        onChanged: (value) => _form.setEmail(value),
        focusNode: _emailFocusNode,
        onFieldSubmitted: (value) =>
            FocusScope.of(context).requestFocus(_passwordFocusNode),
      ),
    );
  }

  Widget _formPassword() {
    final localizations = AppLocalizations.of(context);
    return Observer(
      name: "form-register-password",
      builder: (context) => TextFieldWidget(
        errorText: localizations.translate(_form.formError.password),
        icon: Icons.lock,
        textController: passwordController,
        hint: localizations.translate("register_field_password_hint")!,
        label: localizations.translate("register_field_password_label")!,
        inputAction: TextInputAction.next,
        inputType: TextInputType.visiblePassword,
        isObscure: true,
        isIcon: true,
        onChanged: (value) => _form.setPassword(value),
        focusNode: _passwordFocusNode,
        onFieldSubmitted: (value) =>
            FocusScope.of(context).requestFocus(_phoneFocusNode),
      ),
    );
  }

  Widget _formPhone() {
    final localizations = AppLocalizations.of(context);
    return Observer(
      name: "form-register-phone",
      builder: (context) => TextFieldWidget(
        errorText: localizations.translate(_form.formError.phone),
        icon: Icons.phone,
        textController: phoneController,
        hint: localizations.translate("register_field_phone_hint")!,
        label: localizations.translate("register_field_phone_label")!,
        inputAction: TextInputAction.done,
        inputType: TextInputType.phone,
        isIcon: true,
        focusNode: _phoneFocusNode,
        onChanged: (value) => _form.setPhone(value),
      ),
    );
  }

  Future<void> doRegister() async {
    final RegisterModel? res = await _register.register(
      emailController.text,
      passwordController.text,
      phoneController.text,
      nameController.text,
    );

    if (_register.success) {
      final data = {
        "registerMessage": res?.data,
      };
      navigation.navigateTo(Routes.verificationRegister, arguments: data);
    } else {
      FlushbarHelper.createError(message: _register.errorStore.errorMessage);
    }
  }
}
