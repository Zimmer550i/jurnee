import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:jurnee/models/place_prediction.dart';
import 'package:uuid/uuid.dart';

class MapsController extends GetxController {
  // Reactive variables
  var predictions = <PlacePrediction>[].obs;
  var query = ''.obs; // We listen to changes on this variable

  // Internal variables
  String? _sessionToken;
  final String _apiKey = "AIzaSyDltI2vV-mbS5Qy-gz2lPMTf7RAbR4tZRs";

  @override
  void onInit() {
    super.onInit();
    _sessionToken = const Uuid().v4();

    // GETX MAGIC: This replaces the manual Timer logic
    // It listens to 'query', waits 500ms, then runs _fetchSuggestions
    debounce(
      query,
      (callback) => _fetchSuggestions(callback),
      time: const Duration(milliseconds: 500),
    );
  }

  // 1. Update the query signal (called from UI)
  void onSearchChanged(String val) {
    query.value = val;
  }

  // 2. The API Logic
  Future<void> _fetchSuggestions(String input) async {
    if (input.isEmpty) {
      predictions.clear();
      return;
    }

    final String request =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$_apiKey&sessiontoken=$_sessionToken';

    try {
      final response = await http.get(Uri.parse(request));
      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        debugPrint(response.body);
        if (result['status'] == 'OK') {
          // Convert and assign to the reactive list
          predictions.value = (result['predictions'] as List)
              .map((p) => PlacePrediction.fromJson(p))
              .toList();
        }
      }
    } catch (e) {
      debugPrint("Error fetching places: $e");
    }
    debugPrint(predictions.toString());
  }

  // 3. Selection Logic
  void selectPrediction(
    PlacePrediction prediction,
    TextEditingController textController,
  ) {
    textController.text = prediction.description;
    predictions.clear();
    query.value = ""; // Reset internal query so it doesn't re-trigger search
    _sessionToken = const Uuid().v4(); // Reset session for Google billing
  }
}
