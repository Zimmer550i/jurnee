import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:jurnee/models/pagination_meta.dart';
import 'package:jurnee/models/post_model.dart';
import 'package:jurnee/services/api_service.dart';
import 'package:jurnee/utils/get_location.dart';

enum PostType { defaultPosts }

class PostController extends GetxController {
  final api = ApiService();
  RxMap<PostType, RxList<PostModel>> postMap = <PostType, RxList<PostModel>>{
    for (var e in PostType.values) e: <PostModel>[].obs,
  }.obs;
  Rxn<Position> userLocation = Rxn();
  RxBool isLoading = RxBool(false);

  RxInt currentPage = 1.obs;
  int limit = 10;
  RxInt totalPages = 1.obs;
  RxBool isFirstLoad = true.obs;
  RxBool isMoreLoading = false.obs;

  void fetchLocation() {
    getLocation().then((val) {
      userLocation.value = val;
    });
    getLocation(forceRefresh: true).then((val) {
      userLocation.value = val;
    });
  }

  String getDistance(double targetLat, double targetLong) {
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

  Future<String> fetchPosts({
    bool loadMore = false,
    String? category,
    String? search,
  }) async {
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
        queryParams: {
          "page": currentPage.value.toString(),
          "limit": limit.toString(),
          "category": category,
          "search": search,
        },
        authReq: true,
      );

      final body = jsonDecode(res.body);

      if (res.statusCode == 200) {
        if (!loadMore) {
          postMap[PostType.defaultPosts]!.clear();
        }
        final meta = PaginationMeta.fromJson(body['meta']);
        totalPages(meta.totalPage);

        final List<dynamic> dataList = body['data'];
        final newItems = dataList.map((e) => PostModel.fromJson(e)).toList();

        postMap[PostType.defaultPosts]!.addAll(newItems);

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
        // final data = body['data'];

        // final post = PostModel.fromJson(data);

        // int? index = postMap[PostType.defaultPosts]?.indexWhere(
        //   (val) => val.id == id,
        // );

        // if (index != null && index != -1) {
        //   postMap[PostType.defaultPosts]![index] = post;
        // }

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
