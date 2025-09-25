import 'dart:io';
import 'package:flutter/material.dart';
import 'package:jurnee/views/base/custom_app_bar.dart';
import 'package:jurnee/views/base/custom_button.dart';
import 'package:jurnee/views/base/custom_drop_down.dart';
import 'package:jurnee/views/base/custom_text_field.dart';
import 'package:jurnee/views/screens/post/post_base_widget.dart';

class PostAlert extends StatefulWidget {
  const PostAlert({super.key});

  @override
  State<PostAlert> createState() => _PostAlertState();
}

class _PostAlertState extends State<PostAlert> {
  final GlobalKey<PostBaseWidgetState> _baseKey = GlobalKey();
  final hashtagCtrl = TextEditingController();

  File? cover;
  List<File?> images = [];
  String? title;
  String? description;
  String? placeId;

  String? category;
  String? expiry;
  String? contactInfo;

  void publish() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Post-Alert"),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: SafeArea(
          child: Column(
            children: [
              PostBaseWidget(key: _baseKey),
              CustomDropDown(
                title: "Category",
                hintText: "Choose alert category",
                options: [
                  "Community Update",
                  "Safety Alert",
                  "Lost & Found",
                  "Weather / Hazard",
                  "Missing Person",
                ],
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: hashtagCtrl,
                title: "Contact Info",
                hintText: "Share contact information",
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: hashtagCtrl,
                title: "Hashtags",
                hintText: "#Like #This",
              ),
              const SizedBox(height: 16),
              CustomDropDown(
                title: "Set auto-expire",
                initialPick: 1,
                options: ["1 Day", "7 Days", "14 Days", "30 Days", "90 Days"],
              ),

              const SizedBox(height: 40),
              CustomButton(onTap: publish, text: "Publish"),
              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
    );
  }
}
