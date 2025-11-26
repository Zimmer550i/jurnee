import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jurnee/utils/app_colors.dart';
import 'package:jurnee/views/base/post_card_small.dart';
import 'package:widget_to_marker/widget_to_marker.dart';

class LocationMap extends StatefulWidget {
  const LocationMap({super.key});

  @override
  State<LocationMap> createState() => _LocationMapState();
}

class _LocationMapState extends State<LocationMap> {
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
                target: LatLng(37.42796133580664, -122.085749655962),
                zoom: 14.4746,
              ),
              onMapCreated: (controller) async {
                mapController = controller;
                await updateOverlayPosition();
              },
              onCameraMove: (position) {
                loadMarkers();
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
    markers.addAll([
      Marker(
        markerId: MarkerId("1"),
        position: LatLng(37.42796133580664, -122.085749655962),
        icon: await Icon(Icons.location_pin, color: AppColors.green.shade600)
            .toBitmapDescriptor(
              logicalSize: Size(300, 300),
              waitToRender: Duration.zero,
            ),
        onTap: () async {
          setState(() {
            cardPosition = const LatLng(37.42796133580664, -122.085749655962);
          });
          await updateOverlayPosition();
        },
      ),
      Marker(
        markerId: MarkerId("2"),
        position: LatLng(37.42858833580664, -122.085749655962),
        icon: await Icon(Icons.location_pin, color: AppColors.green.shade600)
            .toBitmapDescriptor(
              logicalSize: Size(300, 300),
              waitToRender: Duration.zero,
            ),
        onTap: () async {
          setState(() {
            if (cardPosition != null &&
                cardPosition!.latitude == 37.42858833580664 &&
                cardPosition!.longitude == -122.085749655962) {
              cardPosition = null;
            } else {
              cardPosition = const LatLng(37.42858833580664, -122.085749655962);
            }
          });
          await updateOverlayPosition();
        },
      ),
    ]);

    // if (cardPosition != null) {
    //   markers.add(
    //     Marker(
    //       markerId: MarkerId("card"),
    //       position: cardPosition!,
    //       icon:
    //           await Padding(
    //             padding: EdgeInsetsGeometry.only(bottom: 60),
    //             child: PostCardSmall(),
    //           ).toBitmapDescriptor(
    //             logicalSize: Size(400, 500),
    //             imageSize: Size(400, 500),
    //             waitToRender: Duration.zero,
    //           ),
    //       onTap: () {
    //         // Get.to(() => PostDetails());
    //       },
    //     ),
    //   );
    // }

    setState(() {});
  }
}
