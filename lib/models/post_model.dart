import 'dart:convert';

import 'package:flutter/material.dart';

PostModel postModelFromJson(String str) => PostModel.fromJson(json.decode(str));

String postModelToJson(PostModel data) => json.encode(data.toJson());

class PostModel {
  final String id;
  final String? image;
  final List<String>? media;
  final Author author;
  final String title;
  final String description;
  final DateTime? startDate;
  final DateTime? startTime;
  final String address;
  final Location location;
  final List<String>? hasTag;
  final int views;
  final int likes;
  final dynamic endDate;
  final double? price;
  final String category;
  final dynamic subcategory;
  final String? serviceType;
  final String? missingName;
  final int? missingAge;
  final String? clothingDescription;
  final Location? lastSeenLocation;
  final dynamic lastSeenDate;
  final String? contactInfo;
  final int? expireLimit;
  final int? capacity;
  final List<String>? amenities;
  final String? licenses;
  final String? status;
  final bool? boost;
  final List<Author> attenders;
  final bool isSaved;
  final int totalSaved;
  final List<dynamic> schedule;
  final DateTime createdAt;
  final DateTime updatedAt;
  final double? distance;
  final int? boostPriority;
  final dynamic averageRating;
  final int? reviewsCount;

  PostModel({
    required this.id,
    this.image,
    this.media,
    required this.author,
    required this.title,
    required this.description,
    this.startDate,
    this.startTime,
    required this.address,
    required this.location,
    this.hasTag,
    required this.views,
    required this.likes,
    required this.endDate,
    this.price,
    required this.category,
    required this.subcategory,
    this.serviceType,
    this.missingName,
    this.missingAge,
    this.clothingDescription,
    this.lastSeenLocation,
    this.lastSeenDate,
    this.contactInfo,
    this.expireLimit,
    this.capacity,
    this.amenities,
    this.licenses,
    this.status,
    this.boost,
    required this.attenders,
    required this.isSaved,
    required this.totalSaved,
    required this.schedule,
    required this.createdAt,
    required this.updatedAt,
    this.distance,
    this.boostPriority,
    required this.averageRating,
    required this.reviewsCount,
  });

