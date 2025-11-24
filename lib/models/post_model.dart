// ignore_for_file: constant_identifier_names

enum Day { mon, tue, wed, thu, fri, sat, sun }

enum PostStatus { PUBLISHED, REJECTED }

PostStatus statusFromString(String? value) {
  if (value == null) return PostStatus.PUBLISHED;
  return PostStatus.values.firstWhere(
    (s) => s.name == value,
    orElse: () => PostStatus.PUBLISHED,
  );
}

String statusToString(PostStatus status) => status.name;

Day? dayFromString(String? value) {
  if (value == null) return null;
  return Day.values.firstWhere(
    (d) => d.name == value,
    orElse: () => Day.mon,
  );
}

String? dayToString(Day? day) => day?.name;

class Schedule {
  final Day? day;
  final String? startTime;
  final String? endTime;
  final bool? available;

  Schedule({
    this.day,
    this.startTime,
    this.endTime,
    this.available = true,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) => Schedule(
        day: dayFromString(json['day']),
        startTime: json['startTime'],
        endTime: json['endTime'],
        available: json['available'],
      );

  Map<String, dynamic> toJson() => {
        'day': dayToString(day),
        'startTime': startTime,
        'endTime': endTime,
        'available': available,
      };
}

class PostModel {
  final String? id;
  final String author;
  final String? image;
  final List<String>? media;
  final String? title;
  final String? description;
  final DateTime? startDate;
  final String? startTime;
  final String? address;

  final List<double>? locationCoordinates;

  final List<String>? hasTag;
  final int views;
  final int likes;

  final DateTime? endDate;

  // service
  final num? price;
  final List<Schedule>? schedule;
  final String? category;
  final String? subcategory;
  final String? serviceType;

  // alert
  final String? missingName;
  final num? missingAge;
  final String? clothingDescription;
  final List<double>? lastSeenCoordinates;
  final DateTime? lastSeenDate;
  final String? contactInfo;
  final num? expireLimit;

  final num? capacity;
  final List<String>? amenities;
  final String? licenses;
  final PostStatus status;
  final bool boost;
  final List<String>? attenders;
  final bool isSaved;
  final num totalSaved;
  final num? averageRating;
  final num? reviewsCount;

