import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jurnee/controllers/chat_controller.dart';
import 'package:jurnee/controllers/user_controller.dart';
import 'package:jurnee/models/chat_model.dart';
import 'package:jurnee/utils/app_colors.dart';
import 'package:jurnee/utils/app_texts.dart';
import 'package:jurnee/utils/custom_list_handler.dart';
import 'package:jurnee/utils/custom_svg.dart';
import 'package:jurnee/views/base/custom_loading.dart';
import 'package:jurnee/views/base/offer_widget.dart';
import 'package:jurnee/views/base/profile_picture.dart';
import 'package:jurnee/views/screens/messages/create_offer.dart';
import 'package:jurnee/views/screens/profile/profile.dart';

class Chat extends StatefulWidget {
  final String inboxId;
  final Member chatMember;
  const Chat({super.key, required this.inboxId, required this.chatMember});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final chat = Get.find<ChatController>();
  final textCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    chat.addChatListener(widget.inboxId);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      chat.fetchMessages(widget.inboxId);
    });
  }

  @override
  void dispose() {
    super.dispose();
    chat.removeChatListener(widget.inboxId);
    textCtrl.dispose();
  }

  void onSend() async {
    chat.sendMessage(
      chatId: widget.inboxId,
      senderId: Get.find<UserController>().userData!.id,
      message: textCtrl.text,
    );
    textCtrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Center(
            child: CustomSvg(asset: "assets/icons/back.svg", size: 24),
          ),
        ),
        titleSpacing: 0,
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            GestureDetector(
              onTap: () => Get.to(() => Profile(userId: widget.chatMember.id)),
              child: Row(
                spacing: 12,
                children: [
                  ProfilePicture(image: widget.chatMember.image, size: 40),
                  Text(
                    widget.chatMember.name,
                    style: AppTexts.tlgb.copyWith(color: AppColors.gray),
                  ),
                ],
              ),
            ),
            Spacer(),
            GestureDetector(
              onTap: () {
                Get.to(
                  () => CreateOffer(
                    chatID: widget.inboxId,
                    userId: widget.chatMember.id,
                  ),
                );
              },
              child: CustomSvg(asset: "assets/icons/offer.svg", size: 24),
            ),
            const SizedBox(width: 20),
          ],
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Obx(
              () => CustomListHandler(
                isLoading: chat.isFirstLoad.value,
                reverse: true,
                onLoadMore: () =>
                    chat.fetchMessages(widget.inboxId, loadMore: true),
                child: Column(
                  children: [
                    if (chat.isMoreLoading.value) CustomLoading(),
                    if (chat.messages.isNotEmpty)
                      for (int i = chat.messages.length - 1; i >= 0; i--)
                        getMessage(i),
                    if (chat.messages.isEmpty)
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).size.height / 3,
                        ),
                        child: Text(
                          "Send somthing to start chatting",
                          textAlign: TextAlign.center,
                          style: AppTexts.tlgm.copyWith(
                            color: AppColors.gray.shade300,
                          ),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: OfferWidget(),
                    ),
                    const SizedBox(height: 70),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 24,
            right: 24,
            bottom: 8,
            child: SafeArea(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: textCtrl,
                        onSubmitted: (value) => onSend(),
                        decoration: InputDecoration(
                          isDense: true,
                          isCollapsed: true,
                          border: InputBorder.none,
                          hintText: "Type a message...",
                          hintStyle: AppTexts.tmdr.copyWith(
                            color: AppColors.gray.shade300,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => onSend(),
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: AppColors.green.shade700,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: CustomSvg(asset: "assets/icons/send.svg"),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getMessage(int index) {
    String message = chat.messages[index].message ?? "____";
    bool isRecieving = widget.chatMember.id == chat.messages[index].sender?.id;

    if (isRecieving) {
      return recieveMessage(
        message,
        hasPrev:
            index != chat.messages.length - 1 &&
            widget.chatMember.id == chat.messages[index + 1].sender?.id,
        hasNext:
            index != 0 &&
            widget.chatMember.id == chat.messages[index - 1].sender?.id,
      );
    } else {
      return sendMessage(
        message,
        hasPrev:
            index != chat.messages.length - 1 &&
            widget.chatMember.id != chat.messages[index + 1].sender?.id,
        hasNext:
            index != 0 &&
            widget.chatMember.id != chat.messages[index - 1].sender?.id,
      );
    }
  }

  Widget recieveMessage(
    String? message, {
    bool hasPrev = false,
    bool hasNext = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(top: hasPrev ? 2 : 14),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // hasNext
                //     ? SizedBox(height: 28, width: 28)
                //     : ProfilePicture(
                //         image: "https://thispersondoesnotexist.com",
                //         size: 28,
                //       ),
                // const SizedBox(width: 16),
                Flexible(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.gray.shade100,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(18),
                        bottomRight: Radius.circular(18),
                        topLeft: Radius.circular(hasPrev ? 4 : 18),
                        bottomLeft: Radius.circular(hasNext ? 4 : 18),
                      ),
                    ),
                    child: Text(message ?? "", style: TextStyle(fontSize: 15)),
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: Container()),
        ],
      ),
    );
  }

  Widget sendMessage(
    String? messgae, {
    bool hasPrev = false,
    bool hasNext = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(top: hasPrev ? 2 : 14),
      child: Row(
        children: [
          Expanded(child: Container()),
          Expanded(
            flex: 3,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.green.shade900,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(18),
                        bottomLeft: Radius.circular(18),
                        topRight: Radius.circular(hasPrev ? 4 : 18),
                        bottomRight: Radius.circular(hasNext ? 4 : 18),
                      ),
                    ),
                    child: Text(
                      messgae ?? "",
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
