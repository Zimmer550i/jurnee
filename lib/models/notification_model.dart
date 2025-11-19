class NotificationModel {
  final String id;
  final String content;
  final String senderId;
  final String receiverId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool read;

  NotificationModel({
    required this.id,
    required this.content,
    required this.senderId,
    required this.receiverId,
    required this.createdAt,
    required this.updatedAt,
    required this.read,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json["_id"],
      content: json["content"],
      senderId: json["senderId"],
      receiverId: json["receiverId"],
      createdAt: DateTime.parse(json["createdAt"]),
      updatedAt: DateTime.parse(json["updatedAt"]),
      read: json["read"] ?? false,
    );
  }

  NotificationModel copyWith({
    String? id,
    String? content,
    String? senderId,
    String? receiverId,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? read,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      content: content ?? this.content,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      read: read ?? this.read,
    );
  }
}