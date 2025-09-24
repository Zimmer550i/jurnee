import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jurnee/utils/app_colors.dart';
import 'package:jurnee/utils/app_texts.dart';
import 'package:jurnee/utils/custom_svg.dart';
import 'package:jurnee/views/base/custom_button.dart';
import 'package:jurnee/views/base/post_card.dart';
import 'package:jurnee/views/base/profile_picture.dart';
import 'package:jurnee/views/screens/home/users_list.dart';
import 'package:jurnee/views/screens/profile/app_info.dart';
import 'package:jurnee/views/screens/profile/edit_profile.dart';

class Profile extends StatefulWidget {
  final bool isUser;
  const Profile({super.key, this.isUser = false});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      endDrawerEnableOpenDragGesture: false,

      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.scaffoldBG,
        surfaceTintColor: Colors.transparent,
        titleSpacing: 0,
        title: Row(
          children: [
            const SizedBox(width: 24),
            CustomSvg(asset: "assets/icons/logo.svg"),
            Spacer(),
            // if (widget.isUser)
            //   GestureDetector(
            //     onTap: () {
            //       _key.currentState?.openDrawer();
            //     },
            //     child: CustomSvg(
            //       asset: "assets/icons/hamburger_menu.svg",
            //       color: AppColors.black,
            //     ),
            //   ),
            const SizedBox(width: 24),
          ],
        ),
      ),
      endDrawer: drawer(context),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            ProfilePicture(
              image: "https://thispersondoesnotexist.com",
              size: 144,
              borderWidth: 2,
              borderColor: AppColors.green,
            ),
            const SizedBox(height: 8),
            Text(
              "Sample Name",
              style: AppTexts.dxsb.copyWith(color: AppColors.gray.shade700),
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
                  "Sample Name",
                  style: AppTexts.tsmr.copyWith(color: AppColors.gray),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              "Exploring local events, deals, and hidden gems—honest reviews only",
              textAlign: TextAlign.center,
              style: AppTexts.tsmr.copyWith(color: AppColors.gray.shade600),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Get.to(() => UsersList(title: "Posts (12)"));
                    },
                    child: Column(
                      children: [
                        Text(
                          "12",
                          style: AppTexts.dxsm.copyWith(
                            color: AppColors.gray.shade700,
                          ),
                        ),
                        Text(
                          "Posts",
                          style: AppTexts.tsmr.copyWith(color: AppColors.gray),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Get.to(() => UsersList(title: "Followers (102)"));
                    },
                    child: Column(
                      children: [
                        Text(
                          "102",
                          style: AppTexts.dxsm.copyWith(
                            color: AppColors.gray.shade700,
                          ),
                        ),
                        Text(
                          "Followers",
                          style: AppTexts.tsmr.copyWith(color: AppColors.gray),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Get.to(() => UsersList(title: "Following (510)"));
                    },
                    child: Column(
                      children: [
                        Text(
                          "510",
                          style: AppTexts.dxsm.copyWith(
                            color: AppColors.gray.shade700,
                          ),
                        ),
                        Text(
                          "Following",
                          style: AppTexts.tsmr.copyWith(color: AppColors.gray),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      leading: "assets/icons/follow.svg",
                      text: "Follow",
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomButton(
                      leading: "assets/icons/message.svg",
                      text: "Message",
                      isSecondary: true,
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
                    },
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: index == 0
                              ? BorderSide(color: AppColors.green.shade600)
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
                    },
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: index == 1
                              ? BorderSide(color: AppColors.green.shade600)
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
                // if(!widget.isUser)
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        index = 2;
                      });
                    },
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: index == 2
                              ? BorderSide(color: AppColors.green.shade600)
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
            for (int i = 0; i < 10; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: PostCard(),
              ),
          ],
        ),
      ),
    );
  }

  Container drawer(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      decoration: BoxDecoration(color: Colors.white),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Get.to(() => EditProfile());
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.7,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: AppColors.green.shade300),
                  ),
                ),
                child: Row(
                  spacing: 8,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CustomSvg(asset: "assets/icons/edit.svg"),
                    Text(
                      "Edit Profile",
                      style: AppTexts.tmdm.copyWith(color: AppColors.gray),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.to(() => AppInfo(title: "Community Guidelines"));
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.7,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: AppColors.green.shade300),
                  ),
                ),
                child: Row(
                  spacing: 8,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CustomSvg(asset: "assets/icons/guidelines.svg"),
                    Text(
                      "Community Guidelines",
                      style: AppTexts.tmdm.copyWith(color: AppColors.gray),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.to(() => AppInfo(title: "Terms of Services"));
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.7,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: AppColors.green.shade300),
                  ),
                ),
                child: Row(
                  spacing: 8,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CustomSvg(asset: "assets/icons/terms.svg"),
                    Text(
                      "Terms of Services",
                      style: AppTexts.tmdm.copyWith(color: AppColors.gray),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.to(() => AppInfo(title: "Privacy Policy"));
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.7,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: AppColors.green.shade300),
                  ),
                ),
                child: Row(
                  spacing: 8,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CustomSvg(asset: "assets/icons/privacy.svg"),
                    Text(
                      "Privacy Policy",
                      style: AppTexts.tmdm.copyWith(color: AppColors.gray),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.to(() => AppInfo(title: "About Us"));
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.7,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: AppColors.green.shade300),
                  ),
                ),
                child: Row(
                  spacing: 8,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CustomSvg(asset: "assets/icons/about.svg"),
                    Text(
                      "About Us",
                      style: AppTexts.tmdm.copyWith(color: AppColors.gray),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.back();
                logoutSheet(context);
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.7,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: AppColors.green.shade300),
                  ),
                ),
                child: Row(
                  spacing: 8,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CustomSvg(asset: "assets/icons/log-out.svg"),
                    Text(
                      "Logout",
                      style: AppTexts.tmdm.copyWith(color: AppColors.gray),
                    ),
                  ],
                ),
              ),
            ),
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
                          // Get.find<AuthController>().logout();
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
