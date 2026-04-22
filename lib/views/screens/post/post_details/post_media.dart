part of 'post_details.dart';

class PostMedia extends StatefulWidget {
  const PostMedia({super.key, required this.index});

  final int index;

  @override
  State<PostMedia> createState() => _PostMediaState();
}

class _PostMediaState extends State<PostMedia> {
  bool showAllTags = false;
  int momentsIndex = 1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final post = Get.find<PostController>();
      final i = widget.index;
      if (i >= 0 && i < post.posts.length) {
        post.getMedia(post.posts[i].id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final postController = Get.find<PostController>();
      final postData = postController.posts[widget.index];
      final moments = postController.mediaList;
      final momentSlice = switch (momentsIndex) {
        0 => moments.toList(),
        1 => moments.where((m) => m.source == MomentSource.owner).toList(),
        2 => moments.where((m) => m.source == MomentSource.community).toList(),
        _ => moments.toList(),
      };
      final mediaCollection = momentSlice.map((m) => m.url).toList();

      return Container(
        color: Colors.white,
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Moments',
              style: AppTexts.tmdb.copyWith(color: AppColors.gray.shade700),
            ),
            Text(
              'Photos & Videos from this ${postData.category.substring(0, 1).toUpperCase()}${postData.category.substring(1)}',
              style: AppTexts.tsmb.copyWith(color: AppColors.gray.shade400),
            ),
            const SizedBox(height: 16),
            Row(
              spacing: 8,
              children: [_tab('All', 0), _tab('Owners', 1), _tab('Community', 2)],
            ),
            const SizedBox(height: 16),
            AnimatedSize(
              duration: Duration(milliseconds: 200),
              alignment: Alignment.topLeft,
              child: mediaCollection.isEmpty
                  ? noData('No Media Yet')
                  : MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      removeBottom: true,
                      child: GridView(
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                        ),
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          for (int i = 0; i < mediaCollection.length; i++)
                            GestureDetector(
                              onTap: () {
                                Get.to(
                                  () => MediaPlayer(
                                    postData: postData,
                                    initialUrl: mediaCollection[i],
                                  ),
                                );
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadiusGeometry.circular(12),
                                child: MediaThumbnail(path: mediaCollection[i]),
                              ),
                            ),
                        ],
                      ),
                    ),
            ),
            const SizedBox(height: 16),
            if (postData.hasTag != null)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.start,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  for (var tag
                      in showAllTags
                          ? postData.hasTag!
                          : postData.hasTag!
                                .getRange(
                                  0,
                                  min(3, postData.hasTag!.length),
                                )
                                .toList())
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.gray.shade100,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        tag.contains('#') ? '$tag ' : '#$tag ',
                        style: AppTexts.tsmr.copyWith(
                          color: AppColors.green.shade800,
                        ),
                      ),
                    ),
                  if (postData.hasTag!.length > 3 && !showAllTags)
                    GestureDetector(
                      onTap: () => setState(() => showAllTags = true),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.gray.shade100,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '+${postData.hasTag!.length - 3} More',
                          style: AppTexts.tsmr.copyWith(
                            color: AppColors.green.shade800,
                          ),
                        ),
                      ),
                    ),
                  if (postData.hasTag!.length > 3 && showAllTags)
                    GestureDetector(
                      onTap: () => setState(() => showAllTags = false),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.gray.shade100,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          "...hide",
                          style: AppTexts.tsmr.copyWith(
                            color: AppColors.green.shade800,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
          ],
        ),
      );
    });
  }

  Widget _tab(String title, int index) {
    final isSelected = index == momentsIndex;
    return GestureDetector(
      onTap: () => setState(() => momentsIndex = index),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 100),
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.green.shade600
              : AppColors.gray.shade100,
          border: isSelected
              ? Border.all(color: AppColors.green.shade600)
              : Border.all(color: AppColors.gray.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          title,
          style: AppTexts.txsb.copyWith(
            color: isSelected ? Colors.white : AppColors.gray.shade700,
          ),
        ),
      ),
    );
  }
}
