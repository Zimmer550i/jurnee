part of 'post_details.dart';

class PostInformation extends StatelessWidget {
  const PostInformation({super.key, required this.postData});

  final PostModel postData;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
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
                      postData.subcategory ?? Formatter.toPascelCase(postData.category),
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
          const SizedBox(height: 20),
          if (postData.subcategory == 'Missing Person' && postData.lastSeenDate != null)
            Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Text('Last Seen: ', style: AppTexts.tsms),
                  Text(
                    Formatter.dateFormatter(postData.lastSeenDate!),
                    style: AppTexts.tsmr,
                  ),
                ],
              ),
            ),
          GestureDetector(
            onTap: () => Get.to(() => PostLocation(post: postData)),
            child: Row(
              spacing: 4,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: CustomSvg(
                    asset: 'assets/icons/location.svg',
                    color: AppColors.green.shade700,
                    size: 16,
                  ),
                ),
                Expanded(
                  child: Text(
                    '${Get.find<PostController>().getDistance(postData.location.coordinates[0], postData.location.coordinates[1])} • ${postData.address}',
                    style: AppTexts.tsmm.copyWith(color: AppColors.gray.shade700),
                  ),
                ),
              ],
            ),
          ),
          if (postData.startDate != null) const SizedBox(height: 12),
          if (postData.startDate != null)
            Row(
              spacing: 4,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: CustomSvg(
                    asset: 'assets/icons/calendar.svg',
                    color: AppColors.green.shade700,
                    size: 16,
                  ),
                ),
                Expanded(
                  child: Text(
                    DateFormat('dd MMM, hh:mm a').format(postData.startDate!),
                    style: AppTexts.tsmm.copyWith(color: AppColors.gray.shade700),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
