import 'package:flutter/material.dart';
import 'package:jurnee/utils/app_colors.dart';
import 'package:jurnee/utils/app_texts.dart';
import 'package:jurnee/utils/custom_svg.dart';
import 'package:jurnee/views/base/custom_button.dart';
import 'package:jurnee/views/base/custom_text_field.dart';
import 'package:jurnee/views/base/profile_picture.dart';

class CommentWidget extends StatefulWidget {
  const CommentWidget({super.key});

  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  bool isReplying = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 12,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProfilePicture(size: 32, image: "https://thispersondoesnotexist.com"),
        Expanded(
          child: Column(
            spacing: 12,
            children: [
              Row(
                spacing: 12,
                children: [
                  Text(
                    "Sample Name",
                    style: AppTexts.tmdb.copyWith(
                      color: AppColors.gray.shade700,
                    ),
                  ),
                  Text(
                    "1 hr Ago",
                    style: AppTexts.txss.copyWith(
                      color: AppColors.green.shade700,
                    ),
                  ),
                ],
              ),
              Text(
                "Amazing experience! The DJ kept the energy high all night long. We had a blast, and the venue was perfect for our group size. Highly recommend!",
                style: AppTexts.tmdr.copyWith(color: AppColors.gray.shade700),
              ),
              Row(
                children: [
                  CustomSvg(asset: "assets/icons/loved.svg", size: 16),
                  const SizedBox(width: 4),
                  Text(
                    "4",
                    style: AppTexts.tsms.copyWith(
                      color: AppColors.gray.shade600,
                    ),
                  ),
                  const SizedBox(width: 24),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isReplying = !isReplying;
                      });
                    },
                    child: Row(
                      children: [
                        CustomSvg(
                          asset: "assets/icons/message.svg",
                          size: 16,
                          color: AppColors.black,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "Reply",
                          style: AppTexts.tsms.copyWith(
                            color: AppColors.gray.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (isReplying)
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        hintText: "Add a reply",
                        height: 36,
                        trailingWidget: GestureDetector(
                          onTap: () {},
                          child: CustomSvg(asset: "assets/icons/add_image.svg"),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    CustomButton(
                      onTap: () {},
                      text: "Reply",
                      width: null,
                      padding: 20,
                      height: 36,
                      fontSize: 14,
                    ),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }
}
