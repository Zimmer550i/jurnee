class Follower {
  final String id;
  final String followed;
  final FollowerUser follower;
  final bool isFollower;
  final DateTime createdAt;
  final DateTime updatedAt;

  Follower({
    required this.id,
    required this.followed,
    required this.follower,
    required this.isFollower,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Follower.fromJson(Map<String, dynamic> json) {
    return Follower(
      id: json['_id'] ?? '',
      followed: json['followed'] ?? '',
      follower: FollowerUser.fromJson(json['follower'] ?? {}),
      isFollower: json['isFollower'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'followed': followed,
      'follower': follower.toJson(),
      'isFollower': isFollower,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class FollowerUser {
  final String name;
  final String image;

  FollowerUser({
    required this.name,
    required this.image,
  });

  factory FollowerUser.fromJson(Map<String, dynamic> json) {
    return FollowerUser(
      name: json['name'] ?? '',
      image: json['image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'image': image,
    };
  }
}