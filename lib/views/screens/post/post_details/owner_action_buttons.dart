part of 'post_details.dart';

class OwnerActionButtons extends StatelessWidget {
  const OwnerActionButtons({
    super.key,
    required this.post,
    required this.onDeleteTap,
  });

  final PostModel post;
  final VoidCallback onDeleteTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(24),
      child: Column(
        spacing: 16,
        children: [
          CustomButton(
            onTap: () => Get.to(() => BoostPost(post: post)),
            text: 'Boost Post',
          ),
          CustomButton(
            onTap: () {
              if (post.category.toLowerCase() == 'event') {
                Get.to(() => PostEvent(post: post));
              } else if (post.category.toLowerCase() == 'deal') {
                Get.to(() => PostDeal(post: post));
              } else if (post.category.toLowerCase() == 'alert') {
                Get.to(() => PostAlert(post: post));
              } else if (post.category.toLowerCase() == 'service') {
                Get.to(() => PostService(post: post));
              }
            },
            text: 'Edit Post',
            isSecondary: true,
          ),
          CustomButton(
            onTap: onDeleteTap,
            text: 'Delete Post',
            isSecondary: true,
          ),
        ],
      ),
    );
  }
}
