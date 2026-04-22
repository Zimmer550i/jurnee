part of 'post_details.dart';

class PostComments extends StatefulWidget {
  const PostComments({
    super.key,
    required this.sectionKey,
    required this.index,
  });

  final GlobalKey sectionKey;
  final int index;

  @override
  State<PostComments> createState() => _PostCommentsState();
}

class _PostCommentsState extends State<PostComments> {
  final commentController = TextEditingController();
  File? commentImage;
  File? commentVideo;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final post = Get.find<PostController>();
      final i = widget.index;
      if (i >= 0 && i < post.posts.length) {
        post.fetchComments(post.posts[i].id).then((message) {
          if (message != "success") {
            customSnackBar(message);
          }
        });
      }
    });
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: widget.sectionKey,
      color: Colors.white,
      padding: EdgeInsets.all(24),
      child: Obx(
        () {
          final postController = Get.find<PostController>();
          final postData = postController.posts[widget.index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Comments (${postController.commentReviewCount.value})',
                style: AppTexts.tmdb,
              ),
              const SizedBox(height: 16),
              if (postController.isFirstLoad.value)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomLoading(),
                ),
              if (!postController.isFirstLoad.value)
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        hintText: 'Add a comment',
                        controller: commentController,
                        trailingWidget: GestureDetector(
                          onTap: () async {
                            final file = await ImagePicker().pickMedia();
                            if (file != null) {
                              setState(() {
                                final pickedFile = File(file.path);
                                if (isVideoMedia(
                                  path: file.path,
                                  mimeType: file.mimeType,
                                )) {
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
                              ? CustomSvg(asset: 'assets/icons/add_image.svg')
                              : ClipRRect(
                                  borderRadius: BorderRadiusGeometry.circular(4),
                                  child: SizedBox(
                                    height: 36,
                                    width: 36,
                                    child: MediaThumbnail(
                                      showPlayButton: false,
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
                    postController.commentLoading.value == postData.id
                        ? CustomLoading()
                        : CustomButton(
                            onTap: () {
                              postController
                                  .createComment(
                                    postData.id,
                                    commentController.text,
                                    commentImage,
                                    commentVideo,
                                  )
                                  .then((message) {
                                    if (message != 'success') {
                                      customSnackBar(message);
                                    } else {
                                      postController.getMedia(postData.id);
                                      setState(() {
                                        commentController.clear();
                                        commentImage = null;
                                        commentVideo = null;
                                      });
                                    }
                                  });
                            },
                            text: 'Post',
                            width: null,
                            padding: 20,
                            height: 36,
                            fontSize: 14,
                          ),
                  ],
                ),
              Divider(height: 32, color: AppColors.gray.shade100),
              if (postController.comments.isEmpty)
                Center(child: noData('No comments yet')),
              ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  _assignCommentKeys(
                    postController.comments.elementAt(index),
                  );
                  return CommentWidget(
                    comment: postController.comments.elementAt(index),
                    postData: postData,
                  );
                },
                separatorBuilder: (context, index) =>
                    Divider(height: 32, color: AppColors.gray.shade100),
                itemCount: postController.comments.length,
              ),
              if (postController.isMoreLoading.value)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomLoading(),
                ),
            ],
          );
        },
      ),
    );
  }

  void _assignCommentKeys(CommentModel comment) {
    if (comment.parentComment == null) {
      commentKeys[comment.id] = GlobalKey();
    }
    for (var child in comment.children) {
      _assignCommentKeys(child);
    }
  }
}
