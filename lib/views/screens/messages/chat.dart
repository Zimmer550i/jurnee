import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jurnee/utils/app_colors.dart';
import 'package:jurnee/utils/app_texts.dart';
import 'package:jurnee/utils/custom_svg.dart';
import 'package:jurnee/views/base/profile_picture.dart';

class Chat extends StatefulWidget {
  final String inboxId;
  const Chat({super.key, required this.inboxId});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  List<Widget> messages = [];

  @override
  void initState() {
    super.initState();
    getMessages();
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
          spacing: 12,
          children: [
            ProfilePicture(
              image: "https://thispersondoesnotexist.com",
              size: 40,
            ),
            Text(
              "Sample Name",
              style: AppTexts.tlgb.copyWith(color: AppColors.gray),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    ...messages,
                    ...messages,
                    ...messages,
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
                    Container(
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
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void getMessages() {
    messages.clear();
    messages.addAll([
      recieveMessage("Hey, do you know what time is it where you are?"),
      sendMessage("t’s morning in Tokyo 😎"),
      recieveMessage("What does it look like in Japan?", hasNext: true),
      recieveMessage("Do you like it?", hasPrev: true),
      sendMessage("Absolutely loving it!", hasNext: true),
    ]);
  }

  Widget recieveMessage(
    String? messgae, {
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
                    child: Text(messgae ?? "", style: TextStyle(fontSize: 15)),
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
