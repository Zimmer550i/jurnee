import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jurnee/controllers/user_controller.dart';
import 'package:jurnee/utils/app_colors.dart';
import 'package:jurnee/utils/custom_snackbar.dart';
import 'package:jurnee/views/base/custom_app_bar.dart';
import 'package:jurnee/views/base/custom_button.dart';
import 'package:jurnee/views/base/custom_text_field.dart';
import 'package:jurnee/views/base/profile_picture.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final user = Get.find<UserController>();
  final nameCtrl = TextEditingController();
  final locationCtrl = TextEditingController();
  final bioCtrl = TextEditingController();

  File? image;

  @override
  void initState() {
    super.initState();
    nameCtrl.text = user.userData?.name ?? "";
    locationCtrl.text = user.userData?.address ?? "";
    bioCtrl.text = user.userData?.bio ?? "";
  }

  void onSubmit() async {
    Map<String, dynamic> data = {
      "name": nameCtrl.text.trim(),
      "address": locationCtrl.text.trim(),
      "bio": bioCtrl.text.trim(),
    };

    if (image != null) {
      data["image"] = image!;
    }

    final message = await user.updateUserData(data);

    if (message == "success") {
      if (context.mounted) {
        Get.back();
      }
      customSnackBar("Profile successfully edited", isError: false);
    } else {
      customSnackBar(message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Edit Profile"),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 24),
              ProfilePicture(
                image: user.userImage,
                imageFile: image,
                size: 144,
                borderColor: AppColors.green.shade600,
                borderWidth: 2,
                isEditable: true,
                imagePickerCallback: (val) {
                  setState(() {
                    image = val;
                  });
                },
              ),
              const SizedBox(height: 24),
              CustomTextField(title: "Name", controller: nameCtrl),
              const SizedBox(height: 16),
              CustomTextField(title: "Location", controller: locationCtrl),
              const SizedBox(height: 16),
              CustomTextField(title: "Bio", controller: bioCtrl, lines: 5),
              Spacer(),
              Obx(
                () => CustomButton(
                  onTap: onSubmit,
                  isLoading: user.isLoading.value,
                  text: "Save Changes",
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
