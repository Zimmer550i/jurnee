import 'package:flutter/widgets.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:jurnee/services/shared_prefs_service.dart';
import 'package:jurnee/utils/custom_snackbar.dart';

/// 1. getLocation with caching logic and override parameter
Future<Position?> getLocation({
  bool forceRefresh = false,
  Duration cacheDuration = const Duration(hours: 1),
}) async {
  // Check cache if we aren't forcing a refresh
  if (!forceRefresh) {
    final cachedPos = await _getCachedPosition(cacheDuration);
    if (cachedPos != null) {
      debugPrint("📍 Returning cached location");
      return cachedPos;
    }
  }

  // Request permissions
  final permission = await _handlePermission();
  if (!permission) {
    customSnackBar("❌ Location permission not granted");
    debugPrint("❌ Location permission not granted");
    return null;
  }

  // Fetch fresh position
  final pos = await _fetchPosition();
  if (pos != null) {
    _savePosition(pos);
  }

  return pos;
}

/// 2. Calculate distance in miles
Future<String> getDistance(double targetLat, double targetLong) async {
  // Get current location (will use cache if available < 1 hour)
  Position? currentPos = await getLocation();

  if (currentPos == null) {
    return "Unknown distance";
  }

  // Calculate distance in meters
  double distanceInMeters = Geolocator.distanceBetween(
    currentPos.latitude,
    currentPos.longitude,
    targetLat,
    targetLong,
  );

  // Convert meters to miles (1 meter = 0.000621371 miles)
  double distanceInMiles = distanceInMeters * 0.000621371;

  return "${distanceInMiles.toStringAsFixed(1)} miles";
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
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.best),
    );
  } catch (e) {
    debugPrint("❌ Failed to get location: $e");
    return null;
  }
}

/// 3. Save location AND current time
void _savePosition(Position pos) {
  SharedPrefsService.set("latitude", pos.latitude);
  SharedPrefsService.set("longitude", pos.longitude);
  // Save the current time as an ISO string
  SharedPrefsService.set("location_timestamp", DateTime.now().toIso8601String()); 
  
  debugPrint("📍 Location Saved: ${pos.latitude}, ${pos.longitude} at ${DateTime.now()}");
}

/// Helper to retrieve cached position
Future<Position?> _getCachedPosition(Duration threshold) async {
  try {
    // Assuming SharedPrefsService has getters. Adjust types if your service is different.
    final String? timestampStr = await SharedPrefsService.get("location_timestamp");
    final double? lat = await SharedPrefsService.getDouble("latitude");
    final double? lng = await SharedPrefsService.getDouble("longitude");

    if (timestampStr != null && lat != null && lng != null) {
      final DateTime savedTime = DateTime.parse(timestampStr);
      final DateTime now = DateTime.now();

      // Check if the saved time is within the threshold
      if (now.difference(savedTime) < threshold) {
        // Reconstruct a Position object
        return Position(
          longitude: lng,
          latitude: lat,
          timestamp: savedTime,
          accuracy: 0.0,
          altitude: 0.0,
          altitudeAccuracy: 0.0,
          heading: 0.0,
          headingAccuracy: 0.0,
          speed: 0.0,
          speedAccuracy: 0.0,
          isMocked: false, // Assuming cached isn't mocked
        );
      }
    }
  } catch (e) {
    debugPrint("⚠️ Error reading cached location: $e");
  }
  return null;
}

Future<bool> isUserInCalifornia() async {
  // You can pass forceRefresh: true here if you want to ensure fresh data
  Position? pos = await getLocation();

  // NOTE: The block below overrides the logic with hardcoded data 
  // as per your original code snippet.
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
