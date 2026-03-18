import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:jurnee/utils/app_colors.dart';

class BannerAdWidget extends StatefulWidget {
  const BannerAdWidget({super.key});

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  final String androidAdUnit = "ca-app-pub-6145393247747170/8049167633";
  final String iosAdUnit = "ca-app-pub-6145393247747170/1675330970";

  BannerAd? _bannerAd;
  bool _bannerAdLoaded = false;
  String? _adError;
  String get adUnitId => Platform.isAndroid ? androidAdUnit : iosAdUnit;

  @override
  void initState() {
    super.initState();
    loadAd();
  }

  loadAd() {
    debugPrint('BannerAd: initiated | adUnitId=$adUnitId');
    _bannerAd = BannerAd(
      adUnitId: adUnitId,
      size: AdSize.fullBanner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          debugPrint('BannerAd: loaded successfully');
          setState(() {
            _bannerAdLoaded = true;
            _adError = null;
          });
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('BannerAd: failed to load | error=${error.message}');
          setState(() {
            _adError = error.message;
          });
          ad.dispose();
        },
      ),
    );

    _bannerAd!.load();
  }

  @override
  void dispose() {
    debugPrint('BannerAd: disposed');
    _bannerAd?.dispose();
    super.dispose();
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
          child: FadeTransition(opacity: animation, child: child),
        );
      },
      child: _bannerAdLoaded
          ? SizedBox(
              key: const ValueKey('ad_loaded'),
              width: _bannerAd!.size.width.toDouble(),
              height: _bannerAd!.size.height.toDouble(),
              child: AdWidget(ad: _bannerAd!),
            )
          : _adError != null
          ? Center(
              child: Column(
                children: [
                  Text(
                    _adError.toString(),
                    style: TextStyle(color: AppColors.red),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            )
          : const SizedBox(key: ValueKey('ad_empty')),
    );
  }
}
