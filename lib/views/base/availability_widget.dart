import 'package:flutter/material.dart';
import 'package:jurnee/models/schedule_model.dart';
import 'package:jurnee/utils/app_colors.dart';
import 'package:jurnee/utils/app_texts.dart';
import 'package:jurnee/views/base/custom_text_field.dart';

class AvailabilityWidget extends StatefulWidget {
  final List<Schedule>? initialSchedule;
  const AvailabilityWidget({super.key, this.initialSchedule});

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
  DateTime? from;
  DateTime? to;

  @override
  void initState() {
    super.initState();
    if (widget.initialSchedule != null) {
      for (var i in widget.initialSchedule!) {
        var index = schedule.indexWhere((val) => val.day == i.day);
        schedule.removeAt(index);
        schedule.insert(index, i);
      }
    }
  }

  List<Map<String, dynamic>> getSchedule() {
    List<Map<String, dynamic>> rtn = [];

    if (from != null && to != null) {
      for (var day in schedule) {
        if (day.availability) {
          day.startTime = "${from!.hour}:${from!.minute}";
          day.endTime = "${to!.hour}:${to!.minute}";

          rtn.add(day.toJson());
        }
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
                child: Text("Mark Available Days", style: AppTexts.txsb),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Color(0xffe6e6e6)),
                ),
                child: Row(
                  spacing: 5,
                  children: [
                    for (int i = 0; i < 7; i++)
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              schedule[i].availability =
                                  !schedule[i].availability;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              border: schedule[i].availability
                                  ? Border.all(
                                      color: AppColors.green.shade600,
                                      width: 2,
                                    )
                                  : null,
                              borderRadius: BorderRadius.circular(8),
                              color: schedule[i].availability
                                  ? AppColors.green[50]
                                  : null,
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
                                  fontWeight: schedule[i].availability
                                      ? FontWeight.w700
                                      : FontWeight.w400,
                                  color: schedule[i].availability
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
