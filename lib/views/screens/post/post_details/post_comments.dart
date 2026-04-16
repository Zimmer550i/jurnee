part of 'post_details.dart';

class PostComments extends StatefulWidget {
  const PostComments({
    super.key,
    required this.sectionKey,
    required this.postController,
    required this.postData,
  });

  final GlobalKey sectionKey;
  final PostController postController;
  final PostModel postData;

  @override
  State<PostComments> createState() => _PostCommentsState();
}

class _PostCommentsState extends State<PostComments> {
  final commentController = TextEditingController();
  File? commentImage;
  File? commentVideo;

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
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Comments (${widget.postController.commentReviewCount.value})',
              style: AppTexts.tmdb,
            ),
            const SizedBox(height: 16),
            if (widget.postController.isFirstLoad.value)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomLoading(),
              ),
            if (!widget.postController.isFirstLoad.value)
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
                  widget.postController.commentLoading.value ==
                          widget.postData.id
                      ? CustomLoading()
                      : CustomButton(
                          onTap: () {
                            widget.postController
                                .createComment(
                                  widget.postData.id,
                                  commentController.text,
                                  commentImage,
                                  commentVideo,
                                )
                                .then((message) {
                                  if (message != 'success') {
                                    customSnackBar(message);
                                  } else {
                                    widget.postController.getMedia(
                                      widget.postData.id,
                                      type: 'community',
                                    );
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
            if (widget.postController.comments.isEmpty)
              Center(child: noData('No comments yet')),
            ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                _assignCommentKeys(
                  widget.postController.comments.elementAt(index),
                );
                return CommentWidget(
                  comment: widget.postController.comments.elementAt(index),
                  postData: widget.postData,
                );
              },
              separatorBuilder: (context, index) =>
                  Divider(height: 32, color: AppColors.gray.shade100),
              itemCount: widget.postController.comments.length,
            ),
            if (widget.postController.isMoreLoading.value)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomLoading(),
              ),
          ],
        ),
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
