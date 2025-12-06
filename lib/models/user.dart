class User {
  final String id;
  final String name;
  final String email;
  final String address;
  final String phone;
  final String bio;
  final List<dynamic> interested;
  final String role;
  final String image;
  final String gender;
  final bool isDeleted;
  final bool verified;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int post;
  bool isFollow;
  int followers;
  int following;
  final Location location;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.address,
    required this.phone,
    required this.bio,
    required this.interested,
    required this.role,
    required this.image,
    required this.gender,
    required this.isDeleted,
    required this.verified,
    required this.createdAt,
    required this.updatedAt,
    required this.post,
    this.isFollow = false,
    this.followers = 0,
    this.following = 0,
    required this.location,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      address: json['address'] ?? '',
      phone: json['phone'] ?? '',
      bio: json['bio'] ?? '',
      interested: json['interested'] ?? [],
      role: json['role'] ?? '',
      image: json['image'] ?? '',
      gender: json['gender'] ?? '',
      isDeleted: json['isDeleted'] ?? false,
      verified: json['verified'] ?? false,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
      post: json['post'] ?? 0,
      isFollow: json['isFollow'] ?? false,
      followers: json['followers'] ?? 0,
      following: json['following'] ?? 0,
      location: Location.fromJson(json['location'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'address': address,
      'phone': phone,
      'bio': bio,
      'interested': interested,
      'role': role,
      'image': image,
      'gender': gender,
      'isDeleted': isDeleted,
      'verified': verified,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'post': post,
      'isFollow': isFollow,
      'followers': followers,
      'following': following,
      'location': location.toJson(),
    };
  }
}

class Location {
  final String type;
  final List<double> coordinates;

  Location({required this.type, required this.coordinates});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      type: json['type'] ?? '',
      coordinates:
          (json['coordinates'] as List?)
              ?.map((e) => (e as num).toDouble())
              .toList() ??
          [0.0, 0.0],
    );
  }

  Map<String, dynamic> toJson() {
    return {'type': type, 'coordinates': coordinates};
  }
}
