import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:spos/constants/dimens.dart';
import 'package:spos/stores/form/login/login_store.dart';
import 'package:spos/utils/locale/app_localization.dart';
import 'package:spos/widgets/textfield_widget.dart';

class LoginFieldPassword extends StatelessWidget {
  final FocusNode passwordFocusNode;

  const LoginFieldPassword({
    required this.passwordFocusNode,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LoginStore _login = Provider.of<LoginStore>(context);
    final AppLocalizations localizations = AppLocalizations.of(context);

    return Observer(
      name: "login-form-password",
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.only(bottom: Dimens.defaultPadding),
          child: TextFieldWidget(
            label: localizations.translate("login_field_password_label"),
            hint: localizations.translate("login_field_password_hint"),
            isObscure: true,
            icon: Icons.lock,
            isIcon: true,
            inputAction: TextInputAction.done,
            inputType: TextInputType.visiblePassword,
            focusNode: passwordFocusNode,
            onChanged: (value) => _login.setPassword(value),
            errorText: localizations.translate(_login.formError.password),
          ),
        );
      },
    );
  }
}
