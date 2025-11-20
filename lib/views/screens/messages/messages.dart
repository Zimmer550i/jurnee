import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jurnee/controllers/chat_controller.dart';
import 'package:jurnee/models/chat_model.dart';
import 'package:jurnee/utils/app_colors.dart';
import 'package:jurnee/utils/app_texts.dart';
import 'package:jurnee/utils/custom_list_handler.dart';
import 'package:jurnee/utils/custom_svg.dart';
import 'package:jurnee/views/base/profile_picture.dart';
import 'package:jurnee/views/screens/messages/chat.dart';

class Messages extends StatefulWidget {
  const Messages({super.key});

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  final chat = Get.find<ChatController>();

  @override
  void initState() {
    super.initState();
    chat.fetchChats();
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
        child: Obx(
          () => Column(
            spacing: 8,
            children: [
              const SizedBox(height: 12),
              for (var i in chat.chats) messageWidget(i),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget messageWidget(ChatModel chat) {
    return GestureDetector(
      onTap: () {
        Get.to(() => Chat(inboxId: chat.id));
      },
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            ProfilePicture(image: chat.members.last.image, size: 48),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          chat.members.last.name,
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
