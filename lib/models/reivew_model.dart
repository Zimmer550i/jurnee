class ReviewModel {
  final String id;
  final ReviewUser user;
  final String postId;
  final int rating;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;

  ReviewModel({
    required this.id,
    required this.user,
    required this.postId,
    required this.rating,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['_id'] ?? '',
      user: ReviewUser.fromJson(json['userId'] ?? {}),
      postId: json['postId'] ?? '',
      rating: json['rating'] ?? 0,
      content: json['content'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': user.toJson(),
      'postId': postId,
      'rating': rating,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class ReviewUser {
  final String name;
  final String image;

  ReviewUser({required this.name, required this.image});

  factory ReviewUser.fromJson(Map<String, dynamic> json) {
    return ReviewUser(name: json['name'] ?? '', image: json['image'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'image': image};
  }
}
