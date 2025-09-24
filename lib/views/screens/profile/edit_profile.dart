import 'package:flutter/material.dart';
import 'package:jurnee/utils/app_colors.dart';
import 'package:jurnee/views/base/custom_app_bar.dart';
import 'package:jurnee/views/base/custom_text_field.dart';
import 'package:jurnee/views/base/profile_picture.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final nameCtrl = TextEditingController();
  final locationCtrl = TextEditingController();
  final bioCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Edit Profile"),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 24),
            ProfilePicture(
              image: "https://thispersondoesnotexist.com",
              size: 144,
              borderColor: AppColors.green.shade600,
              borderWidth: 2,
              isEditable: true,
            ),
            const SizedBox(height: 24),
            CustomTextField(title: "Name", controller: nameCtrl),
            const SizedBox(height: 16),
            CustomTextField(title: "Location", controller: locationCtrl),
            const SizedBox(height: 16),
            CustomTextField(title: "Bio", controller: bioCtrl, lines: 5),
          ],
        ),
      ),
    );
  }
}
