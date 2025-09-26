import 'dart:io';
import 'package:flutter/material.dart';
import 'package:jurnee/utils/app_texts.dart';
import 'package:jurnee/views/base/availability_widget.dart';
import 'package:jurnee/views/base/custom_app_bar.dart';
import 'package:jurnee/views/base/custom_button.dart';
import 'package:jurnee/views/base/custom_drop_down.dart';
import 'package:jurnee/views/base/custom_text_field.dart';
import 'package:jurnee/views/screens/post/post_base_widget.dart';

class PostService extends StatefulWidget {
  const PostService({super.key});

  @override
  State<PostService> createState() => _PostServiceState();
}

class _PostServiceState extends State<PostService> {
  final GlobalKey<PostBaseWidgetState> _baseKey = GlobalKey();
  final GlobalKey<PostBaseWidgetState> _availabilityKey = GlobalKey();
  final hashtagCtrl = TextEditingController();

  File? cover;
  List<File?> images = [];
  String? title;
  String? description;
  String? placeId;
  String? category;

  void publish() async {}

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
                    category = val;
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
              CustomButton(onTap: publish, text: "Publish"),
              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
    );
  }

  Widget getAdditionalFields() {
    switch (category) {
      case "Food & Beverage":
        return CustomTextField(
          title: "Starting Price",
          hintText: "\$ Enter the selling price",
        );
      case "Entertainment":
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text("Rates", style: AppTexts.txsb),
            ),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Color(0xffE6E6E6)),
              ),
              child: Row(
                spacing: 16,
                children: [
                  Expanded(
                    child: CustomTextField(
                      title: "Hourly",
                      hintText: "\$ Enter rate",
                    ),
                  ),
                  Expanded(
                    child: CustomTextField(
                      title: "Day",
                      hintText: "\$ Enter rate",
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      case "Personal/Home Services":
        return Column(
          children: [
            CustomTextField(
              title: "Starting Price",
              hintText: "\$ Enter the selling price",
            ),
            const SizedBox(height: 16),
            CustomTextField(
              title: "Service Type",
              hintText: "Enter your service type",
            ),
            const SizedBox(height: 16),
            CustomTextField(
              onTap: () {},
              title: "Licenses",
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
              hintText: "\$ Enter the selling price",
            ),
            const SizedBox(height: 16),
            CustomTextField(title: "Capacity", hintText: "Enter max guests"),
            const SizedBox(height: 16),
            CustomTextField(title: "Amenities", hintText: "Enter amenities"),
          ],
        );
      default:
        return Container();
    }
  }
}
