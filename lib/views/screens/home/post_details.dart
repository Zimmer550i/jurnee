import 'dart:math';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jurnee/controllers/user_controller.dart';
import 'package:jurnee/models/post_model.dart';
import 'package:jurnee/services/shared_prefs_service.dart';
import 'package:jurnee/utils/app_colors.dart';
import 'package:jurnee/utils/app_texts.dart';
import 'package:jurnee/utils/custom_svg.dart';
import 'package:jurnee/utils/get_location.dart';
import 'package:jurnee/views/base/custom_app_bar.dart';
import 'package:jurnee/views/base/custom_button.dart';
import 'package:jurnee/views/base/custom_networked_image.dart';
import 'package:jurnee/views/base/custom_text_field.dart';
import 'package:jurnee/views/base/media_player.dart';
import 'package:jurnee/views/base/profile_picture.dart';
import 'package:jurnee/views/screens/home/reviews.dart';
import 'package:jurnee/views/screens/home/users_list.dart';
import 'package:jurnee/views/screens/profile/boost_post.dart';
import 'package:jurnee/views/screens/profile/profile.dart';

class PostDetails extends StatefulWidget {
  final PostModel post;
  const PostDetails(this.post, {super.key});

  @override
  State<PostDetails> createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetails> {
  LatLng? userPosition;

  @override
  void initState() {
    super.initState();
    setPosition();
  }

  setPosition() async {
    var latitude = double.tryParse(
      await SharedPrefsService.get("latitude") ?? "",
    );
    var longitude = double.tryParse(
      await SharedPrefsService.get("longitude") ?? "",
    );

    if (latitude != null && longitude != null) {
      setState(() {
        userPosition = LatLng(latitude, longitude);
      });
    } else {
      final pos = await getLocation();

      if (pos != null) {
        setState(() {
          userPosition = LatLng(pos.latitude, pos.longitude);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Event Details",
        trailing: "assets/icons/share.svg",
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  Get.to(
                    () => MediaPlayer(
                      mediaList: [widget.post.image, ...widget.post.media],
                    ),
                  );
                },
                child: CustomNetworkedImage(
                  url: widget.post.image,
                  height: MediaQuery.of(context).size.width / 2,
                  width: MediaQuery.of(context).size.width,
                  radius: 0,
                ),
              ),

              Padding(
                padding: EdgeInsetsGeometry.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.post.title.toString(),
                            style: AppTexts.dxss.copyWith(
                              color: AppColors.gray.shade700,
                            ),
                          ),
                        ),
                        PopupMenuButton(
                          onSelected: (value) {
                            showModalBottomSheet(
                              context: context,
                              useSafeArea: true,
                              backgroundColor: AppColors.scaffoldBG,
                              builder: (context) {
                                return SizedBox(
                                  width: double.infinity,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 60),
                                        Text(
                                          "Why you are reporting this post?",
                                          style: AppTexts.txsb,
                                        ),
                                        const SizedBox(height: 8),
                                        CustomTextField(
                                          lines: 5,
                                          hintText: "Start writing...",
                                        ),
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
                                    child: CustomSvg(
                                      asset: "assets/icons/report.svg",
                                    ),
                                  ),
                                  Text(
                                    "Report",
                                    style: AppTexts.tsms.copyWith(
                                      color: AppColors.green.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    if (widget.post.subcategory != null)
                      Container(
                        margin: EdgeInsets.only(bottom: 8, top: 8),
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: AppColors.green.shade200,
                        ),
                        child: Text(
                          widget.post.subcategory ?? "sfa",
                          style: AppTexts.tsms.copyWith(
                            color: AppColors.green.shade900,
                          ),
                        ),
                      ),
                    // TODO: Fix this
                    // Text(
                    //   "${getDistance(widget.post.locationCoordinates?[0] ?? 0, widget.post.locationCoordinates?[1] ?? 0)} • ${DateFormat("dd MMM, hh:mm a").format(widget.post.startDate ?? DateTime.now())}",
                    //   style: AppTexts.tmdm.copyWith(
                    //     color: AppColors.gray.shade400,
                    //   ),
                    // ),
                    const SizedBox(height: 8),
                    Row(
                      spacing: 4,
                      children: [
                        CustomSvg(asset: "assets/icons/location.svg", size: 24),
                        Expanded(
                          child: Text(
                            widget.post.address.toString(),
                            style: AppTexts.tmdm.copyWith(
                              color: AppColors.gray.shade400,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => Reviews(count: 25));
                      },
                      child: Row(
                        children: [
                          for (int i = 0; i < 5; i++)
                            CustomSvg(asset: "assets/icons/star.svg", size: 24),
                          const SizedBox(width: 4),
                          Text(
                            widget.post.averageRating.toString(),
                            style: AppTexts.tlgm.copyWith(
                              color: AppColors.gray.shade400,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            "See All",
                            style: AppTexts.tsmr.copyWith(
                              color: AppColors.green.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => Profile(userId: widget.post.author.id));
                      },
                      child: Row(
                        children: [
                          Text(
                            "Post by:",
                            style: AppTexts.tlgr.copyWith(
                              color: AppColors.gray.shade600,
                            ),
                          ),
                          const SizedBox(width: 12),
                          ProfilePicture(
                            image: widget.post.author.image,
                            size: 32,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            widget.post.author.name,
                            style: AppTexts.tlgm.copyWith(
                              color: AppColors.gray.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      widget.post.description.toString(),
                      style: AppTexts.tlgr.copyWith(
                        color: AppColors.gray.shade600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      spacing: 4,
                      children: [
                        CustomSvg(asset: "assets/icons/eye.svg", size: 24),
                        Text(
                          widget.post.views.toString(),
                          style: AppTexts.tsmr.copyWith(color: AppColors.gray),
                        ),
                        const SizedBox(width: 4),
                        CustomSvg(asset: "assets/icons/save.svg", size: 24),
                        Text(
                          widget.post.totalSaved.toString(),
                          style: AppTexts.tsmr.copyWith(color: AppColors.gray),
                        ),
                        const SizedBox(width: 4),
                        CustomSvg(asset: "assets/icons/love.svg", size: 24),
                        Text(
                          widget.post.likes.toString(),
                          style: AppTexts.tsmr.copyWith(color: AppColors.gray),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (widget.post.author.id !=
                        Get.find<UserController>().userData!.id)
                      Column(
                        spacing: 24,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Total Earnings",
                                style: AppTexts.tlgm.copyWith(
                                  color: AppColors.gray,
                                ),
                              ),
                              Text(
                                "\$500",
                                style: AppTexts.txlb.copyWith(
                                  color: AppColors.gray.shade700,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Units Sold",
                                style: AppTexts.tlgm.copyWith(
                                  color: AppColors.gray,
                                ),
                              ),
                              Text(
                                "10/40",
                                style: AppTexts.txlb.copyWith(
                                  color: AppColors.gray.shade700,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Unit Price",
                                style: AppTexts.tlgm.copyWith(
                                  color: AppColors.gray,
                                ),
                              ),
                              Text(
                                "\$50",
                                style: AppTexts.txlb.copyWith(
                                  color: AppColors.gray.shade700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 0),
                        ],
                      ),
                    InkWell(
                      onTap: () {
                        Get.to(
                          () => UsersList(
                            title: "Attending",
                            getListMethod: (loadMore) {
                              return Get.find<UserController>().getFollowers();
                            },
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          Text(
                            "Attending",
                            style: AppTexts.tlgm.copyWith(
                              color: AppColors.gray,
                            ),
                          ),
                          Spacer(),
                          SizedBox(
                            width: 79,
                            height: 26,
                            child: Stack(
                              children: [
                                for (
                                  int i = 0;
                                  i < min(5, widget.post.attenders.length);
                                  i++
                                )
                                  Positioned(
                                    left: 12.0 * i,
                                    child: Container(
                                      padding: EdgeInsets.all(1),
                                      decoration: BoxDecoration(
                                        color: AppColors.white,
                                        shape: BoxShape.circle,
                                      ),
                                      child: ProfilePicture(
                                        image: widget.post.attenders
                                            .elementAt(i)
                                            .image,
                                        size: 24,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          if (widget.post.attenders.length > 5)
                            Text(
                              "+${max(0, widget.post.attenders.length - 5)}",
                              style: AppTexts.txsr.copyWith(
                                color: AppColors.gray,
                              ),
                            ),
                          const SizedBox(width: 8),
                          Text(
                            "See all",
                            style: AppTexts.txss.copyWith(
                              color: AppColors.green.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Photos / Videos",
                      style: AppTexts.tlgm.copyWith(
                        color: AppColors.gray.shade600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    GridView(
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                      ),
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        for (int i = 0; i < (widget.post.media.length); i++)
                          CustomNetworkedImage(
                            url: widget.post.media[i],
                            radius: 12,
                          ),
                      ],
                    ),
                    if (widget.post.subcategory != null &&
                        widget.post.subcategory == "Missing Person")
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          Text(
                            "Missing Person’s Information",
                            style: AppTexts.tlgm.copyWith(
                              color: AppColors.gray.shade600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Name: John Doe",
                            style: AppTexts.tmdr.copyWith(
                              color: AppColors.gray,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Age: 21",
                            style: AppTexts.tmdr.copyWith(
                              color: AppColors.gray,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Clothing Info: wearing red shirt & black pant",
                            style: AppTexts.tmdr.copyWith(
                              color: AppColors.gray,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Contact Info: name@example.com",
                            style: AppTexts.tmdr.copyWith(
                              color: AppColors.gray,
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 20),
                    Text(
                      widget.post.hasTag
                              ?.map(
                                (val) => val.contains("#") ? "$val " : "#$val ",
                              )
                              .join() ??
                          "",
                      style: AppTexts.tsmr.copyWith(
                        color: AppColors.green.shade700,
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (widget.post.price != null)
                      Row(
                        children: [
                          Text(
                            "Start From",
                            style: AppTexts.tmdr.copyWith(
                              color: AppColors.gray,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "\$${widget.post.price}",
                            style: AppTexts.dxss.copyWith(
                              color: AppColors.gray.shade700,
                            ),
                          ),
                        ],
                      ),
                    if (widget.post.expireLimit != null)
                      Text(
                        "Expires in 7 days",
                        style: AppTexts.tmdm.copyWith(
                          color: AppColors.gray.shade400,
                        ),
                      ),
                    const SizedBox(height: 32),
                    CustomButton(
                      onTap: () {
                        Get.to(() => BoostPost());
                      },
                      text: "Boost Post",
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String getDistance(double targetLat, double targetLong) {
    // Calculate distance in meters
    double distanceInMeters = Geolocator.distanceBetween(
      userPosition!.latitude,
      userPosition!.longitude,
      targetLat,
      targetLong,
    );

    // Convert meters to miles (1 meter = 0.000621371 miles)
    double distanceInMiles = distanceInMeters * 0.000621371;

    return "${distanceInMiles.toStringAsFixed(1)} miles";
  }
}
