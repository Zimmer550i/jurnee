import 'dart:convert';
import 'package:get/get.dart';
import 'package:jurnee/models/offer_model.dart';
import 'package:jurnee/models/pagination_meta.dart';
import 'package:jurnee/services/api_service.dart';
import 'package:url_launcher/url_launcher.dart';

class BookingController extends GetxController {
  final api = ApiService();

  RxBool isLoading = RxBool(false);
  Rxn<OfferModel> current = Rxn();
  RxList<OfferModel> offers = RxList();

  RxInt currentPage = 1.obs;
  int limit = 10;
  RxInt totalPages = 1.obs;
  RxBool isFirstLoad = true.obs;
  RxBool isMoreLoading = false.obs;

  Future<String> fetchBookings(String type, {bool loadMore = false}) async {
    if (loadMore && currentPage.value >= totalPages.value) return "success";

    isLoading(true);

    if (!loadMore) {
      isFirstLoad(true);
      currentPage(1);
    } else {
      isMoreLoading(true);
      currentPage.value++;
    }

    try {
      final res = await api.get(
        "/offer/$type",
        queryParams: {
          "page": currentPage.value.toString(),
          "limit": limit.toString(),
        },
        authReq: true,
      );

      final body = jsonDecode(res.body);

      if (res.statusCode == 200) {
        if (!loadMore) {
          offers.clear();
        }
        final meta = PaginationMeta.fromJson(body['meta']);
        totalPages(meta.totalPage);

        final List<dynamic> dataList = body['data'];
        final newItems = dataList.map((e) => OfferModel.fromJson(e)).toList();

        offers.addAll(newItems);

        return "success";
      } else {
        return body['message'] ?? "Something went wrong";
      }
    } catch (e) {
      return e.toString();
    } finally {
      isFirstLoad(false);
      isMoreLoading(false);
      isLoading(false);
    }
  }

  Future<String> confirmBooking({
    required String serviceId,
    required String scheduleId,
    required String slotId,
    required DateTime serviceDate,
    required String slotStart,
    required String slotEnd,
    required double amount,
  }) async {
    isLoading(true);
    try {
      final data = {
        "service": serviceId,
        "scheduleId": scheduleId,
        "slotId": slotId,
        "serviceDate": serviceDate.toIso8601String(),
        "slotStart": slotStart,
        "slotEnd": slotEnd,
        "amount": amount,
      };

      final res = await api.post("/offer", data, authReq: true);
      final body = jsonDecode(res.body);

      if (res.statusCode == 200 || res.statusCode == 201) {
        final data = body['data'];

        current.value = OfferModel.fromJson(data);

        return "success";
      } else {
        return body['message'] ?? "Something went wrong";
      }
    } catch (e) {
      return e.toString();
    } finally {
      isLoading(false);
    }
  }

  Future<String> makePayment(
    String serviceId,
    String bookingId,
    double amount,
  ) async {
    isLoading(true);
    try {
      final res = await api.post("//payments/stripe-intent", {
        "serviceId": serviceId,
        "bookingId": bookingId,
        "amount": amount,
      }, authReq: true);
      final body = jsonDecode(res.body);

      if (res.statusCode == 200 || res.statusCode == 201) {
        final url = Uri.parse(body['url']);

        if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
          return "Could not launch payment URL";
        }

        return "success";
      } else {
        return body['message'] ?? "Something went wrong!";
      }
    } catch (e) {
      return e.toString();
    } finally {
      isLoading(false);
    }
  }
}
