import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:jurnee/controllers/post_controller.dart';
import 'package:jurnee/models/place_prediction.dart';
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MapsController extends GetxController {
  var predictions = <PlacePrediction>[].obs;
  Rxn<PlacePrediction> selected = Rxn();
  var query = ''.obs; 
  var isLoading = false.obs;

  String? _sessionToken;
  final String _apiKey = dotenv.env['GOOGLE_API_KEY'] ?? '';
  final int cacheDays = 3; 

  // Count
  int hit = 0;
  int miss = 0;

  @override
  void onInit() {
    super.onInit();
    _sessionToken = const Uuid().v4();

    debounce(
      query,
      (val) => _handleCachedSuggestions(val),
      time: Duration(milliseconds: 100),
    );
  }

  // 1. Update the query signal (called from UI)
  void onSearchChanged(String val) {
    query.value = val;
    _handleCachedSuggestions(val);
  }

  // 3. Selection Logic
  void selectPrediction(
    PlacePrediction prediction,
    TextEditingController textController,
  ) {
    getPlacePosition(prediction.placeId).then((newPosition) {
      Get.find<PostController>().customLocation.value = LatLng(
        newPosition?['lat'],
        newPosition?['lng'],
      );
    });
    selected.value = prediction;
    textController.text = prediction.description;
    predictions.clear();
    query.value = "";
    _sessionToken = const Uuid().v4(); // Reset session for Google billing
  }

  // 4. Get place details (lat/lng) from placeId
  Future<Map<String, dynamic>?> getPlacePosition(String? placeId) async {
    if (placeId == null) return null;

    final String url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$_apiKey&sessiontoken=$_sessionToken';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'OK') {
          final location = data['result']['geometry']['location'];
          return {"lat": location['lat'], "lng": location['lng']};
        }
      }
    } catch (e) {
      debugPrint("Error fetching place position: $e");
    }
    return null;
  }

  // 5. Reverse geocoding: Get address from lat/lng
  Future<String?> getAddressFromLatLng(double lat, double lng) async {
    final String url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$_apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'OK' && data['results'].isNotEmpty) {
          return data['results'][0]['formatted_address'];
        }
      }
    } catch (e) {
      debugPrint("Error reverse geocoding: $e");
    }
    return null;
  }

  // Check cache first, then fetch from API if expired or missing
  Future<void> _handleCachedSuggestions(String input) async {
    if (input.isEmpty) {
      predictions.clear();
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final String cacheKey = "place_cache_$input";
    final String timeKey = "place_cache_time_$input";

    final cached = prefs.getString(cacheKey);
    final cachedTime = prefs.getInt(timeKey);

    if (cached != null && cachedTime != null) {
      final DateTime saved = DateTime.fromMillisecondsSinceEpoch(cachedTime);
      final bool valid = DateTime.now().difference(saved).inDays < cacheDays;

      if (valid) {
        debugPrint("Hit Count: ${hit++}");
        final decoded = json.decode(cached) as List;
        predictions.value = decoded
            .map((p) => PlacePrediction.fromJson(p))
            .toList();
        isLoading.value = false;
        return; // use cached instantly
      }
    }

    // Cache expired → fetch new data
    await _fetchAndCacheSuggestions(input, cacheKey, timeKey);
  }

  // Fetch from API and update cache
  Future<void> _fetchAndCacheSuggestions(
    String input,
    String cacheKey,
    String timeKey,
  ) async {
    isLoading.value = true;
    final String request =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$_apiKey&sessiontoken=$_sessionToken';

    try {
      final response = await http.get(Uri.parse(request));
      debugPrint("Miss Count: ${miss++}");
      if (response.statusCode == 200) {
        final result = json.decode(response.body);

        if (result['status'] == 'OK') {
          final list = (result['predictions'] as List)
              .map((p) => PlacePrediction.fromJson(p))
              .toList();
          predictions.value = list;

          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(cacheKey, json.encode(result['predictions']));
          await prefs.setInt(timeKey, DateTime.now().millisecondsSinceEpoch);
        }
      }
    } catch (e) {
      debugPrint("Error fetching places: $e");
    }
    isLoading.value = false;
  }
}
