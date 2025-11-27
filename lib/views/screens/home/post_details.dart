import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jurnee/controllers/post_controller.dart';
import 'package:jurnee/controllers/user_controller.dart';
import 'package:jurnee/models/post_model.dart';
import 'package:jurnee/utils/app_colors.dart';
import 'package:jurnee/utils/app_texts.dart';
import 'package:jurnee/utils/custom_svg.dart';
import 'package:jurnee/views/base/custom_app_bar.dart';
import 'package:jurnee/views/base/custom_button.dart';
import 'package:jurnee/views/base/custom_networked_image.dart';
import 'package:jurnee/views/base/custom_text_field.dart';
import 'package:jurnee/views/base/media_player.dart';
import 'package:jurnee/views/base/media_thumbnail.dart';
import 'package:jurnee/views/base/profile_picture.dart';
import 'package:jurnee/views/screens/home/reviews.dart';
import 'package:jurnee/views/screens/home/users_list.dart';
import 'package:jurnee/views/screens/profile/boost_post.dart';
import 'package:jurnee/views/screens/profile/profile.dart';

class PostDetails extends StatelessWidget {
  final PostModel post;
  const PostDetails(this.post, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Event Details",
        trailing: "assets/icons/share.svg",
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  Get.to(
                    () => MediaPlayer(
                      postData: post,
                      preferedStart: post.image,
                      mediaList: [post.image, ...post.media ?? []],
                    ),
                  );
                },
                child: CustomNetworkedImage(
                  url: post.image,
                  height: MediaQuery.of(context).size.width / 2,
                  width: MediaQuery.of(context).size.width,
                  radius: 0,
                ),
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
                            post.title.toString(),
                            style: AppTexts.dxss.copyWith(
                              color: AppColors.gray.shade700,
                            ),
                          ),
                        ),
                        PopupMenuButton(
                          onSelected: (value) {
                            showModalBottomSheet(
                              context: context,
                              useSafeArea: true,
                              backgroundColor: AppColors.scaffoldBG,
                              builder: (context) {
                                return SizedBox(
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
                    if (post.subcategory != null)
                      Container(
                        margin: EdgeInsets.only(bottom: 8, top: 8),
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: AppColors.green.shade200,
                        ),
                        child: Text(
                          post.subcategory ?? "sfa",
                          style: AppTexts.tsms.copyWith(
                            color: AppColors.green.shade900,
                          ),
                        ),
                      ),
                    Text(
                      "${Get.find<PostController>().getDistance(post.location.coordinates[0], post.location.coordinates[1])} • ${post.startDate != null ? DateFormat("dd MMM, hh:mm a").format(post.startDate!) : ""}",
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
                            post.address.toString(),
                            style: AppTexts.tmdm.copyWith(
                              color: AppColors.gray.shade400,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => Reviews(count: 25));
                      },
                      child: Row(
                        children: [
                          for (int i = 0; i < 5; i++)
                            CustomSvg(asset: "assets/icons/star.svg", size: 24),
                          const SizedBox(width: 4),
                          Text(
                            post.averageRating.toString(),
                            style: AppTexts.tlgm.copyWith(
                              color: AppColors.gray.shade400,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            "See All",
                            style: AppTexts.tsmr.copyWith(
                              color: AppColors.green.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => Profile(userId: post.author.id));
                      },
                      child: Row(
                        children: [
                          Text(
                            "Post by:",
                            style: AppTexts.tlgr.copyWith(
                              color: AppColors.gray.shade600,
                            ),
                          ),
                          const SizedBox(width: 12),
                          ProfilePicture(image: post.author.image, size: 32),
                          const SizedBox(width: 8),
                          Text(
                            post.author.name,
                            style: AppTexts.tlgm.copyWith(
                              color: AppColors.gray.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      post.description.toString(),
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
                          post.views.toString(),
                          style: AppTexts.tsmr.copyWith(color: AppColors.gray),
                        ),
                        const SizedBox(width: 4),
                        CustomSvg(asset: "assets/icons/save.svg", size: 24),
                        Text(
                          post.totalSaved.toString(),
                          style: AppTexts.tsmr.copyWith(color: AppColors.gray),
                        ),
                        const SizedBox(width: 4),
                        CustomSvg(asset: "assets/icons/love.svg", size: 24),
                        Text(
                          post.likes.toString(),
                          style: AppTexts.tsmr.copyWith(color: AppColors.gray),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (post.author.id !=
                        Get.find<UserController>().userData!.id)
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
                          const SizedBox(height: 0),
                        ],
                      ),
                    InkWell(
                      onTap: () {
                        Get.to(
                          () => UsersList(
                            title: "Attending",
                            getListMethod: (loadMore) {
                              return Get.find<UserController>().getFollowers();
                            },
                          ),
                        );
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
                                for (
                                  int i = 0;
                                  i < min(5, post.attenders.length);
                                  i++
                                )
                                  Positioned(
                                    left: 12.0 * i,
                                    child: Container(
                                      padding: EdgeInsets.all(1),
                                      decoration: BoxDecoration(
                                        color: AppColors.white,
                                        shape: BoxShape.circle,
                                      ),
                                      child: ProfilePicture(
                                        image: post.attenders
                                            .elementAt(i)
                                            .image,
                                        size: 24,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          if (post.attenders.length > 5)
                            Text(
                              "+${max(0, post.attenders.length - 5)}",
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
                    if (post.media != null)
                      Column(
                        spacing: 8,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 12),
                          Text(
                            "Photos / Videos",
                            style: AppTexts.tlgm.copyWith(
                              color: AppColors.gray.shade600,
                            ),
                          ),
                          GridView(
                            shrinkWrap: true,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  mainAxisSpacing: 12,
                                  crossAxisSpacing: 12,
                                ),
                            physics: NeverScrollableScrollPhysics(),
                            children: [
                              for (int i = 0; i < (post.media!.length); i++)
                                GestureDetector(
                                  onTap: () {
                                    Get.to(
                                      () => MediaPlayer(
                                        postData: post,
                                        preferedStart: post.media![i],
                                        mediaList: [
                                          post.image,
                                          ...post.media ?? [],
                                        ],
                                      ),
                                    );
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadiusGeometry.circular(
                                      12,
                                    ),
                                    child: MediaThumbnail(path: post.media![i]),
                                  ),
                                ),
                              // CustomNetworkedImage(
                              //   url: post.media![i],
                              //   radius: 12,
                              // ),
                            ],
                          ),
                        ],
                      ),
                    if (post.subcategory != null &&
                        post.subcategory == "Missing Person")
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
                            "Name: ${post.missingName}",
                            style: AppTexts.tmdr.copyWith(
                              color: AppColors.gray,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Age: ${post.missingAge}",
                            style: AppTexts.tmdr.copyWith(
                              color: AppColors.gray,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Clothing Info: ${post.clothingDescription}",
                            style: AppTexts.tmdr.copyWith(
                              color: AppColors.gray,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Contact Info: ${post.contactInfo}",
                            style: AppTexts.tmdr.copyWith(
                              color: AppColors.gray,
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 20),
                    Text(
                      post.hasTag
                              ?.map(
                                (val) => val.contains("#") ? "$val " : "#$val ",
                              )
                              .join() ??
                          "",
                      style: AppTexts.tsmr.copyWith(
                        color: AppColors.green.shade700,
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (post.price != null)
                      Row(
                        children: [
                          Text(
                            "Start From",
                            style: AppTexts.tmdr.copyWith(
                              color: AppColors.gray,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "\$${post.price}",
                            style: AppTexts.dxss.copyWith(
                              color: AppColors.gray.shade700,
                            ),
                          ),
                        ],
                      ),
                    if (post.expireLimit != null)
                      Text(
                        "Expires in ${post.expireLimit} days",
                        style: AppTexts.tmdm.copyWith(
                          color: AppColors.gray.shade400,
                        ),
                      ),
                    const SizedBox(height: 32),
                    getButton(),
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

  Widget getButton() {
    if (post.author.id == Get.find<UserController>().userData!.id) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: CustomButton(onTap: () {}, text: "Edit Post", isSecondary: true),
      );
    }

    switch (post.category) {
      default:
        return CustomButton(
          onTap: () {
            Get.to(() => BoostPost());
          },
          text: "Boost Post",
        );
    }
  }
}
