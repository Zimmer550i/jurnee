part of 'post_details.dart';

class PostReviews extends StatelessWidget {
  const PostReviews({
    super.key,
    required this.sectionKey,
    required this.postController,
  });

  final GlobalKey sectionKey;
  final PostController postController;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: sectionKey,
      color: Colors.white,
      padding: EdgeInsets.all(24),
      child: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Reviews', style: AppTexts.tmdb),
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
              itemBuilder: (context, index) =>
                  ReviewWidget(review: postController.reviews.elementAt(index)),
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
        ),
      ),
    );
  }
}
