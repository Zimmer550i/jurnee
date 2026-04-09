part of 'post_details.dart';

class PostInformation extends StatelessWidget {
  final void Function()? onSeeAllTap;
  const PostInformation({super.key, required this.postData, this.onSeeAllTap});

  final PostModel postData;
  Widget _infoRow({
    String? assetName,
    required String text,
    String? title,
    Widget? trailing,
  }) {
    final textStyle = AppTexts.tsmm.copyWith(color: AppColors.gray.shade700);
    return Row(
      spacing: 4,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (assetName != null)
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: CustomSvg(
              asset: "assets/icons/$assetName.svg",
              color: AppColors.green.shade700,
              size: 16,
            ),
          ),
        if (title != null) Text("$title: ", style: AppTexts.tsms),
        if (trailing == null) Expanded(child: Text(text, style: textStyle)),
        if (trailing != null) Text(text, style: textStyle),
        if (trailing != null) trailing,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(24),
      child: Column(
        spacing: 12,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        postData.title.toString(),
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: AppColors.gray.shade700,
                        ),
                      ),
                      Text(
                        postData.subcategory ??
                            Formatter.toPascelCase(postData.category),
                        style: AppTexts.txsr.copyWith(
                          color: postData.subcategory == 'Missing Person'
                              ? AppColors.red
                              : AppColors.gray.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
                ReportPostButton(),
              ],
            ),
          ),
          if (postData.subcategory == 'Missing Person' &&
              postData.lastSeenDate != null)
            _infoRow(
              title: "Last Seen",
              text: DateFormat('MMM dd, yyyy.').format(postData.lastSeenDate!),
            ),
          Obx(
            () => _infoRow(
              assetName: 'message',
              text:
                  "${Get.find<PostController>().commentReviewCount} ${postData.category == "service" ? "Reviews" : "Comments"} • ",
              trailing: GestureDetector(
                onTap: onSeeAllTap,
                child: Text(
                  "See All",
                  style: AppTexts.tsms.copyWith(
                    color: AppColors.green.shade700,
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => Get.to(() => PostLocation(post: postData)),
            child: _infoRow(
              assetName: 'location',
              text:
                  '${Get.find<PostController>().getDistance(postData.location.coordinates[0], postData.location.coordinates[1])} • ${postData.address}',
            ),
          ),
          if (postData.startDate != null)
            _infoRow(
              assetName: 'calendar',
              text: DateFormat('dd MMM, hh:mm a').format(postData.startDate!),
            ),
          if (postData.serviceType != null)
            _infoRow(
              assetName: 'tools',
              title: "Service Type",
              text: postData.serviceType!,
            ),
          if (postData.capacity != null)
            _infoRow(
              assetName: 'capacity',
              title: "Capacity",
              text: "Up to ${postData.capacity!} guests",
            ),
          if (postData.amenities != null)
            _infoRow(
              assetName: 'amneties',
              title: "Amneties",
              text: postData.amenities!.join(", "),
            ),
          if (postData.licenses != null)
            _infoRow(
              assetName: 'license',
              title: "License",
              text: postData.licenses!,
            ),
        ],
      ),
    );
  }
}
