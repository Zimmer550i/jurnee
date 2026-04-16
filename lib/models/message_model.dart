import 'offer_model.dart';

enum MessageType { message, offer, media }

class MessageModel {
  final String? id;
  final String? chat;
  final SenderModel? sender;
  final String? message;
  final String? image;
  final String? video;
  final OfferModel? offer;
  final MessageType? type;
  final bool? read;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  MessageModel({
    this.id,
    this.chat,
    this.sender,
    this.message,
    this.image,
    this.video,
    this.offer,
    this.type = MessageType.message,
    this.read,
    this.createdAt,
    this.updatedAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    final rawType = json['type'] as String?;
    return MessageModel(
      id: json['_id'] as String?,
      chat: json['chat'] as String?,
      sender: json['sender'] != null
          ? SenderModel.fromJson(json['sender'])
          : null,
      message: json['message'] as String?,
      image: json['image'] as String?,
      video: json['video'] as String?,
      offer: json['offer'] != null
          ? OfferModel.fromJson(json['offer'] as Map<String, dynamic>)
          : null,
      type: rawType == 'offer'
          ? MessageType.offer
          : rawType == 'media'
          ? MessageType.media
          : MessageType.message,
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
      "image": image,
      "video": video,
      "offer": offer?.toJson(),
      "type": type == MessageType.offer
          ? 'offer'
          : type == MessageType.media
          ? 'media'
          : 'message',
      "read": read,
      "createdAt": createdAt?.toIso8601String(),
      "updatedAt": updatedAt?.toIso8601String(),
    };
  }
}

class SenderModel {
  final String? id;
  final String? name;
  final String? image;

  SenderModel({this.id, this.name, this.image});

  factory SenderModel.fromJson(Map<String, dynamic> json) {
    return SenderModel(
      id: json['_id'] as String?,
      name: json['name'] as String?,
      image: json['image'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "name": name,
      "image": image,
    };
  }
}