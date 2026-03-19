import 'package:flutter/material.dart';
import 'package:jurnee/utils/app_colors.dart';
import 'package:jurnee/utils/app_texts.dart';

Widget noData(String? message) {
  return Text(
    message ?? "No data available",
    style: AppTexts.tsmr.copyWith(color: AppColors.gray.shade400),
  );
}
