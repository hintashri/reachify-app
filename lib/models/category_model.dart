import 'dart:convert';

import 'package:reachify_app/models/product_model.dart';

List<CategoryModel> categoryModelFromJson(String str) =>
    List<CategoryModel>.from(
      json.decode(str).map((x) => CategoryModel.fromJson(x)),
    );

String categoryModelToJson(List<CategoryModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CategoryModel {
  int id;
  String name;
  String slug;
  String icon;
  int parentId;
  int position;
  DateTime createdAt;
  DateTime updatedAt;
  int homeStatus;
  int priority;
  List<CategoryModel> childes;
  List<dynamic> translations;
  List<ProductModel> products;

  CategoryModel({
    this.id = 0,
    this.name = '',
    this.slug = '',
    this.icon = '',
    this.parentId = 0,
    this.position = 0,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.homeStatus = 0,
    this.priority = 0,
    List<CategoryModel>? childes,
    List<ProductModel>? products,
    List<dynamic>? translations,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now(),
       childes = childes ?? <CategoryModel>[],
       products = products ?? <ProductModel>[],
       translations = translations ?? [];

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
    id: json['id'] == null ? 0 : int.parse(json['id'].toString()),
    name: json['name'] ?? '',
    slug: json['slug'] ?? '',
    icon: json['icon'] ?? '',
    parentId: json['parent_id'] ?? 0,
    position: json['position'] ?? 0,
    createdAt: json['created_at'] == null
        ? DateTime.now()
        : DateTime.parse(json['created_at']),
    updatedAt: json['updated_at'] == null
        ? DateTime.now()
        : DateTime.parse(json['updated_at']),
    homeStatus: json['home_status'] ?? 0,
    priority: json['priority'] ?? 0,
    childes: json['childes'] == null
        ? <CategoryModel>[]
        : List<CategoryModel>.from(
            json['childes'].map((x) => CategoryModel.fromJson(x)),
          ),
    products: json['products'] == null
        ? <ProductModel>[]
        : List<ProductModel>.from(
            json['products'].map((x) => ProductModel.fromJson(x)),
          ),
    translations: json['translations'] == null
        ? []
        : List<dynamic>.from(json['translations'].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'slug': slug,
    'icon': icon,
    'parent_id': parentId,
    'position': position,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
    'home_status': homeStatus,
    'priority': priority,
    'childes': List<dynamic>.from(childes.map((x) => x.toJson())),
    'products': List<dynamic>.from(products.map((x) => x.toJson())),
    'translations': List<dynamic>.from(translations.map((x) => x)),
  };
}
