import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_cropper/image_cropper.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jurnee/utils/app_colors.dart';
import 'package:jurnee/utils/media_type.dart';
// import 'package:jurnee/utils/app_colors.dart';

Future<File?> customImagePicker({
  isCircular = true,
  isSquared = true,
  bool allowVideo = false,
}) async {
  final picker = ImagePicker();
  final cropper = ImageCropper();

  final XFile? pickedImage;
  if (allowVideo) {
    final XFile? picked = await picker.pickMedia(imageQuality: 90);
    if (picked == null) return null;
    if (isVideoMedia(path: picked.path, mimeType: picked.mimeType)) {
      return File(picked.path);
    }
    pickedImage = picked;
  } else {
    pickedImage = await picker.pickImage(
      source: ImageSource.gallery,
    );
  }

  if (pickedImage != null) {
    final CroppedFile? croppedImage = await cropper.cropImage(
      sourcePath: pickedImage.path,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop your image',
          toolbarColor: AppColors.green,
          toolbarWidgetColor: Colors.blue[50],
          backgroundColor: AppColors.green,
          // statusBarColor: AppColors.green,
          cropStyle: isCircular ? CropStyle.circle : CropStyle.rectangle,
          hideBottomControls: isSquared,
          initAspectRatio: CropAspectRatioPreset.square,
        ),
        IOSUiSettings(
          title: "Crop your image",
          cropStyle: isCircular ? CropStyle.circle : CropStyle.rectangle,
        ),
      ],
    );

    if (croppedImage != null) {
      return File(croppedImage.path);
    }
  }

  return null;
}
