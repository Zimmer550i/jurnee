import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jurnee/controllers/auth_controller.dart';
import 'package:jurnee/controllers/chat_controller.dart';
import 'package:jurnee/controllers/user_controller.dart';
import 'package:jurnee/utils/app_colors.dart';
import 'package:jurnee/utils/app_texts.dart';
import 'package:jurnee/utils/custom_list_handler.dart';
import 'package:jurnee/utils/custom_snackbar.dart';
import 'package:jurnee/utils/custom_svg.dart';
import 'package:jurnee/views/base/custom_app_bar.dart';
import 'package:jurnee/views/base/custom_button.dart';
import 'package:jurnee/views/base/custom_loading.dart';
import 'package:jurnee/views/base/post_card.dart';
import 'package:jurnee/views/base/profile_picture.dart';
import 'package:jurnee/views/screens/auth/login.dart';
import 'package:jurnee/views/screens/profile/app_info.dart';
import 'package:jurnee/views/screens/profile/edit_profile.dart';
import 'package:jurnee/views/screens/profile/bookings.dart';
import 'package:jurnee/views/screens/profile/support.dart';

class Profile extends StatefulWidget {
  final String? userId;
  const Profile({super.key, this.userId});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final user = Get.find<UserController>();
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  int index = 0;

  @override
  void initState() {
    super.initState();
    getSpecificUserData();
    user.getUserPosts(index, widget.userId ?? user.userData?.id);
  }

