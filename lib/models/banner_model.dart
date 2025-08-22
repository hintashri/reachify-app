// To parse this JSON data, do
//
//     final bannerModel = bannerModelFromJson(jsonString);

import 'dart:convert';

BannerModel bannerModelFromJson(String str) =>
    BannerModel.fromJson(json.decode(str));

String bannerModelToJson(BannerModel data) => json.encode(data.toJson());

class BannerModel {
  int id;
  String photo;
  int published;
  DateTime createdAt;
  DateTime updatedAt;
  String url;
  int priority;
  int catId;

  BannerModel({
    this.id = 0,
    this.photo = '',
    this.published = 0,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.url = '',
    this.priority = 0,
    this.catId = 0,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory BannerModel.fromJson(Map<String, dynamic> json) => BannerModel(
    id: json['id'] ?? 0,
    photo: json['photo'] ?? '',
    published: json['published'] ?? '',
    createdAt: json['created_at'] == null
        ? DateTime.now()
        : DateTime.parse(json['created_at']),
    updatedAt: json['updated_at'] == null
        ? DateTime.now()
        : DateTime.parse(json['updated_at']),
    url: json['url'] ?? '',
    priority: json['priority'] ?? 0,
    catId: json['cat_id'] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'photo': photo,
    'published': published,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
    'url': url,
    'priority': priority,
    'cat_id': catId,
  };
}
