import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jurnee/controllers/post_controller.dart';
import 'package:jurnee/utils/app_colors.dart';
import 'package:jurnee/utils/app_texts.dart';
import 'package:jurnee/utils/custom_snackbar.dart';
import 'package:jurnee/views/base/boost_result_widget.dart';
import 'package:jurnee/views/base/custom_app_bar.dart';
import 'package:jurnee/views/base/custom_loading.dart';

class BoostResults extends StatelessWidget {
  final List<BoostResultItem>? items;

  const BoostResults({super.key, this.items});

  @override
  Widget build(BuildContext context) {
    final post = Get.find<PostController>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      post.getBoostedPosts().then((message) {
        if (message != "success") {
          customSnackBar(message);
        }
      });
    });

    return Scaffold(
      backgroundColor: AppColors.scaffoldBG,
      appBar: const CustomAppBar(title: "Boost Results"),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  "Boost keeps your post on top of the feed for 24 hours.\nLocal relevance (within 25 mile)",
                  style: AppTexts.tlgr.copyWith(color: AppColors.gray.shade400),
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: Obx(() {
                  if (post.isLoading.value) {
                    return CustomLoading();
                  } else if (post.posts.isEmpty) {
                    return Center(
                      child: Text(
                        "No boosted posts yet",
                        style: AppTexts.tsmr.copyWith(
                          color: AppColors.gray.shade400,
                        ),
                      ),
                    );
                  }
                  return ListView.separated(
                    itemCount: post.posts.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, i) {
                      final item = post.posts[i];
                      if (item.boost ?? false) {
                        return BoostResultWidget(
                          post: item,
                          hoursRemaining: item.boostActivatedAt!
                              .add(Duration(days: 1))
                              .difference(DateTime.now())
                              .inHours,
                        );
                      } else {
                        return Container();
                      }
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
