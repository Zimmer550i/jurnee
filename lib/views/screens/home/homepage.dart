import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:get/get.dart';
import 'package:jurnee/controllers/post_controller.dart';
import 'package:jurnee/utils/app_colors.dart';
import 'package:jurnee/utils/app_texts.dart';
import 'package:jurnee/utils/custom_list_handler.dart';
import 'package:jurnee/utils/custom_snackbar.dart';
import 'package:jurnee/utils/custom_svg.dart';
import 'package:jurnee/views/base/banner_ad_widget.dart';
import 'package:jurnee/views/base/custom_loading.dart';
import 'package:jurnee/views/base/native_ad_widget.dart';
import 'package:jurnee/views/base/post_card.dart';
import 'package:jurnee/views/base/search_widget.dart';
import 'package:jurnee/views/screens/home/location_map.dart';
import 'package:jurnee/views/screens/post/post_alert.dart';
import 'package:jurnee/views/screens/post/post_deal.dart';
import 'package:jurnee/views/screens/post/post_event.dart';
import 'package:jurnee/views/screens/post/post_service.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => HomepageState();
}

class HomepageState extends State<Homepage> {
  final post = Get.find<PostController>();
  final search = TextEditingController();
  int tab = 0;
  bool searchEnabled = false;
  bool showMap = false;

  final List<String?> categoryList = [
    null,
    'event',
    'deal',
    'service',
    'alert',
  ];

  @override
  void initState() {
    super.initState();
    post.fetchPosts().then((message) {
      if (message != "success") {
        customSnackBar(message);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              AppBar(
                // toolbarHeight: 50,
                automaticallyImplyLeading: false,
                backgroundColor: AppColors.scaffoldBG,
                surfaceTintColor: Colors.transparent,
                titleSpacing: 0,
                title: Row(
                  children: [
                    const SizedBox(width: 24),
                    CustomSvg(asset: "assets/icons/logo.svg", height: 22),
                    Spacer(),
                    InkWell(
                      onTap: () {
                        setState(() {
                          searchEnabled = true;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: isFiltering()
                            ? BoxDecoration(
                                color: AppColors.green.shade600,
                                borderRadius: BorderRadius.circular(4),
                                boxShadow: [
                                  BoxShadow(
                                    offset: Offset(0, 2),
                                    blurRadius: 2,
                                    color: Colors.black.withValues(alpha: 0.4),
                                  ),
                                ],
                              )
                            : null,
                        child: CustomSvg(
                          asset: "assets/icons/search.svg",
                          color: isFiltering() ? AppColors.green[25] : null,
                        ),
                      ),
                    ),
                    const SizedBox(width: 24),
                  ],
                ),
              ),
              // const SizedBox(height: 12 ,),
              if (!isFiltering())
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 8,
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    clipBehavior: Clip.none,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      spacing: 8,
                      children: [
                        tabs("All", "assets/icons/icon.svg", 0),
                        tabs("Events", "assets/icons/event.svg", 1),
                        tabs("Deals", "assets/icons/deal.svg", 2),
                        tabs("Services", "assets/icons/service.svg", 3),
                        tabs("Alerts", "assets/icons/alert.svg", 4),
                      ],
                    ),
                  ),
                ),

              Container(
                width: double.infinity,
                height: 1,
                color: AppColors.gray.shade200,
              ),
              showMap
                  ? Expanded(child: LocationMap())
                  : Expanded(
                      child: Obx(
                        () => CustomListHandler(
                          isLoading: post.isFirstLoad.value,
                          horizontalPadding: 16,
                          onRefresh: () => post
                              .fetchPosts(category: categoryList[tab])
                              .then((message) {
                                if (message != "success") {
                                  customSnackBar(message);
                                }
                              }),
                          onLoadMore: () => post.fetchPosts(
                            loadMore: true,
                            category: categoryList[tab],
                          ),
                          child: Column(
                            children: [
                              const SizedBox(height: 12),
                              for (int i = 0; i < post.posts.length; i++) ...[
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: PostCard(post.posts.elementAt(i)),
                                ),

                                if (i != 1 && i % 4 == 0) NativeAdWidget(),
                                if (i != 1 && i % 4 == 0) BannerAdWidget(),
                              ],
                              if (post.isMoreLoading.value) CustomLoading(),
                              if (!post.isMoreLoading.value)
                                post.posts.isEmpty
                                    ? _emptyFeedMessage()
                                    : Text(
                                        "End of results",
                                        style: AppTexts.tsmr.copyWith(
                                          color: AppColors.gray.shade300,
                                        ),
                                      ),
                              const SizedBox(height: 24),
                            ],
                          ),
                        ),
                      ),
                    ),
            ],
          ),

