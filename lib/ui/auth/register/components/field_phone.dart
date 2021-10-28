import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:spos/constants/dimens.dart';
import 'package:spos/stores/form/register/register_store.dart';
import 'package:spos/utils/locale/app_localization.dart';
import 'package:spos/widgets/textfield_widget.dart';

class RegisterFieldPhone extends StatelessWidget {
  final FocusNode phoneFocusNode;

  const RegisterFieldPhone({
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
          errorText: localizations.translate(register.formError.phone),
          icon: Icons.phone,
          hint: localizations.translate("register_field_phone_hint")!,
          label: localizations.translate("register_field_phone_label")!,
          inputAction: TextInputAction.done,
          inputType: TextInputType.phone,
          isIcon: true,
          focusNode: phoneFocusNode,
          onChanged: (value) => register.setPhone(value),
        ),
      ),
    );
  }
}
