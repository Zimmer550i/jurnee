import 'dart:convert';
import 'package:get/get.dart';
import 'package:jurnee/models/pagination_meta.dart';
import 'package:jurnee/models/post_model.dart';
import 'package:jurnee/services/api_service.dart';

enum PostType { defaultPosts }

class PostController extends GetxController {
  final api = ApiService();
  RxMap<PostType, RxList<PostModel>> postMap = <PostType, RxList<PostModel>>{
    for (var e in PostType.values) e: <PostModel>[].obs,
  }.obs;
  RxBool isLoading = RxBool(false);

  RxInt currentPage = 1.obs;
  int limit = 10;
  RxInt totalPages = 1.obs;
  RxBool isFirstLoad = true.obs;
  RxBool isMoreLoading = false.obs;

  Future<String> fetchPosts({bool loadMore = false, String? category, String? search}) async {
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
        "/post/all-post",
        queryParams: {
          "page": currentPage.value.toString(),
          "limit": limit.toString(),
          "category": category,
          "search": search
        },
        authReq: true,
      );

      final body = jsonDecode(res.body);

      if (res.statusCode == 200) {
        if (!loadMore) {
          postMap[PostType.defaultPosts]!.clear();
        }
        final meta = PaginationMeta.fromJson(body['meta']);
        totalPages(meta.totalPage);

        final List<dynamic> dataList = body['data'];
        final newItems = dataList.map((e) => PostModel.fromJson(e)).toList();

        postMap[PostType.defaultPosts]!.addAll(newItems);

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
}
