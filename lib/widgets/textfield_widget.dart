import 'package:flutter/material.dart';
import 'package:spos/constants/colors.dart';
import 'package:spos/constants/colors.dart';
import 'package:spos/constants/dimens.dart';

class TextFieldWidget extends StatelessWidget {
  final IconData icon;
  final String? label;
  final String? hint;
  final String? errorText;
  final bool isObscure;
  final bool isIcon;
  final TextInputType? inputType;
  final TextEditingController? textController;
  final EdgeInsets padding;
  final Color labelColor;
  final Color hintColor;
  final Color iconColor;
  final FocusNode? focusNode;
  final ValueChanged? onFieldSubmitted;
  final ValueChanged? onChanged;
  final bool autoFocus;
  final TextInputAction? inputAction;

  const TextFieldWidget({
    required this.icon,
    required this.errorText,
    this.textController,
    this.inputType,
    this.label,
    this.hint,
    this.isObscure = false,
    this.isIcon = false,
    this.padding = const EdgeInsets.all(0.0),
    this.labelColor = AppColors.grey,
    this.hintColor = AppColors.grey,
    this.iconColor = AppColors.primaryColor,
    this.focusNode,
    this.onFieldSubmitted,
    this.onChanged,
    this.autoFocus = false,
    this.inputAction,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: padding,
      child: TextFormField(
        controller: textController,
        focusNode: focusNode,
        onChanged: onChanged,
        onFieldSubmitted: onFieldSubmitted,
        autofocus: autoFocus,
        textInputAction: inputAction,
        obscureText: isObscure,
        keyboardType: inputType,
        style: textTheme.bodyText1,
        decoration: InputDecoration(
          label: label == null ? null : Text(label!),
          border: OutlineInputBorder(
            borderSide: const BorderSide(),
            borderRadius: BorderRadius.circular(Dimens.defaultRadius),
          ),
          labelStyle: textTheme.subtitle1!
              .copyWith(color: AppColors.primaryColor.withOpacity(.6)),
          hintText: hint,
          hintStyle: textTheme.bodyText1!
              .copyWith(color: AppColors.grey.withOpacity(.5)),
          errorText: errorText,
          icon: isIcon
              ? Icon(
                  icon,
                  color: iconColor,
                )
              : null,
        ),
      ),
    );
  }
}
