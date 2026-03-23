import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jurnee/models/post_model.dart';
import 'package:jurnee/utils/app_colors.dart';
import 'package:jurnee/utils/app_texts.dart';
import 'package:jurnee/utils/custom_list_handler.dart';
import 'package:jurnee/utils/no_data.dart';
import 'package:jurnee/views/base/custom_app_bar.dart';
import 'package:jurnee/views/base/profile_picture.dart';
import 'package:jurnee/views/screens/profile/profile.dart';

class UsersList extends StatefulWidget {
  final String title;
  final List<Author>? data;
  final Function(bool) getListMethod;
  const UsersList({
    super.key,
    this.data,
    required this.title,
    required this.getListMethod,
  });

  @override
  State<UsersList> createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  List<Author>? data;

  @override
  void initState() {
    super.initState();
    if (widget.data != null && widget.data!.isNotEmpty) {
      data = widget.data!;
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPersistentFrameCallback(
      (_) => widget.getListMethod(false),
    );
    return Scaffold(
      appBar: CustomAppBar(title: widget.title),
      body: CustomListHandler(
        onRefresh: () => widget.getListMethod(false),
        onLoadMore: () => widget.getListMethod(true),
        child: Column(
          spacing: 20,
          children: [
            const SizedBox(height: 0),
            if (data == null)
              Center(
                child: noData(
                  "No one ${widget.title.substring(0, 1).toLowerCase() + widget.title.substring(1)}",
                ),
              ),
            if (data != null)
              for (var i in data!)
                GestureDetector(
                  onTap: () {
                    Get.to(() => Profile(userId: i.id));
                  },
                  child: Row(
                    spacing: 16,
                    children: [
                      AbsorbPointer(
                        child: ProfilePicture(image: i.image, size: 52),
                      ),
                      Text(
                        i.name,
                        style: AppTexts.tlgm.copyWith(
                          color: AppColors.gray.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
            const SizedBox(height: 0),
          ],
        ),
      ),
    );
  }
}
