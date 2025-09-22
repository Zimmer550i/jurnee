import 'package:flutter/material.dart';
import 'package:jurnee/utils/app_colors.dart';
import 'package:jurnee/utils/app_texts.dart';
import 'package:jurnee/utils/custom_svg.dart';
import 'package:jurnee/views/base/custom_app_bar.dart';
import 'package:jurnee/views/base/custom_button.dart';
import 'package:jurnee/views/base/custom_networked_image.dart';
import 'package:jurnee/views/base/profile_picture.dart';

class PostDetails extends StatelessWidget {
  const PostDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Event-Details",
        trailing: "assets/icons/share.svg",
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              CustomNetworkedImage(
                height: MediaQuery.of(context).size.width / 2,
                width: MediaQuery.of(context).size.width,
                radius: 0,
              ),

              Padding(
                padding: EdgeInsetsGeometry.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Night at Casa Verde",
                            style: AppTexts.dxss.copyWith(
                              color: AppColors.gray.shade700,
                            ),
                          ),
                        ),
                        PopupMenuButton(
                          onSelected: (value) {
                            
                          },
                          menuPadding: EdgeInsets.zero,
                          color: AppColors.green,
                          itemBuilder: (_) => [
                            PopupMenuItem(value: "1", child: Container(
                              color: AppColors.scaffoldBG,
                              
                            )),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "0.8 mi • Tonight 6:00 PM",
                      style: AppTexts.tmdm.copyWith(
                        color: AppColors.gray.shade400,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      spacing: 4,
                      children: [
                        CustomSvg(asset: "assets/icons/location.svg", size: 24),
                        Expanded(
                          child: Text(
                            "2118 Thornridge Cir",
                            style: AppTexts.tmdm.copyWith(
                              color: AppColors.gray.shade400,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      spacing: 4,
                      children: [
                        for (int i = 0; i < 5; i++)
                          CustomSvg(asset: "assets/icons/star.svg", size: 24),
                        Expanded(
                          child: Text(
                            "4.7",
                            style: AppTexts.tlgm.copyWith(
                              color: AppColors.gray.shade400,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Text(
                          "Post by:",
                          style: AppTexts.tlgr.copyWith(
                            color: AppColors.gray.shade600,
                          ),
                        ),
                        const SizedBox(width: 12),
                        ProfilePicture(
                          image: "https://thispersondoesnotexist.com",
                          size: 32,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Jacob Jones",
                          style: AppTexts.tlgm.copyWith(
                            color: AppColors.gray.shade700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Street-style music, live music, patio seating",
                      style: AppTexts.tlgr.copyWith(
                        color: AppColors.gray.shade600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      spacing: 4,
                      children: [
                        CustomSvg(asset: "assets/icons/eye.svg", size: 24),
                        Text(
                          "100+",
                          style: AppTexts.tsmr.copyWith(color: AppColors.gray),
                        ),
                        const SizedBox(width: 4),
                        CustomSvg(asset: "assets/icons/save.svg", size: 24),
                        Text(
                          "50+",
                          style: AppTexts.tsmr.copyWith(color: AppColors.gray),
                        ),
                        const SizedBox(width: 4),
                        CustomSvg(asset: "assets/icons/love.svg", size: 24),
                        Text(
                          "23",
                          style: AppTexts.tsmr.copyWith(color: AppColors.gray),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Text(
                          "Attending",
                          style: AppTexts.tlgm.copyWith(color: AppColors.gray),
                        ),
                        Spacer(),
                        SizedBox(
                          width: 79,
                          height: 26,
                          child: Stack(
                            children: [
                              for (int i = 0; i < 5; i++)
                                Positioned(
                                  left: 12.0 * i,
                                  child: Container(
                                    padding: EdgeInsets.all(1),
                                    decoration: BoxDecoration(
                                      color: AppColors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: ProfilePicture(
                                      image:
                                          "https://thispersondoesnotexist.com",
                                      size: 24,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        Text(
                          "+42",
                          style: AppTexts.txsr.copyWith(color: AppColors.gray),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "See all",
                          style: AppTexts.txss.copyWith(
                            color: AppColors.green.shade600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Photos / Videos",
                      style: AppTexts.tlgm.copyWith(
                        color: AppColors.gray.shade600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    GridView(
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                      ),
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        for (int i = 0; i < 5; i++)
                          CustomNetworkedImage(radius: 12),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "#hashtag" * 9,
                      style: AppTexts.tsmr.copyWith(
                        color: AppColors.green.shade700,
                      ),
                    ),
                    const SizedBox(height: 32),
                    CustomButton(text: "Attending"),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
