import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jurnee/controllers/user_controller.dart';
import 'package:jurnee/models/post_model.dart';
import 'package:jurnee/utils/app_colors.dart';
import 'package:jurnee/utils/app_texts.dart';
import 'package:jurnee/utils/custom_list_handler.dart';
import 'package:jurnee/utils/custom_snackbar.dart';
import 'package:jurnee/utils/no_data.dart';
import 'package:jurnee/views/base/custom_app_bar.dart';
import 'package:jurnee/views/base/profile_picture.dart';
import 'package:jurnee/views/screens/profile/profile.dart';

class UsersList extends StatefulWidget {
  final String title;
  final List<Author>? data;
  final Future<String> Function(bool)? getListMethod;
  const UsersList({
    super.key,
    this.data,
    required this.title,
    this.getListMethod,
  });

  @override
  State<UsersList> createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  final UserController userController = Get.find<UserController>();
  List<Author> data = [];
  bool isUsingDirectData = false;

  @override
  void initState() {
    super.initState();
    if (widget.data != null) {
      isUsingDirectData = true;
      data = List<Author>.from(widget.data!);
    } else if (widget.getListMethod != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _loadUsers());
    }
  }

  Future<void> _loadUsers({bool loadMore = false}) async {
    if (widget.getListMethod == null) return;
    final res = await widget.getListMethod!(loadMore);
    if (!mounted) return;
    if (res == "success") {
      setState(() {
        data = List<Author>.from(userController.usersList);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isUsingDirectData) {
      return Scaffold(
        appBar: CustomAppBar(title: widget.title),
        body: CustomListHandler(child: _buildListContent(showLoadMore: false)),
      );
    }

    return Scaffold(
      appBar: CustomAppBar(title: widget.title),
      body: Obx(
        () => CustomListHandler(
          isLoading: userController.isFirstLoad.value,
          onRefresh: widget.getListMethod != null ? () => _loadUsers() : null,
          onLoadMore: widget.getListMethod != null
              ? () => _loadUsers(loadMore: true)
              : null,
          child: _buildListContent(
            showLoadMore: userController.isMoreLoading.value,
          ),
        ),
      ),
    );
  }

  Widget _buildListContent({required bool showLoadMore}) {
    return Column(
      spacing: 20,
      children: [
        const SizedBox(height: 0),
        if (data.isEmpty)
          Center(
            child: noData(
              "No one ${widget.title.substring(0, 1).toLowerCase() + widget.title.substring(1)}",
            ),
          ),
        for (var i in data)
          GestureDetector(
            onTap: () {
              if (i.id != null) {
                Get.to(() => Profile(userId: i.id));
              } else {
                customSnackBar("Couldn't go to user profile");
              }
            },
            child: Row(
              spacing: 16,
              children: [
                AbsorbPointer(child: ProfilePicture(image: i.image, size: 52)),
                Text(
                  i.name,
                  style: AppTexts.tlgm.copyWith(color: AppColors.gray.shade700),
                ),
              ],
            ),
          ),
        if (showLoadMore)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        const SizedBox(height: 0),
      ],
    );
  }
}
