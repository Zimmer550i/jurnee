part of 'post_details.dart';

class AttendingUsers extends StatelessWidget {
  const AttendingUsers({super.key, required this.post});

  final PostModel post;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(24),
      child: InkWell(
        onTap: () {
          Get.to(
            () => UsersList(
              title: 'Attending',
              data: post.attenders,
              getListMethod: (loadMore) {
                // return Get.find<UserController>().getFollowers();
              },
            ),
          );
        },
        child: Row(
          children: [
            Text(
              'Attending',
              style: AppTexts.tmdb.copyWith(color: AppColors.gray.shade700),
            ),
            Spacer(),
            SizedBox(
              width:
                  29 +
                  (12 * min(5, double.parse(post.attenders.length.toString()))),
              height: 26,
              child: Stack(
                children: [
                  for (int i = 0; i < min(5, post.attenders.length); i++)
                    Positioned(
                      left: 12.0 * i,
                      child: Container(
                        padding: EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          shape: BoxShape.circle,
                        ),
                        child: AbsorbPointer(
                          child: ProfilePicture(
                            image: post.attenders.elementAt(i).image,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (post.attenders.isEmpty)
              Text(
                'No one joined yet',
                style: AppTexts.txsr.copyWith(color: AppColors.gray),
              ),
            if (post.attenders.length > 5)
              Text(
                '+${max(0, post.attenders.length - 5)}',
                style: AppTexts.txsr.copyWith(color: AppColors.gray),
              ),
            const SizedBox(width: 8),
            if (post.attenders.length > 5)
              Text(
                'See all',
                style: AppTexts.txss.copyWith(color: AppColors.green.shade600),
              ),
          ],
        ),
      ),
    );
  }
}
