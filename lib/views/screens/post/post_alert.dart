import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jurnee/controllers/post_controller.dart';
import 'package:jurnee/utils/custom_snackbar.dart';
import 'package:jurnee/utils/get_location.dart';
import 'package:jurnee/views/base/custom_app_bar.dart';
import 'package:jurnee/views/base/custom_button.dart';
import 'package:jurnee/views/base/custom_drop_down.dart';
import 'package:jurnee/views/base/custom_text_field.dart';
import 'package:jurnee/views/screens/post/location_picker.dart';
import 'package:jurnee/views/screens/post/post_base_widget.dart';

class PostAlert extends StatefulWidget {
  const PostAlert({super.key});

  @override
  State<PostAlert> createState() => _PostAlertState();
}

class _PostAlertState extends State<PostAlert> {
  final GlobalKey<PostBaseWidgetState> _baseKey = GlobalKey();
  final hashtagCtrl = TextEditingController();
  final contactCtrl = TextEditingController();
  final nameCtrl = TextEditingController();
  final ageCtrl = TextEditingController();
  final clothCtrl = TextEditingController();
  final locationCtrl = TextEditingController();

  File? cover;
  List<File?> images = [];
  String? title;
  String? description;
  String? placeId;

  String? category;
  String expiry = "7 Days";
  DateTime? date;

  void publish() async {
    if (!isValid()) {
      return;
    }

    final pos = await getLocation();

    Map<String, dynamic> payload = {
      "data": {
        "title": _baseKey.currentState?.titleCtrl.text.trim(),
        "description": _baseKey.currentState?.descriptionCtrl.text.trim(),
        "category": "alert",
        "subcategory": category,
        "address": _baseKey.currentState?.locationCtrl.text.trim(),
        "location": {
          "type": "Point",
          "coordinates": [pos!.longitude, pos.latitude],
        },
        "hasTag": hashtagCtrl.text.split(" "),
        "contactInfo": contactCtrl.text,
        "expireLimit": num.tryParse(expiry.split(" ").first),
      },
      "image": _baseKey.currentState?.cover,
      "media": _baseKey.currentState?.images,
    };

    if (category == "Missing Person") {
      (payload['data'] as Map<String, dynamic>).addAll({
        "missingName": nameCtrl.text.trim(),
        "missingAge": num.tryParse(ageCtrl.text),
        "clothingDescription": clothCtrl.text.trim(),
        "lastSeenDate": date!.toIso8601String(),
        "lastSeenLocation": {
          "type": "Point",
          "coordinates": [pos.longitude, pos.latitude],
        },
      });
    }

    final message = await Get.find<PostController>().createPost(
      "alert/${category == "Missing Person" ? "missing-person" : "others"}",
      payload,
    );
    if (message == "success") {
      if (mounted) {
        Get.until((route) => Get.currentRoute == "/app");
      }
      customSnackBar("Post created successfully", isError: false);
    } else {
      customSnackBar(message);
    }
  }

  bool isValid() {
    final title = _baseKey.currentState?.titleCtrl.text.trim();
    final description = _baseKey.currentState?.descriptionCtrl.text.trim();
    final address = _baseKey.currentState?.locationCtrl.text.trim();

    if (title == null || title.isEmpty) {
      customSnackBar("Title is required");
      return false;
    }
    if (description == null || description.isEmpty) {
      customSnackBar("Description is required");
      return false;
    }
    if (address == null || address.isEmpty) {
      customSnackBar("Address is required");
      return false;
    }
    if (_baseKey.currentState?.cover == null) {
      customSnackBar("Cover image is required");
      return false;
    }

    if (category == "Missing Person") {
      if (nameCtrl.text.isEmpty ||
          ageCtrl.text.isEmpty ||
          clothCtrl.text.isEmpty ||
          date == null) {
        customSnackBar("Provide missing person's information");
        return false;
      }
    }

    return true;
  }

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
                onChanged: (val) {
                  setState(() {
                    category = val;
                  });
                },
              ),
              if (category == "Missing Person")
                Column(
                  spacing: 16,
                  children: [
                    const SizedBox(height: 0),
                    CustomTextField(
                      controller: nameCtrl,
                      title: "Missing Person's Name",
                      hintText: "Enter missing person name",
                    ),
                    CustomTextField(
                      controller: ageCtrl,
                      textInputType: TextInputType.number,
                      title: "Missing Person's Age",
                      hintText: "Enter missing person age",
                    ),
                    CustomTextField(
                      controller: clothCtrl,
                      title: "Clothing Information",
                      hintText: "Enter clothing information",
                    ),
                    LocationPicker(
                      title: "Last Seen Location",
                      controller: locationCtrl,
                    ),
                    CustomTextField(
                      onTap: () async {
                        date = await showDatePicker(
                          context: context,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2050),
                        );
                        setState(() {});
                      },
                      title: "Last Seen Date",
                      hintText: "--- / --- / -----",
                      controller: date != null
                          ? TextEditingController(
                              text: DateFormat("dd / MMMM / yyy").format(date!),
                            )
                          : null,
                      trailing: "assets/icons/calendar.svg",
                    ),
                  ],
                ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: contactCtrl,
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
                onChanged: (val) {
                  setState(() {
                    expiry = val;
                  });
                },
                options: ["1 Day", "7 Days", "14 Days", "30 Days", "90 Days"],
              ),
              const SizedBox(height: 40),
              Obx(
                () => CustomButton(
                  onTap: publish,
                  isLoading: Get.find<PostController>().isLoading.value,
                  text: "Publish",
                ),
              ),
              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
    );
  }
}
