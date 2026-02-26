import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jurnee/controllers/post_controller.dart';
import 'package:jurnee/utils/app_colors.dart';
import 'package:jurnee/utils/app_texts.dart';
import 'package:jurnee/utils/custom_list_handler.dart';
import 'package:jurnee/utils/custom_svg.dart';
import 'package:jurnee/views/base/custom_loading.dart';
import 'package:jurnee/views/base/post_card.dart';
import 'package:jurnee/views/base/search_widget.dart';
import 'package:jurnee/views/screens/home/location_map.dart';

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
    post.fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              AppBar(
                toolbarHeight: 50,
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      tabs("All", "assets/icons/icon.svg", 0),
                      tabs("Events", "assets/icons/event.svg", 1),
                      tabs("Deals", "assets/icons/deal.svg", 2),
                      tabs("Services", "assets/icons/service.svg", 3),
                      tabs("Alerts", "assets/icons/alert.svg", 4),
                    ],
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
                          onRefresh: () =>
                              post.fetchPosts(category: categoryList[tab]),
                          onLoadMore: () => post.fetchPosts(
                            loadMore: true,
                            category: categoryList[tab],
                          ),
                          child: Column(
                            children: [
                              const SizedBox(height: 12),
                              for (var i in post.posts)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: PostCard(i),
                                ),
                              if (post.isMoreLoading.value) CustomLoading(),
                              if (!post.isMoreLoading.value)
                                Text(
                                  "End of list",
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
          post.fetchPosts(category: categoryList[tab]);
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

  bool isFiltering() {
    if (post.customLocation.value != null ||
        post.date.value != null ||
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
