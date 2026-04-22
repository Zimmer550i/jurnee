part of 'post_details.dart';

class PostReviews extends StatefulWidget {
  const PostReviews({
    super.key,
    required this.sectionKey,
    required this.index,
  });

  final GlobalKey sectionKey;
  final int index;

  @override
  State<PostReviews> createState() => _PostReviewsState();
}

class _PostReviewsState extends State<PostReviews> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final post = Get.find<PostController>();
      final i = widget.index;
      if (i >= 0 && i < post.posts.length) {
        post.fetchReviews(post.posts[i].id).then((message) {
          if (message != "success") {
            customSnackBar(message);
          }
        });
      }
    });
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
          postController.posts[widget.index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Reviews (${postController.commentReviewCount.value})',
                style: AppTexts.tmdb,
              ),
              const SizedBox(height: 16),
              if (postController.isFirstLoad.value)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomLoading(),
                ),
              if (postController.reviews.isEmpty)
                Center(child: noData('No reviews yet')),
              ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) => ReviewWidget(
                  review: postController.reviews.elementAt(index),
                ),
                separatorBuilder: (context, index) =>
                    Divider(height: 32, color: AppColors.gray.shade100),
                itemCount: postController.reviews.length,
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
}
