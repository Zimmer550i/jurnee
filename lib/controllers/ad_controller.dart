import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:jurnee/utils/app_colors.dart';

/// Central place for native ad unit IDs, [AdRequest], and [NativeTemplateStyle] used by feed slots.
class AdController extends GetxController {
  /// Google sample native IDs (debug/profile, or when [forceTestAdUnits] is true).
  static const String _androidTestNative = 'ca-app-pub-3940256099942544/2247696110';
  static const String _iosTestNative = 'ca-app-pub-3940256099942544/3986624511';

  /// Production native IDs from AdMob.
  static const String _androidProdNative = 'ca-app-pub-6145393247747170/4449341154';
  static const String _iosProdNative = 'ca-app-pub-6145393247747170/8638887669';

  /// Set true to always use sample ad units (e.g. store review). Release builds use production IDs unless this is set.
  bool forceTestAdUnits = true;

  bool get _shouldUseTestUnits => forceTestAdUnits || !kReleaseMode;

  /// Resolves the correct native ad unit for the current platform and build.
  String get nativeAdUnitId {
    if (_shouldUseTestUnits) {
      return Platform.isAndroid ? _androidTestNative : _iosTestNative;
    }
    return Platform.isAndroid ? _androidProdNative : _iosProdNative;
  }

  /// Same as [nativeAdUnitId]; kept for short call sites.
  String get adUnitId => nativeAdUnitId;

  AdRequest get adRequest => const AdRequest();

  NativeTemplateStyle get nativeTemplateStyle => NativeTemplateStyle(
        templateType: TemplateType.medium,
        mainBackgroundColor: AppColors.scaffoldBG,
        cornerRadius: 12.0,
        callToActionTextStyle: NativeTemplateTextStyle(
          textColor: AppColors.white,
          backgroundColor: AppColors.green.shade600,
          style: NativeTemplateFontStyle.monospace,
          size: 16.0,
        ),
        primaryTextStyle: NativeTemplateTextStyle(
          textColor: AppColors.gray.shade900,
          style: NativeTemplateFontStyle.bold,
          size: 18.0,
        ),
        secondaryTextStyle: NativeTemplateTextStyle(
          textColor: AppColors.gray.shade700,
          style: NativeTemplateFontStyle.italic,
          size: 14.0,
        ),
        tertiaryTextStyle: NativeTemplateTextStyle(
          textColor: AppColors.gray.shade700,
          style: NativeTemplateFontStyle.normal,
          size: 16.0,
        ),
      );
}
