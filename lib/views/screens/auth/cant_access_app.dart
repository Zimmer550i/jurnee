import 'dart:io';

import 'package:flutter/material.dart';
import 'package:jurnee/utils/app_colors.dart';
import 'package:jurnee/utils/app_texts.dart';
import 'package:jurnee/utils/custom_snackbar.dart';
import 'package:jurnee/views/base/custom_button.dart';
import 'package:jurnee/views/base/custom_drop_down.dart';
import 'package:jurnee/views/base/custom_text_field.dart';

class CantAccessApp extends StatefulWidget {
  const CantAccessApp({super.key});

  @override
  State<CantAccessApp> createState() => _CantAccessAppState();
}

class _CantAccessAppState extends State<CantAccessApp> {
  final emailCtrl = TextEditingController();
  String? selectedText;
  bool sentInformation = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            children: [
              Text(
                "Jurnee is currently being tested in California.",
                style: AppTexts.dxsb,
              ),
              const SizedBox(height: 8),
              Text(
                "Join the waitlist to be notified when we go live in your area.",
                style: AppTexts.tmdr.copyWith(color: AppColors.gray.shade400),
              ),
              const SizedBox(height: 24),
              CustomTextField(
                title: "Email",
                hintText: "Enter your email",
                controller: emailCtrl,
              ),
              const SizedBox(height: 16),
              CustomDropDown(
                title: "What will you use Jurnee for?",
                options: ["Events", "Deal", "Services", "Alerts"],
                onChanged: (val) {
                  setState(() {
                    selectedText = val;
                  });
                },
              ),
              Spacer(),
              CustomButton(
                onTap: () {
                  if (sentInformation) {
                    exit(0);
                  }

                  customSnackBar(
                    "We will let you know once Jurnee is available at your Location",
                    isError: false,
                  );
                  setState(() {
                    sentInformation = !sentInformation;
                  });
                },
                text: sentInformation ? "Exit" : "Submit",
                isSecondary: sentInformation,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
