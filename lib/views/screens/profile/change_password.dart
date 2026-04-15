import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jurnee/controllers/user_controller.dart';
import 'package:jurnee/utils/custom_snackbar.dart';
import 'package:jurnee/views/base/custom_app_bar.dart';
import 'package:jurnee/views/base/custom_button.dart';
import 'package:jurnee/views/base/custom_text_field.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final user = Get.find<UserController>();
  final currentPassCtrl = TextEditingController();
  final newPassCtrl = TextEditingController();
  final confirmPassCtrl = TextEditingController();

  @override
  void dispose() {
    currentPassCtrl.dispose();
    newPassCtrl.dispose();
    confirmPassCtrl.dispose();
    super.dispose();
  }

  void onSubmit() async {
    if (currentPassCtrl.text.isEmpty ||
        newPassCtrl.text.isEmpty ||
        confirmPassCtrl.text.isEmpty) {
      customSnackBar("Please fill in all fields");
      return;
    }

    if (newPassCtrl.text != confirmPassCtrl.text) {
      customSnackBar("New password and confirm password do not match");
      return;
    }

    final message = await user.changePassword(
      currentPassCtrl.text,
      newPassCtrl.text,
      confirmPassCtrl.text,
    );

    if (message == "success") {
      if (context.mounted) {
        Get.back();
      }
      customSnackBar("Password changed successfully", isError: false);
    } else {
      customSnackBar(message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Change Password"),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 24),
                CustomTextField(
                  title: "Current Password",
                  hintText: "Enter current password",
                  isPassword: true,
                  controller: currentPassCtrl,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  title: "New Password",
                  hintText: "Enter new password",
                  isPassword: true,
                  controller: newPassCtrl,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  title: "Confirm Password",
                  hintText: "Re-enter new password",
                  isPassword: true,
                  controller: confirmPassCtrl,
                ),
                const SizedBox(height: 24),
                Obx(
                  () => CustomButton(
                    onTap: onSubmit,
                    isLoading: user.isLoading.value,
                    text: "Update Password",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
