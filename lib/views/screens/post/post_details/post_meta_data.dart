part of 'post_details.dart';

class PostMetaData extends StatelessWidget {
  const PostMetaData({
    super.key,
    required this.postController,
    required this.postData,
  });

  final PostController postController;
  final PostModel postData;

  @override
  Widget build(BuildContext context) {
    final index = postController.posts.indexWhere((val) => val.id == postData.id);
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(24),
      child: Obx(
        () => Row(
          children: [
            GestureDetector(
              onTap: () {
                Get.to(
                  () => Profile(userId: postController.posts.elementAt(index).author.id),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Post by:',
                    style: AppTexts.tsmr.copyWith(color: AppColors.gray.shade600),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      AbsorbPointer(
                        child: ProfilePicture(
                          image: postController.posts.elementAt(index).author.image,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        postController.posts.elementAt(index).author.name,
                        style: AppTexts.tmdb.copyWith(color: AppColors.gray.shade700),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Spacer(),
            CustomSvg(asset: 'assets/icons/view.svg'),
            const SizedBox(width: 4),
            Text(
              postController.posts.elementAt(index).views.toString(),
              style: AppTexts.tsmr,
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: () => postController.saveToggle(postController.posts.elementAt(index).id),
              child: Row(
                children: [
                  CustomSvg(
                    asset:
                        'assets/icons/${postController.posts.elementAt(index).isSaved ? 'saved' : 'save'}.svg',
                  ),
                  const SizedBox(width: 4),
                  Text(
                    postController.posts.elementAt(index).totalSaved.toString(),
                    style: AppTexts.tsmr,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: () {
                postController
                    .likeToggle(postController.posts.elementAt(index).id, 'post')
                    .then((message) {});
              },
              child: Row(
                children: [
                  CustomSvg(
                    asset:
                        'assets/icons/${postController.posts.elementAt(index).isLiked ? 'loved' : 'love'}.svg',
                  ),
                  const SizedBox(width: 4),
                  Text(
                    postController.posts.elementAt(index).likes.toString(),
                    style: AppTexts.tsmr,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
