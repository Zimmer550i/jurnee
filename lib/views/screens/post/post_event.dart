import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jurnee/controllers/maps_controller.dart';
import 'package:jurnee/controllers/post_controller.dart';
import 'package:jurnee/models/post_model.dart';
import 'package:jurnee/utils/custom_snackbar.dart';
import 'package:jurnee/utils/formatter.dart';
import 'package:jurnee/views/base/custom_app_bar.dart';
import 'package:jurnee/views/base/custom_button.dart';
import 'package:jurnee/views/base/custom_text_field.dart';
import 'package:jurnee/views/screens/post/post_base_widget.dart';

class PostEvent extends StatefulWidget {
  final PostModel? post;
  const PostEvent({super.key, this.post});

  @override
  State<PostEvent> createState() => _PostEventState();
}

class _PostEventState extends State<PostEvent> {
  final GlobalKey<PostBaseWidgetState> _baseKey = GlobalKey();
  final map = Get.find<MapsController>();
  final hashtagCtrl = TextEditingController();

  String? placeId;
  DateTime? date;
  TimeOfDay? time;

  @override
  void initState() {
    super.initState();
    if (widget.post != null) populateFields();
  }

  void publish() async {
    if (!isValid()) {
      return;
    }

    late Map<String, dynamic> pos;

    if (widget.post == null) {
      pos = await map.getPlacePosition(map.selected.value!.placeId) ?? {};
    } else {
      pos =
          await map.getPlacePosition(map.selected.value?.placeId) ??
          {
            "lng": widget.post!.location.coordinates[0],
            "lat": widget.post!.location.coordinates[1],
          };
    }

    Map<String, dynamic> payload = {
      "data": {
        "title": _baseKey.currentState?.titleCtrl.text.trim(),
        "description": _baseKey.currentState?.descriptionCtrl.text.trim(),
        "category": "Event",
        "address": _baseKey.currentState?.locationCtrl.text.trim(),
        "location": {
          "type": "Point",
          "coordinates": [pos['lng'], pos['lat']],
        },
        "hasTag": hashtagCtrl.text.split(" "),
        "startDate": date?.toIso8601String(),
        "startTime": date
            ?.copyWith(hour: time?.hour, minute: time?.minute)
            .toIso8601String(),
      },
      if (widget.post == null || _baseKey.currentState!.cover != null)
        "image": _baseKey.currentState?.cover,
      "media": _baseKey.currentState?.images,
    };

    // Why?? No one knows. But this is the LAW!
    if (widget.post != null) {
      payload['data'] = jsonEncode(payload['data']);
    }

    late String message;

    if (widget.post == null) {
      message = await Get.find<PostController>().createPost("event", payload);
    } else {
      message = await Get.find<PostController>().updatePost(
        widget.post!.id,
        payload,
      );
    }

    if (message == "success") {
      if (mounted) {
        Get.until((route) => Get.currentRoute == "/app");
      }
      customSnackBar(
        "Post ${widget.post != null ? "created" : "updated"} successfully",
        isError: false,
      );
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
    if (date == null) {
      customSnackBar("Date is required");
      return false;
    }
    if (time == null) {
      customSnackBar("Time is required");
      return false;
    }
    if (_baseKey.currentState?.cover == null && widget.post == null) {
      customSnackBar("Cover image is required");
      return false;
    }
    return true;
  }

  void populateFields() {
    // Base Widget
    WidgetsBinding.instance.addPostFrameCallback((val) {
      setState(() {
        _baseKey.currentState!.titleCtrl.text = widget.post!.title;
        _baseKey.currentState!.descriptionCtrl.text = widget.post!.description;
        _baseKey.currentState!.locationCtrl.text = widget.post!.address;
        _baseKey.currentState!.coverImgUrl = widget.post!.image;
        _baseKey.currentState!.imageUrls =
            widget.post!.media ?? List.generate(5, (_) => null);
      });
    });

    // Others
    hashtagCtrl.text = widget.post!.hasTag?.join(" ") ?? "";
    date = widget.post!.startDate;
    time = widget.post!.startTime != null
        ? TimeOfDay.fromDateTime(widget.post!.startTime!)
        : null;
  }

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
                      controller: date != null
                          ? TextEditingController(
                              text: Formatter.dateFormatter(date!),
                            )
                          : null,
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
                      controller: time != null
                          ? TextEditingController(
                              text: Formatter.timeFormatter(time: time),
                            )
                          : null,
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
              Obx(
                () => CustomButton(
                  onTap: publish,
                  isLoading: Get.find<PostController>().isLoading.value,
                  text: widget.post != null ? "Update" : "Publish",
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
