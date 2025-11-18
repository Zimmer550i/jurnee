import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jurnee/utils/app_colors.dart';
import 'package:jurnee/utils/app_texts.dart';

void customSnackBar(String message, {bool isError = true, String? title}) {
  debugPrint("${isError ? "Error " : ""}Snackbar==> $message");
  title ??= isError ? "Error Occured" : "Succeed";

  // SAFELY close an open snackbar without crashing GetX
  if (Get.isSnackbarOpen) {
    Future.microtask(() {
      if (Get.isSnackbarOpen) {
        Get.closeCurrentSnackbar();
      }
    });
  }

  Get.snackbar(
    '',
    '',
    snackPosition: SnackPosition.TOP,
    margin: const EdgeInsets.all(16),

    titleText: const SizedBox.shrink(),

    messageText: Text(
      message,
      style: AppTexts.tmdm.copyWith(color: isError ? Colors.white : null),
    ),

    backgroundColor: isError
        ? AppColors.red.withValues(alpha: 0.7)
        : AppColors.green.withValues(alpha: 0.3),

    colorText: isError ? Colors.white : null,
  );
}
