import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:jurnee/controllers/ad_controller.dart';
import 'package:jurnee/services/native_ad_load_coordinator.dart';

/// One in-feed native ad. Each instance owns its own [NativeAd]; loads are staggered by [NativeAdLoadCoordinator].
class NativeAdListItem extends StatefulWidget {
  const NativeAdListItem({super.key});

  @override
  State<NativeAdListItem> createState() => _NativeAdListItemState();
}

class _NativeAdListItemState extends State<NativeAdListItem> {
  NativeAd? _nativeAd;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final ads = Get.find<AdController>();
    await NativeAdLoadCoordinator.instance.scheduleLoad(() {
      if (!mounted) return;
      _nativeAd = NativeAd(
        adUnitId: ads.adUnitId,
        request: ads.adRequest,
        nativeTemplateStyle: ads.nativeTemplateStyle,
        listener: NativeAdListener(
          onAdLoaded: (ad) {
            if (mounted) {
              setState(() => _loaded = true);
            }
          },
          onAdFailedToLoad: (ad, error) {
            ad.dispose();
            if (mounted) {
              setState(() {
                _nativeAd = null;
                _loaded = false;
              });
            }
          },
        ),
      );
      _nativeAd!.load();
    });
  }

  @override
  void dispose() {
    _nativeAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded || _nativeAd == null) {
      return const SizedBox.shrink();
    }
    return AspectRatio(
      aspectRatio: 1,
      child: AdWidget(ad: _nativeAd!),
    );
  }
}
