import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jurnee/utils/app_colors.dart';
import 'package:jurnee/utils/app_texts.dart';
import 'package:jurnee/views/base/profile_picture.dart';
import 'package:jurnee/views/screens/messages/chat.dart';

class Messages extends StatelessWidget {
  const Messages({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          spacing: 8,
          children: [
            const SizedBox(height: 12),
            for (int i = 0; i < 16; i++) messageWidget(),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget messageWidget() {
    return GestureDetector(
      onTap: () {
        Get.to(() => Chat());
      },
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            ProfilePicture(
              image: "https://thispersondoesnotexist.com",
              size: 48,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Sample Name",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTexts.tlgs.copyWith(
                            color: AppColors.gray.shade700,
                          ),
                        ),
                      ),
                      Text(
                        "08:09 PM",
                        style: TextStyle(
                          fontFamily: "Roboto",
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          height: 24 / 14,
                          color: AppColors.gray.shade300,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Sample Message" * 3,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTexts.tmdr.copyWith(
                            color: AppColors.gray.shade400,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Container(
                        height: 16,
                        width: 16,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.green.shade600,
                        ),
                        child: Center(
                          child: Text(
                            "2",
                            style: TextStyle(
                              fontSize: 12,
                              height: 1,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
