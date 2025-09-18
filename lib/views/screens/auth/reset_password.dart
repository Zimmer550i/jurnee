import 'package:flutter/material.dart';
import 'package:jurnee/utils/app_texts.dart';
import 'package:jurnee/views/base/custom_button.dart';
import 'package:jurnee/views/base/custom_text_field.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final passCtrl = TextEditingController();
  final conPassCtrl = TextEditingController();

  void onSubmit() async {}

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
              CustomButton(onTap: onSubmit, text: "Confirm"),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
