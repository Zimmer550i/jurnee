import 'dart:io';
import 'dart:math';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:jurnee/controllers/chat_controller.dart';
import 'package:jurnee/controllers/post_controller.dart';
import 'package:jurnee/controllers/user_controller.dart';
import 'package:jurnee/models/comment_model.dart';
import 'package:jurnee/models/moment_model.dart';
import 'package:jurnee/models/post_model.dart';
import 'package:jurnee/utils/app_colors.dart';
import 'package:jurnee/utils/app_texts.dart';
import 'package:jurnee/utils/custom_snackbar.dart';
import 'package:jurnee/utils/custom_svg.dart';
import 'package:jurnee/utils/formatter.dart';
import 'package:jurnee/utils/media_type.dart';
import 'package:jurnee/utils/no_data.dart';
import 'package:jurnee/views/base/comment_widget.dart';
import 'package:jurnee/views/base/custom_app_bar.dart';
import 'package:jurnee/views/base/custom_button.dart';
import 'package:jurnee/views/base/custom_loading.dart';
import 'package:jurnee/views/base/custom_text_field.dart';
import 'package:jurnee/views/base/media_player.dart';
import 'package:jurnee/views/base/media_thumbnail.dart';
import 'package:jurnee/views/base/profile_picture.dart';
import 'package:jurnee/views/base/review_widget.dart';
import 'package:jurnee/views/screens/home/post_location.dart';
import 'package:jurnee/views/screens/home/users_list.dart';
import 'package:jurnee/views/screens/post/post_alert.dart';
import 'package:jurnee/views/screens/post/post_deal.dart';
import 'package:jurnee/views/screens/post/post_event.dart';
import 'package:jurnee/views/screens/post/post_details/redeem_code_sheet.dart';
import 'package:jurnee/views/screens/post/post_service.dart';
import 'package:jurnee/views/screens/profile/boost_post.dart';
import 'package:jurnee/views/screens/profile/profile.dart';
import 'package:page_indicator_plus/page_indicator_plus.dart';
import 'package:share_plus/share_plus.dart';
part 'attending_users.dart';
part 'missing_person_info.dart';
part 'owner_action_buttons.dart';
part 'post_comments.dart';
part 'post_description.dart';
part 'post_delete_sheet.dart';
part 'post_earnings.dart';
part 'post_information.dart';
part 'post_meta_data.dart';
part 'post_buttons.dart';
part 'post_cover.dart';
part 'post_media.dart';
part 'post_reviews.dart';
part 'report_post_button.dart';

Map<String, GlobalKey> commentKeys = {};

class PostDetails extends StatefulWidget {
  final PostModel? post;
  final bool showPostActions;
  final String? postId;
  const PostDetails(
    this.post, {
    super.key,
    this.showPostActions = false,
    this.postId,
  });

  @override
  State<PostDetails> createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetails> {
  final post = Get.find<PostController>();
  final listController = ScrollController();
  final GlobalKey commentSectionKey = GlobalKey();
  PostModel? postData;

  @override
  void initState() {
    super.initState();
    resolvePostData();
  }

  void resolvePostData() async {
    if (widget.post != null) {
      postData = widget.post!;
      post.addViewCount(postData!.id);
    } else {
      await post.addViewCount(widget.postId!);
      try {
        postData = post.posts.firstWhere(
          (element) => element.id == widget.postId,
        );
      } catch (e) {
        customSnackBar("Post not found");
      }
      setState(() {});
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (postData!.category != "service") {
        post.fetchComments(postData!.id).then((message) {
          if (message != "success") {
            customSnackBar(message);
          }
        });
      } else {
        post.fetchReviews(postData!.id).then((message) {
          if (message != "success") {
            customSnackBar(message);
          }
        });
      }
      post.getMedia(postData!.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (postData == null) {
      return Scaffold(
        backgroundColor: AppColors.gray[50],
        appBar: CustomAppBar(title: ""),
        body: Center(child: CustomLoading()),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.gray[50],
      appBar: CustomAppBar(
        title:
            "${postData!.category.substring(0, 1).toUpperCase()}${postData!.category.substring(1)} Details",
        trailing: "assets/icons/share.svg",
        trailingAction: () {
          final deepLink = "https://jurnee.app/post/${postData!.id}";

          SharePlus.instance.share(
            ShareParams(
              text: "Check out ${postData!.title} on Jurnee:\n$deepLink",
              subject: "Jurnee Post",
            ),
          );
        },
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollInfo) {
          if (scrollInfo.metrics.pixels >=
                  scrollInfo.metrics.maxScrollExtent - 200 &&
              !post.isFirstLoad.value) {
            if (postData!.category != "service") {
              post.fetchComments(postData!.id, loadMore: true).then((message) {
                if (message != "success") {
                  customSnackBar(message);
                }
              });
            } else {
              post.fetchReviews(postData!.id, loadMore: true).then((message) {
                if (message != "success") {
                  customSnackBar(message);
                }
              });
            }
          }

          return false;
        },
        child: SingleChildScrollView(
          controller: listController,
          physics: ClampingScrollPhysics(),
          child: SafeArea(
            bottom: false,
            child: Column(
              children: [
                PostCover(post: postData!, context: context),

                Column(
                  spacing: 8,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PostInformation(
                      postData: postData!,
                      onSeeAllTap: () {
                        final sectionContext = commentSectionKey.currentContext;
                        if (sectionContext == null) return;
                        Scrollable.ensureVisible(
                          sectionContext,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          alignment: 0,
                        );
                      },
                    ),
                    if (widget.showPostActions) PostEarnings(),
                    PostDescription(
                      postData: postData!,
                      showPostActions: widget.showPostActions,
                      commentSectionKey: commentSectionKey,
                    ),
                    PostMetaData(postController: post, postData: postData!),
                    if (postData!.category == "event")
                      AttendingUsers(post: postData!),
                    PostMedia(postData: postData!, postController: post),

                    if (widget.showPostActions)
                      OwnerActionButtons(
                        post: postData!,
                        onDeleteTap: () => showPostDeleteSheet(
                          context,
                          postController: post,
                          postData: postData!,
                        ),
                      ),

                    if (postData!.category != "service")
                      PostComments(
                        sectionKey: commentSectionKey,
                        postController: post,
                        postData: postData!,
                      ),
                    if (postData!.category == "service")
                      PostReviews(
                        sectionKey: commentSectionKey,
                        postController: post,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
