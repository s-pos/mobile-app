import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:spos/constants/dimens.dart';
import 'package:spos/stores/auth/register/register_store.dart';
import 'package:spos/utils/locale/app_localization.dart';
import 'package:spos/widgets/textfield_widget.dart';

class RegisterFieldPassword extends StatelessWidget {
  final FocusNode passwordFocusNode;
  final FocusNode phoneFocusNode;

  const RegisterFieldPassword({
    required this.passwordFocusNode,
    required this.phoneFocusNode,
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
          errorText: localizations.translate(register.formError.password),
          icon: Icons.lock,
          hint: localizations.translate("register_field_password_hint")!,
          label: localizations.translate("register_field_password_label")!,
          inputAction: TextInputAction.next,
          inputType: TextInputType.visiblePassword,
          isObscure: true,
          isIcon: true,
          onChanged: (value) => register.setPassword(value),
          focusNode: passwordFocusNode,
          onFieldSubmitted: (value) =>
              FocusScope.of(context).requestFocus(phoneFocusNode),
        ),
      ),
    );
  }
}
