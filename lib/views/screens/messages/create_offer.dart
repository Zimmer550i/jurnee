import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jurnee/controllers/chat_controller.dart';
import 'package:jurnee/controllers/post_controller.dart';
import 'package:jurnee/controllers/user_controller.dart';
import 'package:jurnee/utils/app_colors.dart';
import 'package:jurnee/utils/app_texts.dart';
import 'package:jurnee/utils/custom_snackbar.dart';
import 'package:jurnee/utils/custom_svg.dart';
import 'package:jurnee/utils/formatter.dart';
import 'package:jurnee/views/base/custom_app_bar.dart';
import 'package:jurnee/views/base/custom_button.dart';
import 'package:jurnee/views/base/custom_drop_down.dart';
import 'package:jurnee/views/base/custom_text_field.dart';
import 'package:jurnee/views/screens/messages/offer_preview.dart';

class CreateOffer extends StatefulWidget {
  final String chatID;
  final String userId;
  const CreateOffer({super.key, required this.chatID, required this.userId});

  @override
  State<CreateOffer> createState() => _CreateOfferState();
}

class _CreateOfferState extends State<CreateOffer> {
  final user = Get.find<UserController>();
  final post = Get.find<PostController>();
  final TextEditingController _serviceDetailsController =
      TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  List<TextEditingController> titleController = [TextEditingController()];
  List<TextEditingController> quantityController = [TextEditingController()];
  List<TextEditingController> unitPriceController = [TextEditingController()];
  DateTime? date;
  TimeOfDay? start;
  TimeOfDay? end;
  String? serviceId;

  @override
  void initState() {
    super.initState();
    user.getUserPosts(3, user.userData?.id).then((message) {
      if (message != "success") {
        customSnackBar(message);
      }
    });
  }

  onSubmit() async {
    final offerData = {
      "chat": widget.chatID,
      "provider": user.userData!.id,
      "customer": widget.userId,
      "service": serviceId,
      "description": _serviceDetailsController.text.trim(),
      "date": date?.toUtc().toIso8601String(),
      "from": "${start?.hour}:${start?.minute}",
      "to": "${end?.hour}:${end?.minute}",
      "items": [
        for (int i = 0; i < titleController.length; i++)
          {
            "title": titleController.elementAt(i).text,
            "quantity": double.tryParse(quantityController.elementAt(i).text),
            "unitPrice": double.tryParse(unitPriceController.elementAt(i).text),
          },
      ],
      "discount": int.tryParse(_discountController.text.trim()) ?? 0,
    };

    final message = await Get.find<ChatController>().createOffer(offerData);

    if (message == "success") {
      Get.to(() => OfferPreview());
    } else {
      customSnackBar(message);
    }
  }

  @override
  void dispose() {
    _serviceDetailsController.dispose();
    _discountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    num sum = 0;

    for (int i = 0; i < titleController.length; i++) {
      var quantity = double.tryParse(quantityController.elementAt(i).text) ?? 1;
      var price = double.tryParse(unitPriceController.elementAt(i).text) ?? 0;

      sum += quantity * price;
    }

    return Scaffold(
      appBar: CustomAppBar(title: "Create Offer"),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: SafeArea(
          child: Column(
            spacing: 16,
            children: [
              const SizedBox(height: 4),
              Obx(
                () => CustomDropDown(
                  title: "Select Service",
                  isLoading: user.isFirstLoad.value,
                  onChanged: (val) {
                    setState(() {
                      serviceId = user.posts
                          .firstWhere((temp) => temp.title == val)
                          .id;
                    });
                  },
                  options: [for (var i in user.posts) i.title],
                ),
              ),
              CustomTextField(
                title: "Service Details",
                lines: 5,
                hintText: "Enter Details",
                controller: _serviceDetailsController,
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
                title: "Date",
                controller: date != null
                    ? TextEditingController(
                        text: Formatter.dateFormatter(date!),
                      )
                    : null,
                hintText: "Pick date",
                trailing: "assets/icons/calendar.svg",
              ),

              Row(
                spacing: 16,
                children: [
                  Expanded(
                    child: CustomTextField(
                      onTap: () async {
                        start = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        setState(() {});
                      },
                      title: "From",
                      controller: start != null
                          ? TextEditingController(
                              text: Formatter.timeFormatter(time: start),
                            )
                          : null,
                      hintText: "Pick time",
                      trailing: "assets/icons/clock.svg",
                    ),
                  ),
                  Expanded(
                    child: CustomTextField(
                      onTap: () async {
                        end = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        setState(() {});
                      },
                      title: "To",
                      controller: end != null
                          ? TextEditingController(
                              text: Formatter.timeFormatter(time: end),
                            )
                          : null,
                      hintText: "Pick time",
                      trailing: "assets/icons/clock.svg",
                    ),
                  ),
                ],
              ),

              CustomTextField(
                title: "Discount",
                isOptional: true,
                hintText: "Set Discount",
                controller: _discountController,
                textInputType: TextInputType.number,
              ),
              for (int i = 0; i < titleController.length; i++) serviceItem(i),
              const SizedBox(height: 8),
              CustomButton(
                onTap: () {
                  setState(() {
                    titleController.add(TextEditingController());
                    quantityController.add(TextEditingController());
                    unitPriceController.add(TextEditingController());
                  });
                },
                text: "Add New Item",
                isSecondary: true,
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: CustomButton(
                  onTap: () => setState(() {}),
                  text: "Calculate",
                  radius: 4,
                  width: null,
                  padding: 8,
                  height: 36,
                ),
              ),
              const SizedBox(height: 8),
              Column(
                spacing: 12,
                children: [
                  Row(
                    children: [
                      Text(
                        "Service",
                        style: AppTexts.tsmm.copyWith(color: AppColors.gray),
                      ),
                      Spacer(),
                      Text(
                        "\$$sum",
                        style: AppTexts.tsmm.copyWith(color: AppColors.gray),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "Discount",
                        style: AppTexts.tsmm.copyWith(color: AppColors.gray),
                      ),
                      Spacer(),
                      Text(
                        "\$${_discountController.text}",
                        style: AppTexts.tsmm.copyWith(color: AppColors.gray),
                      ),
                    ],
                  ),
                  Divider(color: AppColors.gray.shade200),
                  Row(
                    children: [
                      Text("Total", style: AppTexts.tmdb),
                      Spacer(),
                      Text(
                        "\$${sum - (double.tryParse(_discountController.text) ?? 0)}",
                        style: AppTexts.tmdb,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Obx(
                () => CustomButton(
                  onTap: onSubmit,
                  isLoading: Get.find<ChatController>().isLoading.value,
                  text: "Preview Offer",
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget serviceItem(int index) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.gray.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        spacing: 16,
        children: [
          Text("Service Item", style: AppTexts.tmdb),
          CustomTextField(
            title: "Name",
            controller: titleController.elementAt(index),
          ),
          CustomTextField(
            title: "Quantity",
            textInputType: TextInputType.number,
            controller: quantityController.elementAt(index),
          ),
          CustomTextField(
            title: "Unit Price",
            textInputType: TextInputType.number,
            controller: unitPriceController.elementAt(index),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  titleController.removeAt(index);
                  quantityController.removeAt(index);
                  unitPriceController.removeAt(index);
                });
              },
              child: CustomSvg(asset: "assets/icons/delete.svg"),
            ),
          ),
        ],
      ),
    );
  }
}
