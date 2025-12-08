import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jurnee/controllers/post_controller.dart';
import 'package:jurnee/models/post_model.dart';
import 'package:jurnee/utils/custom_snackbar.dart';
import 'package:jurnee/utils/get_location.dart';
import 'package:jurnee/views/base/availability_widget.dart';
import 'package:jurnee/views/base/custom_app_bar.dart';
import 'package:jurnee/views/base/custom_button.dart';
import 'package:jurnee/views/base/custom_drop_down.dart';
import 'package:jurnee/views/base/custom_text_field.dart';
import 'package:jurnee/views/screens/post/post_base_widget.dart';

class PostService extends StatefulWidget {
  final PostModel? post;
  const PostService({super.key, this.post});

  @override
  State<PostService> createState() => _PostServiceState();
}

class _PostServiceState extends State<PostService> {
  final GlobalKey<AvailabilityWidgetState> _availabilityKey = GlobalKey();
  final GlobalKey<PostBaseWidgetState> _baseKey = GlobalKey();
  final hashtagCtrl = TextEditingController();
  final priceCtrl = TextEditingController();
  final serviceTypeCtrl = TextEditingController();
  final capacityCtrl = TextEditingController();
  final amenitiesCtrl = TextEditingController();

  File? cover;
  List<File?> images = [];
  File? lisenses;
  String? placeId;
  DateTime? date;
  TimeOfDay? time;
  String? subCategory;

  void publish() async {
    if (!isValid()) {
      return;
    }

    final pos = await getLocation();

    Map<String, dynamic> payload = {
      "data": {
        "title": _baseKey.currentState?.titleCtrl.text.trim(),
        "description": _baseKey.currentState?.descriptionCtrl.text.trim(),
        "category": "service",
        "subcategory": subCategory,
        "address": _baseKey.currentState?.locationCtrl.text.trim(),
        "location": {
          "type": "Point",
          "coordinates": [pos!.longitude, pos.latitude],
        },
        "hasTag": hashtagCtrl.text.split(" "),

        "schedule": _availabilityKey.currentState?.getSchedule(),
      },
      "image": _baseKey.currentState?.cover,
      "media": _baseKey.currentState?.images,
    };

    switch (subCategory) {
      case "Food & Beverage":
        (payload['data'] as Map<String, dynamic>).addAll({
          "price": num.tryParse(priceCtrl.text),
        });
        break;
      case "Entertainment":
        (payload['data'] as Map<String, dynamic>).addAll({
          "price": num.tryParse(priceCtrl.text),
        });
        break;
      case "Personal/Home Services":
        (payload['data'] as Map<String, dynamic>).addAll({
          "price": num.tryParse(priceCtrl.text),
          "serviceType": serviceTypeCtrl.text,
        });
        if (lisenses != null) payload.addAll({"licenses": lisenses});
        break;
      case "Venues":
        (payload['data'] as Map<String, dynamic>).addAll({
          "price": num.tryParse(priceCtrl.text),
          "capacity": num.tryParse(priceCtrl.text),
          "amenities": amenitiesCtrl.text.trim().split(","),
        });
        break;
    }

    final message = await Get.find<PostController>().createPost(
      // Create api endpoint according to the subcategory. It's messy but working. Don't touch!!!
      "/service/${{"Food & Beverage": "food-beverage", "Entertainment": "entertainment", "Personal/Home Services": "home", "Venues": "venue"}[subCategory]}",
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

    if (subCategory == null) {
      customSnackBar("Category is required");
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Post-Service"),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: SafeArea(
          child: Column(
            children: [
              PostBaseWidget(key: _baseKey),
              AvailabilityWidget(key: _availabilityKey),

              const SizedBox(height: 16),
              CustomTextField(
                controller: hashtagCtrl,
                title: "Hashtags",
                hintText: "#Like #This",
              ),
              const SizedBox(height: 16),
              CustomDropDown(
                title: "Category",
                onChanged: (val) {
                  setState(() {
                    subCategory = val;
                  });
                },
                hintText: "Select service category",
                options: [
                  "Food & Beverage",
                  "Entertainment",
                  "Personal/Home Services",
                  "Venues",
                ],
              ),

              const SizedBox(height: 16),
              getAdditionalFields(),

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

  Widget getAdditionalFields() {
    switch (subCategory) {
      case "Food & Beverage":
        return CustomTextField(
          title: "Starting Price",
          controller: priceCtrl,
          textInputType: TextInputType.number,
          hintText: "\$ Enter the selling price",
        );
      case "Entertainment":
        return CustomTextField(
          title: "Starting Price",
          controller: priceCtrl,
          textInputType: TextInputType.number,
          hintText: "\$ Enter the starting price",
        );
      case "Personal/Home Services":
        return Column(
          children: [
            CustomTextField(
              title: "Starting Price",
              controller: priceCtrl,
              textInputType: TextInputType.number,
              hintText: "\$ Enter the starting price",
            ),
            const SizedBox(height: 16),
            CustomTextField(
              title: "Service Type",
              controller: serviceTypeCtrl,
              hintText: "Enter your service type",
            ),
            const SizedBox(height: 16),
            CustomTextField(
              onTap: () async {
                final temp = await FilePicker.platform.pickFiles(
                  allowMultiple: false,
                );
                if (temp != null && temp.files.isNotEmpty) {
                  setState(() {
                    lisenses = File(temp.files.single.path!);
                  });
                }
              },
              title: "Licenses",
              controller: lisenses != null
                  ? TextEditingController(text: lisenses!.path.split("/").last)
                  : null,
              hintText: "Upload your licenses",
              trailing: "assets/icons/attachment.svg",
            ),
          ],
        );
      case "Venues":
        return Column(
          children: [
            CustomTextField(
              title: "Starting Price",
              controller: priceCtrl,
              textInputType: TextInputType.number,
              hintText: "\$ Enter the starting price",
            ),
            const SizedBox(height: 16),
            CustomTextField(
              title: "Capacity",
              controller: capacityCtrl,
              textInputType: TextInputType.number,
              hintText: "Enter max guests",
            ),
            const SizedBox(height: 16),
            CustomTextField(
              title: "Amenities",
              controller: amenitiesCtrl,
              hintText: "Use comma(,) to seperate",
            ),
          ],
        );
      default:
        return Container();
    }
  }
}
