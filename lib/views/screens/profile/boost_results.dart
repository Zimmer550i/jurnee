import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jurnee/controllers/user_controller.dart';
import 'package:jurnee/utils/app_colors.dart';
import 'package:jurnee/utils/app_texts.dart';
import 'package:jurnee/views/base/boost_result_widget.dart';
import 'package:jurnee/views/base/custom_app_bar.dart';

class BoostResults extends StatelessWidget {
  final List<BoostResultItem>? items;

  const BoostResults({super.key, this.items});

  List<BoostResultItem> _resolveItems(UserController user) {
    if (items != null) return items!;
    return user.posts
        .where((p) => p.boost == true)
        .map((p) => BoostResultItem(post: p, hoursRemaining: 11))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final user = Get.find<UserController>();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBG,
      appBar: const CustomAppBar(title: "Boost Results"),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Obx(() {
            final list = _resolveItems(user);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    "Boost keeps your post on top of the feed for 24 hours.\nLocal relevance (within 25 mile)",
                    style: AppTexts.tlgr.copyWith(
                      color: AppColors.gray.shade400,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: list.isEmpty
                      ? Center(
                          child: Text(
                            "No boosted posts yet",
                            style: AppTexts.tsmr.copyWith(
                              color: AppColors.gray.shade400,
                            ),
                          ),
                        )
                      : ListView.separated(
                          itemCount: list.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 16),
                          itemBuilder: (context, i) {
                            final item = list[i];
                            return BoostResultWidget(
                              post: item.post,
                              hoursRemaining: item.hoursRemaining,
                            );
                          },
                        ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
