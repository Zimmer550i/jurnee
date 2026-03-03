import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:jurnee/utils/app_colors.dart';

class NativeAdWidget extends StatefulWidget {
  const NativeAdWidget({super.key});

  @override
  State<NativeAdWidget> createState() => _NativeAdWidgetState();
}

class _NativeAdWidgetState extends State<NativeAdWidget> {
  NativeAd? _nativeAd;
  bool _nativeAdLoaded = false;
  final adUnitId = Platform.isAndroid
      ? 'ca-app-pub-6145393247747170/4449341154'
      : 'ca-app-pub-6145393247747170/8638887669';

  @override
  void initState() {
    super.initState();
    loadAd();
  }

  loadAd() {
    _nativeAd = NativeAd(
      adUnitId: adUnitId,
      request: const AdRequest(),
      nativeTemplateStyle: NativeTemplateStyle(
        templateType: TemplateType.medium,
        mainBackgroundColor: AppColors.scaffoldBG,
        cornerRadius: 6.0,
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
          textColor: AppColors.gray.shade700,
          style: NativeTemplateFontStyle.normal,
          size: 14.0,
        ),
        tertiaryTextStyle: NativeTemplateTextStyle(
          textColor: AppColors.gray.shade700,
          style: NativeTemplateFontStyle.italic,
          size: 14.0,
        ),
      ),
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _nativeAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    );

    _nativeAd!.load();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      switchInCurve: Curves.easeInOut,
      switchOutCurve: Curves.easeInOut,
      transitionBuilder: (Widget child, Animation<double> animation) {
        return SizeTransition(
          sizeFactor: animation,
          axisAlignment: -1.0,
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
      child: _nativeAdLoaded
          ? AspectRatio(
              key: const ValueKey('ad_loaded'),
              aspectRatio: 1,
              child: AdWidget(ad: _nativeAd!),
            )
          : const SizedBox(
              key: ValueKey('ad_empty'),
            ),
    );
  }
}
