import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:spos/constants/dimens.dart';
import 'package:spos/stores/auth/register/register_store.dart';
import 'package:spos/utils/locale/app_localization.dart';
import 'package:spos/widgets/textfield_widget.dart';

class RegisterFieldName extends StatelessWidget {
  final FocusNode emailFocusNode;

  const RegisterFieldName({
    required this.emailFocusNode,
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
          errorText: localizations.translate(register.formError.name),
          icon: Icons.account_circle_rounded,
          hint: localizations.translate("register_field_name_hint")!,
          label: localizations.translate("register_field_name_label")!,
          inputAction: TextInputAction.next,
          inputType: TextInputType.name,
          isIcon: true,
          onChanged: (value) => register.setName(value),
          onFieldSubmitted: (value) =>
              FocusScope.of(context).requestFocus(emailFocusNode),
        ),
      ),
    );
  }
}
