import 'dart:io';
import 'package:flutter/material.dart';
import 'package:jurnee/views/base/custom_app_bar.dart';
import 'package:jurnee/views/base/custom_button.dart';
import 'package:jurnee/views/base/custom_text_field.dart';
import 'package:jurnee/views/screens/post/post_base_widget.dart';

class PostEvent extends StatefulWidget {
  const PostEvent({super.key});

  @override
  State<PostEvent> createState() => _PostEventState();
}

class _PostEventState extends State<PostEvent> {
  final GlobalKey<PostBaseWidgetState> _baseKey = GlobalKey();
  final hashtagCtrl = TextEditingController();

  File? cover;
  List<File?> images = [];
  String? title;
  String? description;
  String? placeId;
  DateTime? date;
  TimeOfDay? time;

  void publish() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Post-Event"),
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
                        date = await showDatePicker(
                          context: context,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2050),
                        );
                        setState(() {});
                      },
                      title: "Date",
                      hintText: "Pick date",
                      trailing: "assets/icons/calendar.svg",
                    ),
                  ),
                  Expanded(
                    child: CustomTextField(
                      onTap: () async {
                        time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        setState(() {});
                      },
                      title: "Time",
                      hintText: "Pick time",
                      trailing: "assets/icons/clock.svg",
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
