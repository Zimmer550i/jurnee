enum MomentSource {
  owner,
  community;

  static MomentSource fromString(String? raw) {
    switch (raw?.toLowerCase().trim()) {
      case 'community':
        return MomentSource.community;
      default:
        return MomentSource.owner;
    }
  }
}

class MomentModel {
  final String url;
  final String type;
  final MomentSource source;
  final String userName;
  final String userImage;
  final int like;

  MomentModel({
    required this.url,
    required this.type,
    required this.source,
    required this.userName,
    required this.userImage,
    required this.like,
  });

  factory MomentModel.fromJson(Map<String, dynamic> json) {
    return MomentModel(
      url: json['url'] as String? ?? '',
      type: json['type'] as String? ?? '',
      source: MomentSource.fromString(json['source'] as String?),
      userName: json['userName'] as String? ?? '',
      userImage: json['userImage'] as String? ?? '',
      like: (json['like'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'url': url,
        'type': type,
        'source': source.name,
        'userName': userName,
        'userImage': userImage,
        'like': like,
      };
}
