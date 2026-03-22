part of 'post_details.dart';

Future<dynamic> showPostDeleteSheet(
  BuildContext context, {
  required PostController postController,
  required PostModel postData,
}) {
  return showModalBottomSheet(
    context: context,
    backgroundColor: AppColors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadiusGeometry.vertical(top: Radius.circular(20)),
    ),
    builder: (_) {
      return SafeArea(
        child: Container(
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: Color(0xffE0E0E0))),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 24),
              Text('Delete', style: AppTexts.tlgb.copyWith(color: AppColors.red)),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                height: 1,
                color: AppColors.gray.shade100,
              ),
              const SizedBox(height: 24),
              Text(
                'Are you sure you want to delete this Post?',
                style: AppTexts.tlgs.copyWith(color: AppColors.gray.shade400),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  const SizedBox(width: 40),
                  Expanded(
                    child: CustomButton(
                      text: 'Yes, Delete',
                      padding: 0,
                      isSecondary: true,
                      onTap: () async {
                        final message = await postController.deletePost(postData.id);
                        Get.back();

                        if (message == 'success') {
                          customSnackBar(
                            '${postData.title} has been deleted!',
                            isError: false,
                          );
                        } else {
                          customSnackBar(message);
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: CustomButton(text: 'Cancel', onTap: () => Get.back()),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      );
    },
  );
}
