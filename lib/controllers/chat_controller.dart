import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:get/get.dart';
import 'package:jurnee/models/chat_model.dart';
import 'package:jurnee/models/message_model.dart';
import 'package:jurnee/models/pagination_meta.dart';
import 'package:jurnee/services/api_service.dart';

class ChatController extends GetxController {
  final api = ApiService();
  late io.Socket socket;
  final socketUrl = "http://10.10.12.54:3001";
  final RxList<ChatModel> chats = RxList.empty();
  final RxList<MessageModel> messages = RxList.empty();

  RxInt currentPage = 1.obs;
  int limit = 20;
  RxInt totalPages = 1.obs;

  RxBool isFirstLoad = true.obs;
  RxBool isMoreLoading = false.obs;
  RxBool isLoading = RxBool(false);

  /// Connect and listen to a specific chat in one method
  void connectAndListen(String chatId) {
    messages.clear();
    debugPrint("🔌 Connecting to socket…");

    socket = io.io(
      socketUrl,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .build(),
    );

    socket.connect();

    socket.onConnect((_) {
      debugPrint("🟢 Socket connected");

      String eventName = "receive-message:$chatId";
      debugPrint("👂 Listening to event: $eventName");

      socket.on(eventName, (data) {
        try {
          final message = MessageModel.fromJson(data);
          if (messages.elementAt(0).id == "demo") {
            messages.removeAt(0);
          }
          messages.insert(0, message);
          debugPrint("📩 New message received: ${message.message}");
        } catch (e) {
          debugPrint("❌ Message parsing error: $e");
        }
      });
    });

    socket.onDisconnect((_) {
      debugPrint("🔴 Socket disconnected");
    });
  }

  void disconnect() {
    socket.disconnect();
  }

  /// Send message to server
  void sendMessage({
    required String chatId,
    required String senderId,
    required String message,
  }) {
    messages.insert(
      0,
      MessageModel(id: "demo", chat: chatId, message: message),
    );
    messages.refresh();
    final payload = {"chat": chatId, "sender": senderId, "message": message};

    socket.emit("send-message", payload);
  }

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
