import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:get/get.dart';
import 'package:jurnee/utils/app_colors.dart';

class AdController extends GetxController {
  final RxBool isLoaded = false.obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  NativeAd? _nativeAd;
  final adUnitId = Platform.isAndroid
      ? 'ca-app-pub-6145393247747170/4449341154'
      : 'ca-app-pub-6145393247747170/8638887669';

  AdController() {
    loadAd();
  }

  /// Load Native Ad
  void loadAd() {
    if (isLoading.value) return;

    isLoading.value = true;
    errorMessage.value = '';

    _nativeAd = NativeAd(
      adUnitId: adUnitId,
      request: const AdRequest(),
      nativeTemplateStyle: NativeTemplateStyle(
        templateType: TemplateType.medium,
        mainBackgroundColor: AppColors.scaffoldBG,
        cornerRadius: 10.0,
        callToActionTextStyle: NativeTemplateTextStyle(
          textColor: AppColors.gray.shade900,
          backgroundColor: AppColors.green.shade600,
          style: NativeTemplateFontStyle.monospace,
          size: 16.0,
        ),
        primaryTextStyle: NativeTemplateTextStyle(
          textColor: AppColors.gray.shade900,
          style: NativeTemplateFontStyle.bold,
          size: 16.0,
        ),
        secondaryTextStyle: NativeTemplateTextStyle(
          textColor: Colors.green,
          backgroundColor: Colors.black,
          style: NativeTemplateFontStyle.bold,
          size: 16.0,
        ),
        tertiaryTextStyle: NativeTemplateTextStyle(
          textColor: Colors.brown,
          backgroundColor: Colors.amber,
          style: NativeTemplateFontStyle.normal,
          size: 16.0,
        ),
      ),
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          isLoaded.value = true;
          isLoading.value = false;
        },
        onAdFailedToLoad: (ad, error) {
          errorMessage.value = error.message;
          isLoaded.value = false;
          isLoading.value = false;
          ad.dispose();
        },
      ),
    );

    _nativeAd!.load();
  }

  List<int> generateAdIndexes(int totalPosts) {
    final random = Random();
    final List<int> indexes = [];
    int currentIndex = random.nextInt(3) + 2;

    while (currentIndex < totalPosts) {
      indexes.add(currentIndex);
      currentIndex += random.nextInt(3) + 2;
    }

    return indexes;
  }

  /// Optional: reload ad
  void reloadAd() {
    _nativeAd?.dispose();
    isLoaded.value = false;
    loadAd();
  }

  @override
  void onClose() {
    _nativeAd?.dispose();
    super.onClose();
  }
}
