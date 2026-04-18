part of 'post_details.dart';

class PostCover extends StatefulWidget {
  const PostCover({
    super.key,
    required this.post,
    required this.context,
  });
  final PostModel post;
  final BuildContext context;

  @override
  State<PostCover> createState() => _PostCoverState();
}

class _PostCoverState extends State<PostCover> {
  final _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.width / 1.57,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          PageView(
            scrollDirection: Axis.horizontal,
            controller: _controller,
            children: [
              for (var i in [
                widget.post.image,
                if (widget.post.media != null)
                  ...widget.post.media!,
              ])
                GestureDetector(
                  onTap: () {
                    Get.to(
                      () => MediaPlayer(
                        postData: widget.post,
                        initialUrl: i!,
                      ),
                      transition: Transition.noTransition,
                    );
                  },
                  child: MediaThumbnail(path: i),
                ),
            ],
          ),
          Positioned(
            bottom: 12,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: PageIndicator(
                  controller: _controller,
                  size: 6,
                  activeColor: AppColors.green.shade700,
                  count: (widget.post.media?.length ?? 0) + 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
