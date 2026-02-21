class OfferModel {
  final String id;
  final String chat;
  final String provider;
  final String customer;
  final String service;
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
      provider: json['provider'] ?? '',
      customer: json['customer'] ?? '',
      service: json['service'] ?? '',
      description: json['description'] ?? '',
      date: DateTime.parse(json['date']),
      from: json['from'] ?? '',
      to: json['to'] ?? '',
      items: (json['items'] as List)
          .map((e) => OfferItem.fromJson(e))
          .toList(),
      discount: (json['discount'] ?? 0).toDouble(),
      status: json['status'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'chat': chat,
      'provider': provider,
      'customer': customer,
      'service': service,
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