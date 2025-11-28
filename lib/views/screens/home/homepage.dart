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
                automaticallyImplyLeading: false,
                backgroundColor: AppColors.scaffoldBG,
                surfaceTintColor: Colors.transparent,
                titleSpacing: 0,
                title: Row(
                  children: [
                    const SizedBox(width: 24),
                    CustomSvg(asset: "assets/icons/logo.svg"),
                    Spacer(),
                    InkWell(
                      onTap: () {
                        setState(() {
                          searchEnabled = true;
                        });
                      },
                      child: CustomSvg(asset: "assets/icons/search.svg"),
                    ),
                    const SizedBox(width: 24),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    tabs("All", null, 0),
                    tabs("Events", "assets/icons/calendar.svg", 1),
                    tabs("Deals", "assets/icons/price_tag.svg", 2),
                    tabs("Services", "assets/icons/info.svg", 3),
                    tabs("Alerts", "assets/icons/wrench.svg", 4),
                  ],
                ),
              ),

              Container(
                width: double.infinity,
                height: 1,
                color: AppColors.gray.shade200,
              ),
              showMap
                  ? LocationMap()
                  : Expanded(
                      child: CustomListHandler(
                        onRefresh: () =>
                            post.fetchPosts(category: categoryList[tab]),
                        onLoadMore: () => post.fetchPosts(
                          loadMore: true,
                          category: categoryList[tab],
                        ),
                        child: Obx(
                          () => Column(
                            children: [
                              const SizedBox(height: 12),
                              if (post.isLoading.value) CustomLoading(),
                              if (!post.isLoading.value)
                                for (var i
                                    in post.postMap[PostType.defaultPosts]!)
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 20),
                                    child: PostCard(i),
                                  ),
                              if (!post.isLoading.value &&
                                  post.isMoreLoading.value)
                                CustomLoading(),
                              if (!post.isLoading.value &&
                                  post.totalPages.value ==
                                      post.currentPage.value)
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
                if (searchEnabled) SearchWidget(search),
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
                color: isSelected
                    ? AppColors.gray.shade900
                    : AppColors.gray.shade500,
              ),
            Text(
              title,
              style: AppTexts.txsm.copyWith(
                color: isSelected
                    ? AppColors.gray.shade900
                    : AppColors.gray.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
