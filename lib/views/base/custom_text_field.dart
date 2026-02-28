import 'package:jurnee/utils/app_colors.dart';
import 'package:jurnee/utils/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jurnee/utils/app_texts.dart';

class CustomTextField extends StatefulWidget {
  final String? title;
  final bool isOptional;
  final String? hintText;
  final String? errorText;
  final String? leading;
  final String? trailing;
  final Widget? trailingWidget;
  final TextInputType? textInputType;
  final bool isDisabled;
  final double radius;
  final double? height;
  final double? width;
  final Color focusColor;
  final TextEditingController? controller;
  final bool isPassword;
  final int lines;
  final void Function()? onTap;
  final void Function(String)? onChanged;
  const CustomTextField({
    super.key,
    this.title,
    this.trailingWidget,
    this.hintText,
    this.leading,
    this.trailing,
    this.isPassword = false,
    this.isDisabled = false,
    this.isOptional = false,
    this.radius = 12,
    this.lines = 1,
    this.focusColor = AppColors.green,
    this.textInputType,
    this.controller,
    this.onTap,
    this.errorText,
    this.height = 48,
    this.width,
    this.onChanged,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool isObscured = false;
  bool isFocused = false;
  final focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    isObscured = widget.isPassword;
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        setState(() {
          isFocused = true;
        });
      } else {
        setState(() {
          isFocused = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              spacing: 8,
              children: [
                Text(widget.title!, style: AppTexts.txsb),
                if (widget.isOptional)
                  Text(
                    "(Optional)",
                    style: AppTexts.txsb.copyWith(color: AppColors.gray),
                  ),
              ],
            ),
          ),
        GestureDetector(
          onTap: () {
            if (widget.onTap != null) {
              widget.onTap!();
            } else {
              if (!widget.isDisabled) {
                focusNode.requestFocus();
              }
            }
          },
          child: Container(
            height: widget.lines == 1 ? widget.height : null,
            width: widget.width,
            padding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: widget.lines == 1 ? 0 : 20,
            ),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(widget.radius),
              border: widget.errorText != null
                  ? Border.all(color: AppColors.red.shade400, width: 1.5)
                  : isFocused
                  ? Border.all(color: widget.focusColor, width: 1.5)
                  : Border.all(color: AppColors.gray.shade200),
            ),
            child: Row(
              spacing: 16,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (widget.leading != null)
                  SvgPicture.asset(
                    widget.leading!,
                    height: 24,
                    width: 24,
                    colorFilter: ColorFilter.mode(
                      isFocused ? widget.focusColor : AppColors.gray.shade900,
                      BlendMode.srcIn,
                    ),
                  ),
                Expanded(
                  child: TextField(
                    focusNode: focusNode,
                    controller: widget.controller,
                    maxLines: widget.lines,
                    cursorColor: AppColors.green,
                    keyboardType: widget.textInputType,
                    obscureText: isObscured,
                    enabled: !widget.isDisabled && widget.onTap == null,
                    onTapOutside: (event) {
                      setState(() {
                        isFocused = false;
                        focusNode.unfocus();
                      });
                    },
                    onChanged: widget.onChanged,
                    style: AppTexts.tmdr,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                      hintText: widget.hintText,
                      hintStyle: AppTexts.tsmr.copyWith(
                        color: AppColors.gray[300],
                      ),
                    ),
                  ),
                ),
                if (widget.trailingWidget != null) widget.trailingWidget!,
                if (widget.trailing != null)
                  SvgPicture.asset(
                    widget.trailing!,
                    height: 16,
                    width: 16,
                    colorFilter: ColorFilter.mode(
                      AppColors.green.shade700,
                      BlendMode.srcIn,
                    ),
                  ),
                if (widget.isPassword)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isObscured = !isObscured;
                      });
                    },
                    behavior: HitTestBehavior.translucent,
                    child: SvgPicture.asset(
                      isObscured ? AppIcons.eyeOff : AppIcons.eye,
                      width: 24,
                      colorFilter: ColorFilter.mode(
                        isFocused ? widget.focusColor : AppColors.gray.shade100,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        if (widget.errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              widget.errorText!,
              style: AppTexts.txsr.copyWith(color: AppColors.red.shade400),
            ),
          ),
      ],
    );
  }
}