  PostModel copyWith({
    String? id,
    String? image,
    List<String>? media,
    Author? author,
    String? title,
    String? description,
    DateTime? startDate,
    DateTime? startTime,
    String? address,
    Location? location,
    List<String>? hasTag,
    int? views,
    int? likes,
    dynamic endDate,
    double? price,
    String? category,
    dynamic subcategory,
    String? serviceType,
    String? missingName,
    int? missingAge,
    String? clothingDescription,
    Location? lastSeenLocation,
    dynamic lastSeenDate,
    String? contactInfo,
    int? expireLimit,
    int? capacity,
    List<String>? amenities,
    String? licenses,
    String? status,
    bool? boost,
    List<Author>? attenders,
    bool? isSaved,
    int? totalSaved,
    List<dynamic>? schedule,
    DateTime? createdAt,
    DateTime? updatedAt,
    double? distance,
    int? boostPriority,
    dynamic averageRating,
    int? reviewsCount,
  }) => PostModel(
    id: id ?? this.id,
    image: image ?? this.image,
    media: media ?? this.media,
    author: author ?? this.author,
    title: title ?? this.title,
    description: description ?? this.description,
    startDate: startDate ?? this.startDate,
    startTime: startTime ?? this.startTime,
    address: address ?? this.address,
    location: location ?? this.location,
    hasTag: hasTag ?? this.hasTag,
    views: views ?? this.views,
    likes: likes ?? this.likes,
    endDate: endDate ?? this.endDate,
    price: price ?? this.price,
    category: category ?? this.category,
    subcategory: subcategory ?? this.subcategory,
    serviceType: serviceType ?? this.serviceType,
    missingName: missingName ?? this.missingName,
    missingAge: missingAge ?? this.missingAge,
    clothingDescription: clothingDescription ?? this.clothingDescription,
    lastSeenLocation: lastSeenLocation ?? this.lastSeenLocation,
    lastSeenDate: lastSeenDate ?? this.lastSeenDate,
    contactInfo: contactInfo ?? this.contactInfo,
    expireLimit: expireLimit ?? this.expireLimit,
    capacity: capacity ?? this.capacity,
    amenities: amenities ?? this.amenities,
    licenses: licenses ?? this.licenses,
    status: status ?? this.status,
    boost: boost ?? this.boost,
    attenders: attenders ?? this.attenders,
    isSaved: isSaved ?? this.isSaved,
    totalSaved: totalSaved ?? this.totalSaved,
    schedule: schedule ?? this.schedule,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    distance: distance ?? this.distance,
    boostPriority: boostPriority ?? this.boostPriority,
    averageRating: averageRating ?? this.averageRating,
    reviewsCount: reviewsCount ?? this.reviewsCount,
  );

  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
    id: json["_id"],
    image: json["image"],
    media: json["media"] == null
        ? null
        : List<String>.from(json["media"].map((x) => x)),
    author: Author.fromJson(json["author"]),
    title: json["title"],
    description: json["description"],
    startDate: json["startDate"] == null
        ? null
        : DateTime.parse(json["startDate"]),
    startTime: json["startTime"] == null
        ? null
        : DateTime.now().copyWith(
            hour: int.parse(json['startTime'].split(":").first),
            minute: int.parse(json['startTime'].split(":").last),
          ),
    address: json["address"],
    location: Location.fromJson(json["location"]),
    hasTag: json["hasTag"] == null
        ? null
        : List<String>.from(json["hasTag"].map((x) => x)),
    views: json["views"],
    likes: json["likes"],
    endDate: json["endDate"],
    price: json["price"]?.toDouble(),
    category: json["category"],
    subcategory: json["subcategory"],
    serviceType: json["serviceType"],
    missingName: json["missingName"],
    missingAge: json["missingAge"],
    clothingDescription: json["clothingDescription"],
    lastSeenLocation: json["lastSeenLocation"] == null
        ? null
        : Location.fromJson(json["lastSeenLocation"]),
    lastSeenDate: json["lastSeenDate"],
    contactInfo: json["contactInfo"],
    expireLimit: json["expireLimit"],
    capacity: json["capacity"],
    amenities: json["amenities"] == null
        ? null
        : List<String>.from(json["amenities"].map((x) => x)),
    licenses: json["licenses"],
    status: json["status"],
    boost: json["boost"],
    attenders: List<Author>.from(
      json["attenders"].map((x) => Author.fromJson(x)),
    ),
    isSaved: json["isSaved"],
    totalSaved: json["totalSaved"],
    schedule: List<dynamic>.from(json["schedule"].map((x) => x)),
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    distance: json["distance"]?.toDouble(),
    boostPriority: json["boostPriority"],
    averageRating: json["averageRating"],
    reviewsCount: json["reviewsCount"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "image": image,
    "media": media == null ? null : List<dynamic>.from(media!.map((x) => x)),
    "author": author.toJson(),
    "title": title,
    "description": description,
    "startDate": startDate?.toIso8601String(),
    "startTime": startTime?.toIso8601String(),
    "address": address,
    "location": location.toJson(),
    "hasTag": hasTag == null ? null : List<dynamic>.from(hasTag!.map((x) => x)),
    "views": views,
    "likes": likes,
    "endDate": endDate,
    "price": price,
    "category": category,
    "subcategory": subcategory,
    "serviceType": serviceType,
    "missingName": missingName,
    "missingAge": missingAge,
    "clothingDescription": clothingDescription,
    "lastSeenLocation": lastSeenLocation?.toJson(),
    "lastSeenDate": lastSeenDate,
    "contactInfo": contactInfo,
    "expireLimit": expireLimit,
    "capacity": capacity,
    "amenities": amenities == null
        ? null
        : List<dynamic>.from(amenities!.map((x) => x)),
    "licenses": licenses,
    "status": status,
    "boost": boost,
    "attenders": List<dynamic>.from(attenders.map((x) => x.toJson())),
    "isSaved": isSaved,
    "totalSaved": totalSaved,
    "schedule": List<dynamic>.from(schedule.map((x) => x)),
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "distance": distance,
    "boostPriority": boostPriority,
    "averageRating": averageRating,
    "reviewsCount": reviewsCount,
  };
}

class Author {
  final String id;
  final String name;
  final String image;

  Author({required this.id, required this.name, required this.image});

  Author copyWith({String? id, String? name, String? image}) => Author(
    id: id ?? this.id,
    name: name ?? this.name,
    image: image ?? this.image,
  );

  factory Author.fromJson(Map<String, dynamic> json) =>
      Author(id: json["_id"], name: json["name"], image: json["image"]);

  Map<String, dynamic> toJson() => {"id": id, "name": name, "image": image};
}

class Location {
  final String type;
  final List<double> coordinates;

  Location({required this.type, required this.coordinates});

  Location copyWith({String? type, List<double>? coordinates}) => Location(
    type: type ?? this.type,
    coordinates: coordinates ?? this.coordinates,
  );

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    type: json["type"],
    coordinates: List<double>.from(
      json["coordinates"].map((x) => x?.toDouble()),
    ),
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "coordinates": List<dynamic>.from(coordinates.map((x) => x)),
  };
}
