import 'dart:convert';

import 'package:get/state_manager.dart';
import 'package:jurnee/models/pagination_meta.dart';
import 'package:jurnee/models/post_model.dart';
import 'package:jurnee/models/user.dart';
import 'package:jurnee/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserController extends GetxController {
  Rxn<User> user = Rxn();
  Rxn<User> specificUser = Rxn();
  RxList<PostModel> posts = RxList.empty();
  RxBool isLoading = RxBool(false);
  RxBool isFollowLoading = RxBool(false);

  final api = ApiService();
  late SharedPreferences prefs;

  RxInt currentPage = 1.obs;
  int limit = 10;
  RxInt totalPages = 1.obs;
  RxBool isFirstLoad = true.obs;
  RxBool isMoreLoading = false.obs;

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

  Future followUnfollowUser(String id) async {
    isFollowLoading(true);
    try {
      final res = await api.post("/follower/follow-unfollow", {
        "follower": id,
      }, authReq: true);
      final body = jsonDecode(res.body);

      if (res.statusCode == 200 || res.statusCode == 201) {
        bool isFollower = body['data']['isFollower'];
        return isFollower;
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
    } finally {
      getFollowers();
      getFollowing();
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

  Future<String> getFollowers({int page = 1, int limit = 5}) async {
    try {
      final res = await api.get(
        "/follower/my-followers",
        queryParams: {"page": page.toString(), "limit": limit.toString()},
        authReq: true,
      );
      final body = jsonDecode(res.body);

      if (res.statusCode == 200 || res.statusCode == 201) {
        user.value?.followers = PaginationMeta.fromJson(body['meta']).total;
        user.refresh();
        return "success";
      } else {
        return body["message"] ?? "Something went wrong";
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> getFollowing({int page = 1, int limit = 5}) async {
    try {
      final res = await api.get(
        "/follower/my-following",
        queryParams: {"page": page.toString(), "limit": limit.toString()},
        authReq: true,
      );
      final body = jsonDecode(res.body);

      if (res.statusCode == 200 || res.statusCode == 201) {
        user.value?.following = PaginationMeta.fromJson(body['meta']).total;
        user.refresh();
        return "success";
      } else {
        return body["message"] ?? "Something went wrong";
      }
    } catch (e) {
      return e.toString();
    }
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
