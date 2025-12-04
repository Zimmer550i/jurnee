import 'package:flutter/material.dart';
import 'package:jurnee/models/schedule_model.dart';
import 'package:jurnee/utils/app_colors.dart';
import 'package:jurnee/utils/app_texts.dart';
import 'package:jurnee/views/base/custom_button.dart';
import 'package:jurnee/views/base/custom_checkbox.dart';
import 'package:jurnee/views/base/custom_text_field.dart';

class AvailabilityWidget extends StatefulWidget {
  const AvailabilityWidget({super.key});

  @override
  State<AvailabilityWidget> createState() => AvailabilityWidgetState();
}

class AvailabilityWidgetState extends State<AvailabilityWidget> {
  List<Schedule> schedule = [
    Schedule(day: "mon"),
    Schedule(day: "tue"),
    Schedule(day: "wed"),
    Schedule(day: "thu"),
    Schedule(day: "fri"),
    Schedule(day: "sat"),
    Schedule(day: "sun"),
  ];
  bool repeat = false;
  int index = 0;

  List<Map<String, dynamic>> getSchedule() {
    List<Map<String, dynamic>> rtn = [];

    for (var day in schedule) {
      if (day.endTime != null && day.startTime != null && day.availability) {
        List slots = [];

        for (var slot in day.timeSlots) {
          if (slot.start != null && slot.end != null) {
            slots.add(slot);
          }
        }

        rtn.add(day.toJson());
      }
    }

    return rtn;
  }

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
                    for (int i = 0; i < 7; i++)
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              index = i;
                            });
                          },
                          child: Container(
                            height: 44,
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: index == i
                                    ? BorderSide(
                                        width: 4,
                                        color: AppColors.green.shade600,
                                      )
                                    : BorderSide.none,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                schedule
                                        .elementAt(i)
                                        .day
                                        .substring(0, 1)
                                        .toUpperCase() +
                                    schedule.elementAt(i).day.substring(1),
                                style: AppTexts.tsmb.copyWith(
                                  fontWeight: index == i
                                      ? FontWeight.w700
                                      : FontWeight.w400,
                                  color: index == i
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
              const SizedBox(height: 8),
              Row(
                children: [
                  if (index != 0)
                    GestureDetector(
                      onTap: () {
                        Schedule prev = schedule[index - 1];
                        setState(() {
                          schedule[index] = prev.copyWith(
                            day: schedule[index].day,
                          );
                        });
                      },
                      child: Container(
                        height: 26,
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: AppColors.green.shade600,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            "Copy Previous",
                            style: AppTexts.txsm.copyWith(
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  Spacer(),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomCheckBox(
                        value: !schedule[index].availability,
                        size: 20,
                        activeColor: AppColors.red.shade400,
                        inactiveColor: Color(0xffe6e6e6),
                        onChanged: (val) {
                          setState(() {
                            schedule[index].availability = !val;
                          });
                        },
                      ),
                      const SizedBox(width: 12),
                      Text(
                        "Unavailable",
                        style: AppTexts.tsmm.copyWith(
                          color: AppColors.red.shade400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                spacing: 16,
                children: [
                  Expanded(
                    child: CustomTextField(
                      onTap: () async {
                        schedule[index].startTime = await getTime();
                        setState(() {});
                      },
                      controller: TextEditingController(
                        text: schedule[index].startTime,
                      ),
                      title: "From",
                      hintText: "Available from",
                      trailing: "assets/icons/clock.svg",
                    ),
                  ),
                  Expanded(
                    child: CustomTextField(
                      onTap: () async {
                        schedule[index].endTime = await getTime();
                        setState(() {});
                      },
                      controller: TextEditingController(
                        text: schedule[index].endTime,
                      ),
                      title: "To",
                      hintText: "Available till",
                      trailing: "assets/icons/clock.svg",
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text("Slots", style: AppTexts.txsb),
              ),
              for (var i in schedule.elementAt(index).timeSlots)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          onTap: () async {
                            i.start = await getTime();
                            setState(() {});
                          },
                          controller: TextEditingController(text: i.start),
                          hintText: "Start",
                          trailing: "assets/icons/clock.svg",
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: CustomTextField(
                          onTap: () async {
                            i.end = await getTime();
                            setState(() {});
                          },
                          controller: TextEditingController(text: i.end),
                          hintText: "End",
                          trailing: "assets/icons/clock.svg",
                        ),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            schedule
                                .elementAt(index)
                                .timeSlots
                                .removeWhere((val) => val == i);
                          });
                        },
                        child: Icon(
                          Icons.close_rounded,
                          color: AppColors.gray.shade200,
                        ),
                      ),
                    ],
                  ),
                ),
              if (schedule.elementAt(index).timeSlots.isEmpty)
                Center(
                  child: Text(
                    "No slots available",
                    style: AppTexts.tsmr.copyWith(
                      color: AppColors.gray.shade200,
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      onTap: () {
                        setState(() {
                          schedule
                              .elementAt(index)
                              .timeSlots
                              .add(TimeSlot(available: true));
                        });
                      },
                      leading: "assets/icons/plus.svg",
                      text: "Add Slot",
                      isSecondary: true,
                    ),
                  ),
                  // SizedBox(width: 12),
                  // Expanded(child: CustomButton(text: "Apply")),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<String?> getTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time != null) {
      return "${time.hour}:${time.minute}";
    }
    return null;
  }
}
