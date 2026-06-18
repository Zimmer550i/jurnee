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
    final parentState =
        context.findAncestorStateOfType<_PostDetailsState>();
    int index = postController.posts.indexWhere((val) => val.id == postData.id);
    if (index == -1) {
      index = Get.find<UserController>().posts.indexWhere(
        (val) => val.id == postData.id,
      );
    }
    // final index = 0;
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(24),
      child: Obx(() {
        if (index == -1) {
          return SizedBox(
            width: double.infinity,
            child: Text("Reload this page"),
          );
        }
        final currentPost = postController.posts.elementAt(index);
        return Row(
          children: [
            GestureDetector(
              onTap: () {
                if (parentState != null && !parentState._isLoggedIn) {
                  parentState._onAuthRequired();
                  return;
                }
                Get.to(
                  () => Profile(
                    userId: currentPost.author.id,
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Post by:',
                    style: AppTexts.tsmr.copyWith(
                      color: AppColors.gray.shade600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      AbsorbPointer(
                        child: ProfilePicture(
                          image: currentPost.author.image,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        currentPost.author.name,
                        style: AppTexts.tmdb.copyWith(
                          color: AppColors.gray.shade700,
                        ),
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
              currentPost.views.toString(),
              style: AppTexts.tsmr,
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: () {
                if (parentState != null && !parentState._isLoggedIn) {
                  parentState._onAuthRequired();
                  return;
                }
                postController.saveToggle(currentPost.id);
              },
              child: Row(
                children: [
                  CustomSvg(
                    asset:
                        'assets/icons/${currentPost.isSaved ? 'saved' : 'save'}.svg',
                  ),
                  const SizedBox(width: 4),
                  Text(
                    currentPost.totalSaved.toString(),
                    style: AppTexts.tsmr,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: () {
                if (parentState != null && !parentState._isLoggedIn) {
                  parentState._onAuthRequired();
                  return;
                }
                postController
                    .likeToggle(
                      currentPost.id,
                      'post',
                    )
                    .then((message) {});
              },
              child: Row(
                children: [
                  CustomSvg(
                    asset:
                        'assets/icons/${currentPost.isLiked ? 'loved' : 'love'}.svg',
                  ),
                  const SizedBox(width: 4),
                  Text(
                    currentPost.likes.toString(),
                    style: AppTexts.tsmr,
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}

