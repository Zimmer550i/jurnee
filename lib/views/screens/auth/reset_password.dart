import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jurnee/controllers/auth_controller.dart';
import 'package:jurnee/utils/app_texts.dart';
import 'package:jurnee/utils/custom_snackbar.dart';
import 'package:jurnee/views/base/custom_button.dart';
import 'package:jurnee/views/base/custom_text_field.dart';
import 'package:jurnee/views/screens/auth/login.dart';
import 'package:jurnee/views/screens/home/home.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final auth = Get.find<AuthController>();
  final passCtrl = TextEditingController();
  final conPassCtrl = TextEditingController();

  void onSubmit() async {
    final message = await auth.resetPassword(passCtrl.text, conPassCtrl.text);

    if (message == "success") {
      customSnackBar("Your password has been changed", isError: false);
      if (await auth.previouslyLoggedIn()) {
        Get.offAll(() => Home(), routeName: "/app");
      } else {
        Get.offAll(Login());
      }
    } else {
      customSnackBar(message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Text("Reset Password", style: AppTexts.dxsb),
              const SizedBox(height: 24),
              CustomTextField(
                title: "New Password",
                hintText: "Create new password",
                isPassword: true,
                controller: passCtrl,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                hintText: "Re-enter new password",
                isPassword: true,
                controller: conPassCtrl,
              ),
              Spacer(),
              Obx(
                () => CustomButton(
                  onTap: onSubmit,
                  isLoading: auth.isLoading.value,
                  text: "Confirm",
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
