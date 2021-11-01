import 'package:flutter/material.dart';
import 'package:spos/constants/colors.dart';

class SnackbarCustom {
  static snackBar({
    required String message,
    required bool isError,
    Color defaultColor = AppColors.successColor,
    Color defaultTextColor = AppColors.white,
  }) {
    return SnackBar(
      content: Text(
        message,
        style: TextStyle(
          color: defaultTextColor,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 3),
      backgroundColor: isError ? AppColors.dangerColor : defaultColor,
    );
  }
}
