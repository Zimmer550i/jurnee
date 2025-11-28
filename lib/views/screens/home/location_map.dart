import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jurnee/controllers/post_controller.dart';
import 'package:jurnee/models/post_model.dart';
import 'package:jurnee/utils/get_location.dart';
import 'package:jurnee/views/base/post_card_small.dart';

class LocationMap extends StatefulWidget {
  const LocationMap({super.key});

  @override
  State<LocationMap> createState() => _LocationMapState();
}

class _LocationMapState extends State<LocationMap> {
  final post = Get.find<PostController>();
  late Position pos;
  Set<Marker> markers = {};
  GoogleMapController? mapController;
  Offset? overlayPos;
  LatLng? cardPosition;

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
                target: LatLng(pos.latitude, pos.longitude),
                zoom: 14.4746,
              ),
              onMapCreated: (controller) async {
                mapController = controller;
                await updateOverlayPosition();
              },
              onCameraMove: (position) {
                // loadMarkers();
                updateOverlayPosition();
              },
              markers: markers,
            ),
          ),
          if (overlayPos != null)
            Positioned(
              left: overlayPos!.dx - 150,
              top: overlayPos!.dy - 180,
              child: const PostCardSmall(),
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
    pos = (await getLocation())!;
    for (var i in post.postMap[PostType.defaultPosts] ?? <PostModel>[]) {
      markers.add(
        Marker(
          markerId: MarkerId(i.id),
          position: LatLng(pos!.latitude, pos.longitude),
          onTap: () {
            setState(() {
              cardPosition = LatLng(pos.latitude, pos.longitude);
            });
          },
        ),
      );
    }
    setState(() {});
  }
}
