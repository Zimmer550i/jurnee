import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:jurnee/views/base/custom_button.dart';
import 'package:jurnee/views/screens/auth/login.dart';
import 'package:motor/motor.dart';
import 'package:get/get.dart';
import 'package:jurnee/controllers/chat_controller.dart';
import 'package:jurnee/controllers/notification_controller.dart';
import 'package:jurnee/controllers/post_controller.dart';
import 'package:jurnee/controllers/user_controller.dart';
import 'package:jurnee/utils/app_colors.dart';
import 'package:jurnee/utils/app_texts.dart';
import 'package:jurnee/utils/custom_snackbar.dart';
import 'package:jurnee/utils/custom_svg.dart';
import 'package:jurnee/views/base/custom_bottom_navbar.dart';
import 'package:jurnee/views/screens/auth/user_interests.dart';
import 'package:jurnee/views/screens/home/homepage.dart';
import 'package:jurnee/views/screens/home/need_login.dart';
import 'package:jurnee/views/screens/messages/messages.dart';
import 'package:jurnee/views/screens/notifications/notifications.dart';
import 'package:jurnee/views/screens/post/post_alert.dart';
import 'package:jurnee/views/screens/post/post_deal.dart';
import 'package:jurnee/views/screens/post/post_event.dart';
import 'package:jurnee/views/screens/post/post_service.dart';
import 'package:jurnee/views/screens/profile/profile.dart';

final GlobalKey<HomepageState> homeKey = GlobalKey();

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  PageController pageController = PageController(initialPage: 0);
  final user = Get.find<UserController>();
  int index = 0;
  bool showOverlay = false;
  bool showNavBar = true;

  List<Widget> pages = [
    Homepage(key: homeKey),
    Messages(),
    Notifications(),
    Profile(),
  ];

  @override
  void initState() {
    super.initState();
    if (!user.isLoggedIn.value) {
      pages = [Homepage(key: homeKey), NeedLogin(), NeedLogin(), NeedLogin()];
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (user.userData?.interested.isEmpty ?? false) {
        Get.to(() => UserInterests());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            physics: NeverScrollableScrollPhysics(),
            controller: pageController,
            children: pages,
          ),
          if (showOverlay)
            GestureDetector(
              onTap: () {
                setState(() {
                  showOverlay = false;
                });
              },
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                child: Container(
                  color: AppColors.black.withValues(alpha: 0.37),
                ),
              ),
            ),
          Positioned(
            bottom: 20,
            left: 24,
            right: 24,
            child: _buildCreatePostOverlay(),
          ),
        ],
      ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButton: showOverlay || index != 0
          ? null
          : GestureDetector(
              onTap: () {
                final state = homeKey.currentState;

                if (state != null) {
                  state.setState(() {
                    state.showMap = !state.showMap;
                  });
                  setState(() {
                    showNavBar = !state.showMap;
                  });
                }

                final post = Get.find<PostController>();

                post.clearFilters();
                homeKey.currentState?.setState(() {
                  homeKey.currentState?.searchEnabled = false;
                });
                final userCtrl = Get.find<UserController>();
                if (userCtrl.isLoggedIn.value) {
                  post.fetchPosts().then((message) {
                    if (message != "success") customSnackBar(message);
                  });
                } else {
                  post.fetchPostsWithoutAuth().then((message) {
                    if (message != "success") customSnackBar(message);
                  });
                }
              },
              child: Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  color: AppColors.green.shade600,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: CustomSvg(
                    asset: homeKey.currentState?.showMap ?? false
                        ? "assets/icons/home.svg"
                        : "assets/icons/map.svg",
                    size: 30,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
      bottomNavigationBar: showNavBar
          ? CustomBottomNavbar(
              index: index,
              showOverlay: showOverlay,
              onChanged: (val) {
                pageController.animateToPage(
                  val,
                  duration: Duration(milliseconds: 100 * (index - val).abs()),
                  curve: Curves.decelerate,
                );
                setState(() {
                  index = val;
                });
                _fetchDataForTab(val);
              },
              onShowOverlay: () {
                setState(() {
                  showOverlay = !showOverlay;
                });
              },
            )
          : null,
    );
  }

  Widget _buildCreatePostOverlay() {
    return SingleMotionBuilder(
      motion: showOverlay
          ? CupertinoMotion.bouncy(duration: Duration(milliseconds: 200))
          : CupertinoMotion.snappy(duration: Duration(milliseconds: 200)),
      value: showOverlay ? 3.0 : 0.0,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, -(value - 3) * 50),
          child: Transform.scale(
            scale: value / 3,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: !user.isLoggedIn.value
                  ? Column(
                      children: [
                        Text("Log In to Continue", style: AppTexts.tlgs),
                        const SizedBox(height: 8),
                        Text(
                          "Sign in to your account to unlock all features and enjoy a personalized experience.",
                          style: AppTexts.tsmr.copyWith(
                            color: AppColors.gray.shade600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        CustomButton(
                          onTap: () {
                            Get.offAll(() => Login());
                          },
                          text: "Login",
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        Text(
                          "Create Post",
                          style: AppTexts.tlgs.copyWith(
                            color: AppColors.gray.shade700,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildPostOption(
                              asset: "assets/icons/event.svg",
                              title: "Event",
                              description:
                                  "Share upcoming activities, concerts, meetups",
                              onTap: () => Get.to(() => PostEvent()),
                            ),
                            const SizedBox(width: 16),
                            _buildPostOption(
                              asset: "assets/icons/deal.svg",
                              title: "Deal",
                              description:
                                  "Promote discounts, specials, flash offers",
                              onTap: () => Get.to(() => PostDeal()),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildPostOption(
                              asset: "assets/icons/service.svg",
                              title: "Service",
                              description:
                                  "Add professional services with availability & pricing",
                              onTap: () => Get.to(() => PostService()),
                            ),
                            const SizedBox(width: 16),
                            _buildPostOption(
                              asset: "assets/icons/alert.svg",
                              title: "Alerts",
                              description:
                                  "Quick community updates (road closures, lost pet)",
                              onTap: () => Get.to(() => PostAlert()),
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
  }

  Widget _buildPostOption({
    required String asset,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            showOverlay = false;
          });
          onTap();
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.gray[50],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              CustomSvg(asset: asset),
              Text(
                title,
                style: AppTexts.tmdb.copyWith(color: AppColors.gray.shade600),
              ),
              Text(
                description,
                textAlign: TextAlign.center,
                style: AppTexts.txsr.copyWith(color: AppColors.gray.shade500),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _fetchDataForTab(int tabIndex) {
    if (!user.isLoggedIn.value) return;

    switch (tabIndex) {
      case 0:
        Get.find<PostController>().fetchPosts().then((message) {
          if (message != "success") customSnackBar(message);
        });
        break;
      case 1:
        Get.find<ChatController>().fetchChats().then((message) {
          if (message != "success") customSnackBar(message);
        });
        user.getMyServices();
        break;
      case 2:
        Get.find<NotificationController>().fetchNotifications();
        break;
      case 3:
        user.getUserPosts(Profile.index, user.userData?.id).then((message) {
          if (message != "success") customSnackBar(message);
        });
        break;
    }
  }
}