  PostModel({
    this.id,
    required this.author,
    this.image,
    this.media,
    this.title,
    this.description,
    this.startDate,
    this.startTime,
    this.address,
    this.locationCoordinates,
    this.hasTag,
    this.views = 0,
    this.likes = 0,
    this.endDate,
    this.price,
    this.schedule,
    this.category,
    this.subcategory,
    this.serviceType,
    this.missingName,
    this.missingAge,
    this.clothingDescription,
    this.lastSeenCoordinates,
    this.lastSeenDate,
    this.contactInfo,
    this.expireLimit,
    this.capacity,
    this.amenities,
    this.licenses,
    this.status = PostStatus.PUBLISHED,
    this.boost = false,
    this.attenders,
    this.isSaved = false,
    this.totalSaved = 0,
    this.averageRating,
    this.reviewsCount,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
        id: json['_id'],
        author: json['author'],
        image: json['image'],
        media: json['media'] == null ? null : List<String>.from(json['media']),
        title: json['title'],
        description: json['description'],
        startDate: json['startDate'] == null ? null : DateTime.parse(json['startDate']),
        startTime: json['startTime'],
        address: json['address'],

        locationCoordinates: json['location']?['coordinates'] == null
            ? null
            : List<double>.from(
                json['location']['coordinates'].map((e) => e.toDouble())),

        hasTag: json['hasTag'] == null ? null : List<String>.from(json['hasTag']),
        views: json['views'] ?? 0,
        likes: json['likes'] ?? 0,
        endDate: json['endDate'] == null ? null : DateTime.parse(json['endDate']),
        price: json['price'],
        schedule: json['schedule'] == null
            ? null
            : List<Schedule>.from(
                json['schedule'].map((x) => Schedule.fromJson(x)),
              ),
        category: json['category'],
        subcategory: json['subcategory'],
        serviceType: json['serviceType'],
        missingName: json['missingName'],
        missingAge: json['missingAge'],
        clothingDescription: json['clothingDescription'],

        lastSeenCoordinates:
            json['lastSeenLocation']?['coordinates'] == null
                ? null
                : List<double>.from(
                    json['lastSeenLocation']['coordinates']
                        .map((e) => e.toDouble()),
                  ),

        lastSeenDate: json['lastSeenDate'] == null ? null : DateTime.parse(json['lastSeenDate']),
        contactInfo: json['contactInfo'],
        expireLimit: json['expireLimit'],
        capacity: json['capacity'],
        amenities:
            json['amenities'] == null ? null : List<String>.from(json['amenities']),
        licenses: json['licenses'],
        status: statusFromString(json['status']),
        boost: json['boost'] ?? false,
        attenders: json['attenders'] == null
            ? null
            : List<String>.from(json['attenders'].map((e) => e.toString())),
        isSaved: json['isSaved'] ?? false,
        totalSaved: json['totalSaved'] ?? 0,
        averageRating: json['averageRating'],
        reviewsCount: json['reviewsCount'],
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'author': author,
        'image': image,
        'media': media,
        'title': title,
        'description': description,
        'startDate': startDate?.toIso8601String(),
        'startTime': startTime,
        'address': address,
        'location': {
          'type': 'Point',
          'coordinates': locationCoordinates,
        },
        'hasTag': hasTag,
        'views': views,
        'likes': likes,
        'endDate': endDate?.toIso8601String(),
        'price': price,
        'schedule': schedule?.map((x) => x.toJson()).toList(),
        'category': category,
        'subcategory': subcategory,
        'serviceType': serviceType,
        'missingName': missingName,
        'missingAge': missingAge,
        'clothingDescription': clothingDescription,
        'lastSeenLocation': {
          'type': 'Point',
          'coordinates': lastSeenCoordinates,
        },
        'lastSeenDate': lastSeenDate?.toIso8601String(),
        'contactInfo': contactInfo,
        'expireLimit': expireLimit,
        'capacity': capacity,
        'amenities': amenities,
        'licenses': licenses,
        'status': statusToString(status),
        'boost': boost,
        'attenders': attenders,
        'isSaved': isSaved,
        'totalSaved': totalSaved,
        'averageRating': averageRating,
        'reviewsCount': reviewsCount,
      };

  PostModel copyWith({
    String? id,
    String? author,
    String? image,
    List<String>? media,
    String? title,
    String? description,
    DateTime? startDate,
    String? startTime,
    String? address,
    List<double>? locationCoordinates,
    List<String>? hasTag,
    int? views,
    int? likes,
    DateTime? endDate,
    num? price,
    List<Schedule>? schedule,
    String? category,
    String? subcategory,
    String? serviceType,
    String? missingName,
    num? missingAge,
    String? clothingDescription,
    List<double>? lastSeenCoordinates,
    DateTime? lastSeenDate,
    String? contactInfo,
    num? expireLimit,
    num? capacity,
    List<String>? amenities,
    String? licenses,
    PostStatus? status,
    bool? boost,
    List<String>? attenders,
    bool? isSaved,
    num? totalSaved,
    num? averageRating,
    num? reviewsCount,
  }) {
    return PostModel(
      id: id ?? this.id,
      author: author ?? this.author,
      image: image ?? this.image,
      media: media ?? this.media,
      title: title ?? this.title,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      startTime: startTime ?? this.startTime,
      address: address ?? this.address,
      locationCoordinates: locationCoordinates ?? this.locationCoordinates,
      hasTag: hasTag ?? this.hasTag,
      views: views ?? this.views,
      likes: likes ?? this.likes,
      endDate: endDate ?? this.endDate,
      price: price ?? this.price,
      schedule: schedule ?? this.schedule,
      category: category ?? this.category,
      subcategory: subcategory ?? this.subcategory,
      serviceType: serviceType ?? this.serviceType,
      missingName: missingName ?? this.missingName,
      missingAge: missingAge ?? this.missingAge,
      clothingDescription: clothingDescription ?? this.clothingDescription,
      lastSeenCoordinates: lastSeenCoordinates ?? this.lastSeenCoordinates,
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
      averageRating: averageRating ?? this.averageRating,
      reviewsCount: reviewsCount ?? this.reviewsCount,
    );
  }
}