import 'package:jurnee/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jurnee/utils/app_texts.dart';

class CustomDropDown extends StatefulWidget {
  final String? title;
  final int? initialPick;
  final String? hintText;
  final List<String> options;
  final double? height;
  final double? width;
  final double radius;
  final void Function(String)? onChanged;
  const CustomDropDown({
    super.key,
    this.title,
    this.initialPick,
    this.hintText,
    required this.options,
    this.onChanged,
    this.radius = 12,
    this.height = 48,
    this.width,
  });

  @override
  State<CustomDropDown> createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  String? currentVal;
  bool isExpanded = false;
  Duration defaultDuration = const Duration(milliseconds: 100);

  @override
  void initState() {
    super.initState();
    if (widget.initialPick != null) {
      currentVal = widget.options[widget.initialPick!];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(widget.title!, style: AppTexts.txsb),
          ),

        GestureDetector(
          onTap: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(widget.radius),
              border: isExpanded
                  ? Border.all(color: AppColors.green.shade600, width: 1)
                  : Border.all(color: AppColors.gray.shade200),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: widget.height,
                  child: Row(
                    children: [
                      currentVal == null
                          ? Text(
                              widget.hintText ?? "Select One",
                              style: AppTexts.tsmr.copyWith(
                                color: AppColors.gray.shade400,
                              ),
                            )
                          : Text(currentVal!, style: AppTexts.tsmr),
                      const Spacer(),
                      AnimatedRotation(
                        duration: defaultDuration,
                        turns: isExpanded ? 0.5 : 1,
                        child: SvgPicture.asset("assets/icons/dropdown.svg"),
                      ),
                    ],
                  ),
                ),
                if (isExpanded)
                  Container(
                    width: widget.width,
                    height: 0.5,
                    color: AppColors.gray.shade200,
                  ),
                AnimatedSize(
                  duration: defaultDuration,
                  child: isExpanded
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ...widget.options.map((e) {
                              return GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () {
                                  setState(() {
                                    isExpanded = false;
                                    currentVal = e;
                                    if (widget.onChanged != null) {
                                      widget.onChanged!(e);
                                    }
                                  });
                                },
                                child: SizedBox(
                                  height: widget.height,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      e,
                                      style: TextStyle(
                                        color: AppColors.gray,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ],
                        )
                      : SizedBox(height: 0, width: double.infinity),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
