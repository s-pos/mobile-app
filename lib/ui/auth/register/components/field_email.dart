import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:spos/constants/dimens.dart';
import 'package:spos/stores/auth/register/register_store.dart';
import 'package:spos/utils/locale/app_localization.dart';
import 'package:spos/widgets/textfield_widget.dart';

class RegisterFieldEmail extends StatelessWidget {
  final FocusNode emailFocusNode;
  final FocusNode passwordFocusNode;

  const RegisterFieldEmail({
    required this.emailFocusNode,
    required this.passwordFocusNode,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final RegisterStore register = Provider.of<RegisterStore>(context);
    final AppLocalizations localizations = AppLocalizations.of(context);

    return Observer(
      builder: (context) => Padding(
        padding: const EdgeInsets.only(bottom: Dimens.defaultPadding),
        child: TextFieldWidget(
          errorText: localizations.translate(register.formError.email),
          icon: Icons.email,
          hint: localizations.translate("register_field_email_hint")!,
          label: localizations.translate("register_field_email_label")!,
          inputAction: TextInputAction.next,
          inputType: TextInputType.emailAddress,
          isIcon: true,
          onChanged: (value) => register.setEmail(value),
          focusNode: emailFocusNode,
          onFieldSubmitted: (value) =>
              FocusScope.of(context).requestFocus(passwordFocusNode),
        ),
      ),
    );
  }
}
