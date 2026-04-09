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
  final PostModel post;
  final bool showPostActions;
  const PostDetails(this.post, {super.key, this.showPostActions = false});

  @override
  State<PostDetails> createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetails> {
  final post = Get.find<PostController>();
  final listController = ScrollController();
  final GlobalKey commentSectionKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.post.category != "service") {
        post.fetchComments(widget.post.id).then((message) {
          if (message != "success") {
            customSnackBar(message);
          }
        });
      } else {
        post.fetchReviews(widget.post.id).then((message) {
          if (message != "success") {
            customSnackBar(message);
          }
        });
      }
      post.addViewCount(widget.post.id);
      post.getMedia(widget.post.id, type: "owner");
      post.getMedia(widget.post.id, type: "community");
    });
  }

  @override
  Widget build(BuildContext context) {
    var isOwner =
        widget.post.author.id == Get.find<UserController>().userData!.id;
    return Scaffold(
      backgroundColor: AppColors.gray[50],
      appBar: CustomAppBar(
        title:
            "${widget.post.category.substring(0, 1).toUpperCase()}${widget.post.category.substring(1)} Details",
        trailing: "assets/icons/share.svg",
        trailingAction: () {
          final deepLink = "https://jurnee.app/post/${widget.post.id}";

          SharePlus.instance.share(
            ShareParams(
              text: "Check out ${widget.post.title} on Jurnee:\n$deepLink",
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
            if (widget.post.category != "service") {
              post.fetchComments(widget.post.id, loadMore: true).then((
                message,
              ) {
                if (message != "success") {
                  customSnackBar(message);
                }
              });
            } else {
              post.fetchReviews(widget.post.id, loadMore: true).then((message) {
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
                PostCover(widget: widget, post: post, context: context),

                Column(
                  spacing: 8,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PostInformation(
                      postData: widget.post,
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
                    if (isOwner && widget.showPostActions) PostEarnings(),
                    PostDescription(
                      postData: widget.post,
                      showPostActions: widget.showPostActions,
                      commentSectionKey: commentSectionKey,
                    ),
                    PostMetaData(postController: post, postData: widget.post),
                    if (widget.post.category == "event")
                      AttendingUsers(post: widget.post),
                    PostMedia(postData: widget.post, postController: post),

                    if (isOwner && widget.showPostActions)
                      OwnerActionButtons(
                        post: widget.post,
                        onDeleteTap: () => showPostDeleteSheet(
                          context,
                          postController: post,
                          postData: widget.post,
                        ),
                      ),

                    if (widget.post.category != "service")
                      PostComments(
                        sectionKey: commentSectionKey,
                        postController: post,
                        postData: widget.post,
                      ),
                    if (widget.post.category == "service")
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
