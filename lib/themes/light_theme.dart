import 'package:flutter/material.dart';
import 'package:jurnee/utils/app_colors.dart';

ThemeData light() => ThemeData(
  fontFamily: "Lato",
  scaffoldBackgroundColor: AppColors.scaffoldBG,
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.green.shade600,
    brightness: Brightness.light,
  ),
  datePickerTheme: DatePickerThemeData(
    headerBackgroundColor: AppColors.scaffoldBG,
    headerForegroundColor: Colors.black,
    backgroundColor: AppColors.scaffoldBG,
    todayForegroundColor: WidgetStatePropertyAll(AppColors.black),
    todayBackgroundColor: WidgetStatePropertyAll(AppColors.green.shade100),
    dayForegroundColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) return Colors.white;
      return null;
    }),
    dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return AppColors.green.shade600;
      }
      return null;
    }),
    yearForegroundColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) return Colors.white;
      return null;
    }),
    yearBackgroundColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return AppColors.green.shade600;
      }
      return null;
    }),
    cancelButtonStyle: ButtonStyle(
      foregroundColor: WidgetStatePropertyAll(AppColors.green.shade600),
    ),
    confirmButtonStyle: ButtonStyle(
      foregroundColor: WidgetStatePropertyAll(AppColors.green.shade600),
    ),
  ),
);
