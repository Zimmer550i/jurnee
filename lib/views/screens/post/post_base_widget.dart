import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jurnee/utils/app_colors.dart';
import 'package:jurnee/utils/app_texts.dart';
import 'package:jurnee/utils/custom_image_picker.dart';
import 'package:jurnee/utils/custom_svg.dart';
import 'package:jurnee/views/base/custom_networked_image.dart';
import 'package:jurnee/views/base/custom_text_field.dart';
import 'package:jurnee/views/base/media_thumbnail.dart';
import 'package:jurnee/views/screens/post/location_picker.dart';

class PostBaseWidget extends StatefulWidget {
  const PostBaseWidget({super.key});

  @override
  State<PostBaseWidget> createState() => PostBaseWidgetState();
}

class PostBaseWidgetState extends State<PostBaseWidget> {
  final GlobalKey<PostBaseWidgetState> locationKey = GlobalKey();
  final titleCtrl = TextEditingController();
  final descriptionCtrl = TextEditingController();
  final locationCtrl = TextEditingController();

  File? cover;
  String? coverImgUrl;
  List<File?> images = List.generate(5, (_) => null);
  List<String?> imageUrls = List.generate(5, (_) => null);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text("Cover Photo / Video", style: AppTexts.txsb),
          ),
        ),
        GestureDetector(
          onTap: () async {
            cover = await customImagePicker(
              isCircular: false,
              isSquared: false,
            );
            setState(() {});
          },
          child: Container(
            width: MediaQuery.of(context).size.width - 48,
            height: (MediaQuery.of(context).size.width - 48) * 0.43,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Color(0xffE6E6E6)),
            ),
            child: cover != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(cover!, fit: BoxFit.cover),
                  )
                : coverImgUrl != null
                ? CustomNetworkedImage(
                    url: coverImgUrl,
                    radius: 12,
                    fit: BoxFit.cover,
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomSvg(
                        asset: "assets/icons/plus.svg",
                        color: AppColors.gray.shade300,
                      ),
                      Text(
                        "Upload Photo/Video",
                        style: AppTexts.tsmr.copyWith(color: AppColors.gray),
                      ),
                    ],
                  ),
          ),
        ),

        const SizedBox(height: 16),

        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text("Add More Media", style: AppTexts.txsb),
          ),
        ),

        FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            spacing: 15,
            children: [
              for (int i = 0; i < 5; i++)
                GestureDetector(
                  onTap: () async {
                    final XFile? picked = await ImagePicker().pickMedia(
                      imageQuality: 90,
                    );
                    if (picked != null) {
                      images[i] = File(picked.path);
                      setState(() {});
                    }
                  },
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Color(0xffE6E6E6)),
                    ),
                    child: images[i] != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: MediaThumbnail(path: images[i]!.path),
                          )
                        : imageUrls.length > i && imageUrls[i] != null
                        ? CustomNetworkedImage(url: imageUrls[i], radius: 12)
                        : Center(
                            child: CustomSvg(
                              asset: "assets/icons/plus.svg",
                              color: AppColors.gray.shade300,
                            ),
                          ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: titleCtrl,
          title: "Title",
          hintText: "Enter title",
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: descriptionCtrl,
          title: "Description",
          hintText: "Enter description",
          lines: 5,
        ),
        const SizedBox(height: 16),
        LocationPicker(key: locationKey, controller: locationCtrl),
        const SizedBox(height: 16),
      ],
    );
  }
}
