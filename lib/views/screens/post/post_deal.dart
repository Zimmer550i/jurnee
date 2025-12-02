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

class PostDeal extends StatefulWidget {
  final PostModel? post;
  const PostDeal({super.key, this.post});

  @override
  State<PostDeal> createState() => _PostDealState();
}

class _PostDealState extends State<PostDeal> {
  final GlobalKey<PostBaseWidgetState> _baseKey = GlobalKey();
  final map = Get.find<MapsController>();
  final hashtagCtrl = TextEditingController();

  String? placeId;
  DateTime? startDate;
  DateTime? endDate;

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
        "category": "Deal",
        "address": _baseKey.currentState?.locationCtrl.text.trim(),
        "location": {
          "type": "Point",
          "coordinates": [pos['lng'], pos['lat']],
        },
        "hasTag": hashtagCtrl.text.split(" "),
        "startDate": startDate?.toIso8601String(),
        "endDate": endDate?.toIso8601String(),
      },
      if (widget.post == null || _baseKey.currentState!.cover != null)
        "image": _baseKey.currentState?.cover,
      "media": _baseKey.currentState?.images,
    };

    late String message;

    if (widget.post == null) {
      message = await Get.find<PostController>().createPost("deal", payload);
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
        "Deal ${widget.post == null ? "created" : "updated"} successfully",
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
    if (startDate == null) {
      customSnackBar("Date is required");
      return false;
    }
    if (endDate == null) {
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
    startDate = widget.post!.startDate;
    endDate = widget.post!.endDate;
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
