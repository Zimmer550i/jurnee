import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jurnee/controllers/post_controller.dart';
import 'package:jurnee/models/post_model.dart';
import 'package:jurnee/utils/app_colors.dart';
import 'package:jurnee/utils/app_texts.dart';
import 'package:jurnee/views/base/custom_loading.dart';
import 'package:jurnee/views/base/post_card_small.dart';

class LocationMap extends StatefulWidget {
  final LatLng? startPosition;
  final PostModel? initialPost;
  const LocationMap({super.key, this.startPosition, this.initialPost});

  @override
  State<LocationMap> createState() => _LocationMapState();
}

class _LocationMapState extends State<LocationMap> {
  final post = Get.find<PostController>();
  late double pixelRatio;
  Set<Marker> markers = {};
  GoogleMapController? mapController;
  Offset? overlayPos;
  LatLng? cardPosition;
  PostModel? cardPost;

  @override
  void initState() {
    super.initState();
    loadMarkers();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      pixelRatio = MediaQuery.of(context).devicePixelRatio;
    });
    if (widget.initialPost != null) {
      cardPost = widget.initialPost;
      cardPosition = LatLng(
        cardPost!.location.coordinates[1],
        cardPost!.location.coordinates[0],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          webCameraControlEnabled: false,
          zoomControlsEnabled: false,
          mapType: MapType.normal,
          indoorViewEnabled: true,
          myLocationButtonEnabled: false,
          initialCameraPosition: CameraPosition(
            target: LatLng(
              widget.startPosition?.latitude ??
                  post.userLocation.value?.latitude ??
                  36.7783,
              widget.startPosition?.longitude ??
                  post.userLocation.value?.longitude ??
                  -119.4179,
            ),
            zoom: 14.5,
          ),
          onTap: (LatLng latLng) {
            setState(() {
              cardPosition = null;
              cardPost = null;
              overlayPos = null;
            });
          },
          onMapCreated: (controller) async {
            mapController = controller;
            await updateOverlayPosition();
          },
          onCameraMove: (position) async {
            updateOverlayPosition();
          },
          markers: markers,
        ),
        if (overlayPos != null)
          Positioned(
            left: overlayPos!.dx - 175,
            top: overlayPos!.dy - 180,
            child: PostCardSmall(post: cardPost!),
          ),

        // TODO: Fix the ditached scroll
        Positioned.fill(
          child: DraggableScrollableSheet(
            initialChildSize: 0.2,
            minChildSize: 0.2,
            maxChildSize: 1,
            snap: true,
            snapSizes: [0.2, 0.6, 1],
            builder: (context, controller) => ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              controller: controller,
              children: [
                Container(
                  padding: EdgeInsets.only(top: 12, left: 16, right: 16),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(25),
                    ),
                  ),
                  child: Obx(
                    () => Column(
                      children: [
                        Container(
                          width: 38,
                          height: 3,
                          decoration: BoxDecoration(
                            color: AppColors.gray.shade200,
                            borderRadius: BorderRadius.circular(99),
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (post.isFirstLoad.value) CustomLoading(),
                        for (var i in post.posts)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: PostCardSmall(
                              post: i,
                              witdth: double.infinity,
                            ),
                          ),
                        if (post.isMoreLoading.value) CustomLoading(),
                        if (!post.isMoreLoading.value)
                          Text(
                            "End of list",
                            style: AppTexts.tsmr.copyWith(
                              color: AppColors.gray.shade300,
                            ),
                          ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> updateOverlayPosition() async {
    if (mapController == null || cardPosition == null) return;

    if (Platform.isIOS) {
      final screenPoint = await mapController!.getScreenCoordinate(
        cardPosition!,
      );
      setState(() {
        overlayPos = Offset(screenPoint.x.toDouble(), screenPoint.y.toDouble());
      });
    } else if (Platform.isAndroid) {
      final screenPoint = await mapController!.getScreenCoordinate(
        cardPosition!,
      );
      // ignore: use_build_context_synchronously

      final dpX = screenPoint.x / pixelRatio;
      final dpY = screenPoint.y / pixelRatio;

      setState(() {
        overlayPos = Offset(dpX, dpY);
      });
    }
  }

  void loadMarkers() async {
    for (var i in post.posts) {
      final latlng = LatLng(
        i.location.coordinates[1],
        i.location.coordinates[0],
      );
      markers.add(
        Marker(
          markerId: MarkerId(i.id),
          position: latlng,
          onTap: () {
            setState(() {
              cardPosition = latlng;
              cardPost = i;
            });
            updateOverlayPosition();
          },
        ),
      );
    }
  }
}
