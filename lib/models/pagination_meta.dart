class PaginationMeta {
  final int page;
  final int limit;
  final int totalPage;
  final int total;

  PaginationMeta({
    required this.page,
    required this.limit,
    required this.totalPage,
    required this.total,
  });

  factory PaginationMeta.fromJson(Map<String, dynamic> json) {
    return PaginationMeta(
      page: json['page'],
      limit: json['limit'],
      totalPage: json['totalPage'],
      total: json['total'],
    );
  }
}