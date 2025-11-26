import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jurnee/controllers/post_controller.dart';
import 'package:jurnee/utils/custom_snackbar.dart';
import 'package:jurnee/utils/formatter.dart';
import 'package:jurnee/utils/get_location.dart';
import 'package:jurnee/views/base/custom_app_bar.dart';
import 'package:jurnee/views/base/custom_button.dart';
import 'package:jurnee/views/base/custom_text_field.dart';
import 'package:jurnee/views/screens/post/post_base_widget.dart';

class PostDeal extends StatefulWidget {
  const PostDeal({super.key});

  @override
  State<PostDeal> createState() => _PostDealState();
}

class _PostDealState extends State<PostDeal> {
  final GlobalKey<PostBaseWidgetState> _baseKey = GlobalKey();
  final hashtagCtrl = TextEditingController();

  File? cover;
  List<File?> images = [];
  String? placeId;
  DateTime? startDate;
  DateTime? endDate;

  void publish() async {
    if (!isValid()) {
      return;
    }

    final pos = await getLocation();

    Map<String, dynamic> payload = {
      "data": {
        "title": _baseKey.currentState?.titleCtrl.text.trim(),
        "description": _baseKey.currentState?.descriptionCtrl.text.trim(),
        "category": "Event",
        "address": _baseKey.currentState?.locationCtrl.text.trim(),
        "location": {
          "type": "Point",
          "coordinates": [pos!.longitude, pos.latitude],
        },
        "hasTag": hashtagCtrl.text.split(" "),
        "startDate": startDate?.toIso8601String(),
        "endDate": endDate?.toIso8601String(),
      },
      "image": _baseKey.currentState?.cover,
      "media": _baseKey.currentState?.images,
    };

    final message = await Get.find<PostController>().createPost(
      "deal",
      payload,
    );
    if (message == "success") {
      if (mounted) {
        Get.until((route)=> Get.currentRoute == "/app");
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
    if (startDate == null) {
      customSnackBar("Date is required");
      return false;
    }
    if (endDate == null) {
      customSnackBar("Time is required");
      return false;
    }
    if (_baseKey.currentState?.cover == null) {
      customSnackBar("Cover image is required");
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Post-Deal"),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: SafeArea(
          child: Column(
            children: [
              PostBaseWidget(key: _baseKey),

              Row(
                spacing: 16,
                children: [
                  Expanded(
                    child: CustomTextField(
                      onTap: () async {
                        startDate = await showDatePicker(
                          context: context,
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2050),
                        );
                        setState(() {});
                      },
                      title: "Start",
                      hintText: "Start date",
                      controller: startDate != null
                          ? TextEditingController(
                              text: Formatter.dateFormatter(startDate!),
                            )
                          : null,
                      trailing: "assets/icons/calendar.svg",
                    ),
                  ),
                  Expanded(
                    child: CustomTextField(
                      onTap: () async {
                        endDate = await showDatePicker(
                          context: context,
                          firstDate: startDate ?? DateTime.now(),
                          lastDate: DateTime(2050),
                        );
                        setState(() {});
                      },
                      title: "End",
                      hintText: "End Date",
                      controller: endDate != null
                          ? TextEditingController(
                              text: Formatter.dateFormatter(endDate!),
                            )
                          : null,
                      trailing: "assets/icons/calendar.svg",
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: hashtagCtrl,
                title: "Hashtags",
                hintText: "#Like #This",
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
