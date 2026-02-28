import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jurnee/controllers/post_controller.dart';
import 'package:jurnee/models/comment_model.dart';
import 'package:jurnee/models/post_model.dart';
import 'package:jurnee/utils/app_colors.dart';
import 'package:jurnee/utils/app_texts.dart';
import 'package:jurnee/utils/custom_snackbar.dart';
import 'package:jurnee/utils/custom_svg.dart';
import 'package:jurnee/utils/formatter.dart';
import 'package:jurnee/views/base/custom_button.dart';
import 'package:jurnee/views/base/custom_loading.dart';
import 'package:jurnee/views/base/custom_networked_image.dart';
import 'package:jurnee/views/base/custom_text_field.dart';
import 'package:jurnee/views/base/media_player.dart';
import 'package:jurnee/views/base/media_thumbnail.dart';
import 'package:jurnee/views/base/profile_picture.dart';
import 'package:jurnee/views/base/video_widget.dart';

class CommentWidget extends StatefulWidget {
  final CommentModel comment;
  final bool isReply;
  final PostModel postData;
  const CommentWidget({
    super.key,
    required this.comment,
    this.isReply = false,
    required this.postData,
  });

  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  final post = Get.find<PostController>();

  bool isReplying = false;
  bool isLiked = false;

  final commentController = TextEditingController();
  File? commentImage;
  File? commentVideo;

  @override
  void initState() {
    super.initState();
    isLiked = widget.comment.liked;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 12,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProfilePicture(size: 32, image: widget.comment.user.image),
        Expanded(
          child: Column(
            spacing: 12,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                spacing: 12,
                children: [
                  Text(
                    widget.comment.user.name,
                    style: AppTexts.tmdb.copyWith(
                      color: AppColors.gray.shade700,
                    ),
                  ),
                  Text(
                    Formatter.durationFormatter(
                      DateTime.now().difference(widget.comment.createdAt),
                    ),
                    style: AppTexts.txss.copyWith(
                      color: AppColors.green.shade700,
                    ),
                  ),
                ],
              ),
              if (widget.comment.content.isNotEmpty)
                Text(
                  widget.comment.content,
                  style: AppTexts.tmdr.copyWith(color: AppColors.gray.shade700),
                ),
              if (widget.comment.image?.isNotEmpty ?? false)
                GestureDetector(
                  onTap: () => Get.to(
                    () => MediaPlayer(
                      postData: widget.postData,
                      mediaList: [widget.comment.image],
                    ),
                  ),
                  child: CustomNetworkedImage(
                    url: widget.comment.image,
                    height: 200,
                  ),
                ),
              if (widget.comment.video?.isNotEmpty ?? false)
                ClipRRect(
                  borderRadius: BorderRadiusGeometry.circular(12),
                  child: SizedBox(
                    height: 200,
                    child: GestureDetector(
                      onTap: () =>
                          Get.to(() => VideoWidget(widget.comment.video)),
                      child: MediaThumbnail(path: widget.comment.video),
                    ),
                  ),
                ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      post.likeToggle(
                        widget.comment.id,
                        widget.isReply ? "reply" : "comment",
                      );
                    },
                    child: Row(
                      children: [
                        CustomSvg(
                          asset:
                              "assets/icons/${widget.comment.liked == true ? "loved" : "love"}.svg",
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          widget.comment.like.toString(),
                          style: AppTexts.tsms.copyWith(
                            color: AppColors.gray.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 24),
                  if (!widget.isReply)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isReplying = !isReplying;
                        });
                      },
                      child: Row(
                        children: [
                          CustomSvg(
                            asset: "assets/icons/message.svg",
                            size: 16,
                            color: AppColors.black,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "Reply",
                            style: AppTexts.tsms.copyWith(
                              color: AppColors.gray.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              if (isReplying)
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        height: 36,
                        hintText: "Add a reply",
                        controller: commentController,
                        trailingWidget: GestureDetector(
                          onTap: () async {
                            final file = await ImagePicker().pickMedia();
                            if (file != null) {
                              setState(() {
                                final pickedFile = File(file.path);
                                if (file.mimeType?.startsWith('video/') ??
                                    false) {
                                  commentVideo = pickedFile;
                                  commentImage = null;
                                } else {
                                  commentImage = pickedFile;
                                  commentVideo = null;
                                }
                              });
                            }
                          },
                          child: commentImage == null && commentVideo == null
                              ? CustomSvg(asset: "assets/icons/add_image.svg")
                              : ClipRRect(
                                  borderRadius: BorderRadiusGeometry.circular(
                                    4,
                                  ),
                                  child: SizedBox(
                                    height: 36,
                                    child: MediaThumbnail(
                                      path:
                                          commentImage?.path ??
                                          commentVideo?.path,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    post.commentLoading.value == widget.comment.id
                        ? CustomLoading()
                        : CustomButton(
                            onTap: () {
                              post
                                  .createReply(
                                    widget.comment.id,
                                    commentController.text,
                                    commentImage,
                                    commentVideo,
                                  )
                                  .then((message) {
                                    if (message != "success") {
                                      customSnackBar(message);
                                    } else {
                                      setState(() {
                                        commentController.clear();
                                        commentImage = null;
                                        commentVideo = null;
                                      });
                                    }
                                  });
                            },
                            text: "Reply",
                            width: null,
                            padding: 12,
                            height: 36,
                            fontSize: 14,
                          ),
                  ],
                ),
              for (var i in widget.comment.reply)
                CommentWidget(
                  comment: i,
                  isReply: true,
                  postData: widget.postData,
                ),
            ],
          ),
        ),
      ],
    );
  }
}
