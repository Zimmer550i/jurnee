import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jurnee/controllers/user_controller.dart';
import 'package:jurnee/models/comment_model.dart';
import 'package:jurnee/models/pagination_meta.dart';
import 'package:jurnee/models/post_model.dart';
import 'package:jurnee/models/reivew_model.dart';
import 'package:jurnee/services/api_service.dart';
import 'package:jurnee/utils/get_location.dart';

enum PostType { defaultPosts }

class PostController extends GetxController {
  final api = ApiService();
  RxList<PostModel> posts = RxList.empty();
  RxList<CommentModel> comments = RxList.empty();
  RxList<ReviewModel> reviews = RxList.empty();
  RxList<String> mediaListOwner = RxList.empty();
  RxList<String> mediaListCommunity = RxList.empty();
  Rxn<Position> userLocation = Rxn();
  RxBool isLoading = RxBool(false);
  RxBool mediaLoading = RxBool(false);

  RxInt currentPage = 1.obs;
  int limit = 10;
  RxInt totalPages = 1.obs;
  RxBool isFirstLoad = true.obs;
  RxBool isMoreLoading = false.obs;
  RxString commentLoading = RxString("");

  RxBool highlyRated = RxBool(false);
  RxList<String> categoryList = RxList.empty();
  RxnString search = RxnString();
  RxnInt minPrice = RxnInt();
  RxnInt maxPrice = RxnInt();
  RxnDouble distance = RxnDouble();
  Rxn<LatLng> customLocation = Rxn();
  Rxn<DateTime> fromDate = Rxn<DateTime>();
  Rxn<DateTime> toDate = Rxn<DateTime>();

