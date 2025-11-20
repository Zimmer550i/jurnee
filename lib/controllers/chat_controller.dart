import 'dart:convert';
import 'package:get/get.dart';
import 'package:jurnee/models/chat_model.dart';
import 'package:jurnee/models/message_model.dart';
import 'package:jurnee/models/pagination_meta.dart';
import 'package:jurnee/services/api_service.dart';

class ChatController extends GetxController {
  final api = ApiService();
  final RxList<ChatModel> chats = RxList.empty();
  final RxList<MessageModel> messages = RxList.empty();

  RxInt currentPage = 1.obs;
  int limit = 10;
  RxInt totalPages = 1.obs;

  RxBool isFirstLoad = true.obs;
  RxBool isMoreLoading = false.obs;
  RxBool isLoading = RxBool(false);

  Future<String> fetchChats({bool loadMore = false}) async {
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
        "/chat",
        queryParams: {
          "page": currentPage.value.toString(),
          "limit": limit.toString(),
        },
        authReq: true,
      );

      final body = jsonDecode(res.body);

      if (res.statusCode == 200) {
        if (!loadMore) {
          chats.clear();
        }
        final meta = PaginationMeta.fromJson(body['meta']);
        totalPages(meta.totalPage);

        final List<dynamic> dataList = body['data'];
        final newItems = dataList.map((e) => ChatModel.fromJson(e)).toList();

        chats.addAll(newItems);

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

  Future<String> fetchMessages(String id, {bool loadMore = false}) async {
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
        "/chat/inbox/$id",
        queryParams: {
          "page": currentPage.value.toString(),
          "limit": limit.toString(),
        },
        authReq: true,
      );

      final body = jsonDecode(res.body);

      if (res.statusCode == 200) {
        if (!loadMore) {
          messages.clear();
        }
        final meta = PaginationMeta.fromJson(body['meta']);
        totalPages(meta.totalPage);

        final List<dynamic> dataList = body['data'];
        final newItems = dataList.map((e) => MessageModel.fromJson(e)).toList();

        messages.addAll(newItems);

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
}
