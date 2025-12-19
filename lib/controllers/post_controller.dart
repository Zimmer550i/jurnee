import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jurnee/controllers/user_controller.dart';
import 'package:jurnee/models/pagination_meta.dart';
import 'package:jurnee/models/post_model.dart';
import 'package:jurnee/services/api_service.dart';
import 'package:jurnee/utils/get_location.dart';

enum PostType { defaultPosts }

class PostController extends GetxController {
  final api = ApiService();
  RxList<PostModel> posts = RxList.empty();
  Rxn<Position> userLocation = Rxn();
  RxBool isLoading = RxBool(false);

  RxInt currentPage = 1.obs;
  int limit = 10;
  RxInt totalPages = 1.obs;
  RxBool isFirstLoad = true.obs;
  RxBool isMoreLoading = false.obs;

  RxBool highlyRated = RxBool(false);
  RxList<String> categoryList = RxList.empty();
  RxnString search = RxnString();
  RxnInt minPrice = RxnInt();
  RxnInt maxPrice = RxnInt();
  RxnDouble distance = RxnDouble();
  Rxn<LatLng> customLocation = Rxn();
  Rxn<DateTime> date = Rxn<DateTime>();

  void fetchLocation() {
    getLocation().then((val) {
      userLocation.value = val;
    });
    getLocation(forceRefresh: true).then((val) {
      userLocation.value = val;
      Get.find<UserController>().updateUserData({
        "location": {
          "type": "Point",
          "coordinates": [val!.longitude, val.latitude],
        },
      });
    });
  }

  String getDistance(double targetLong, double targetLat) {
    // Calculate distance in meters
    double distanceInMeters = Geolocator.distanceBetween(
      userLocation.value?.latitude ?? 0,
      userLocation.value?.longitude ?? 0,
      targetLat,
      targetLong,
    );

    // Convert meters to miles (1 meter = 0.000621371 miles)
    double distanceInMiles = distanceInMeters * 0.000621371;

    return "${distanceInMiles.toStringAsFixed(1)} miles";
  }

  Map<String, String> _removeNullQueryParams(Map<String, dynamic> params) {
    final Map<String, String> cleaned = {};
    params.forEach((key, value) {
      if (value != null && value.toString().isNotEmpty) {
        cleaned[key] = value.toString();
      }
    });
    return cleaned;
  }

  Future<String> fetchPosts({bool loadMore = false, String? category}) async {
    if (loadMore && currentPage.value >= totalPages.value) return "success";

    if (!loadMore) {
      isFirstLoad(true);
      currentPage(1);
    } else {
      isMoreLoading(true);
      currentPage.value++;
    }

    try {
      final res = await api.get(
        "/post/all-post",
        queryParams: _removeNullQueryParams({
          "page": currentPage.value,
          "limit": limit,
          "lat": customLocation.value?.latitude,
          "lng": customLocation.value?.longitude,
          "maxDistance": distance.value != null
              ? (distance.value! * 1609.344 * 1000).toInt()
              : null,
          "rating": highlyRated.value ? "4" : null,
          "minPrice": minPrice.value,
          "maxPrice": maxPrice.value,
          "category": category ?? categoryList.join(","),
          "dateTime": date.value?.toIso8601String(),
          "search": search.value,
        }),
        authReq: true,
      );

      final body = jsonDecode(res.body);

      if (res.statusCode == 200) {
        if (!loadMore) {
          posts.clear();
        }
        final meta = PaginationMeta.fromJson(body['meta']);
        totalPages(meta.totalPage);

        final List<dynamic> dataList = body['data'];
        final newItems = dataList.map((e) => PostModel.fromJson(e)).toList();

        posts.addAll(newItems);

        return "success";
      } else {
        return body['message'] ?? "Something went wrong";
      }
    } catch (e) {
      return e.toString();
    } finally {
      isFirstLoad(false);
      isMoreLoading(false);
    }
  }

  Future<String> createPost(String type, Map<String, dynamic> data) async {
    isLoading(true);
    try {
      final res = await api.post(
        "/post/$type",
        data,
        isMultiPart: true,
        authReq: true,
      );
      final body = jsonDecode(res.body);

      if (res.statusCode == 200 || res.statusCode == 201) {
        return "success";
      } else {
        return body['message'] ?? "Something went wrong";
      }
    } catch (e) {
      return e.toString();
    } finally {
      isLoading(false);
    }
  }

  Future<String> updatePost(String id, Map<String, dynamic> data) async {
    isLoading(true);
    try {
      final res = await api.patch("/post/$id", data, authReq: true);
      final body = jsonDecode(res.body);

      if (res.statusCode == 200 || res.statusCode == 201) {
        final data = body['data'];

        final post = PostModel.fromJson(data);

        int? index = posts.indexWhere((val) => val.id == id);

        if (index != -1) {
          posts[index] = post;
        }

        return "success";
      } else {
        return body['message'] ?? "Something went wrong";
      }
    } catch (e) {
      return e.toString();
    } finally {
      isLoading(false);
    }
  }
}
