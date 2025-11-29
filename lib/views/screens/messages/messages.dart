import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jurnee/controllers/chat_controller.dart';
import 'package:jurnee/controllers/user_controller.dart';
import 'package:jurnee/models/chat_model.dart';
import 'package:jurnee/utils/app_colors.dart';
import 'package:jurnee/utils/app_texts.dart';
import 'package:jurnee/utils/custom_list_handler.dart';
import 'package:jurnee/utils/custom_svg.dart';
import 'package:jurnee/views/base/custom_loading.dart';
import 'package:jurnee/views/base/profile_picture.dart';
import 'package:jurnee/views/screens/messages/chat.dart';

class Messages extends StatefulWidget {
  const Messages({super.key});

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  final chat = Get.find<ChatController>();
  late String userId;

  @override
  void initState() {
    super.initState();
    chat.fetchChats();
    userId = Get.find<UserController>().userData!.id;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.scaffoldBG,
        surfaceTintColor: Colors.transparent,
        titleSpacing: 0,
        title: Row(
          children: [
            const SizedBox(width: 24),
            CustomSvg(asset: "assets/icons/logo.svg"),
            Spacer(),
            const SizedBox(width: 24),
          ],
        ),
      ),
      body: CustomListHandler(
        onRefresh: () => chat.fetchChats(),
        onLoadMore: () => chat.fetchChats(loadMore: true),
        child: Obx(
          () => chat.isFirstLoad.value
              ? CustomLoading()
              : Column(
                  spacing: 8,
                  children: [
                    const SizedBox(height: 12),
                    for (var i in chat.chats) messageWidget(i),
                    if (chat.isMoreLoading.value) CustomLoading(),
                    if (!chat.isMoreLoading.value)
                      Text(
                        "End of list",
                        style: AppTexts.tsmr.copyWith(
                          color: AppColors.gray.shade300,
                        ),
                      ),
                    if (!chat.isMoreLoading.value &&
                        !chat.isFirstLoad.value &&
                        chat.chats.isEmpty)
                      Center(
                        child: Text(
                          "You have to messages",
                          style: AppTexts.tsmr.copyWith(
                            color: AppColors.gray.shade300,
                          ),
                        ),
                      ),
                    const SizedBox(height: 12),
                  ],
                ),
        ),
      ),
    );
  }

  Widget messageWidget(ChatModel chat) {
    // Hides chat with single member
    if (chat.members.length == 1) return Container();
    final Member recipent = chat.members.where((mem) => mem.id != userId).first;

    return GestureDetector(
      onTap: () {
        Get.to(() => Chat(inboxId: chat.id, chatMember: recipent));
      },
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            ProfilePicture(image: recipent.image, size: 48),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          recipent.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTexts.tlgs.copyWith(
                            color: AppColors.gray.shade700,
                          ),
                        ),
                      ),
                      Text(
                        DateFormat("HH:MM a").format(chat.createdAt),
                        style: TextStyle(
                          fontFamily: "Roboto",
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          height: 24 / 14,
                          color: AppColors.gray.shade300,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          chat.lastMessage?.message ?? "",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTexts.tmdr.copyWith(
                            color: AppColors.gray.shade400,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      if (chat.unread != 0)
                        Container(
                          height: 16,
                          width: 16,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.green.shade600,
                          ),
                          child: Center(
                            child: Text(
                              chat.unread.toString(),
                              style: TextStyle(
                                fontSize: 12,
                                height: 1,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
