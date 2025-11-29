class ChatModel {
  final String id;
  final List<Member> members;
  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final LastMessage? lastMessage;
  final int unread;

  ChatModel({
    required this.id,
    required this.members,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    this.lastMessage,
    required this.unread,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json["_id"] ?? "",
      members:
          (json["members"] as List<dynamic>?)
              ?.map((e) => Member.fromJson(e))
              .toList() ??
          [],
      createdBy: json["createdBy"] ?? "",
      createdAt: DateTime.tryParse(json["createdAt"] ?? "") ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? "") ?? DateTime.now(),
      lastMessage: json["lastMessage"] != null
          ? LastMessage.fromJson(json["lastMessage"])
          : null,
      unread: json["unread"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "members": members.map((e) => e.toJson()).toList(),
      "createdBy": createdBy,
      "createdAt": createdAt.toIso8601String(),
      "updatedAt": updatedAt.toIso8601String(),
      "lastMessage": lastMessage?.toJson(),
      "unread": unread,
    };
  }
}

// Member model
class Member {
  final String id;
  final String name;
  final String image;

  Member({required this.id, required this.name, required this.image});

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      id: json["_id"],
      name: json["name"] ?? "",
      image: json["image"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {"_id": id, "name": name, "image": image};
  }
}

// LastMessage model
class LastMessage {
  final String message;
  final bool read;

  LastMessage({required this.message, required this.read});

  factory LastMessage.fromJson(Map<String, dynamic> json) {
    return LastMessage(
      message: json["message"] ?? "",
      read: json["read"] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {"message": message, "read": read};
  }
}
