import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spos/constants/colors.dart';

// create custom palettes for apps
final ThemeData themeData = ThemeData(
  brightness: Brightness.light,
  primaryColor: AppColors.primaryColor,
  primaryColorBrightness: Brightness.light,
  textTheme: TextTheme(
    headline1: GoogleFonts.rubik(
      color: AppColors.primaryColor,
      fontWeight: FontWeight.bold,
      fontSize: 28.0,
      letterSpacing: 1,
    ),
    headline2: GoogleFonts.rubik(
        color: AppColors.primaryColor,
        fontWeight: FontWeight.bold,
        fontSize: 24.0,
        letterSpacing: .7),
    headline3: GoogleFonts.rubik(
      color: AppColors.primaryColor,
      fontWeight: FontWeight.bold,
      fontSize: 22.0,
    ),
    headline4: GoogleFonts.rubik(
      color: AppColors.primaryColor,
      fontWeight: FontWeight.bold,
      fontSize: 20.0,
    ),
    headline5: GoogleFonts.rubik(
      color: AppColors.primaryColor,
      fontWeight: FontWeight.bold,
      fontSize: 18.0,
    ),
    headline6: GoogleFonts.rubik(
      color: AppColors.primaryColor,
      fontWeight: FontWeight.bold,
      fontSize: 16.0,
    ),
    subtitle1: GoogleFonts.rubik(
      color: AppColors.primaryColor,
      fontWeight: FontWeight.w600,
      fontSize: 16.0,
    ),
    subtitle2: GoogleFonts.rubik(
      color: AppColors.primaryColor,
      fontWeight: FontWeight.w600,
      fontSize: 14.0,
    ),
    bodyText1: GoogleFonts.rubik(
      color: AppColors.primaryColor,
      fontWeight: FontWeight.w400,
      fontSize: 14.0,
    ),
    bodyText2: GoogleFonts.rubik(
      color: AppColors.primaryColor,
      fontWeight: FontWeight.w400,
      fontSize: 12.0,
    ),
  ),
);
