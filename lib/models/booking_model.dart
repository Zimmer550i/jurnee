class BookingService {
  final String id;
  final String title;
  final String category;

  BookingService({
    required this.id,
    required this.title,
    required this.category,
  });

  factory BookingService.fromJson(Map<String, dynamic> json) {
    return BookingService(
      id: json['_id'] as String,
      title: json['title'] as String,
      category: json['category'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'category': category,
    };
  }
}

class BookingProvider {
  final String id;
  final String name;
  final String email;
  final String address;
  final String? image;

  BookingProvider({
    required this.id,
    required this.name,
    required this.email,
    required this.address,
    this.image,
  });

  factory BookingProvider.fromJson(Map<String, dynamic> json) {
    return BookingProvider(
      id: json['_id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      address: json['address'] as String,
      image: json['image'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'address': address,
      'image': image,
    };
  }
}

class BookingModel {
  final String id;
  final BookingService service;
  final BookingProvider provider;
  final String customer;
  final String scheduleId;
  final String slotId;
  final String slotStart;
  final String slotEnd;
  final DateTime serviceDate;
  final String status;
  final num amount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int version;

  BookingModel({
    required this.id,
    required this.service,
    required this.provider,
    required this.customer,
    required this.scheduleId,
    required this.slotId,
    required this.slotStart,
    required this.slotEnd,
    required this.serviceDate,
    required this.status,
    required this.amount,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['_id'] as String,
      service: BookingService.fromJson(json['service']),
      provider: BookingProvider.fromJson(json['provider']),
      customer: json['customer'] as String,
      scheduleId: json['scheduleId'] as String,
      slotId: json['slotId'] as String,
      slotStart: json['slotStart'] as String,
      slotEnd: json['slotEnd'] as String,
      serviceDate: DateTime.parse(json['serviceDate']),
      status: json['status'] as String,
      amount: json['amount'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      version: json['__v'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'service': service.toJson(),
      'provider': provider.toJson(),
      'customer': customer,
      'scheduleId': scheduleId,
      'slotId': slotId,
      'slotStart': slotStart,
      'slotEnd': slotEnd,
      'serviceDate': serviceDate.toIso8601String(),
      'status': status,
      'amount': amount,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '__v': version,
    };
  }

  BookingModel copyWith({
    String? id,
    BookingService? service,
    BookingProvider? provider,
    String? customer,
    String? scheduleId,
    String? slotId,
    String? slotStart,
    String? slotEnd,
    DateTime? serviceDate,
    String? status,
    num? amount,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? version,
  }) {
    return BookingModel(
      id: id ?? this.id,
      service: service ?? this.service,
      provider: provider ?? this.provider,
      customer: customer ?? this.customer,
      scheduleId: scheduleId ?? this.scheduleId,
      slotId: slotId ?? this.slotId,
      slotStart: slotStart ?? this.slotStart,
      slotEnd: slotEnd ?? this.slotEnd,
      serviceDate: serviceDate ?? this.serviceDate,
      status: status ?? this.status,
      amount: amount ?? this.amount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      version: version ?? this.version,
    );
  }
}