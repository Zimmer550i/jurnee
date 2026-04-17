import 'package:jurnee/models/post_model.dart';

class MyServiceModel {
  final String id;
  final Author? author;
  final String title;
  final String? category;
  final dynamic subcategory;

  MyServiceModel({
    required this.id,
    this.author,
    required this.title,
    this.category,
    this.subcategory,
  });

  factory MyServiceModel.fromJson(Map<String, dynamic> json) => MyServiceModel(
    id: json["_id"],
    author: Author.fromJson(Map<String, dynamic>.from(json["author"] as Map)),
    title: json["title"],
    category: json["category"],
    subcategory: json["subcategory"],
  );
}
