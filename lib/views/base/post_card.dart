import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jurnee/models/post_model.dart';
import 'package:jurnee/services/shared_prefs_service.dart';
import 'package:jurnee/utils/app_colors.dart';
import 'package:jurnee/utils/app_texts.dart';
import 'package:jurnee/utils/custom_svg.dart';
import 'package:jurnee/utils/get_location.dart';
import 'package:jurnee/views/base/custom_networked_image.dart';
import 'package:jurnee/views/screens/home/post_details.dart';

class PostCard extends StatefulWidget {
  final PostModel post;
  const PostCard(this.post, {super.key});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  LatLng? userPosition;

  @override
  void initState() {
    super.initState();
    setPosition();
  }

  setPosition() async {
    var latitude = double.tryParse(await SharedPrefsService.get("latitude") ?? "");
    var longitude = double.tryParse(await SharedPrefsService.get("longitude") ?? "");

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
    return GestureDetector(
      onTap: () {
        Get.to(() => PostDetails());
      },
      child: ClipRRect(
        borderRadius: BorderRadiusGeometry.circular(16),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(color: AppColors.white),
          child: Column(
            children: [
              CustomNetworkedImage(
                height: 184,
                // width: double.infinity,
                url: widget.post.image,
                fit: BoxFit.cover,
                radius: 0,
              ),
              SizedBox(
                height: 124,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Column(
                    spacing: 8,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.post.title.toString(),
                        style: AppTexts.dxss.copyWith(
                          color: AppColors.gray.shade600,
                        ),
                      ),

                      Row(
                        spacing: 4,
                        children: [
                          CustomSvg(asset: "assets/icons/location.svg"),
                          Text(
                            userPosition == null
                                ? "fetching..."
                                : getDistance(
                                    userPosition!.latitude,
                                    userPosition!.longitude,
                                  ),
                            style: AppTexts.tsmm.copyWith(
                              color: AppColors.gray.shade600,
                            ),
                          ),
                          Container(),
                          CustomSvg(asset: "assets/icons/star.svg"),
                          Text(
                            widget.post.averageRating == null
                                ? "N/A"
                                : widget.post.averageRating!.toString(),
                            style: AppTexts.tsmm.copyWith(
                              color: AppColors.gray.shade600,
                            ),
                          ),
                        ],
                      ),

                      Text(
                        widget.post.description.toString(),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTexts.tsmr.copyWith(
                          color: AppColors.gray.shade600,
                        ),
                      ),
                    ],
                  ),
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
      userPosition!.latitude ,
      userPosition!.longitude ,
      targetLat,
      targetLong,
    );

    // Convert meters to miles (1 meter = 0.000621371 miles)
    double distanceInMiles = distanceInMeters * 0.000621371;

    return "${distanceInMiles.toStringAsFixed(1)} miles";
  }
}
