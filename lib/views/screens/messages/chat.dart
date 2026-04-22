import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jurnee/controllers/chat_controller.dart';
import 'package:jurnee/controllers/user_controller.dart';
import 'package:jurnee/models/chat_model.dart';
import 'package:jurnee/models/message_model.dart';
import 'package:jurnee/utils/app_colors.dart';
import 'package:jurnee/utils/app_texts.dart';
import 'package:jurnee/utils/media_type.dart';
import 'package:jurnee/utils/custom_list_handler.dart';
import 'package:jurnee/utils/custom_snackbar.dart';
import 'package:jurnee/utils/custom_svg.dart';
import 'package:jurnee/views/base/custom_loading.dart';
import 'package:jurnee/views/base/custom_networked_image.dart';
import 'package:jurnee/views/base/media_thumbnail.dart';
import 'package:jurnee/views/base/offer_widget.dart';
import 'package:jurnee/views/base/profile_picture.dart';
import 'package:jurnee/views/base/video_widget.dart';
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
  File? messageImage;
  File? messageVideo;

  @override
  void initState() {
    super.initState();
    chat.addChatListener(widget.inboxId);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      chat.fetchMessages(widget.inboxId).then((message) {
        if (message != "success") {
          customSnackBar(message);
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    chat.removeChatListener(widget.inboxId);
    textCtrl.dispose();
  }

  void onSend() async {
    if (textCtrl.text.trim().isEmpty &&
        messageImage == null &&
        messageVideo == null) {
      return;
    }
    final tempVideo = messageVideo;
    final tempImage = messageImage;
    setState(() {
      textCtrl.clear();
      messageImage = null;
      messageVideo = null;
    });

    final senderId = Get.find<UserController>().userData!.id;
    final text = textCtrl.text.trim();

    if (tempImage != null || tempVideo != null) {
      final mediaResult = await chat.sendMedia(
        chatId: widget.inboxId,
        senderId: senderId,
        image: tempImage,
        video: tempVideo,
      );
      if (mediaResult != "success" && mounted) {
        customSnackBar(mediaResult);
        return;
      }
    }

    if (text.isNotEmpty) {
      chat.sendMessage(
        chatId: widget.inboxId,
        senderId: senderId,
        message: text,
      );
    }
  }

  Future<void> onPickMedia() async {
    final file = await ImagePicker().pickMedia();
    if (file == null) return;

    setState(() {
      final pickedFile = File(file.path);
      if (isVideoMedia(path: file.path, mimeType: file.mimeType)) {
        messageVideo = pickedFile;
        messageImage = null;
      } else {
        messageImage = pickedFile;
        messageVideo = null;
      }
    });
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
                  AbsorbPointer(
                    child: ProfilePicture(
                      image: widget.chatMember.image,
                      size: 40,
                    ),
                  ),
                  Text(
                    widget.chatMember.name,
                    style: AppTexts.tlgb.copyWith(color: AppColors.gray),
                  ),
                ],
              ),
            ),
            Spacer(),
            if (Get.find<UserController>().myServices.isNotEmpty)
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
                          "Send a message to start chatting",
                          textAlign: TextAlign.center,
                          style: AppTexts.tlgm.copyWith(
                            color: AppColors.gray.shade300,
                          ),
                        ),
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
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Stack(
                      alignment: Alignment.topRight,
                      children: [
                        Container(
                          height: (messageImage == null && messageVideo == null)
                              ? 40
                              : 100,
                          padding: EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(
                              (messageImage == null && messageVideo == null)
                                  ? 99
                                  : 10,
                            ),
                          ),
                          child: Row(
                            spacing: 8,
                            children: [
                              if (messageImage == null && messageVideo == null)
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
                                onTap: onPickMedia,
                                child:
                                    messageImage == null && messageVideo == null
                                    ? CustomSvg(
                                        asset: "assets/icons/add_image.svg",
                                        color: AppColors.gray.shade400,
                                      )
                                    : _ChatMediaPreview(
                                        imagePath: messageImage?.path,
                                        videoPath: messageVideo?.path,
                                        isLocalFile: true,
                                        size:
                                            (MediaQuery.of(context).size.width /
                                                1.7) -
                                            (124 / 1.7),
                                        onTap: onPickMedia,
                                      ),
                              ),
                            ],
                          ),
                        ),
                        if (messageImage != null || messageVideo != null)
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                messageImage = null;
                                messageVideo = null;
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.only(top: 6, right: 6),
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.close,
                                size: 16,
                                color: AppColors.gray.shade400,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
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
        ],
      ),
    );
  }

  Widget getMessage(int index) {
    final currentMessage = chat.messages[index];
    if (currentMessage.type == MessageType.offer) {
      if (currentMessage.offer?.status == "rejected" ||
          chat.rejectedOfferId.value == currentMessage.offer?.id) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Text(
            "Offer Rejected!",
            style: AppTexts.tsmr.copyWith(color: AppColors.gray.shade400),
          ),
        );
      }
      try {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: OfferWidget(offer: currentMessage.offer!),
        );
      } catch (e) {
        debugPrint(e.toString());
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Text(
            "Error Loading Offer!",
            style: AppTexts.tsmr.copyWith(color: AppColors.red),
          ),
        );
      }
    }

    String text = currentMessage.message ?? "";
    bool isRecieving = widget.chatMember.id == currentMessage.sender?.id;

    if (isRecieving) {
      return recieveMessage(
        text,
        messageModel: currentMessage,
        hasPrev:
            index != chat.messages.length - 1 &&
            widget.chatMember.id == chat.messages[index + 1].sender?.id,
        hasNext:
            index != 0 &&
            widget.chatMember.id == chat.messages[index - 1].sender?.id,
      );
    } else {
      return sendMessage(
        text,
        messageModel: currentMessage,
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
    MessageModel? messageModel,
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 6,
                      children: [
                        if ((message?.isNotEmpty ?? false))
                          Text(message ?? "", style: TextStyle(fontSize: 15)),
                        if ((messageModel?.image?.isNotEmpty ?? false) ||
                            (messageModel?.video?.isNotEmpty ?? false))
                          _ChatMediaPreview(
                            imagePath: messageModel?.image,
                            videoPath: messageModel?.video,
                            isLocalFile: messageModel?.id == "demo",
                          ),
                      ],
                    ),
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
    MessageModel? messageModel,
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      spacing: 6,
                      children: [
                        if ((messgae?.isNotEmpty ?? false))
                          Text(
                            messgae ?? "",
                            style: TextStyle(fontSize: 15, color: Colors.white),
                          ),
                        if ((messageModel?.image?.isNotEmpty ?? false) ||
                            (messageModel?.video?.isNotEmpty ?? false))
                          _ChatMediaPreview(
                            imagePath: messageModel?.image,
                            videoPath: messageModel?.video,
                            isLocalFile: messageModel?.id == "demo",
                          ),
                      ],
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

class _ChatMediaPreview extends StatelessWidget {
  final String? imagePath;
  final String? videoPath;
  final bool isLocalFile;
  final double size;
  final VoidCallback? onTap;

  const _ChatMediaPreview({
    this.imagePath,
    this.videoPath,
    this.isLocalFile = false,
    this.size = 180,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final normalizedImagePath = (imagePath?.trim().isNotEmpty ?? false)
        ? imagePath!.trim()
        : null;
    final normalizedVideoPath = (videoPath?.trim().isNotEmpty ?? false)
        ? videoPath!.trim()
        : null;
    final mediaPath = normalizedImagePath ?? normalizedVideoPath;
    if (mediaPath == null || mediaPath.isEmpty) {
      return const SizedBox();
    }

    return GestureDetector(
      onTap:
          onTap ??
          () {
            if (normalizedVideoPath != null) {
              Get.to(() => VideoWidget(initialUrl: normalizedVideoPath));
            }
          },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(
          height: size,
          width: size * 1.7,
          child: normalizedVideoPath != null
              ? MediaThumbnail(path: normalizedVideoPath)
              : isLocalFile
              ? Image.file(File(mediaPath), fit: BoxFit.cover)
              : CustomNetworkedImage(url: mediaPath, fit: BoxFit.cover),
        ),
      ),
    );
  }
}
