import 'package:flutter/widgets.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:jurnee/services/shared_prefs_service.dart';

class LocationController extends GetxController {
  Rxn<Position> userLocation = Rxn();
  RxBool hasPermission = RxBool(false);

  Future<void> checkPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }

    hasPermission.value =
        permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  Future<Position?> getLocation() async {
    await checkPermission();
    if (!hasPermission.value) {
      Geolocator.openAppSettings();
      return null;
    }

    final pos = await _fetchPosition();
    if (pos != null) {
      userLocation.value = pos;
      _savePosition(pos);
    }

    return pos;
  }

  Future<Position?> _fetchPosition() async {
    try {
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.best,
        ),
      );
    } catch (e) {
      debugPrint("❌ Failed to get location: $e");
      return null;
    }
  }

  void _savePosition(Position pos) {
    SharedPrefsService.set("latitude", pos.latitude);
    SharedPrefsService.set("longitude", pos.longitude);
    SharedPrefsService.set(
      "location_timestamp",
      DateTime.now().toIso8601String(),
    );
  }

  Future<bool> isUserInCalifornia() async {
    final pos = await getLocation();
    if (pos == null) return true;

    try {
      final placemarks = await placemarkFromCoordinates(
        pos.latitude,
        pos.longitude,
      );

      if (placemarks.isNotEmpty) {
        final region = placemarks.first.administrativeArea
            ?.toLowerCase()
            .trim();
        return region == 'california' || region == 'ca';
      }
    } catch (e) {
      debugPrint("❌ Failed to detect California: $e");
    }

    return false;
  }
}
