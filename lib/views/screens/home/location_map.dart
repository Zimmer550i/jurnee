import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jurnee/controllers/post_controller.dart';
import 'package:jurnee/models/post_model.dart';
import 'package:jurnee/views/base/post_card_small.dart';

class LocationMap extends StatefulWidget {
  const LocationMap({super.key});

  @override
  State<LocationMap> createState() => _LocationMapState();
}

class _LocationMapState extends State<LocationMap> {
  final post = Get.find<PostController>();
  Set<Marker> markers = {};
  GoogleMapController? mapController;
  Offset? overlayPos;
  LatLng? cardPosition;
  PostModel? cardPost;

  @override
  void initState() {
    super.initState();
    loadMarkers();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                cardPosition = null;
              });
            },
            child: GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  post.userLocation.value!.latitude,
                  post.userLocation.value!.longitude,
                ),
                zoom: 14.5,
              ),
              onMapCreated: (controller) async {
                mapController = controller;
                await updateOverlayPosition();
              },
              onCameraMove: (position) async {
                updateOverlayPosition();
              },
              markers: markers,
            ),
          ),
          if (overlayPos != null)
            Positioned(
              left: overlayPos!.dx - 175,
              top: overlayPos!.dy - 180,
              child: PostCardSmall(post: cardPost!),
            ),
        ],
      ),
    );
  }

  Future<void> updateOverlayPosition() async {
    if (mapController == null || cardPosition == null) return;

    final screenPoint = await mapController!.getScreenCoordinate(cardPosition!);
    setState(() {
      overlayPos = Offset(screenPoint.x.toDouble(), screenPoint.y.toDouble());
    });
  }

  void loadMarkers() async {
    for (var i in post.postMap[PostType.defaultPosts] ?? <PostModel>[]) {
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
