import 'package:flutter/widgets.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:jurnee/services/shared_prefs_service.dart';
import 'package:jurnee/utils/custom_snackbar.dart';

Future<Position?> getLocation() async {
  final permission = await _handlePermission();
  if (!permission) {
    customSnackBar("❌ Location permission not granted");
    debugPrint("❌ Location permission not granted");
    return null;
  }

  final pos = await _fetchPosition();
  if (pos != null) {
    _savePosition(pos);
  }

  return pos;
}

Future<bool> _handlePermission() async {
  LocationPermission permission = await Geolocator.checkPermission();

  if (permission == LocationPermission.denied ||
      permission == LocationPermission.deniedForever) {
    permission = await Geolocator.requestPermission();
  }

  return permission == LocationPermission.always ||
      permission == LocationPermission.whileInUse;
}

Future<Position?> _fetchPosition() async {
  try {
    return await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(accuracy: LocationAccuracy.best),
    );
  } catch (e) {
    debugPrint("❌ Failed to get location: $e");
    return null;
  }
}

void _savePosition(Position pos) {
  SharedPrefsService.set("latitude", pos.latitude);
  SharedPrefsService.set("longitude", pos.longitude);
  debugPrint("📍 Location Saved: ${pos.latitude}, ${pos.longitude}");
}

Future<bool> isUserInCalifornia() async {
  Position? pos = await getLocation();
  pos = Position(
    latitude: 44.7749,
    longitude: -122.4194,
    timestamp: DateTime.now(),
    accuracy: 5.0,
    altitude: 10.0,
    altitudeAccuracy: 5.0,
    heading: 0.0,
    headingAccuracy: 0.0,
    speed: 0.0,
    speedAccuracy: 0.0,
    isMocked: true,
  );

  // if (pos == null) {
  //   return false;
  // }

  try {
    final placemarks = await placemarkFromCoordinates(
      pos.latitude,
      pos.longitude,
    );

    if (placemarks.isNotEmpty) {
      final place = placemarks.first;
      final region = place.administrativeArea?.toLowerCase().trim();
      return region == 'california' || region == 'ca';
    }
  } catch (e) {
    debugPrint("❌ Failed to detect California: $e");
  }

  return false;
}
