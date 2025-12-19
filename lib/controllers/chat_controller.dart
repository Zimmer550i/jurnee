import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:jurnee/views/screens/messages/chat.dart';
import 'package:get/get.dart';
import 'package:jurnee/models/chat_model.dart';
import 'package:jurnee/models/message_model.dart';
import 'package:jurnee/models/pagination_meta.dart';
import 'package:jurnee/services/api_service.dart';
// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatController extends GetxController {
  final api = ApiService();

  RxBool isConnected = RxBool(false);
  IO.Socket? socket;
  final _socketUrl = "https://api.joinjurnee.com/";

  final RxList<ChatModel> chats = RxList.empty();
  final RxList<MessageModel> messages = RxList.empty();

  RxInt currentPage = 1.obs;
  int limit = 20;
  RxInt totalPages = 1.obs;

  RxBool isFirstLoad = true.obs;
  RxBool isMoreLoading = false.obs;
  RxBool isLoading = RxBool(false);

  @override
  void onInit() {
    super.onInit();
    _initSocket();
  }

  /// ⚙️ Initializes the Socket.IO client instance
  void _initSocket() {
    try {
      socket = IO.io(_socketUrl, <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
      });

      // Setup general connection listeners
      socket?.on('connect', (_) {
        isConnected.value = true;
        debugPrint('Socket.IO Connected');
      });

      socket?.on('disconnect', (_) {
        isConnected.value = false;
        debugPrint('Socket.IO Disconnected');
      });

      socket?.on('connect_error', (data) {
        debugPrint('Connection Error: $data');
        isConnected.value = false;
      });
    } catch (e) {
      debugPrint('Socket.IO initialization error: $e');
    }
  }

  /// 👂 Adds the specific message listener for the current chat ID.
  void addChatListener(String chatId) {
    messages.clear();
    debugPrint("🔌 Preparing socket connection for chat: $chatId…");
    String eventName = "receive-message:$chatId";

    if (!socket!.connected) {
      socket!.connect();
    }

    socket?.on(eventName, (data) {
      try {
        final message = MessageModel.fromJson(data);
        if (messages.isNotEmpty && messages.elementAt(0).id == "demo") {
          messages.removeAt(0);
        }
        messages.insert(0, message);
        debugPrint("📩 New message received: ${message.message}");
      } catch (e) {
        debugPrint('Error parsing incoming message: $e, Data: $data');
      }
    });
    debugPrint('Listening to event: $eventName');
  }

  /// 🛑 Removes the specific message listener for the current chat ID.
  void removeChatListener(String chatId) {
    final eventName = 'receive-message:$chatId';
    // Use the off method to stop listening to a specific event
    socket?.off(eventName);
    debugPrint('Stopped listening to event: $eventName');
  }

  /// Send message to server
  void sendMessage({
    required String chatId,
    required String senderId,
    required String message,
  }) {
    // Check if socket is null or disconnected before attempting to send
    if (socket == null || !socket!.connected) {
      debugPrint(
        "⚠️ Cannot send message: Socket is not connected or initialized.",
      );
      // Optionally show a user message or try to reconnect
      return;
    }

    messages.insert(
      0,
      MessageModel(id: "demo", chat: chatId, message: message),
    );
    messages.refresh();
    final payload = {"chat": chatId, "sender": senderId, "message": message};

    socket!.emit("send-message", payload);
  }

  Future<String> createOrGetChat(String id) async {
    isLoading(true);
    try {
      final res = await api.post("/chat/create", {"member": id}, authReq: true);
      final body = jsonDecode(res.body);

      if (res.statusCode == 200 || res.statusCode == 201) {
        final data = body['data'];

        final newId = data['_id'];

        Get.to(
          () => Chat(
            inboxId: newId,
            chatMember: Member.fromJson(data["members"][1]),
          ),
        );

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

  Future<String> fetchChats({bool loadMore = false}) async {
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
    }
  }

  Future<String> fetchMessages(String id, {bool loadMore = false}) async {
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
    }
  }
}
