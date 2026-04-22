part of 'post_details.dart';

class PostButtons extends StatelessWidget {
  const PostButtons({
    super.key,
    required this.postData,
    required this.commentSectionKey,
  });

  final PostModel postData;
  final GlobalKey commentSectionKey;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final category = postData.category.toLowerCase();
      String buttonText = "Request Quote";
      VoidCallback buttonAction = () {
        if (postData.author.id != null) {
          Get.find<ChatController>().createOrGetChat(
            postData.author.id!,
            postTitle: postData.title,
          );
        } else {
          customSnackBar("Can't start chat with this user");
        }
      };

      if (category == "event") {
        final post = Get.find<PostController>().posts.firstWhere(
          (element) => element.id == postData.id,
        );
        buttonText = post.isAttender == true ? "Attending" : "Attend";
        buttonAction = () async {
          final message = await Get.find<PostController>().joinEvent(
            postData.id,
          );
          if (message != "success") {
            customSnackBar(message);
          } else {
            customSnackBar("You have joined the event", isError: false);
          }
        };
      } else if (category == "deal") {
        buttonText = "Get Deal";
        buttonAction = () {
          showRedeemCodeSheet(context, postData);
        };
      } else if (category == "alert") {
        buttonText = "Add Comment";
        buttonAction = () {
          final target = commentSectionKey.currentContext;
          if (target != null) {
            Scrollable.ensureVisible(
              target,
              duration: Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          }
        };
      }
      return Row(
        spacing: 10,
        children: [
          Expanded(
            child: Obx(
              () => CustomButton(
                onTap: buttonAction,
                text: buttonText,
                isLoading: Get.find<PostController>().isAttendLoading.value,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              if (postData.author.id != null) {
                Get.find<ChatController>().createOrGetChat(postData.author.id!);
              } else {
                customSnackBar("Can't start chat with this user");
              }
            },
            child: Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                color: AppColors.green[25],
                shape: BoxShape.circle,
                border: Border.all(width: 2, color: AppColors.green.shade600),
              ),
              child: Get.find<ChatController>().isLoading.value
                  ? CustomLoading()
                  : Center(
                      child: CustomSvg(
                        asset: "assets/icons/message_rounded.svg",
                      ),
                    ),
            ),
          ),
        ],
      );
    });
  }
}
