import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jurnee/controllers/auth_controller.dart';
import 'package:jurnee/utils/app_colors.dart';
import 'package:jurnee/utils/app_texts.dart';
import 'package:jurnee/utils/custom_snackbar.dart';
import 'package:jurnee/views/base/custom_button.dart';
import 'package:jurnee/views/base/custom_text_field.dart';
import 'package:jurnee/views/screens/auth/verification.dart';

class ForgotPassword extends StatefulWidget {
  final String? email;
  const ForgotPassword({super.key, this.email});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final auth = Get.find<AuthController>();
  final emailCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    emailCtrl.text = widget.email ?? "";
  }

  void onSubmit() async {
    final message = await auth.forgetPassword(emailCtrl.text);

    if (message == "success") {
      customSnackBar(
        "An OTP has been send to ${emailCtrl.text}",
        isError: false,
      );
      Get.to(
        () => Verification(email: emailCtrl.text, isResettingPassword: true),
      );
    } else {
      customSnackBar(message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Text("Forgot Password?", style: AppTexts.dxsb),
              const SizedBox(height: 8),
              Text(
                "Please enter your email to reset your passord",
                textAlign: TextAlign.start,
                style: AppTexts.tmdr.copyWith(color: AppColors.gray.shade400),
              ),
              const SizedBox(height: 24),
              CustomTextField(
                title: "Email",
                hintText: "Enter your email",
                controller: emailCtrl,
              ),
              Spacer(),
              Obx(
                () => CustomButton(
                  onTap: onSubmit,
                  isLoading: auth.isLoading.value,
                  text: "Send OTP",
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
