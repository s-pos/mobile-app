import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:spos/constants/colors.dart';
import 'package:spos/utils/locale/app_localization.dart';
import 'package:spos/widgets/textfield_widget.dart';

class RegisterFieldComponent extends StatelessWidget {
  final String? observerName;
  final String labelName;
  final String hintName;
  final IconData icons;
  final TextEditingController textController;
  final TextInputType? inputType;
  final TextInputAction? inputAction;
  final ValueChanged onChanged;
  final ValueChanged? onSubmitted;
  final String? errorMessage;

  const RegisterFieldComponent({
    required this.labelName,
    required this.hintName,
    required this.errorMessage,
    required this.icons,
    required this.textController,
    required this.onChanged,
    this.observerName,
    this.inputType = TextInputType.text,
    this.inputAction = TextInputAction.done,
    this.onSubmitted,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    return Observer(
      name: observerName,
      builder: (context) {
        return TextFieldWidget(
          label: localizations.translate(labelName),
          hint: localizations.translate(hintName),
          icon: Icons.email,
          iconColor: AppColors.accentColor,
          textController: textController,
          inputType: inputType,
          inputAction: TextInputAction.next,
          onChanged: onChanged,
          onFieldSubmitted: onSubmitted,
          errorText: localizations.translate(errorMessage),
        );
      },
    );
  }
}
