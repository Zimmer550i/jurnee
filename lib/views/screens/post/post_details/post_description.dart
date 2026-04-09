part of 'post_details.dart';

class PostDescription extends StatefulWidget {
  const PostDescription({
    super.key,
    required this.postData,
    required this.showPostActions,
    required this.commentSectionKey,
  });

  final PostModel postData;
  final bool showPostActions;
  final GlobalKey commentSectionKey;

  @override
  State<PostDescription> createState() => _PostDescriptionState();
}

class _PostDescriptionState extends State<PostDescription> {
  bool showFullDescription = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "About this ${widget.postData.category.substring(0, 1).toUpperCase()}${widget.postData.category.substring(1)}",
            style: AppTexts.tmdb.copyWith(color: AppColors.gray.shade700),
          ),
          const SizedBox(height: 8),
          if (widget.postData.subcategory != null &&
              widget.postData.subcategory == "Missing Person")
            MissingPersonInfo(post: widget.postData),
          RichText(
            text: TextSpan(
              text: widget.postData.description.length > 100 &&
                      !showFullDescription
                  ? "${widget.postData.description.substring(0, 100)}..."
                  : widget.postData.description,
              style: AppTexts.tsmr.copyWith(color: AppColors.gray.shade600),
              children: [
                if (widget.postData.description.length > 100)
                  TextSpan(
                    text: showFullDescription ? " Show Less" : "Read More",
                    style: AppTexts.tsmb.copyWith(
                      color: AppColors.green.shade700,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        setState(() {
                          showFullDescription = !showFullDescription;
                        });
                      },
                  ),
              ],
            ),
          ),
          if (widget.postData.price != null) const SizedBox(height: 32),
          if (widget.postData.price != null)
            Row(
              children: [
                Text(
                  widget.postData.category == "service"
                      ? "Starting At: "
                      : "Entry Fee: ",
                  style: AppTexts.tsmr,
                ),
                Text(
                  "\$${Formatter.numberFormatter(widget.postData.price)}",
                  style: AppTexts.tlgb,
                ),
              ],
            ),
          if (!widget.showPostActions) const SizedBox(height: 32),
          if (!widget.showPostActions)
            PostButtons(
              postData: widget.postData,
              commentSectionKey: widget.commentSectionKey,
            ),
        ],
      ),
    );
  }
}
