import 'dart:convert';

import 'package:get/get.dart';
import 'package:jurnee/controllers/post_controller.dart';
import 'package:jurnee/models/pagination_meta.dart';
import 'package:jurnee/models/post_model.dart';
import 'package:jurnee/models/user.dart';
import 'package:jurnee/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserController extends GetxController {
  Rxn<User> user = Rxn();
  Rxn<User> specificUser = Rxn();
  RxList<PostModel> get posts => Get.find<PostController>().posts;
  RxBool isLoading = RxBool(false);
  RxBool isFollowLoading = RxBool(false);
 
  final api = ApiService();
  late SharedPreferences prefs;

  RxInt currentPage = 1.obs;
  int limit = 10;
  RxInt totalPages = 1.obs;
  RxBool isFirstLoad = true.obs;
  RxBool isMoreLoading = false.obs;
  RxList<Author> usersList = RxList.empty();

  User? get userData => user.value;
  String? get userImage {
    if (user.value == null || user.value?.image == null) return null;

    return "${user.value?.image}";
  }

  set userData(User? val) {
    user.value = val;
  }

  @override
  void onInit() async {
    super.onInit();
    prefs = await SharedPreferences.getInstance();
  }

  Future<String> getSpecificUserInfo(String id) async {
    isLoading(true);
    try {
      final res = await api.get("/user/get-single-user/$id", authReq: true);
      final body = jsonDecode(res.body);

      if (res.statusCode == 200 || res.statusCode == 201) {
        specificUser.value = User.fromJson(body['data']);
        return "success";
      } else {
        return body["message"] ?? "Something went wrong";
      }
    } catch (e) {
      return e.toString();
    } finally {
      isLoading(false);
    }
  }

  Future<String> followUnfollowUser(String id) async {
    isFollowLoading(true);
    try {
      final res = await api.post("/follower/follow-unfollow", {
        "follower": id,
      }, authReq: true);
      final body = jsonDecode(res.body);

      if (res.statusCode == 200 || res.statusCode == 201) {
        bool isFollower = body['data']['isFollower'];

        if (isFollower) {
          specificUser.value!.followers += 1;
        } else {
          specificUser.value!.followers -= 1;
        }
        specificUser.value!.isFollow = isFollower;

        specificUser.refresh();

        return "success";
      } else {
        return body["message"] ?? "Something went wrong";
      }
    } catch (e) {
      return e.toString();
    } finally {
      isFollowLoading(false);
    }
  }

  Future<String> getUserData() async {
    try {
      final res = await api.get("/user/profile", authReq: true);
      final body = jsonDecode(res.body);

      if (res.statusCode == 200 || res.statusCode == 201) {
        user.value = User.fromJson(body['data']);
        return "success";
      } else {
        return body["message"] ?? "Something went wrong";
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> getUserPosts(
    int index,
    String? id, {
    bool loadMore = false,
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
        [
          "/post/user-post/$id",
          "/post/user-join-event/$id",
          "/save/my-saved-post",
          "/post/my-service",
        ][index],
        queryParams: {
          "page": currentPage.value.toString(),
          "limit": limit.toString(),
        },
        authReq: true,
      );
      final body = jsonDecode(res.body);

      if (res.statusCode == 200 || res.statusCode == 201) {
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
        return body["message"] ?? "Something went wrong";
      }
    } catch (e) {
      return e.toString();
    } finally {
      isFirstLoad(false);
      isMoreLoading(false);
    }
  }

  Future<String> changePassword(
    String currentPassword,
    String newPassword,
    String confirmPassword,
  ) async {
    isLoading(true);
    try {
      final res = await api.post("/auth/change-password", {
        "currentPassword": currentPassword,
        "newPassword": newPassword,
        "confirmPassword": confirmPassword,
      }, authReq: true);
      final body = jsonDecode(res.body);

      if (res.statusCode == 200 || res.statusCode == 201) {
        return "success";
      } else {
        return body["message"] ?? "Something went wrong";
      }
    } catch (e) {
      return e.toString();
    } finally {
      isLoading(false);
    }
  }

  Future<String> updateUserData(Map<String, dynamic> data) async {
    isLoading(true);
    try {
      final res = await api.patch("/user/update-profile", data, authReq: true);
      final body = jsonDecode(res.body);

      if (res.statusCode == 200 || res.statusCode == 201) {
        user.value = User.fromJson(body['data']);
        return "success";
      } else {
        return body["message"] ?? "Something went wrong";
      }
    } catch (e) {
      return e.toString();
    } finally {
      isLoading(false);
    }
  }

  Future<String> getFollowers(String id, {bool loadMore = false}) async {
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
        "/follower/followers/$id",
        queryParams: {
          "page": currentPage.value.toString(),
          "limit": limit.toString(),
        },
        authReq: true,
      );
      final body = jsonDecode(res.body);

      if (res.statusCode == 200 || res.statusCode == 201) {
        if (!loadMore) {
          usersList.clear();
        }

        final meta = PaginationMeta.fromJson(body['meta']);
        totalPages(meta.totalPage);

        final List<dynamic> dataList = body['data'] ?? [];
        final newItems = dataList
            .map((e) => _mapFollowUserToAuthor(e, preferredKey: 'follower'))
            .whereType<Author>()
            .toList();
        usersList.addAll(newItems);
        return "success";
      } else {
        return body["message"] ?? "Something went wrong";
      }
    } catch (e) {
      return e.toString();
    } finally {
      isFirstLoad(false);
      isMoreLoading(false);
    }
  }

  Future<String> getFollowing(String id, {bool loadMore = false}) async {
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
        "/follower/following/$id",
        queryParams: {
          "page": currentPage.value.toString(),
          "limit": limit.toString(),
        },
        authReq: true,
      );
      final body = jsonDecode(res.body);

      if (res.statusCode == 200 || res.statusCode == 201) {
        if (!loadMore) {
          usersList.clear();
        }

        final meta = PaginationMeta.fromJson(body['meta']);
        totalPages(meta.totalPage);

        final List<dynamic> dataList = body['data'] ?? [];
        final newItems = dataList
            .map((e) => _mapFollowUserToAuthor(e, preferredKey: 'followed'))
            .whereType<Author>()
            .toList();
        usersList.addAll(newItems);
        return "success";
      } else {
        return body["message"] ?? "Something went wrong";
      }
    } catch (e) {
      return e.toString();
    } finally {
      isFirstLoad(false);
      isMoreLoading(false);
    }
  }

  Author? _mapFollowUserToAuthor(dynamic raw, {required String preferredKey}) {
    if (raw is! Map<String, dynamic>) return null;

    final dynamic preferred = raw[preferredKey];
    final dynamic alternate =
        raw[preferredKey == 'follower' ? 'followed' : 'follower'];
    final Map<String, dynamic>? userData = preferred is Map<String, dynamic>
        ? preferred
        : (alternate is Map<String, dynamic> ? alternate : null);

    if (userData == null) return null;

    final String? id = userData['_id'] ?? userData['id'];
    final String name = (userData['name'] ?? '').toString();
    final String image = (userData['image'] ?? '').toString();

    return Author(id: id, name: name, image: image);
  }

  Future<String> postSupport(
    String name,
    String email,
    String description,
    String subject,
    String transactionId,
  ) async {
    isLoading(true);
    try {
      final res = await api.post("/support", {
        "name": name,
        "email": email,
        "description": description,
        "subject": subject,
        "transactionId": transactionId,
      }, authReq: true);
      final body = jsonDecode(res.body);

      if (res.statusCode == 200 || res.statusCode == 201) {
        return "success";
      } else {
        return body["message"] ?? "Something went wrong";
      }
    } catch (e) {
      return e.toString();
    } finally {
      isLoading(false);
    }
  }
}
