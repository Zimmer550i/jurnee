import 'package:flutter/material.dart';
import 'package:jurnee/utils/app_colors.dart';
import 'package:jurnee/utils/app_texts.dart';
import 'package:jurnee/views/base/custom_button.dart';
import 'package:jurnee/views/base/custom_checkbox.dart';
import 'package:jurnee/views/base/custom_text_field.dart';

class AvailabilityWidget extends StatefulWidget {
  const AvailabilityWidget({super.key});

  @override
  State<AvailabilityWidget> createState() => _AvailabilityWidgetState();
}

class _AvailabilityWidgetState extends State<AvailabilityWidget> {
  bool repeat = false;
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text("Availability", style: AppTexts.txsb),
        ),
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Color(0xffE6E6E6)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text("Day", style: AppTexts.txsb),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Color(0xffe6e6e6)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            index = 0;
                          });
                        },
                        child: Container(
                          height: 44,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: index == 0
                                  ? BorderSide(
                                      width: 4,
                                      color: AppColors.green.shade600,
                                    )
                                  : BorderSide.none,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "Mon",
                              style: AppTexts.tsmb.copyWith(
                                fontWeight: index == 0
                                    ? FontWeight.w700
                                    : FontWeight.w400,
                                color: index == 0
                                    ? AppColors.gray.shade700
                                    : AppColors.gray.shade300,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            index = 1;
                          });
                        },
                        child: Container(
                          height: 44,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: index == 1
                                  ? BorderSide(
                                      width: 4,
                                      color: AppColors.green.shade600,
                                    )
                                  : BorderSide.none,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "Tue",
                              style: AppTexts.tsmb.copyWith(
                                fontWeight: index == 1
                                    ? FontWeight.w700
                                    : FontWeight.w400,
                                color: index == 1
                                    ? AppColors.gray.shade700
                                    : AppColors.gray.shade300,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            index = 2;
                          });
                        },
                        child: Container(
                          height: 44,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: index == 2
                                  ? BorderSide(
                                      width: 4,
                                      color: AppColors.green.shade600,
                                    )
                                  : BorderSide.none,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "Wed",
                              style: AppTexts.tsmb.copyWith(
                                fontWeight: index == 2
                                    ? FontWeight.w700
                                    : FontWeight.w400,
                                color: index == 2
                                    ? AppColors.gray.shade700
                                    : AppColors.gray.shade300,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            index = 3;
                          });
                        },
                        child: Container(
                          height: 44,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: index == 3
                                  ? BorderSide(
                                      width: 4,
                                      color: AppColors.green.shade600,
                                    )
                                  : BorderSide.none,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "Thu",
                              style: AppTexts.tsmb.copyWith(
                                fontWeight: index == 3
                                    ? FontWeight.w700
                                    : FontWeight.w400,
                                color: index == 3
                                    ? AppColors.gray.shade700
                                    : AppColors.gray.shade300,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            index = 4;
                          });
                        },
                        child: Container(
                          height: 44,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: index == 4
                                  ? BorderSide(
                                      width: 4,
                                      color: AppColors.green.shade600,
                                    )
                                  : BorderSide.none,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "Fri",
                              style: AppTexts.tsmb.copyWith(
                                fontWeight: index == 4
                                    ? FontWeight.w700
                                    : FontWeight.w400,
                                color: index == 4
                                    ? AppColors.gray.shade700
                                    : AppColors.gray.shade300,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            index = 5;
                          });
                        },
                        child: Container(
                          height: 44,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: index == 5
                                  ? BorderSide(
                                      width: 4,
                                      color: AppColors.green.shade600,
                                    )
                                  : BorderSide.none,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "Sat",
                              style: AppTexts.tsmb.copyWith(
                                fontWeight: index == 5
                                    ? FontWeight.w700
                                    : FontWeight.w400,
                                color: index == 5
                                    ? AppColors.gray.shade700
                                    : AppColors.gray.shade300,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            index = 6;
                          });
                        },
                        child: Container(
                          height: 44,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: index == 6
                                  ? BorderSide(
                                      width: 4,
                                      color: AppColors.green.shade600,
                                    )
                                  : BorderSide.none,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "Sun",
                              style: AppTexts.tsmb.copyWith(
                                fontWeight: index == 6
                                    ? FontWeight.w700
                                    : FontWeight.w400,
                                color: index == 6
                                    ? AppColors.gray.shade700
                                    : AppColors.gray.shade300,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                spacing: 16,
                children: [
                  Expanded(
                    child: CustomTextField(
                      onTap: () async {
                        // time = await showTimePicker(
                        //   context: context,
                        //   initialTime: TimeOfDay.now(),
                        // );
                        // setState(() {});
                      },
                      title: "From",
                      hintText: "Available from",
                      trailing: "assets/icons/clock.svg",
                    ),
                  ),
                  Expanded(
                    child: CustomTextField(
                      onTap: () async {
                        // time = await showTimePicker(
                        //   context: context,
                        //   initialTime: TimeOfDay.now(),
                        // );
                        // setState(() {});
                      },
                      title: "To",
                      hintText: "Available till",
                      trailing: "assets/icons/clock.svg",
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text("Repeat", style: AppTexts.txsb),
              ),
              Row(
                children: [
                  CustomCheckBox(
                    value: repeat,
                    size: 20,
                    activeColor: AppColors.green.shade600,
                    inactiveColor: Color(0xffe6e6e6),
                    onChanged: (val) {
                      setState(() {
                        repeat = val;
                      });
                    },
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Repeat this for all days of the week.",
                      style: AppTexts.tsmr.copyWith(
                        color: AppColors.gray.shade400,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Center(
                child: CustomButton(
                  text: "Apply",
                  isSecondary: true,
                  // padding: 0,
                  width: null,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
