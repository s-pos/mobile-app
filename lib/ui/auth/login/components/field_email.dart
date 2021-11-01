import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:spos/constants/dimens.dart';
import 'package:spos/stores/auth/login/login_store.dart';
import 'package:spos/utils/locale/app_localization.dart';
import 'package:spos/widgets/textfield_widget.dart';

class LoginFieldEmail extends StatelessWidget {
  final FocusNode passwordFocusNode;

  const LoginFieldEmail({
    required this.passwordFocusNode,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LoginStore _login = Provider.of<LoginStore>(context);
    final AppLocalizations localizations = AppLocalizations.of(context);

    return Observer(
      name: "login-form-email",
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.only(bottom: Dimens.defaultPadding),
          child: TextFieldWidget(
            label: localizations.translate("login_field_email_label"),
            hint: localizations.translate("login_field_email_hint"),
            icon: Icons.email,
            isIcon: true,
            inputType: TextInputType.emailAddress,
            inputAction: TextInputAction.next,
            onChanged: (value) => _login.setEmail(value),
            onFieldSubmitted: (value) =>
                FocusScope.of(context).requestFocus(passwordFocusNode),
            errorText: localizations.translate(_login.formError.email),
          ),
        );
      },
    );
  }
}
