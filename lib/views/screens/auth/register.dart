import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jurnee/utils/app_colors.dart';
import 'package:jurnee/utils/app_texts.dart';
import 'package:jurnee/views/base/custom_button.dart';
import 'package:jurnee/views/base/custom_checkbox.dart';
import 'package:jurnee/views/base/custom_text_field.dart';
import 'package:jurnee/views/screens/auth/verification.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final nameCtrl = TextEditingController();
  final locationCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final conPassCtrl = TextEditingController();

  bool agreedTerms = false;

  void onSubmit() async {
    Get.to(() => Verification(email: emailCtrl.text));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                Text("Sign up", style: AppTexts.dxsb),
                const SizedBox(height: 8),
                Text(
                  "Create an account to get started ",
                  textAlign: TextAlign.start,
                  style: AppTexts.tmdr.copyWith(color: AppColors.gray.shade400),
                ),
                const SizedBox(height: 24),
                CustomTextField(
                  title: "Name",
                  hintText: "Enter your name",
                  controller: nameCtrl,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  title: "Location",
                  hintText: "Enter your location",
                  controller: locationCtrl,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  title: "Email",
                  hintText: "Enter your email",
                  controller: emailCtrl,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  title: "Password",
                  hintText: "Create a password",
                  controller: passCtrl,
                  isPassword: true,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  hintText: "Confirm password",
                  controller: conPassCtrl,
                  isPassword: true,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    CustomCheckBox(
                      value: agreedTerms,
                      size: 24,
                      activeColor: AppColors.green.shade600,
                      inactiveColor: Color(0xffe6e6e6),
                      onChanged: (val) {
                        setState(() {
                          agreedTerms = val;
                        });
                      },
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          text: "I've read and agree with the ",
                          style: AppTexts.txsr.copyWith(
                            color: Color(0xff808080),
                          ),
                          children: [
                            TextSpan(
                              text: "Terms and Conditions",
                              style: AppTexts.txsb.copyWith(
                                color: AppColors.green.shade600,
                              ),
                            ),
                            TextSpan(text: " and the "),
                            TextSpan(
                              text: "Privacy Policy",
                              style: AppTexts.txsb.copyWith(
                                color: AppColors.green.shade600,
                              ),
                            ),
                            TextSpan(text: "."),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                CustomButton(onTap: onSubmit, text: "Register"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
