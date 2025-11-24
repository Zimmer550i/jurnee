import 'package:flutter/material.dart';
import 'package:jurnee/utils/app_colors.dart';
import 'package:jurnee/utils/app_texts.dart';
import 'package:jurnee/utils/custom_list_handler.dart';
import 'package:jurnee/views/base/custom_app_bar.dart';
import 'package:jurnee/views/base/profile_picture.dart';

class UsersList extends StatelessWidget {
  final String title;
  final Function(bool) getListMethod;
  const UsersList({
    super.key,
    required this.title,
    required this.getListMethod,
  });

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPersistentFrameCallback(
      (_) => getListMethod(false),
    );
    return Scaffold(
      appBar: CustomAppBar(title: title),
      body: CustomListHandler(
        onRefresh: () => getListMethod(false),
        onLoadMore: () => getListMethod(true),
        child: Column(
          spacing: 20,
          children: [
            const SizedBox(height: 0),
            for (int i = 0; i < 20; i++)
              Row(
                spacing: 16,
                children: [
                  ProfilePicture(
                    image: "https://thispersondoesnotexist.com",
                    size: 52,
                  ),
                  Text(
                    "Sample Name",
                    style: AppTexts.tlgm.copyWith(
                      color: AppColors.gray.shade700,
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 0),
          ],
        ),
      ),
    );
  }
}
