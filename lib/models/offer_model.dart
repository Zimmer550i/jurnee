class OfferModel {
  final String id;
  final String chat;
  final ProviderModel provider;
  final String customer;
  final ServiceModel service;
  final String description;
  final DateTime date;
  final String from;
  final String to;
  final List<OfferItem> items;
  final double discount;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  OfferModel({
    required this.id,
    required this.chat,
    required this.provider,
    required this.customer,
    required this.service,
    required this.description,
    required this.date,
    required this.from,
    required this.to,
    required this.items,
    required this.discount,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OfferModel.fromJson(Map<String, dynamic> json) {
    return OfferModel(
      id: json['_id'] ?? '',
      chat: json['chat'] ?? '',
      provider: ProviderModel.fromJson(json['provider'] as Map<String, dynamic>)
  ,
      customer: json['customer'] ?? '',
      service: json['service'] != null ? ServiceModel.fromJson(json['service'] as Map<String, dynamic>) : ServiceModel(id: ''),
      description: json['description'] ?? '',
      date: json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
      from: json['from'] ?? '',
      to: json['to'] ?? '',
      items: (json['items'] as List?)?.map((e) => OfferItem.fromJson(e)).toList() ?? [],
      discount: (json['discount'] ?? 0).toDouble(),
      status: json['status'] ?? '',
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'chat': chat,
      'provider': provider.toJson(),
      'customer': customer,
      'service': service.toJson(),
      'description': description,
      'date': date.toIso8601String(),
      'from': from,
      'to': to,
      'items': items.map((e) => e.toJson()).toList(),
      'discount': discount,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
  double get amount {
    double total = 0;
    for (final item in items) {
      total += item.unitPrice * item.quantity;
    }
    return total;
  }
}

class OfferItem {
  final String id;
  final String title;
  final int quantity;
  final double unitPrice;

  OfferItem({
    required this.id,
    required this.title,
    required this.quantity,
    required this.unitPrice,
  });

  factory OfferItem.fromJson(Map<String, dynamic> json) {
    return OfferItem(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      quantity: json['quantity'] ?? 0,
      unitPrice: (json['unitPrice'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'quantity': quantity,
      'unitPrice': unitPrice,
    };
  }
}

class ServiceModel {
  final String id;
  final ServiceLocation? location;
  final String image;
  final String title;
  final String description;
  final String category;
  final String subcategory;

  ServiceModel({
    required this.id,
    this.location,
    this.image = '',
    this.title = '',
    this.description = '',
    this.category = '',
    this.subcategory = '',
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['_id']?.toString() ?? '',
      location: json['location'] is Map<String, dynamic>
          ? ServiceLocation.fromJson(json['location'] as Map<String, dynamic>)
          : null,
      image: json['image']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      subcategory: json['subcategory']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'location': location?.toJson(),
      'image': image,
      'title': title,
      'description': description,
      'category': category,
      'subcategory': subcategory,
    };
  }
}

class ServiceLocation {
  final String type;
  final List<double> coordinates;

  ServiceLocation({required this.type, required this.coordinates});

  factory ServiceLocation.fromJson(Map<String, dynamic> json) {
    final coords = json['coordinates'];

    return ServiceLocation(
      type: json['type']?.toString() ?? 'Point',
      coordinates: coords is List
          ? coords.map((e) => (e ?? 0).toDouble()).cast<double>().toList()
          : <double>[],
    );
  }

  Map<String, dynamic> toJson() {
    return {'type': type, 'coordinates': coordinates};
  }

  double? get longitude => coordinates.isNotEmpty ? coordinates[0] : null;
  double? get latitude => coordinates.length > 1 ? coordinates[1] : null;
}

class ProviderModel {
  final String id;
  final String name;
  final String email;
  final String address;
  final String? image;

  ProviderModel({
    required this.id,
    required this.name,
    required this.email,
    required this.address,
    required this.image,
  });

  factory ProviderModel.fromJson(Map<String, dynamic> json) {
    return ProviderModel(
      id: json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
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
