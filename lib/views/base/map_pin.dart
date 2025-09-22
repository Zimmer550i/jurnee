import 'package:flutter/material.dart';
import 'package:jurnee/utils/custom_svg.dart';

class MapPin extends StatefulWidget {
  const MapPin({super.key});

  @override
  State<MapPin> createState() => _MapPinState();
}

class _MapPinState extends State<MapPin> {
  bool showDetails = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8,
      mainAxisSize: MainAxisSize.min,
      children: [
        if(showDetails)
        GestureDetector(
          onTap: () {
            setState(() {
              showDetails = !showDetails;
            });
          },
          child: CustomSvg(asset: "assets/icons/pin.svg"),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              showDetails = !showDetails;
            });
          },
          child: CustomSvg(asset: "assets/icons/pin.svg"),
        ),
      ],
    );
  }
}
