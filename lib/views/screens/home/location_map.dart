import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jurnee/utils/app_colors.dart';
import 'package:jurnee/views/base/post_card_small.dart';
import 'package:jurnee/views/screens/home/post_details.dart';
import 'package:widget_to_marker/widget_to_marker.dart';

class LocationMap extends StatefulWidget {
  const LocationMap({super.key});

  @override
  State<LocationMap> createState() => _LocationMapState();
}

class _LocationMapState extends State<LocationMap> {
  Set<Marker> markers = {};
  LatLng? cardPosition;

  @override
  void initState() {
    super.initState();
    loadMarkers();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: LatLng(37.42796133580664, -122.085749655962),
          zoom: 14.4746,
        ),
        onCameraMove: (position) {
          loadMarkers();
        },
        markers: markers,
      ),
    );
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
            cardPosition = LatLng(37.42796133580664, -122.085749655962);
          });
          loadMarkers();
        },
      ),
      Marker(
        markerId: MarkerId("2"),
        position: LatLng(37.42796133580664, -122.085749655962),
        icon: await Icon(Icons.location_pin, color: AppColors.green.shade600)
            .toBitmapDescriptor(
              logicalSize: Size(300, 300),
              waitToRender: Duration.zero,
            ),
        onTap: () async {
          setState(() {
            if (cardPosition == LatLng(37.42796133580664, -122.085749655962)) {
              cardPosition = null;
            } else {
              cardPosition = LatLng(37.42796133580664, -122.085749655962);
            }
          });
          loadMarkers();
        },
      ),
    ]);
    while (markers.length > 2) {
      markers.remove(markers.elementAt(0));
    }

    if (cardPosition != null) {
      markers.add(
        Marker(
          markerId: MarkerId("card"),
          position: cardPosition!,
          icon:
              await Padding(
                padding: EdgeInsetsGeometry.only(bottom: 60),
                child: PostCardSmall(),
              ).toBitmapDescriptor(
                logicalSize: Size(400, 400),
                imageSize: Size(600, 600),
                waitToRender: Duration.zero,
              ),
          onTap: () {
            Get.to(() => PostDetails());
          },
        ),
      );
    }

    setState(() {});
  }
}
