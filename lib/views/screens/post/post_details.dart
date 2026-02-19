import 'dart:math';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jurnee/controllers/chat_controller.dart';
import 'package:jurnee/controllers/post_controller.dart';
import 'package:jurnee/models/post_model.dart';
import 'package:jurnee/utils/app_colors.dart';
import 'package:jurnee/utils/app_texts.dart';
import 'package:jurnee/utils/custom_svg.dart';
import 'package:jurnee/views/base/comment_widget.dart';
import 'package:jurnee/views/base/custom_app_bar.dart';
import 'package:jurnee/views/base/custom_button.dart';
import 'package:jurnee/views/base/custom_loading.dart';
import 'package:jurnee/views/base/custom_text_field.dart';
import 'package:jurnee/views/base/media_player.dart';
import 'package:jurnee/views/base/media_thumbnail.dart';
import 'package:jurnee/views/base/profile_picture.dart';
import 'package:jurnee/views/base/rating_widget.dart';
import 'package:jurnee/views/base/review_widget.dart';
import 'package:jurnee/views/screens/home/post_location.dart';
import 'package:jurnee/views/screens/home/users_list.dart';
import 'package:jurnee/views/screens/post/post_alert.dart';
import 'package:jurnee/views/screens/post/post_deal.dart';
import 'package:jurnee/views/screens/post/post_event.dart';
import 'package:jurnee/views/screens/post/post_service.dart';
import 'package:jurnee/views/screens/post/service_booking.dart';
import 'package:jurnee/views/screens/profile/boost_post.dart';
import 'package:jurnee/views/screens/profile/profile.dart';
import 'package:page_indicator_plus/page_indicator_plus.dart';
import 'package:share_plus/share_plus.dart';

class PostDetails extends StatefulWidget {
  final PostModel post;
  const PostDetails(this.post, {super.key});

