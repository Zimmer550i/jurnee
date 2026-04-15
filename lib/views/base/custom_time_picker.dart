import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jurnee/utils/app_colors.dart';
import 'package:jurnee/utils/app_texts.dart';
import 'package:jurnee/views/base/custom_button.dart';

Future<TimeOfDay?> showCustomTimePicker(
  BuildContext context, {
  TimeOfDay? initialTime,
  String title = 'Select time',
}) {
  final seedTime = initialTime ?? TimeOfDay.now();
  int selectedHour = _toHour12(seedTime.hour);
  int selectedMinute = seedTime.minute;
  bool isPm = seedTime.hour >= 12;

  return showModalBottomSheet<TimeOfDay>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      return StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            decoration: const BoxDecoration(
              color: AppColors.gray,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(title, style: AppTexts.tlgb),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 180,
                      width: MediaQuery.of(context).size.width / 2,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Positioned(
                            left: 0,
                            right: 0,
                            top: (180 / 2) - 40,
                            child: Divider(color: AppColors.gray.shade200),
                          ),
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: (180 / 2) - 40,
                            child: Divider(color: AppColors.gray.shade200),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: _TimeWheel(
                                  itemCount: 12,
                                  initialItem: selectedHour - 1,
                                  onSelectedItemChanged: (index) {
                                    setModalState(
                                      () => selectedHour = index + 1,
                                    );
                                  },
                                  labelBuilder: (index) =>
                                      (index + 1).toString().padLeft(2, '0'),
                                ),
                              ),
                              Text(':', style: AppTexts.dxsb),
                              Expanded(
                                child: _TimeWheel(
                                  itemCount: 60,
                                  initialItem: selectedMinute,
                                  onSelectedItemChanged: (index) {
                                    setModalState(() => selectedMinute = index);
                                  },
                                  labelBuilder: (index) =>
                                      index.toString().padLeft(2, '0'),
                                ),
                              ),
                              Expanded(
                                child: _TimeWheel(
                                  itemCount: 2,
                                  initialItem: isPm ? 1 : 0,
                                  onSelectedItemChanged: (index) {
                                    setModalState(() => isPm = index == 1);
                                  },
                                  labelBuilder: (index) =>
                                      index == 0 ? 'AM' : 'PM',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            onTap: () => Navigator.of(sheetContext).pop(),
                            text: 'Cancel',
                            isSecondary: true,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: CustomButton(
                            onTap: () {
                              final hour24 = _toHour24(selectedHour, isPm);
                              Navigator.of(sheetContext).pop(
                                TimeOfDay(hour: hour24, minute: selectedMinute),
                              );
                            },
                            text: 'Save',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

int _toHour12(int hour24) {
  if (hour24 == 0) return 12;
  if (hour24 > 12) return hour24 - 12;
  return hour24;
}

int _toHour24(int hour12, bool isPm) {
  if (hour12 == 12) {
    return isPm ? 12 : 0;
  }
  return isPm ? hour12 + 12 : hour12;
}

class _TimeWheel extends StatelessWidget {
  final int itemCount;
  final int initialItem;
  final ValueChanged<int> onSelectedItemChanged;
  final String Function(int index) labelBuilder;

  const _TimeWheel({
    required this.itemCount,
    required this.initialItem,
    required this.onSelectedItemChanged,
    required this.labelBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoPicker(
      scrollController: FixedExtentScrollController(initialItem: initialItem),
      itemExtent: 60,
      selectionOverlay: const SizedBox.shrink(),
      useMagnifier: true,
      magnification: 1.05,
      onSelectedItemChanged: onSelectedItemChanged,
      children: List.generate(
        itemCount,
        (index) =>
            Center(child: Text(labelBuilder(index), style: AppTexts.tlgb)),
      ),
    );
  }
}
