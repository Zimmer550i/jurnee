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

  Future<String> getSingleBooking(String id) async {
    isLoading(true);

    try {
      final res = await api.get("/offer/$id", authReq: true);
      final body = jsonDecode(res.body);

      if (res.statusCode == 200) {
        current.value = OfferModel.fromJson(body['data']);
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

  Future<String> makePayment(String offerId, double amount) async {
    isLoading(true);
    try {
      final res = await api.post("/payments/stripe-intent", {
        "offerId": offerId,
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