  @override
  State<PostDetails> createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetails> {
  final _controller = PageController();
  bool showFullDescription = false;
  int momentsIndex = 0;

  @override
  Widget build(BuildContext context) {
    // var isOwner =
    //     widget.post.author.id == Get.find<UserController>().userData!.id;
    return Scaffold(
      backgroundColor: AppColors.gray[50],
      appBar: CustomAppBar(
        title: "Event Details",
        trailing: "assets/icons/share.svg",
        trailingAction: () {
          final deepLink = "https://jurnee.app/post/${widget.post.id}";

          SharePlus.instance.share(
            ShareParams(
              text: "Check out ${widget.post.title} on Jurnee:\n$deepLink",
              subject: "Jurnee Post",
            ),
          );
        },
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(
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
                          if (widget.post.media != null) ...widget.post.media!,
                        ])
                          GestureDetector(
                            onTap: () {
                              Get.to(
                                () => MediaPlayer(
                                  postData: widget.post,
                                  preferedStart: i,
                                  mediaList: [
                                    widget.post.image,
                                    ...widget.post.media ?? [],
                                  ],
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
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
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
              ),

              Column(
                spacing: 8,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
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
                                    widget.post.title.toString(),
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.gray.shade700,
                                    ),
                                  ),
                                  Text(
                                    widget.post.subcategory ??
                                        widget.post.category,
                                    style: AppTexts.txsr.copyWith(
                                      color: AppColors.gray.shade700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            reportPost(context),
                          ],
                        ),
                        const SizedBox(height: 20),
                        if (widget.post.category == "service")
                          Row(
                            children: [
                              RatingWidget(
                                averageRating: widget.post.averageRating,
                                isSmall: true,
                              ),
                              GestureDetector(
                                onTap: () {},
                                child: Text(
                                  "See All",
                                  style: AppTexts.tsms.copyWith(
                                    color: AppColors.green.shade700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        if (widget.post.category != "service")
                          Row(
                            spacing: 4,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 2),
                                child: CustomSvg(
                                  asset: "assets/icons/message.svg",
                                  color: AppColors.green.shade700,
                                  size: 16,
                                ),
                              ),
                              Text(
                                "112 Comments • ",
                                style: AppTexts.tsmm.copyWith(
                                  color: AppColors.gray.shade700,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {},
                                child: Text(
                                  "See All",
                                  style: AppTexts.tsms.copyWith(
                                    color: AppColors.green.shade700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        const SizedBox(height: 12),
                        GestureDetector(
                          onTap: () {
                            Get.to(() => PostLocation(post: widget.post));
                          },
                          child: Row(
                            spacing: 4,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 2),
                                child: CustomSvg(
                                  asset: "assets/icons/location.svg",
                                  color: AppColors.green.shade700,
                                  size: 16,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  "${Get.find<PostController>().getDistance(widget.post.location.coordinates[0], widget.post.location.coordinates[1])} • ${widget.post.address}",
                                  style: AppTexts.tsmm.copyWith(
                                    color: AppColors.gray.shade700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (widget.post.startDate != null)
                          const SizedBox(height: 12),
                        if (widget.post.startDate != null)
                          Row(
                            spacing: 4,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 2),
                                child: CustomSvg(
                                  asset: "assets/icons/calendar.svg",
                                  color: AppColors.green.shade700,
                                  size: 16,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  widget.post.startDate != null
                                      ? DateFormat(
                                          "dd MMM, hh:mm a",
                                        ).format(widget.post.startDate!)
                                      : "",
                                  style: AppTexts.tsmm.copyWith(
                                    color: AppColors.gray.shade700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(24),
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (widget.post.subcategory != null &&
                            widget.post.subcategory == "Missing Person")
                          missingPersonInfo(),

                        RichText(
                          text: TextSpan(
                            text:
                                widget.post.description.length > 100 &&
                                    !showFullDescription
                                ? "${widget.post.description.substring(0, 100)}..."
                                : widget.post.description,
                            style: AppTexts.tsmr.copyWith(
                              color: AppColors.gray.shade600,
                            ),
                            children: [
                              if (widget.post.description.length > 100)
                                TextSpan(
                                  text: showFullDescription
                                      ? " Show Less"
                                      : "Read More",
                                  style: AppTexts.tsmb.copyWith(
                                    color: AppColors.green.shade700,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      setState(() {
                                        showFullDescription =
                                            !showFullDescription;
                                      });
                                    },
                                ),
                            ],
                          ),
                        ),
                        if (widget.post.price != null)
                          const SizedBox(height: 32),
                        if (widget.post.price != null)
                          Row(
                            children: [
                              Text("Entry: ", style: AppTexts.tsmr),
                              Text(
                                widget.post.price.toString(),
                                style: AppTexts.tlgb,
                              ),
                            ],
                          ),
                        const SizedBox(height: 32),
                        getButton(),
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.all(24),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.to(
                              () => Profile(userId: widget.post.author.id),
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Post by:",
                                style: AppTexts.tsmr.copyWith(
                                  color: AppColors.gray.shade600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  ProfilePicture(
                                    image: widget.post.author.image,
                                    size: 32,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    widget.post.author.name,
                                    style: AppTexts.tmdb.copyWith(
                                      color: AppColors.gray.shade700,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Spacer(),
                        CustomSvg(asset: "assets/icons/view.svg"),
                        const SizedBox(width: 4),
                        Text(
                          widget.post.views.toString(),
                          style: AppTexts.tsmr,
                        ),
                        const SizedBox(width: 12),
                        CustomSvg(
                          asset:
                              "assets/icons/${widget.post.isSaved ? "saved" : "save"}.svg",
                        ),
                        const SizedBox(width: 4),
                        Text(
                          widget.post.totalSaved.toString(),
                          style: AppTexts.tsmr,
                        ),
                        const SizedBox(width: 12),
                        CustomSvg(
                          asset:
                              "assets/icons/${widget.post.isSaved ? "loved" : "love"}.svg",
                        ),
                        const SizedBox(width: 4),
                        Text(
                          widget.post.likes.toString(),
                          style: AppTexts.tsmr,
                        ),
                      ],
                    ),
                  ),
                  // if (isOwner) postEarnings(),
                  attendingUsers(),
                  if (widget.post.media != null) postMedia(),

                  // if (widget.post.category != "service")
                  postComments(),
                  // if (widget.post.category == "service")
                  postReviews(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget postReviews() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Reviews (25)", style: AppTexts.tmdb),
          const SizedBox(height: 16),
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) => ReviewWidget(),
            separatorBuilder: (context, index) =>
                Divider(height: 32, color: AppColors.gray.shade100),
            itemCount: 5,
          ),
        ],
      ),
    );
  }

  Widget postComments() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Comments (3)", style: AppTexts.tmdb),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  hintText: "Add a comment",
                  trailingWidget: GestureDetector(
                    onTap: () {},
                    child: CustomSvg(asset: "assets/icons/add_image.svg"),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              CustomButton(
                onTap: () {},
                text: "Post",
                width: null,
                padding: 20,
                height: 36,
                fontSize: 14,
              ),
            ],
          ),
          const SizedBox(height: 16),

          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) => CommentWidget(),
            separatorBuilder: (context, index) =>
                Divider(height: 32, color: AppColors.gray.shade100),
            itemCount: 5,
          ),
        ],
      ),
    );
  }

  Widget postMedia() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Moments",
            style: AppTexts.tmdb.copyWith(color: AppColors.gray.shade700),
          ),
          Text(
            "Photos & Videos From this Event",
            style: AppTexts.tsmb.copyWith(color: AppColors.gray.shade400),
          ),
          const SizedBox(height: 16),
          Row(
            spacing: 8,
            children: [
              tabs("All", null, 0),
              tabs("Owners", null, 1),
              tabs("Community", null, 2),
            ],
          ),
          const SizedBox(height: 16),
          GridView(
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
            ),
            physics: NeverScrollableScrollPhysics(),
            children: [
              for (int i = 0; i < (widget.post.media!.length); i++)
                GestureDetector(
                  onTap: () {
                    Get.to(
                      () => MediaPlayer(
                        postData: widget.post,
                        preferedStart: widget.post.media![i],
                        mediaList: [
                          widget.post.image,
                          ...widget.post.media ?? [],
                        ],
                      ),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadiusGeometry.circular(12),
                    child: MediaThumbnail(path: widget.post.media![i]),
                  ),
                ),

              // CustomNetworkedImage(
              //   url: post.media![i],
              //   radius: 12,
              // ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            children: [
              for (var tag in widget.post.hasTag ?? [])
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.gray.shade100,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    tag.contains("#") ? "$tag " : "#$tag ",
                    style: AppTexts.tsmr.copyWith(
                      color: AppColors.green.shade800,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget attendingUsers() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(24),
      child: InkWell(
        onTap: () {
          Get.to(
            () => UsersList(
              title: "Attending",
              getListMethod: (loadMore) {
                // return Get.find<UserController>().getFollowers();
              },
            ),
          );
        },
        child: Row(
          children: [
            Text(
              "Attending",
              style: AppTexts.tmdb.copyWith(color: AppColors.gray.shade700),
            ),
            Spacer(),
            SizedBox(
              width: 79,
              height: 26,
              child: Stack(
                children: [
                  for (int i = 0; i < min(5, widget.post.attenders.length); i++)
                    Positioned(
                      left: 12.0 * i,
                      child: Container(
                        padding: EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          shape: BoxShape.circle,
                        ),
                        child: ProfilePicture(
                          image: widget.post.attenders.elementAt(i).image,
                          size: 24,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (widget.post.attenders.isEmpty)
              Text(
                "No one joined yet",
                style: AppTexts.txsr.copyWith(color: AppColors.gray),
              ),
            if (widget.post.attenders.length > 5)
              Text(
                "+${max(0, widget.post.attenders.length - 5)}",
                style: AppTexts.txsr.copyWith(color: AppColors.gray),
              ),
            const SizedBox(width: 8),
            if (widget.post.attenders.length > 5)
              Text(
                "See all",
                style: AppTexts.txss.copyWith(color: AppColors.green.shade600),
              ),
          ],
        ),
      ),
    );
  }

  Column missingPersonInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Missing Person’s Information",
          style: AppTexts.tmds.copyWith(color: AppColors.gray.shade700),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Text(
              "Name: ",
              style: AppTexts.tsms.copyWith(color: AppColors.gray.shade700),
            ),
            Text(
              widget.post.missingName ?? "",
              style: AppTexts.tsmr.copyWith(color: AppColors.gray.shade700),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Text(
              "Age: ",
              style: AppTexts.tsms.copyWith(color: AppColors.gray.shade700),
            ),
            Text(
              widget.post.missingAge.toString(),
              style: AppTexts.tsmr.copyWith(color: AppColors.gray.shade700),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Text(
              "Clothing Info: ",
              style: AppTexts.tsms.copyWith(color: AppColors.gray.shade700),
            ),
            Text(
              widget.post.clothingDescription ?? "",
              style: AppTexts.tsmr.copyWith(color: AppColors.gray.shade700),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Text(
              "Contact Info: ",
              style: AppTexts.tsms.copyWith(color: AppColors.gray.shade700),
            ),
            Text(
              widget.post.contactInfo.toString(),
              style: AppTexts.tsmr.copyWith(color: AppColors.gray.shade700),
            ),
          ],
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  PopupMenuButton<String> reportPost(BuildContext context) {
    return PopupMenuButton(
      icon: CustomSvg(asset: "assets/icons/options.svg"),
      padding: EdgeInsets.zero,
      onSelected: (value) {
        showModalBottomSheet(
          context: context,
          useSafeArea: true,
          backgroundColor: AppColors.scaffoldBG,
          builder: (context) {
            return SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  // mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 60),
                    Text(
                      "Why you are reporting this post?",
                      style: AppTexts.txsb,
                    ),
                    const SizedBox(height: 8),
                    CustomTextField(lines: 5, hintText: "Start writing..."),
                    const SizedBox(height: 24),
                    CustomButton(
                      onTap: () {
                        Get.back();
                      },
                      text: "Submit",
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            );
          },
        );
      },
      menuPadding: EdgeInsets.zero,
      color: AppColors.white,
      itemBuilder: (_) => [
        PopupMenuItem(
          value: "1",
          child: Row(
            spacing: 8,
            children: [
              Transform.translate(
                offset: Offset(0, 2),
                child: CustomSvg(asset: "assets/icons/report.svg"),
              ),
              Text(
                "Report",
                style: AppTexts.tsms.copyWith(color: AppColors.green.shade600),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Column postEarnings() {
    return Column(
      spacing: 24,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Total Earnings",
              style: AppTexts.tlgm.copyWith(color: AppColors.gray),
            ),
            Text(
              "\$500",
              style: AppTexts.txlb.copyWith(color: AppColors.gray.shade700),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Units Sold",
              style: AppTexts.tlgm.copyWith(color: AppColors.gray),
            ),
            Text(
              "10/40",
              style: AppTexts.txlb.copyWith(color: AppColors.gray.shade700),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Unit Price",
              style: AppTexts.tlgm.copyWith(color: AppColors.gray),
            ),
            Text(
              "\$50",
              style: AppTexts.txlb.copyWith(color: AppColors.gray.shade700),
            ),
          ],
        ),
        const SizedBox(height: 0),
      ],
    );
  }

  Widget getButton({bool isOwner = false}) {
    if (isOwner) {
      return Column(
        spacing: 8,
        children: [
          CustomButton(
            onTap: () {
              if (widget.post.category.toLowerCase() == "event") {
                Get.to(() => PostEvent(post: widget.post));
              } else if (widget.post.category.toLowerCase() == "deal") {
                Get.to(() => PostDeal(post: widget.post));
              } else if (widget.post.category.toLowerCase() == "alert") {
                Get.to(() => PostAlert(post: widget.post));
              } else if (widget.post.category.toLowerCase() == "service") {
                Get.to(() => PostService(post: widget.post));
              }
            },
            text: "Edit Post",
            isSecondary: true,
          ),
          CustomButton(
            onTap: () => Get.to(() => BoostPost(post: widget.post)),
            text: "Boost Post",
          ),
        ],
      );
    }

    if (widget.post.schedule.isEmpty) {
      return CustomButton(onTap: () {}, text: "Contact Owner");
    } else {
      return Row(
        spacing: 10,
        children: [
          Expanded(
            child: CustomButton(
              onTap: () {
                Get.to(() => ServiceBooking(post: widget.post));
              },
              text: "Request Quote",
            ),
          ),
          GestureDetector(
            onTap: () {
              Get.find<ChatController>().createOrGetChat(widget.post.author.id);
            },
            child: Obx(
              () => Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: AppColors.green[25],
                  shape: BoxShape.circle,
                  border: Border.all(width: 2, color: AppColors.green.shade600),
                ),
                child: Get.find<ChatController>().isLoading.value
                    ? CustomLoading()
                    : Center(
                        child: CustomSvg(
                          asset: "assets/icons/message_rounded.svg",
                        ),
                      ),
              ),
            ),
          ),
        ],
      );
    }
  }

  Widget tabs(String title, String? icon, int index) {
    bool isSelected = index == momentsIndex;
    return GestureDetector(
      onTap: () {
        setState(() {
          momentsIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 100),
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.green.shade600
              : AppColors.gray.shade100,
          border: isSelected
              ? null
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