  Future<void> fetchLocation() async {
    await getLocation().then((val) {
      userLocation.value = val;
    });
    if (userLocation.value != null) {
      await Get.find<UserController>().updateUserData({
        "location": {
          "type": "Point",
          "coordinates": [
            userLocation.value!.longitude,
            userLocation.value!.latitude,
          ],
        },
      });
    }
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
          "dateFrom": fromDate.value?.toIso8601String(),
          "dateTo": toDate.value?.toIso8601String(),
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

  Future<String> fetchComments(String id, {bool loadMore = false}) async {
    if (loadMore && currentPage.value >= totalPages.value) return "success";

    if (!loadMore) {
      isFirstLoad(true);
      currentPage(1);
      comments.clear();
    } else {
      isMoreLoading(true);
      currentPage.value++;
    }

    try {
      final res = await api.get(
        "/comments/$id",
        queryParams: {
          "page": currentPage.value.toString(),
          "limit": limit.toString(),
        },
        authReq: true,
      );

      final body = jsonDecode(res.body);

      if (res.statusCode == 200) {
        final meta = PaginationMeta.fromJson(body['meta']);
        totalPages(meta.totalPage);

        final List<dynamic> dataList = body['data'];
        final newItems = dataList.map((e) => CommentModel.fromJson(e)).toList();

        comments.addAll(newItems);

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

  Future<String> fetchReviews(String id, {bool loadMore = false}) async {
    if (loadMore && currentPage.value >= totalPages.value) return "success";

    if (!loadMore) {
      isFirstLoad(true);
      currentPage(1);
      reviews.clear();
    } else {
      isMoreLoading(true);
      currentPage.value++;
    }

    try {
      final res = await api.get(
        "/review/post-reviews/$id",
        queryParams: {
          "page": currentPage.value.toString(),
          "limit": limit.toString(),
        },
        authReq: true,
      );

      final body = jsonDecode(res.body);

      if (res.statusCode == 200) {
        final meta = PaginationMeta.fromJson(body['meta']);
        totalPages(meta.totalPage);

        final List<dynamic> dataList = body['data'];
        final newItems = dataList.map((e) => ReviewModel.fromJson(e)).toList();

        reviews.addAll(newItems);

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
        posts.insert(0, PostModel.fromJson(body['data']));
        try {} catch (e) {
          debugPrint(e.toString());
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

  Future<String> createComment(
    String id,
    String content,
    File? image,
    File? video,
  ) async {
    commentLoading(id);
    try {
      final data = {
        "data": {"postId": id, "content": content},
        "image": image,
        "video": video,
      };

      final res = await api.post(
        "/comments",
        data,
        isMultiPart: true,
        authReq: true,
      );
      final body = jsonDecode(res.body);

      if (res.statusCode == 200 || res.statusCode == 201) {
        comments.insert(0, CommentModel.fromJson(body['data']));

        return "success";
      } else {
        return body['message'] ?? "Something went wrong";
      }
    } catch (e) {
      return e.toString();
    } finally {
      commentLoading("");
    }
  }

  Future<String> createReply(
    String id,
    String content,
    File? image,
    File? video,
  ) async {
    commentLoading(id);
    try {
      final data = {
        "data": {"commentId": id, "content": content},
        "image": image,
        "video": video,
      };

      final res = await api.post(
        "/replies",
        data,
        isMultiPart: true,
        authReq: true,
      );
      final body = jsonDecode(res.body);

      if (res.statusCode == 200 || res.statusCode == 201) {
        var reply = CommentModel.fromJson(body['data']);
        comments
            .firstWhere((val) => reply.commentId == val.id)
            .reply
            .insert(0, reply);

        comments.refresh();

        return "success";
      } else {
        return body['message'] ?? "Something went wrong";
      }
    } catch (e) {
      return e.toString();
    } finally {
      commentLoading("");
    }
  }

  Future<String> likeToggle(String id, String postCommentOrReply) async {
    try {
      final res = await api.post(
        "/like/${postCommentOrReply == "post" ? "like-toggle" : postCommentOrReply}",
        {"${postCommentOrReply}Id": id},
        authReq: true,
      );
      final body = jsonDecode(res.body);

      if (res.statusCode == 200 || res.statusCode == 201) {
        bool isLiked = true;
        if (body['data'] == "disliked") isLiked = false;

        if (postCommentOrReply == "post") {
          posts.firstWhere((val) => val.id == id).likes += isLiked ? 1 : -1;
          posts.refresh();
        } else if (postCommentOrReply == "comment") {
          comments.firstWhere((val) => val.id == id).like += isLiked ? 1 : -1;
          comments.firstWhere((val) => val.id == id).liked = isLiked
              ? true
              : false;
          comments.refresh();
        } else if (postCommentOrReply == "reply") {
          final parentComment = comments.firstWhere(
            (c) => c.reply.any((r) => r.id == id),
          );

          final replyIndex = parentComment.reply.indexWhere((r) => r.id == id);

          if (replyIndex != -1) {
            parentComment.reply[replyIndex].like += isLiked ? 1 : -1;
            parentComment.reply[replyIndex].liked = isLiked;
          }

          comments.refresh();
        }

        return "liked";
      } else {
        return body['message'] ?? "Something went wrong";
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> saveToggle(String id) async {
    try {
      final res = await api.post("/save/save-toggle", {
        "postId": id,
      }, authReq: true);

      final body = jsonDecode(res.body);

      if (res.statusCode == 200 || res.statusCode == 201) {
        bool isSaved = true;
        if (body['data'] == "unsaved") isSaved = false;

        final postIndex = posts.indexWhere((val) => val.id == id);

        if (postIndex != -1) {
          posts[postIndex].isSaved = isSaved;
        }

        posts.refresh();

        return "success";
      } else {
        return body['message'] ?? "Something went wrong";
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> addViewCount(String id) async {
    try {
      final res = await api.get("/post/details/$id", authReq: true);

      final body = jsonDecode(res.body);

      if (res.statusCode == 200 || res.statusCode == 201) {
        return "success";
      } else {
        return body['message'] ?? "Something went wrong";
      }
    } catch (e) {
      return e.toString();
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

  Future<String> deletePost(String id) async {
    isLoading(true);
    try {
      final res = await api.delete("/post/$id", authReq: true);
      final body = jsonDecode(res.body);

      if (res.statusCode == 200 || res.statusCode == 201) {
        int index = posts.indexWhere((val) => val.id == id);
        posts.removeAt(index);

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

  Future<String> getMedia(String id, {String type = "owner"}) async {
    mediaLoading(true);
    try {
      final res = await api.get("/post/moment/$id/$type", authReq: true);
      final body = jsonDecode(res.body);

      if (res.statusCode == 200 || res.statusCode == 201) {
        final data = body['data'];

        if (type == "owner") {
          mediaListOwner.clear();
          for (var i in data['media']) {
            mediaListOwner.add(i);
          }
        } else {
          mediaListCommunity.clear();
          for (var i in data['media']) {
            mediaListCommunity.add(i);
          }
        }

        return "success";
      } else {
        return body['message'] ?? "Something went wrong";
      }
    } catch (e) {
      return e.toString();
    } finally {
      mediaLoading(false);
    }
  }
}
