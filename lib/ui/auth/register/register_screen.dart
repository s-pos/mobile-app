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
import 'package:spos/ui/auth/register/components/field.dart';
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
      body: Material(
        child: Stack(
          children: <Widget>[
            Observer(
              builder: (context) {
                return Visibility(
                  child: const CustomProgressIndicatorWidget(),
                  visible: _register.loading,
                );
              },
            ),
            Column(
              children: <Widget>[
                SizedBox(
                  height: size.height * .12,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Dimens.defaultPadding,
                    ),
                    child: Column(
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
                          style: textTheme.subtitle1,
                        ),
                        const SizedBox(
                          height: Dimens.defaultHeight,
                        ),
                        RegisterFieldComponent(
                          observerName: "register-form-name",
                          labelName: "register_field_name_label",
                          hintName: "register_field_name_hint",
                          errorMessage: _form.formError.name,
                          icons: Icons.account_circle_sharp,
                          textController: nameController,
                          onChanged: (value) =>
                              _form.setName(nameController.text),
                          inputType: TextInputType.name,
                          inputAction: TextInputAction.next,
                          onSubmitted: (value) => FocusScope.of(context)
                              .requestFocus(_emailFocusNode),
                        ),
                        const SizedBox(
                          height: Dimens.defaultHeight * 1.5,
                        ),
                        RegisterFieldComponent(
                          observerName: "register-form-email",
                          labelName: "register_field_email_label",
                          hintName: "register_field_email_hint",
                          errorMessage: _form.formError.email,
                          icons: Icons.email,
                          textController: emailController,
                          onChanged: (value) =>
                              _form.setEmail(emailController.text),
                          inputType: TextInputType.emailAddress,
                          inputAction: TextInputAction.next,
                          onSubmitted: (value) => FocusScope.of(context)
                              .requestFocus(_passwordFocusNode),
                        ),
                        const SizedBox(
                          height: Dimens.defaultHeight * 1.5,
                        ),
                        RegisterFieldComponent(
                          observerName: "register-form-password",
                          labelName: "register_field_password_label",
                          hintName: "register_field_password_hint",
                          errorMessage: _form.formError.password,
                          icons: Icons.password,
                          textController: passwordController,
                          onChanged: (value) =>
                              _form.setPassword(passwordController.text),
                          inputType: TextInputType.visiblePassword,
                          inputAction: TextInputAction.next,
                          onSubmitted: (value) => FocusScope.of(context)
                              .requestFocus(_phoneFocusNode),
                        ),
                        const SizedBox(
                          height: Dimens.defaultHeight * 1.5,
                        ),
                        RegisterFieldComponent(
                          observerName: "register-form-phone",
                          labelName: "register_field_phone_label",
                          hintName: "register_field_phone_hint",
                          errorMessage: _form.formError.phone,
                          icons: Icons.phone,
                          textController: phoneController,
                          onChanged: (value) =>
                              _form.setPhone(phoneController.text),
                          inputType: TextInputType.phone,
                          inputAction: TextInputAction.done,
                        ),
                        const SizedBox(
                          height: Dimens.defaultHeight * 2,
                        ),
                        RoundedButtonWidget(
                          buttonColor: _form.canRegister
                              ? AppColors.primaryColor
                              : AppColors.primaryColor.withOpacity(.5),
                          buttonText:
                              localizations.translate("register_button")!,
                          textColor: AppColors.white,
                          onPressed: _form.canRegister
                              ? () async => await doRegister()
                              : null,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
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
