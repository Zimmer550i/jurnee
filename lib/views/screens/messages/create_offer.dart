import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jurnee/utils/app_colors.dart';
import 'package:jurnee/utils/app_texts.dart';
import 'package:jurnee/utils/custom_svg.dart';
import 'package:jurnee/utils/formatter.dart';
import 'package:jurnee/views/base/custom_app_bar.dart';
import 'package:jurnee/views/base/custom_button.dart';
import 'package:jurnee/views/base/custom_drop_down.dart';
import 'package:jurnee/views/base/custom_text_field.dart';
import 'package:jurnee/views/screens/messages/offer_preview.dart';

class CreateOffer extends StatefulWidget {
  const CreateOffer({super.key});

  @override
  State<CreateOffer> createState() => _CreateOfferState();
}

class _CreateOfferState extends State<CreateOffer> {
  final TextEditingController _serviceDetailsController =
      TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  DateTime? date;
  TimeOfDay? start;
  TimeOfDay? end;

  onSubmit() async {
    Get.to(() => OfferPreview());
  }

  @override
  void dispose() {
    _serviceDetailsController.dispose();
    _dateController.dispose();
    _fromController.dispose();
    _toController.dispose();
    _discountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Create Offer"),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: SafeArea(
          child: Column(
            spacing: 16,
            children: [
              const SizedBox(height: 4),
              // TODO: Impl Loading logic from j4corp
              CustomDropDown(
                title: "Select Service",
                options: ["Plumbing Service"],
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
                  if (date != null) {
                    _dateController.text = Formatter.dateFormatter(date!);
                  }
                  setState(() {});
                },
                title: "Date",
                controller: _dateController,
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
                        if (start != null) {
                          _fromController.text = Formatter.timeFormatter(
                            time: start,
                          );
                        }
                        setState(() {});
                      },
                      title: "From",
                      controller: _fromController,
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
                        if (end != null) {
                          _toController.text = Formatter.timeFormatter(
                            time: end,
                          );
                        }
                        setState(() {});
                      },
                      title: "To",
                      controller: _toController,
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
              ),
              for (int i = 0; i < 2; i++) serviceItem(),
              const SizedBox(height: 8),
              CustomButton(
                onTap: () {},
                text: "Add New Item",
                isSecondary: true,
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
                        "\$350",
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
                        "\$50",
                        style: AppTexts.tsmm.copyWith(color: AppColors.gray),
                      ),
                    ],
                  ),
                  Divider(color: AppColors.gray.shade200),
                  Row(
                    children: [
                      Text("Total", style: AppTexts.tmdb),
                      Spacer(),
                      Text("\$350", style: AppTexts.tmdb),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              CustomButton(onTap: onSubmit, text: "Preview Offer"),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget serviceItem() {
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
          CustomTextField(title: "Name"),
          CustomTextField(
            title: "Quantity",
            textInputType: TextInputType.number,
          ),
          CustomTextField(
            title: "Unit Price",
            textInputType: TextInputType.number,
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: GestureDetector(
              onTap: () {},
              child: CustomSvg(asset: "assets/icons/delete.svg"),
            ),
          ),
        ],
      ),
    );
  }
}
