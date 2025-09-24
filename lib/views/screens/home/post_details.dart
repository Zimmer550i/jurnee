import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jurnee/utils/app_colors.dart';
import 'package:jurnee/utils/app_texts.dart';
import 'package:jurnee/utils/custom_svg.dart';
import 'package:jurnee/views/base/custom_app_bar.dart';
import 'package:jurnee/views/base/custom_button.dart';
import 'package:jurnee/views/base/custom_networked_image.dart';
import 'package:jurnee/views/base/custom_text_field.dart';
import 'package:jurnee/views/base/profile_picture.dart';
import 'package:jurnee/views/screens/home/users_list.dart';
import 'package:jurnee/views/screens/profile/boost_post.dart';

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
                            showModalBottomSheet(
                              context: context,
                              backgroundColor: AppColors.scaffoldBG,
                              builder: (context) {
                                return SafeArea(
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 24,
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 60),
                                          Text(
                                            "Why you are reporting this post?",
                                            style: AppTexts.txsb,
                                          ),
                                          const SizedBox(height: 8),
                                          CustomTextField(
                                            lines: 5,
                                            hintText: "Start writing...",
                                          ),
                                          const SizedBox(height: 24),
                                          CustomButton(
                                            onTap: () {
                                              Get.back();
                                            },
                                            text: "Submit",
                                          ),
                                          const SizedBox(height: 24),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          menuPadding: EdgeInsets.zero,
                          color: AppColors.white,
                          itemBuilder: (_) => [
                            PopupMenuItem(
                              value: "1",
                              child: Row(
                                spacing: 8,
                                children: [
                                  Transform.translate(
                                    offset: Offset(0, 2),
                                    child: CustomSvg(
                                      asset: "assets/icons/report.svg",
                                    ),
                                  ),
                                  Text(
                                    "Report",
                                    style: AppTexts.tsms.copyWith(
                                      color: AppColors.green.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
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
                    Column(
                      spacing: 24,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Total Earnings",
                              style: AppTexts.tlgm.copyWith(
                                color: AppColors.gray,
                              ),
                            ),
                            Text(
                              "\$500",
                              style: AppTexts.txlb.copyWith(
                                color: AppColors.gray.shade700,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Units Sold",
                              style: AppTexts.tlgm.copyWith(
                                color: AppColors.gray,
                              ),
                            ),
                            Text(
                              "10/40",
                              style: AppTexts.txlb.copyWith(
                                color: AppColors.gray.shade700,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Unit Price",
                              style: AppTexts.tlgm.copyWith(
                                color: AppColors.gray,
                              ),
                            ),
                            Text(
                              "\$50",
                              style: AppTexts.txlb.copyWith(
                                color: AppColors.gray.shade700,
                              ),
                            ),
                          ],
                        ),

                        InkWell(
                          onTap: () {
                            Get.to(() => UsersList(title: "Attending"));
                          },
                          child: Row(
                            children: [
                              Text(
                                "Attending",
                                style: AppTexts.tlgm.copyWith(
                                  color: AppColors.gray,
                                ),
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
                                style: AppTexts.txsr.copyWith(
                                  color: AppColors.gray,
                                ),
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        Text(
                          "Missing Person’s Information",
                          style: AppTexts.tlgm.copyWith(
                            color: AppColors.gray.shade600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Name: John Doe",
                          style: AppTexts.tmdr.copyWith(color: AppColors.gray),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Age: 21",
                          style: AppTexts.tmdr.copyWith(color: AppColors.gray),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Clothing Info: wearing red shirt & black pant",
                          style: AppTexts.tmdr.copyWith(color: AppColors.gray),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Contact Info: name@example.com",
                          style: AppTexts.tmdr.copyWith(color: AppColors.gray),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "#hashtag" * 9,
                      style: AppTexts.tsmr.copyWith(
                        color: AppColors.green.shade700,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Text(
                          "Start From",
                          style: AppTexts.tmdr.copyWith(color: AppColors.gray),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "\$200",
                          style: AppTexts.dxss.copyWith(
                            color: AppColors.gray.shade700,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "Expires in 7 days",
                      style: AppTexts.tmdm.copyWith(
                        color: AppColors.gray.shade400,
                      ),
                    ),
                    const SizedBox(height: 32),
                    CustomButton(
                      onTap: () {
                        Get.to(() => BoostPost());
                      },
                      text: "Boost Post",
                    ),
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
