import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jurnee/controllers/user_controller.dart';
import 'package:jurnee/utils/app_colors.dart';
import 'package:jurnee/utils/app_texts.dart';
import 'package:jurnee/utils/custom_svg.dart';
import 'package:jurnee/views/base/custom_bottom_navbar.dart';
import 'package:jurnee/views/screens/auth/user_interests.dart';
import 'package:jurnee/views/screens/home/homepage.dart';
import 'package:jurnee/views/screens/messages/messages.dart';
import 'package:jurnee/views/screens/notifications/notifications.dart';
import 'package:jurnee/views/screens/post/post_alert.dart';
import 'package:jurnee/views/screens/post/post_deal.dart';
import 'package:jurnee/views/screens/post/post_event.dart';
import 'package:jurnee/views/screens/post/post_service.dart';
import 'package:jurnee/views/screens/profile/profile.dart';

final GlobalKey<HomepageState> _globalKey = GlobalKey();

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int index = 0;
  bool showOverlay = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.find<UserController>().userData!.interested.isEmpty) {
        Get.to(() => UserInterests());
      }
    });
  }

  List<Widget> pages = [
    Homepage(key: _globalKey),
    Messages(),
    Notifications(),
    Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          pages[index],
          if (showOverlay)
            GestureDetector(
              onTap: () {
                setState(() {
                  showOverlay = false;
                });
              },
              child: Container(color: AppColors.black.withValues(alpha: 0.37)),
            ),
          Positioned(
            bottom: 20,
            left: 24,
            right: 24,
            child: TweenAnimationBuilder(
              tween: Tween(begin: 0.0, end: showOverlay ? 3.0 : 0.0),
              duration: Duration(milliseconds: 100),
              builder: (context, value, child) {
                return BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: value, sigmaY: value),
                  child: Transform.scale(
                    scale: value / 3,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
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
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      showOverlay = false;
                                    });
                                    Get.to(() => PostEvent());
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: AppColors.green[50],
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Column(
                                      children: [
                                        CustomSvg(
                                          asset: "assets/icons/event.svg",
                                        ),
                                        Text(
                                          "Event",
                                          style: AppTexts.tmdb.copyWith(
                                            color: AppColors.gray.shade600,
                                          ),
                                        ),
                                        Text(
                                          "Share upcoming activities, concerts, meetups",
                                          textAlign: TextAlign.center,
                                          style: AppTexts.txsr.copyWith(
                                            color: AppColors.gray.shade500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      showOverlay = false;
                                    });
                                    Get.to(() => PostDeal());
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: AppColors.green[50],
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Column(
                                      children: [
                                        CustomSvg(
                                          asset: "assets/icons/deal.svg",
                                        ),
                                        Text(
                                          "Deal",
                                          style: AppTexts.tmdb.copyWith(
                                            color: AppColors.gray.shade600,
                                          ),
                                        ),
                                        Text(
                                          "Promote discounts, specials, flash offers",
                                          textAlign: TextAlign.center,
                                          style: AppTexts.txsr.copyWith(
                                            color: AppColors.gray.shade500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      showOverlay = false;
                                    });
                                    Get.to(() => PostService());
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: AppColors.green[50],
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Column(
                                      children: [
                                        CustomSvg(
                                          asset: "assets/icons/service.svg",
                                        ),
                                        Text(
                                          "Service",
                                          style: AppTexts.tmdb.copyWith(
                                            color: AppColors.gray.shade600,
                                          ),
                                        ),
                                        Text(
                                          "Add professional services with availability & pricing",
                                          textAlign: TextAlign.center,
                                          style: AppTexts.txsr.copyWith(
                                            color: AppColors.gray.shade500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      showOverlay = false;
                                    });
                                    Get.to(() => PostAlert());
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: AppColors.green[50],
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Column(
                                      children: [
                                        CustomSvg(
                                          asset: "assets/icons/alerts.svg",
                                        ),
                                        Text(
                                          "Alerts",
                                          style: AppTexts.tmdb.copyWith(
                                            color: AppColors.gray.shade600,
                                          ),
                                        ),
                                        Text(
                                          "Quick community updates (road closures, lost pet)",
                                          textAlign: TextAlign.center,
                                          style: AppTexts.txsr.copyWith(
                                            color: AppColors.gray.shade500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButton: showOverlay || index != 0
          ? null
          : GestureDetector(
              onTap: () {
                final state = _globalKey.currentState;

                if (state != null) {
                  state.setState(() {
                    state.showMap = !state.showMap;
                  });
                }
                // Get.to(
                //   () => Homepage(showMap: true),
                //   transition: Transition.noTransition,
                // );
              },
              child: Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  color: AppColors.green.shade600,
                  shape: BoxShape.circle,
                ),
                child: Center(child: CustomSvg(asset: "assets/icons/map.svg")),
              ),
            ),
      bottomNavigationBar: CustomBottomNavbar(
        index: index,
        showOverlay: showOverlay,
        onChanged: (val) {
          setState(() {
            index = val;
          });
        },
        onShowOverlay: () {
          setState(() {
            showOverlay = !showOverlay;
          });
        },
      ),
    );
  }
}
