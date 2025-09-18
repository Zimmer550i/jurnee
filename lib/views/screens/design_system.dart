import 'package:flutter/material.dart';
import 'package:jurnee/utils/app_colors.dart';
import 'package:jurnee/views/base/custom_app_bar.dart';
import 'package:jurnee/views/base/custom_button.dart';
import 'package:jurnee/views/base/custom_text_field.dart';
import 'package:jurnee/views/base/profile_picture.dart';

class DesignSystem extends StatelessWidget {
  const DesignSystem({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Design System"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          spacing: 16,
          children: [
            ProfilePicture(
              image: "https://picsum.photos/500/500",
              isEditable: true,
            ),
            CustomTextField(
              hintText: "Search",
              leading: "assets/icons/search.svg",
              focusColor: AppColors.gray.shade900,
            ),
            CustomTextField(
              title: "Email",
              hintText: "Enter your email",
              errorText: "Email didn't match",
            ),
            CustomTextField(
              title: "Password",
              hintText: "Enter your password",
              isPassword: true,
            ),
            CustomButton(text: "Button"),
            CustomButton(text: "Button", isSecondary: true),
          ],
        ),
      ),
    );
  }
}
