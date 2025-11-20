class MessageModel {
  final String? id;
  final String? chat;
  final SenderModel? sender;
  final String? message;
  final bool? read;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  MessageModel({
    this.id,
    this.chat,
    this.sender,
    this.message,
    this.read,
    this.createdAt,
    this.updatedAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['_id'] as String?,
      chat: json['chat'] as String?,
      sender: json['sender'] != null
          ? SenderModel.fromJson(json['sender'])
          : null,
      message: json['message'] as String?,
      read: json['read'] as bool?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "chat": chat,
      "sender": sender?.toJson(),
      "message": message,
      "read": read,
      "createdAt": createdAt?.toIso8601String(),
      "updatedAt": updatedAt?.toIso8601String(),
    };
  }
}

class SenderModel {
  final String? name;
  final String? image;

  SenderModel({this.name, this.image});

  factory SenderModel.fromJson(Map<String, dynamic> json) {
    return SenderModel(
      name: json['name'] as String?,
      image: json['image'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "image": image,
    };
  }
}