part of 'post_details.dart';

class PostMedia extends StatefulWidget {
  const PostMedia({
    super.key,
    required this.postData,
    required this.postController,
  });

  final PostModel postData;
  final PostController postController;

  @override
  State<PostMedia> createState() => _PostMediaState();
}

class _PostMediaState extends State<PostMedia> {
  bool showAllTags = false;
  int momentsIndex = 1;

  @override
  Widget build(BuildContext context) {
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
            'Photos & Videos from this ${widget.postData.category.substring(0, 1).toUpperCase()}${widget.postData.category.substring(1)}',
            style: AppTexts.tsmb.copyWith(color: AppColors.gray.shade400),
          ),
          const SizedBox(height: 16),
          Row(
            spacing: 8,
            children: [
              _tab('All', 0),
              _tab('Owners', 1),
              _tab('Community', 2),
            ],
          ),
          const SizedBox(height: 16),
          AnimatedSize(
            duration: Duration(milliseconds: 200),
            alignment: Alignment.topLeft,
            child: Obx(() {
              final mediaCollection = [
                [...widget.postController.mediaListOwner, ...widget.postController.mediaListCommunity],
                [...widget.postController.mediaListOwner],
                [...widget.postController.mediaListCommunity],
              ][momentsIndex];

              if (mediaCollection.isEmpty) {
                return noData('No Moments available');
              }

              return MediaQuery.removePadding(
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
                              postData: widget.postData,
                              preferedStart: mediaCollection[i],
                              mediaList: [widget.postData.image, ...mediaCollection],
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
              );
            }),
          ),
          const SizedBox(height: 16),
          if (widget.postData.hasTag != null)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                for (var tag
                    in showAllTags
                        ? widget.postData.hasTag!
                        : widget.postData.hasTag!
                              .getRange(0, min(3, widget.postData.hasTag!.length))
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
                if (widget.postData.hasTag!.length > 3 && !showAllTags)
                  GestureDetector(
                    onTap: () => setState(() => showAllTags = true),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.gray.shade100,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '+${widget.postData.hasTag!.length - 3} More',
                        style: AppTexts.tsmr.copyWith(
                          color: AppColors.green.shade800,
                        ),
                      ),
                    ),
                  ),
                if (widget.postData.hasTag!.length > 3 && showAllTags)
                  GestureDetector(
                    onTap: () => setState(() => showAllTags = false),
                    child: Text(
                      '...hide',
                      style: AppTexts.txsr.copyWith(
                        color: AppColors.gray.shade300,
                      ),
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _tab(String title, int index) {
    final isSelected = index == momentsIndex;
    return GestureDetector(
      onTap: () => setState(() => momentsIndex = index),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 100),
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.green.shade600 : AppColors.gray.shade100,
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