  void getSpecificUserData() async {
    if (widget.userId == null) return;
    final message = await user.getSpecificUserInfo(widget.userId!);

    if (message != "success") {
      customSnackBar(message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      endDrawerEnableOpenDragGesture: false,
      appBar: widget.userId == null
          ? AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: AppColors.scaffoldBG,
              surfaceTintColor: Colors.transparent,
              titleSpacing: 0,
              title: Row(
                children: [
                  const SizedBox(width: 24),
                  CustomSvg(asset: "assets/icons/logo.svg", height: 22),
                  Spacer(),
                  const SizedBox(width: 24),
                ],
              ),
            )
          : CustomAppBar(title: "Profile"),
      endDrawer: widget.userId == null ? drawer(context) : null,
      body: CustomListHandler(
        onRefresh: () => widget.userId == null
            ? user.getUserData()
            : user.getSpecificUserInfo(widget.userId!),

        onLoadMore: () => user.getUserPosts(
          index,
          widget.userId ?? user.userData?.id,
          loadMore: true,
        ),
        child: Obx(
          () => user.isLoading.value
              ? CustomLoading()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    ProfilePicture(
                      image: widget.userId != null
                          ? user.specificUser.value?.image
                          : user.userImage,
                      size: 144,
                      borderWidth: 2,
                      borderColor: AppColors.green,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      (widget.userId != null
                              ? user.specificUser.value?.name
                              : user.userData?.name) ??
                          "Loading...",
                      style: AppTexts.dxsb.copyWith(
                        color: AppColors.gray.shade700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      spacing: 4,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomSvg(
                          asset: "assets/icons/location.svg",
                          color: AppColors.gray,
                        ),
                        Text(
                          (widget.userId != null
                                  ? user.specificUser.value?.address
                                  : user.userData?.address) ??
                              "Loading...",
                          style: AppTexts.tsmr.copyWith(color: AppColors.gray),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      (widget.userId != null
                              ? user.specificUser.value?.bio
                              : user.userData?.bio) ??
                          "Loading...",
                      textAlign: TextAlign.center,
                      style: AppTexts.tsmr.copyWith(
                        color: AppColors.gray.shade600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        // Spacer(),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              // Get.to(
                              //   () => UsersList(
                              //     title: "Posts (${user.userData?.post.toString()})",
                              //   ),
                              // );
                            },
                            child: Column(
                              children: [
                                Text(
                                  (widget.userId != null
                                          ? user.specificUser.value?.post
                                                .toString()
                                          : user.userData?.post.toString()) ??
                                      "",
                                  style: AppTexts.dxsm.copyWith(
                                    color: AppColors.gray.shade700,
                                  ),
                                ),
                                Text(
                                  "Posts",
                                  style: AppTexts.tsmr.copyWith(
                                    color: AppColors.gray,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              // Get.to(
                              //   () => UsersList(
                              //     title:
                              //         "Followers (${user.userData?.followers.toString()})",
                              //   ),
                              // );
                            },
                            child: Column(
                              children: [
                                if (widget.userId != null)
                                  Obx(
                                    () => Text(
                                      user.specificUser.value!.followers
                                          .toString(),
                                      style: AppTexts.dxsm.copyWith(
                                        color: AppColors.gray.shade700,
                                      ),
                                    ),
                                  ),
                                if (widget.userId == null)
                                  Text(
                                    user.userData!.followers.toString(),
                                    style: AppTexts.dxsm.copyWith(
                                      color: AppColors.gray.shade700,
                                    ),
                                  ),
                                Text(
                                  "Followers",
                                  style: AppTexts.tsmr.copyWith(
                                    color: AppColors.gray,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              // Get.to(
                              //   () => UsersList(
                              //     title:
                              //         "Following (${user.userData?.following.toString()})",
                              //   ),
                              // );
                            },
                            child: Column(
                              children: [
                                if (widget.userId != null)
                                  Obx(
                                    () => Text(
                                      user.specificUser.value!.following
                                          .toString(),
                                      style: AppTexts.dxsm.copyWith(
                                        color: AppColors.gray.shade700,
                                      ),
                                    ),
                                  ),
                                if (widget.userId == null)
                                  Text(
                                    user.userData!.following.toString(),
                                    style: AppTexts.dxsm.copyWith(
                                      color: AppColors.gray.shade700,
                                    ),
                                  ),
                                Text(
                                  "Following",
                                  style: AppTexts.tsmr.copyWith(
                                    color: AppColors.gray,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Spacer(),
                      ],
                    ),
                    if (widget.userId != null &&
                        user.userData!.id != widget.userId)
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Row(
                          children: [
                            Expanded(
                              child: Obx(
                                () => CustomButton(
                                  onTap: () {
                                    user.followUnfollowUser(widget.userId!);
                                  },
                                  isSecondary:
                                      user.specificUser.value!.isFollow,
                                  isLoading: user.isFollowLoading.value,
                                  leading: "assets/icons/follow.svg",
                                  text: user.specificUser.value!.isFollow
                                      ? "Unfollow"
                                      : "Follow",
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Obx(
                                () => CustomButton(
                                  onTap: () => Get.find<ChatController>()
                                      .createOrGetChat(widget.userId!),
                                  isLoading: Get.find<ChatController>()
                                      .isLoading
                                      .value,
                                  leading: "assets/icons/message.svg",
                                  text: "Message",
                                  isSecondary: true,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                index = 0;
                              });
                              user
                                  .getUserPosts(
                                    index,
                                    widget.userId ?? user.userData?.id,
                                  )
                                  .then((message) {
                                    if (message != "success") {
                                      customSnackBar(message);
                                    }
                                  });
                            },
                            child: Container(
                              height: 48,
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: index == 0
                                      ? BorderSide(
                                          color: AppColors.green.shade600,
                                        )
                                      : BorderSide.none,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  "Posts",
                                  style: AppTexts.tmds.copyWith(
                                    color: index == 0
                                        ? AppColors.green.shade600
                                        : AppColors.gray.shade400,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                index = 1;
                              });
                              user
                                  .getUserPosts(
                                    index,
                                    widget.userId ?? user.userData?.id,
                                  )
                                  .then((message) {
                                    if (message != "success") {
                                      customSnackBar(message);
                                    }
                                  });
                            },
                            child: Container(
                              height: 48,
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: index == 1
                                      ? BorderSide(
                                          color: AppColors.green.shade600,
                                        )
                                      : BorderSide.none,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  "Attending",
                                  style: AppTexts.tmds.copyWith(
                                    color: index == 1
                                        ? AppColors.green.shade600
                                        : AppColors.gray.shade400,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (widget.userId == null)
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  index = 2;
                                });
                                user
                                    .getUserPosts(
                                      index,
                                      widget.userId ?? user.userData?.id,
                                    )
                                    .then((message) {
                                      if (message != "success") {
                                        customSnackBar(message);
                                      }
                                    });
                              },
                              child: Container(
                                height: 48,
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: index == 2
                                        ? BorderSide(
                                            color: AppColors.green.shade600,
                                          )
                                        : BorderSide.none,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    "Saved",
                                    style: AppTexts.tmds.copyWith(
                                      color: index == 2
                                          ? AppColors.green.shade600
                                          : AppColors.gray.shade400,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Obx(
                      () => Column(
                        children: [
                          if (!user.isFirstLoad.value)
                            for (var i in user.posts)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: PostCard(i),
                              ),

                          if (user.isFirstLoad.value) CustomLoading(),
                          if (user.isMoreLoading.value) CustomLoading(),
                          if (!user.isMoreLoading.value &&
                              !user.isFirstLoad.value &&
                              user.totalPages.value <= user.currentPage.value)
                            Text(
                              "End of list",
                              style: AppTexts.tsmr.copyWith(
                                color: AppColors.gray.shade300,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Container drawer(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      decoration: BoxDecoration(color: Colors.white),
      child: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              drawerButton("Edit Profile", "edit", () {
                Get.back();
                Get.to(() => EditProfile());
              }),
              // drawerButton("Orders", "order_history", () {
              //   Get.back();
              //   Get.to(() => EditProfile());
              // }),
              drawerButton("My Orders", "calendar", () {
                Get.back();
                Get.to(() => Bookings());
              }),
              drawerButton("Client Orders", "client", () {
                Get.back();
                Get.to(() => Bookings(showClientBooking: true));
              }),
              drawerButton("Boosted Posts", "boost", () {
                Get.back();
                // TODO: Add Boosted Posts Page
                Get.to(() => Bookings(showClientBooking: true));
              }),
              drawerButton("Community Guidelines", "guidelines", () {
                Get.back();
                Get.to(() => AppInfo(title: "Community Guidelines"));
              }),
              drawerButton("Terms of Services", "terms", () {
                Get.back();
                Get.to(() => AppInfo(title: "Terms of Services"));
              }),
              drawerButton("Privacy Policy", "privacy", () {
                Get.back();
                Get.to(() => AppInfo(title: "Privacy Policy"));
              }),
              drawerButton("About Us", "about", () {
                Get.back();
                Get.to(() => AppInfo(title: "About Us"));
              }),
              drawerButton("Support", "support", () {
                Get.back();
                Get.to(() => Support());
              }),
              drawerButton("Logout", "log-out", () {
                Get.back();
                logoutSheet(context);
              }),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  GestureDetector drawerButton(
    String name,
    String iconName,
    void Function() onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.7,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.gray.shade700)),
        ),
        child: Row(
          spacing: 8,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CustomSvg(
              asset: "assets/icons/$iconName.svg",
              size: 24,
              color: AppColors.green,
            ),
            Text(name, style: AppTexts.tmdm.copyWith(color: AppColors.gray)),
          ],
        ),
      ),
    );
  }

  Future<dynamic> logoutSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return SafeArea(
          child: Container(
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Color(0xffE0E0E0))),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 24),
                Text(
                  "Logout",
                  style: AppTexts.tlgb.copyWith(color: AppColors.red),
                ),
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  height: 1,
                  color: AppColors.gray.shade100,
                ),
                const SizedBox(height: 24),
                Text(
                  "Are you sure you want to log out?",
                  style: AppTexts.tlgs.copyWith(color: AppColors.gray.shade400),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    const SizedBox(width: 40),
                    Expanded(
                      child: CustomButton(
                        text: "Yes, Logout",
                        padding: 0,
                        isSecondary: true,
                        onTap: () async {
                          Get.back();
                          Get.find<AuthController>().logout();
                          customSnackBar(
                            "You have been logged out!",
                            isError: false,
                          );
                          Get.offAll(() => Login());
                        },
                      ),
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: CustomButton(
                        text: "Cancel",
                        onTap: () {
                          Get.back();
                        },
                      ),
                    ),
                    const SizedBox(width: 40),
                  ],
                ),
                const SizedBox(height: 48),
              ],
            ),
          ),
        );
      },
    );
  }
}
