import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jurnee/controllers/user_controller.dart';
import 'package:jurnee/utils/app_colors.dart';
import 'package:jurnee/utils/app_texts.dart';
import 'package:jurnee/utils/custom_svg.dart';
import 'package:jurnee/views/base/custom_app_bar.dart';
import 'package:jurnee/views/base/custom_button.dart';
import 'package:jurnee/views/base/custom_text_field.dart';

class Support extends StatefulWidget {
  const Support({super.key});

  @override
  State<Support> createState() => _SupportState();
}

class _SupportState extends State<Support> {
  final user = Get.find<UserController>();

  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final subjectCtrl = TextEditingController();
  final descriptionCtrl = TextEditingController();
  final transactionCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameCtrl.text = user.userData?.name ?? "";
    emailCtrl.text = user.userData?.email ?? "";
  }

  void onSubmit() async {
    final message = await user.postSupport(
      nameCtrl.text,
      emailCtrl.text,
      descriptionCtrl.text,
      subjectCtrl.text,
      transactionCtrl.text,
    );
    if (message == "success") {
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (context) {
          Future.delayed(Duration(seconds: 2), () {
            if (context.mounted) {
              Get.back();
              Get.back();
            }
          });
          return Center(
            child: Dialog(
              child: Container(
                padding: EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomSvg(asset: "assets/icons/submitted.svg"),
                    const SizedBox(height: 32),
                    Text(
                      "Thanks for submitting your request We'll review it and back to you shortly",
                      textAlign: TextAlign.center,
                      style: AppTexts.txls.copyWith(
                        color: AppColors.gray.shade400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Support"),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          spacing: 16,
          children: [
            const SizedBox(height: 8),
            CustomTextField(
              title: "Name",
              hintText: "Enter your name",
              controller: nameCtrl,
            ),
            CustomTextField(
              title: "Email",
              hintText: "Enter your email",
              controller: emailCtrl,
            ),
            CustomTextField(
              title: "Subject",
              hintText: "Enter subject",
              controller: subjectCtrl,
            ),
            CustomTextField(
              controller: descriptionCtrl,
              title: "Description",
              lines: 5,
              hintText: "What went wrong",
            ),
            CustomTextField(
              controller: transactionCtrl,
              title: "Transaction ID",
              hintText: "Enter transaction ID",
            ),
            const SizedBox(height: 8),
            Obx(
              () => CustomButton(
                onTap: onSubmit,
                isLoading: user.isLoading.value,
                text: "Submit",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
