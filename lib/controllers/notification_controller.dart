import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:jurnee/models/notification_model.dart';
import 'package:jurnee/models/pagination_meta.dart';
import 'package:jurnee/services/api_service.dart';

class NotificationController extends GetxController {
  final api = ApiService();

  RxList<NotificationModel> notifications = <NotificationModel>[].obs;

  RxInt currentPage = 1.obs;
  int limit = 10;
  RxInt totalPages = 1.obs;

  RxBool isFirstLoad = true.obs;
  RxBool isMoreLoading = false.obs;
  RxBool isLoading = RxBool(false);

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  Future<String> fetchNotifications({bool loadMore = false}) async {
    if (loadMore && currentPage.value >= totalPages.value) return "success";

    isLoading(true);

    if (!loadMore) {
      isFirstLoad(true);
      currentPage(1);
    } else {
      isMoreLoading(true);
      currentPage.value++;
    }

    try {
      final res = await api.get(
        "/notification",
        queryParams: {
          "page": currentPage.value.toString(),
          "limit": limit.toString(),
        },
        authReq: true,
      );

      final body = jsonDecode(res.body);

      if (res.statusCode == 200) {
        if (!loadMore) {
          notifications.clear();
        }
        final meta = PaginationMeta.fromJson(body['meta']);
        totalPages(meta.totalPage);

        final List<dynamic> dataList = body['data'];
        final newItems = dataList
            .map((e) => NotificationModel.fromJson(e))
            .toList();

        notifications.addAll(newItems);

        return "success";
      } else {
        return body['message'] ?? "Something went wrong";
      }
    } catch (e) {
      return e.toString();
    } finally {
      isFirstLoad(false);
      isMoreLoading(false);
      isLoading(false);
    }
  }

  readNotification(String id) async {
    try {
      final res = await api.get("/notification", authReq: true);

      if (res.statusCode == 200 || res.statusCode == 201) {
        int index = notifications.indexWhere((val) => val.id == id);
        notifications[index] = notifications
            .elementAt(index)
            .copyWith(read: true);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  deleteNotification(String id) async {
    try {
      final res = await api.delete("/notification", authReq: true);

      if (res.statusCode == 200 || res.statusCode == 201) {
        notifications.removeWhere((val) => val.id == id);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
