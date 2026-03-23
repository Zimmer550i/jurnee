part of 'post_details.dart';

class PostInformation extends StatelessWidget {
  const PostInformation({super.key, required this.postData});

  final PostModel postData;
  Widget _infoRow({String? assetName, required String text, String? title}) {
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
        Expanded(
          child: Text(
            text,
            style: AppTexts.tsmm.copyWith(color: AppColors.gray.shade700),
          ),
        ),
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
              text: Formatter.dateFormatter(postData.lastSeenDate!),
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
