import 'package:employeeadmin/common/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppThemes {
  AppThemes._internal();

  static ThemeData primaryTheme = ThemeData(
    primarySwatch: AppColors.primarySwatch,
    appBarTheme: const AppBarTheme(
      centerTitle: false,
      elevation: 0,
      backgroundColor: AppColors.primaryColor,
    ),
  );

  static ButtonStyle primaryButton = ElevatedButton.styleFrom(
    backgroundColor: AppColors.primaryColor,
    foregroundColor: AppColors.white,
    shadowColor: Colors.transparent,
    elevation: 0,
    enableFeedback: false,
    side: const BorderSide(style: BorderStyle.none),
  );

  static ButtonStyle secondaryButton = ElevatedButton.styleFrom(
    backgroundColor: AppColors.outlinedButtonBgColor,
    foregroundColor: AppColors.primaryColor,
    shadowColor: Colors.transparent,
    elevation: 0,
    enableFeedback: false,
    side: const BorderSide(style: BorderStyle.none),
  );

  static TextStyle listTileTitle = const TextStyle(
    fontWeight: FontWeight.w500,
    color: AppColors.textHeadingColor,
  );

  static TextStyle listTileText = const TextStyle(
    color: AppColors.textColor,
    fontSize: 14,
  );

  static TextStyle listSepartorTitle = const TextStyle(
    fontWeight: FontWeight.w500,
    color: AppColors.primaryColor,
    fontSize: 16,
  );

  static InputDecoration inputDecoration(String icon, String labelText) =>
      InputDecoration(
        labelText: labelText,
        prefixIcon: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SvgPicture.asset(icon),
        ),
        contentPadding: const EdgeInsets.all(0),
        labelStyle: const TextStyle(color: AppColors.textColor),
        border: const OutlineInputBorder(),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.inputBorderColor,
            width: 1.0,
          ),
        ),
        disabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.inputBorderColor,
            width: 1.0,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.inputBorderColor,
            width: 1.0,
          ),
        ),
      );
}
