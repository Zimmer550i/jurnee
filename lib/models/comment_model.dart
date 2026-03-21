class CommentModel {
  final String id;
  final String? parentComment;
  final String postId;
  int like;
  final String content;
  final String? image;
  final String? video;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;
  final UserModel user;
  bool liked;
  final int replyCount;
  final List<CommentModel> children;

  CommentModel({
    required this.id,
    this.parentComment,
    required this.postId,
    required this.like,
    required this.content,
    this.image,
    this.video,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.user,
    required this.liked,
    required this.replyCount,
    required this.children,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['_id'] ?? '',
      parentComment: json['parentComment'],
      postId: json['postId'] ?? '',
      like: json['like'] ?? 0,
      content: json['content'] ?? '',
      image: json['image'],
      video: json['video'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      v: json['__v'] ?? 0,
      user: UserModel.fromJson(json['user'] ?? {}),
      liked: json['liked'] ?? false,
      replyCount: json['replyCount'] ?? 0,
      children: (json['children'] as List<dynamic>? ?? [])
          .map((e) => CommentModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'parentComment': parentComment,
      'postId': postId,
      'like': like,
      'content': content,
      'image': image,
      'video': video,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '__v': v,
      'user': user.toJson(),
      'liked': liked,
      'replyCount': replyCount,
      'children': children.map((e) => e.toJson()).toList(),
    };
  }
}

class UserModel {
  final String id;
  final String name;
  final String image;

  UserModel({required this.id, required this.name, required this.image});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'name': name, 'image': image};
  }
}
