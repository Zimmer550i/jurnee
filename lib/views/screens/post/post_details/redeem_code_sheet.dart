import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jurnee/models/post_model.dart';
import 'package:jurnee/utils/app_colors.dart';
import 'package:jurnee/utils/app_texts.dart';
import 'package:jurnee/utils/custom_svg.dart';
import 'package:qr_flutter/qr_flutter.dart';

/// Modal bottom sheet: deal headline, validity, promo code, QR encoding the code.
void showRedeemCodeSheet(BuildContext context, PostModel post) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => RedeemCodeSheet(post: post),
  );
}

class RedeemCodeSheet extends StatelessWidget {
  final PostModel post;

  const RedeemCodeSheet({super.key, required this.post});

  String get _coupon =>
      (post.couponCode != null && post.couponCode!.trim().isNotEmpty)
      ? post.couponCode!.trim()
      : 'JURNEE-${post.id}';

  DateTime? _endDate() {
    final e = post.endDate;
    if (e == null) return null;
    if (e is DateTime) return e;
    if (e is String) return DateTime.tryParse(e);
    return null;
  }

  String _validityLine() {
    final start = post.startDate;
    final end = _endDate();
    if (start == null && end == null) {
      return '—';
    }
    if (start != null && end != null) {
      if (start.year == end.year) {
        return '${DateFormat('MMMM d').format(start)} - ${DateFormat('MMMM d, y').format(end)}';
      }
      return '${DateFormat('MMMM d, y').format(start)} - ${DateFormat('MMMM d, y').format(end)}';
    }
    if (start != null) {
      return DateFormat('MMMM d, y').format(start);
    }
    return DateFormat('MMMM d, y').format(end!);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.gray.shade200,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Redeem Code',
                textAlign: TextAlign.center,
                style: AppTexts.tmds.copyWith(color: AppColors.gray.shade400),
              ),
              const SizedBox(height: 12),
              Divider(thickness: 8, color: AppColors.gray[50]),
              const SizedBox(height: 24),
              Text(
                post.title,
                textAlign: TextAlign.center,
                style: AppTexts.dxsb,
              ),
              const SizedBox(height: 24),
              Divider(thickness: 8, color: AppColors.gray[50]),
              const SizedBox(height: 24),
              Text(
                'Valid Through',
                textAlign: TextAlign.center,
                style: AppTexts.tmdr.copyWith(color: AppColors.gray.shade700),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomSvg(
                    asset: 'assets/icons/calendar.svg',
                    size: 16,
                    color: AppColors.green,
                  ),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      _validityLine(),
                      textAlign: TextAlign.center,
                      style: AppTexts.tsmr.copyWith(
                        color: AppColors.gray.shade700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Divider(thickness: 8, color: AppColors.gray[50]),
              const SizedBox(height: 24),
              Text(
                'Show this at Checkout',
                textAlign: TextAlign.center,
                style: AppTexts.tlgs.copyWith(color: AppColors.gray.shade700),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  decoration: BoxDecoration(
                    color: AppColors.gray[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _coupon,
                    textAlign: TextAlign.center,
                    style: AppTexts.txls.copyWith(
                      color: AppColors.green.shade700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.black, width: 5),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: QrImageView(
                  data: _coupon,
                  version: QrVersions.auto,
                  size: 95,
                  backgroundColor: AppColors.white,
                  padding: EdgeInsets.zero,
                  eyeStyle: const QrEyeStyle(
                    eyeShape: QrEyeShape.square,
                    color: AppColors.black,
                  ),
                  dataModuleStyle: const QrDataModuleStyle(
                    dataModuleShape: QrDataModuleShape.square,
                    color: AppColors.black,
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