          if (searchEnabled)
            Column(
              children: [
                SearchWidget(search),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        searchEnabled = false;
                      });
                    },
                    child: Container(
                      color: AppColors.black.withValues(alpha: 0.37),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget tabs(String title, String? icon, int index) {
    bool isSelected = index == tab;
    return GestureDetector(
      onTap: () {
        setState(() {
          tab = index;
          post.fetchPosts(category: categoryList[tab]).then((message) {
            if (message != "success") {
              customSnackBar(message);
            }
          });
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 100),
        padding: EdgeInsets.symmetric(
          vertical: 6,
          horizontal: isSelected ? 16 : 8,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.green.shade600 : Colors.white,
          border: isSelected
              ? null
              : Border.all(color: AppColors.gray.shade300),
          borderRadius: BorderRadius.circular(27),
        ),
        child: Row(
          spacing: 4,
          children: [
            if (icon != null)
              CustomSvg(
                asset: icon,
                size: 16,
                color: isSelected ? Colors.white : AppColors.gray.shade500,
              ),
            Text(
              title,
              style: AppTexts.txsm.copyWith(
                color: isSelected ? Colors.white : AppColors.gray.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyFeedMessage() {
    String emptyText;
    String addText;

    switch (tab) {
      case 1:
        emptyText = "No events yet. ";
        addText = "Add an event";
        break;
      case 2:
        emptyText = "No deals yet. ";
        addText = "Add a deal";
        break;
      case 3:
        emptyText = "No services yet. ";
        addText = "Add a service";
        break;
      case 4:
        emptyText = "No alerts yet. ";
        addText = "Add an alert";
        break;
      default:
        emptyText = "No post yet. ";
        addText = "Add a post";
    }

    return Text.rich(
      TextSpan(
        style: AppTexts.tsmr,
        children: [
          TextSpan(text: emptyText),
          TextSpan(
            text: addText,
            style: AppTexts.tsmr.copyWith(color: AppColors.green.shade700),
            recognizer: TapGestureRecognizer()
              ..onTap = _openCreatePostForCurrentTab,
          ),
          const TextSpan(text: "."),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }

  void _openCreatePostForCurrentTab() {
    switch (tab) {
      case 1:
        Get.to(() => PostEvent());
        break;
      case 2:
        Get.to(() => PostDeal());
        break;
      case 3:
        Get.to(() => PostService());
        break;
      case 4:
        Get.to(() => PostAlert());
        break;
      default:
        Get.bottomSheet(
          Container(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Create Post",
                    style: AppTexts.tlgs.copyWith(
                      color: AppColors.gray.shade700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ListTile(
                    title: const Text("Event"),
                    onTap: () {
                      Get.back();
                      Get.to(() => PostEvent());
                    },
                  ),
                  ListTile(
                    title: const Text("Deal"),
                    onTap: () {
                      Get.back();
                      Get.to(() => PostDeal());
                    },
                  ),
                  ListTile(
                    title: const Text("Service"),
                    onTap: () {
                      Get.back();
                      Get.to(() => PostService());
                    },
                  ),
                  ListTile(
                    title: const Text("Alert"),
                    onTap: () {
                      Get.back();
                      Get.to(() => PostAlert());
                    },
                  ),
                ],
              ),
            ),
          ),
        );
    }
  }

  bool isFiltering() {
    if (post.customLocation.value != null ||
        post.fromDate.value != null ||
        post.toDate.value != null ||
        post.minPrice.value != null ||
        post.maxPrice.value != null ||
        post.search.value != null ||
        post.customLocation.value != null ||
        post.highlyRated.value == true ||
        post.categoryList.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }
}
