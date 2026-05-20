import 'dart:io';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jurnee/controllers/post_controller.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class RevcatController extends GetxController {
  static const String defaultOfferingId = "default";
  static const String boostPackageId = "boost";

  final RxBool isConfigured = false.obs;
  final RxBool isLoading = false.obs;
  final RxBool isPurchasing = false.obs;
  final RxString errorMessage = "".obs;
  final Rxn<Offerings> offerings = Rxn<Offerings>();
  final Rxn<Offering> defaultOffering = Rxn<Offering>();
  final Rxn<Package> boostPackage = Rxn<Package>();
  final Rxn<CustomerInfo> customerInfo = Rxn<CustomerInfo>();

  @override
  void onInit() {
    super.onInit();
    init();
  }

  Future<String> init() async {
    if (isConfigured.value) return "success";

    try {
      final configuration = PurchasesConfiguration(
        Platform.isIOS
            ? "appl_JvCzpaHGvtnWvMymRKjzRythhNc"
            : "goog_LoNOPCHPtXQMdGLmKaAAlZQpLqv",
      );

      await Purchases.configure(configuration);
      isConfigured(true);

      return await loadBoostPackage();
    } catch (e) {
      final message = _formatError(e);
      errorMessage(message);
      return message;
    }
  }

  Future<String> loadBoostPackage() async {
    isLoading(true);
    errorMessage("");

    try {
      if (!isConfigured.value) {
        await Purchases.configure(
          PurchasesConfiguration(
            Platform.isIOS
                ? "appl_JvCzpaHGvtnWvMymRKjzRythhNc"
                : "goog_LoNOPCHPtXQMdGLmKaAAlZQpLqv",
          ),
        );
        isConfigured(true);
      }

      final fetchedOfferings = await Purchases.getOfferings();
      final offering = fetchedOfferings.getOffering(defaultOfferingId);
      final package = offering?.getPackage(boostPackageId);

      offerings(fetchedOfferings);
      defaultOffering(offering);
      boostPackage(package);

      if (offering == null) {
        return _setError('RevenueCat offering "$defaultOfferingId" not found');
      }

      if (package == null) {
        return _setError(
          'RevenueCat package "$boostPackageId" not found in "$defaultOfferingId"',
        );
      }

      return "success";
    } catch (e) {
      return _setError(_formatError(e));
    } finally {
      isLoading(false);
    }
  }

  Future<String> purchaseBoostPackage(String postId) async {
    isPurchasing(true);
    errorMessage("");

    try {
      if (boostPackage.value == null) {
        final loadResult = await loadBoostPackage();
        if (loadResult != "success") return loadResult;
      }

      final result = await Purchases.purchase(
        PurchaseParams.package(boostPackage.value!),
      );
      customerInfo(result.customerInfo);

      final message = await Get.find<PostController>().boostPost(
        postId,
        result.storeTransaction.transactionIdentifier,
        5,
      );

      if (message != "success") {
        return message;
      }

      return "success";
    } catch (e) {
      final message = _formatError(e);
      errorMessage(message);
      return message;
    } finally {
      isPurchasing(false);
    }
  }

  String _setError(String message) {
    errorMessage(message);
    return message;
  }

  String _formatError(Object error) {
    if (error is PlatformException) {
      final code = PurchasesErrorHelper.getErrorCode(error);

      if (code == PurchasesErrorCode.purchaseCancelledError) {
        return "Purchase cancelled";
      }

      return error.message ?? code.name;
    }

    return error.toString();
  }
}
