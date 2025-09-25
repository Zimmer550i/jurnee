import 'dart:io';
import 'package:flutter/material.dart';
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
  String? title;
  String? description;
  String? placeId;

  DateTime? start;
  DateTime? end;

  void publish() async {}

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
                        start = await showDatePicker(
                          context: context,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2050),
                        );
                        setState(() {});
                      },
                      title: "Start",
                      hintText: "Start date",
                      trailing: "assets/icons/calendar.svg",
                    ),
                  ),
                  Expanded(
                    child: CustomTextField(
                      onTap: () async {
                        end = await showDatePicker(
                          context: context,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2050),
                        );
                        setState(() {});
                      },
                      title: "End",
                      hintText: "End Date",
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
              CustomButton(onTap: publish, text: "Publish"),
              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
    );
  }
}
