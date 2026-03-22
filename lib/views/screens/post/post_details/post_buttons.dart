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
    final category = postData.category.toLowerCase();
    String buttonText = "Request Quote";
    VoidCallback buttonAction = () {
      Get.find<ChatController>().createOrGetChat(postData.author.id);
    };

    if (category == "event") {
      buttonText = "Attend";
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
    } else if (category == "deal") {
      buttonText = "Get Deal";
      buttonAction = () {
        // TODO: Create the modal here
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
          child: CustomButton(onTap: buttonAction, text: buttonText),
        ),
        GestureDetector(
          onTap: () {
            Get.find<ChatController>().createOrGetChat(postData.author.id);
          },
          child: Obx(
            () => Container(
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
        ),
      ],
    );
  }
}
