import 'dart:convert';
import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jurnee/controllers/maps_controller.dart';
import 'package:jurnee/controllers/user_controller.dart';
import 'package:jurnee/models/comment_model.dart';
import 'package:jurnee/models/pagination_meta.dart';
import 'package:jurnee/models/moment_model.dart';
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
  RxList<MomentModel> mediaList = RxList.empty();
  Rxn<Position> userLocation = Rxn();
  RxBool isLoading = RxBool(false);
  RxBool isAttendLoading = RxBool(false);
  RxBool mediaLoading = RxBool(false);

  RxInt currentPage = 1.obs;
  int limit = 10;
  RxInt totalPages = 1.obs;
  RxBool isFirstLoad = true.obs;
  RxBool isMoreLoading = false.obs;
  RxString commentLoading = RxString("");
  RxInt commentReviewCount = 0.obs;

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
    final currentLat =
        customLocation.value?.latitude ?? userLocation.value?.latitude ?? 0;
    final currentLng =
        customLocation.value?.longitude ?? userLocation.value?.longitude ?? 0;

    // Calculate distance in meters
    double distanceInMeters = Geolocator.distanceBetween(
      currentLat,
      currentLng,
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

  void clearFilters() {
    customLocation.value = null;
    fromDate.value = null;
    toDate.value = null;
    distance.value = null;
    minPrice.value = null;
    maxPrice.value = null;
    search.value = null;
    highlyRated.value = false;
    categoryList.clear();
    Get.find<MapsController>().selected.value = null;
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
              ? (distance.value! * 1609.344 * 1000).toInt() + 100
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
    commentReviewCount(0);
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
        commentReviewCount(meta.total);
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
    commentReviewCount(0);
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
        commentReviewCount(meta.total);
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
        // posts.insert(0, PostModel.fromJson(body['data']));
        // try {} catch (e) {
        //   debugPrint(e.toString());
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

  Future<String> createComment(
    String id,
    String content,
    File? image,
    File? video,
  ) async {
    if (content.isEmpty && image == null && video == null) {
      return "success";
    }
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
        commentReviewCount.value++;

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
    String postId,
    String parentId,
    String content,
    File? image,
    File? video,
  ) async {
    commentLoading(parentId);
    try {
      final data = {
        "data": {
          "postId": postId,
          "parentComment": parentId,
          "content": content,
        },
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
        var reply = CommentModel.fromJson(body['data']);
        // Recursive function to find the parent comment
        bool insertReply(List<CommentModel> commentsList) {
          for (var c in commentsList) {
            if (c.id == reply.parentComment) {
              c.children.insert(0, reply);
              return true;
            } else if (c.children.isNotEmpty) {
              if (insertReply(c.children)) return true;
            }
          }
          return false;
        }

        insertReply(comments);

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
    void Function()? revert;
    void Function(bool isLiked)? syncFromServer;

    void flipPostLike() {
      final i = posts.indexWhere((p) => p.id == id);
      if (i == -1) return;
      final liked = posts[i].isLiked;
      final n = posts[i].likes;
      posts[i].isLiked = !liked;
      posts[i].likes = n + (posts[i].isLiked ? 1 : -1);
      posts.refresh();
      revert = () {
        posts[i].isLiked = liked;
        posts[i].likes = n;
        posts.refresh();
      };
      syncFromServer = (ok) {
        posts[i].isLiked = ok;
        posts[i].likes = n + (ok ? 1 : -1);
        posts.refresh();
      };
    }

    void flipCommentLike() {
      final i = comments.indexWhere((c) => c.id == id);
      if (i == -1) return;
      final liked = comments[i].liked;
      final n = comments[i].like;
      comments[i].liked = !liked;
      comments[i].like = n + (comments[i].liked ? 1 : -1);
      comments.refresh();
      revert = () {
        comments[i].liked = liked;
        comments[i].like = n;
        comments.refresh();
      };
      syncFromServer = (ok) {
        comments[i].liked = ok;
        comments[i].like = n + (ok ? 1 : -1);
        comments.refresh();
      };
    }

    void flipReplyLike() {
      for (final c in comments) {
        final ri = c.children.indexWhere((r) => r.id == id);
        if (ri == -1) continue;
        final r = c.children[ri];
        final liked = r.liked;
        final n = r.like;
        r.liked = !liked;
        r.like = n + (r.liked ? 1 : -1);
        comments.refresh();
        revert = () {
          r.liked = liked;
          r.like = n;
          comments.refresh();
        };
        syncFromServer = (ok) {
          r.liked = ok;
          r.like = n + (ok ? 1 : -1);
          comments.refresh();
        };
        break;
      }
    }

    if (postCommentOrReply == "post") {
      flipPostLike();
    } else if (postCommentOrReply == "comment") {
      flipCommentLike();
    } else if (postCommentOrReply == "reply") {
      flipReplyLike();
    }

    try {
      final res = await api.post(
        "/like/${postCommentOrReply == "post" ? "like-toggle" : postCommentOrReply}",
        {"${postCommentOrReply}Id": id},
        authReq: true,
      );
      final body = jsonDecode(res.body);

      if (res.statusCode == 200 || res.statusCode == 201) {
        syncFromServer?.call(body['data'] != "disliked");
        return "liked";
      }
      revert?.call();
      return body['message'] ?? "Something went wrong";
    } catch (e) {
      revert?.call();
      return e.toString();
    }
  }

  Future<String> saveToggle(String id) async {
    void Function()? revert;
    void Function(bool isSaved)? syncFromServer;

    final i = posts.indexWhere((p) => p.id == id);
    if (i != -1) {
      final saved = posts[i].isSaved;
      final n = posts[i].totalSaved;
      posts[i].isSaved = !saved;
      posts[i].totalSaved = n + (posts[i].isSaved ? 1 : -1);
      posts.refresh();
      revert = () {
        posts[i].isSaved = saved;
        posts[i].totalSaved = n;
        posts.refresh();
      };
      syncFromServer = (ok) {
        posts[i].isSaved = ok;
        posts[i].totalSaved = n + (ok ? 1 : -1);
        posts.refresh();
      };
    }

    try {
      final res = await api.post("/save/save-toggle", {
        "postId": id,
      }, authReq: true);
      final body = jsonDecode(res.body);

      if (res.statusCode == 200 || res.statusCode == 201) {
        syncFromServer?.call(body['data'] != "unsaved");
        if (syncFromServer == null) posts.refresh();
        return "success";
      }
      revert?.call();
      return body['message'] ?? "Something went wrong";
    } catch (e) {
      revert?.call();
      return e.toString();
    }
  }

  Future<String> joinEvent(String id) async {
    isAttendLoading(true);
    try {
      final res = await api.post("/post/event/join/$id", {}, authReq: true);
      final body = jsonDecode(res.body);

      if (res.statusCode == 200 || res.statusCode == 201) {
        for (int index = 0; index < posts.length; index++) {
          if (posts[index].id == id) {
            posts[index].isAttender = true;
            final user = Get.find<UserController>().userData;
            posts[index].attenders.add(
              Author(id: user!.id, name: user.name, image: user.image),
            );
            posts.refresh();
          }
        }
        return "success";
      } else {
        return body['message'] ?? "Something went wrong";
      }
    } catch (e) {
      return e.toString();
    } finally {
      isAttendLoading(false);
    }
  }

  Future<String> addViewCount(String id) async {
    try {
      // final prefs = await SharedPreferences.getInstance();
      // final now = DateTime.now();
      // final todayKey = now.year * 10000 + now.month * 100 + now.day;
      // final prefsKey = 'post_view_count_day_$id';
      // final lastCalledDay = prefs.getInt(prefsKey);

      // if (lastCalledDay == todayKey) {
      //   return "success";
      // }

      final res = await api.get("/post/details/$id", authReq: true);

      final body = jsonDecode(res.body);

      if (res.statusCode == 200 || res.statusCode == 201) {
        final post = PostModel.fromJson(body['data']);
        int index = posts.indexWhere((val) => val.id == id);
        if (index == -1) {
          index = Get.find<UserController>().posts.indexWhere(
            (val) => val.id == id,
          );
        }
        if (index != -1) {
          posts[index] = post;
        } else {
          posts.add(post);
        }
        posts.refresh();
        // await prefs.setInt(prefsKey, todayKey);
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
        final user = Get.find<UserController>();
        int index = user.posts.indexWhere((val) => val.id == id);
        user.posts.removeAt(index);

        user.posts.refresh();

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

  Future<String> getMedia(String id) async {
    mediaLoading(true);
    try {
      final res = await api.get("/post/moment/$id/all", authReq: true);
      final body = jsonDecode(res.body);

      if (res.statusCode == 200 || res.statusCode == 201) {
        final data = body['data'];
        mediaList.clear();
        for (var i in data['mediaSource'] as List<dynamic>? ?? []) {
          mediaList.add(
            MomentModel.fromJson(Map<String, dynamic>.from(i as Map)),
          );
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
