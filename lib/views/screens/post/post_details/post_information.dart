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
                      if (postData.subcategory != 'Missing Person')
                        Text(
                          postData.subcategory ??
                              Formatter.toPascelCase(postData.category),
                          style: AppTexts.txsr.copyWith(
                            color: AppColors.gray.shade700,
                          ),
                        ),
                      if (postData.subcategory == 'Missing Person')
                        Row(
                          children: [
                            Text(
                              postData.subcategory ??
                                  Formatter.toPascelCase(postData.category),
                              style: AppTexts.txsr.copyWith(
                                color: AppColors.red,
                              ),
                            ),
                            Text(
                              " • ${Formatter.durationFormatter(DateTime.now().difference(postData.createdAt))}",
                              style: AppTexts.txsr.copyWith(
                                color: AppColors.green.shade700,
                              ),
                            ),
                          ],
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
          if (postData.startDate != null || postData.schedule.isNotEmpty)
            _infoRow(assetName: 'calendar', text: _dateOrScheduleText()),
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

  String _dateOrScheduleText() {
    String fallback = postData.startDate != null
        ? DateFormat('dd MMM, hh:mm a').format(postData.startDate!)
        : "";
    if (postData.category != "service" || postData.schedule.isEmpty) {
      return fallback;
    }

    final schedule = postData.schedule
        .where((s) => s.startTime != null && s.endTime != null)
        .toList();
    if (schedule.isEmpty) return fallback;

    final first = schedule.first;
    final startTime = first.startTime!;
    final endTime = first.endTime!;

    final dayIndexes =
        schedule
            .where((s) => s.startTime == startTime && s.endTime == endTime)
            .map((s) => _dayOrder(s.day))
            .where((idx) => idx >= 0 && idx <= 6)
            .toSet()
            .toList()
          ..sort();
    if (dayIndexes.isEmpty) return fallback;

    final dayRanges = <String>[];
    int i = 0;
    while (i < dayIndexes.length) {
      final start = dayIndexes[i];
      int end = start;
      while (i + 1 < dayIndexes.length && dayIndexes[i + 1] == end + 1) {
        end = dayIndexes[i + 1];
        i++;
      }
      dayRanges.add(
        start == end ? _dayName(start) : "${_dayName(start)}-${_dayName(end)}",
      );
      i++;
    }

    return "${dayRanges.join("-")}, ${_formatTime(startTime)}-${_formatTime(endTime)}";
  }

  int _dayOrder(String day) {
    const days = ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun'];
    final normalized = day.trim().toLowerCase();
    final short = normalized.length >= 3
        ? normalized.substring(0, 3)
        : normalized;
    final index = days.indexOf(short);
    return index == -1 ? 99 : index;
  }

  String _dayName(int dayIndex) {
    const names = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    if (dayIndex < 0 || dayIndex >= names.length) return "Day";
    return names[dayIndex];
  }

  String _formatTime(String value) {
    final chunks = value.split(":");
    if (chunks.length < 2) return value;
    final hour = int.tryParse(chunks[0]);
    final minute = int.tryParse(chunks[1]);
    if (hour == null || minute == null) return value;
    return DateFormat('h:mm a').format(DateTime(2000, 1, 1, hour, minute));
  }
}
