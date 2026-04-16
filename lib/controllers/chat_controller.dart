import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:jurnee/controllers/user_controller.dart';
import 'package:jurnee/models/offer_model.dart';
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
  final Rxn<OfferModel> lastOffer = Rxn();
  final RxnString rejectedOfferId = RxnString();

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
    File? image,
    File? video,
    bool isOffer = false,
  }) {
    if (message.trim().isEmpty && image == null && video == null) {
      return;
    }

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
      MessageModel(
        id: "demo",
        chat: chatId,
        message: message,
        image: image?.path,
        video: video?.path,
      ),
    );
    messages.refresh();
    var payload = {"chat": chatId, "sender": senderId, "message": message};
    if (image != null) {
      payload["image"] = image.path;
    }
    if (video != null) {
      payload["video"] = video.path;
    }
    if (isOffer) {
      payload.addAll({"offer": message, "type": "offer"});
    }

    socket!.emit("send-message", payload);
  }

  Future<String> sendMedia({
    required String chatId,
    required String senderId,
    File? image,
    File? video,
  }) async {
    final mediaFile = image ?? video;
    if (mediaFile == null) {
      return "No media selected";
    }

    if (image != null && video != null) {
      return "Please send one media file at a time";
    }

    if (socket == null || !socket!.connected) {
      debugPrint(
        "⚠️ Cannot send media: Socket is not connected or initialized.",
      );
      return "Socket is not connected";
    }

    messages.insert(
      0,
      MessageModel(
        id: "demo",
        chat: chatId,
        image: image?.path,
        video: video?.path,
      ),
    );
    messages.refresh();

    try {
      final uploadBody = image != null ? {"image": image} : {"video": video!};
      final uploadRes = await api.post(
        "/chat/upload",
        uploadBody,
        isMultiPart: true,
        authReq: true,
      );
      final uploadJson = jsonDecode(uploadRes.body);

      if (uploadRes.statusCode != 200 && uploadRes.statusCode != 201) {
        messages.removeWhere((msg) => msg.id == "demo");
        messages.refresh();
        return uploadJson["message"] ?? "Failed to upload media";
      }

      final mediaUrl = _extractMediaUrl(uploadJson);
      if (mediaUrl == null || mediaUrl.isEmpty) {
        messages.removeWhere((msg) => msg.id == "demo");
        messages.refresh();
        return "Media upload succeeded but media url is missing";
      }

      final payload = {
        "chat": chatId,
        "sender": senderId,
        "type": "media",
        if (image != null) "image": mediaUrl,
        if (video != null) "video": mediaUrl,
      };

      socket!.emit("send-message", payload);
      return "success";
    } catch (e) {
      messages.removeWhere((msg) => msg.id == "demo");
      messages.refresh();
      return e.toString();
    }
  }

  String? _extractMediaUrl(Map<String, dynamic> uploadJson) {
    if (uploadJson["media_url"] is String) {
      return uploadJson["media_url"] as String;
    }
    if (uploadJson["data"] is Map &&
        uploadJson["data"]["media_url"] is String) {
      return uploadJson["data"]["media_url"] as String;
    }
    return null;
  }

  Future<String> createOrGetChat(String id, {String? postTitle}) async {
    isLoading(true);
    try {
      final res = await api.post("/chat/create", {"member": id}, authReq: true);
      final body = jsonDecode(res.body);

      if (res.statusCode == 200 || res.statusCode == 201) {
        final data = body['data'];

        final newId = data['_id'];

        final userController = Get.find<UserController>();
        final currentUserId = userController.userData?.id;

        final otherMember = (data["members"] as List)
            .map((mem) => Member.fromJson(mem))
            .firstWhere(
              (mem) => mem.id != currentUserId,
              orElse: () => Member.fromJson(data["members"].first),
            );

        if (postTitle != null) {
          final senderName = userController.userData?.name ?? "User";
          if (socket == null) {
            _initSocket();
          }
          if (socket != null && !socket!.connected) {
            socket!.connect();
          }
          if (socket != null && currentUserId != null) {
            socket!.emit("send-message", {
              "chat": newId,
              "sender": currentUserId,
              "message":
                  "Mr. $senderName is requesting a Quote Request for $postTitle",
              "type": "quote",
            });
          }
        }

        Get.to(() => Chat(inboxId: newId, chatMember: otherMember));

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

  Future<String> createOffer(Map<String, dynamic> data) async {
    isLoading(true);
    try {
      final res = await api.post("/offer", data, authReq: true);
      final body = jsonDecode(res.body);

      if (res.statusCode == 200 || res.statusCode == 201) {
        lastOffer.value = OfferModel.fromJson(body['data']);

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

  Future<String> rejectOffer(OfferModel offer) async {
    isLoading(true);
    try {
      final res = await api.post("/offer/reject", {
        "offerId": offer.id,
        "customerId": offer.customer,
      }, authReq: true);
      final body = jsonDecode(res.body);

      if (res.statusCode == 200 || res.statusCode == 201) {
        rejectedOfferId.value = offer.id;

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

  // Future<String> acceptOffer(OfferModel offer) async {
  //   isLoading(true);
  //   try {
  //     final res = await api.post("/offer/completed", {
  //       "offerId": offer.id,
  //       "customerId": offer.customer,
  //     }, authReq: true);
  //     final body = jsonDecode(res.body);

  //     if (res.statusCode == 200 || res.statusCode == 201) {
  //       return "success";
  //     } else {
  //       return body['message'] ?? "Something went wrong";
  //     }
  //   } catch (e) {
  //     return e.toString();
  //   } finally {
  //     isLoading(false);
  //   }
  // }
}
