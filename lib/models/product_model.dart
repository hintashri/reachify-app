import 'package:reachify_app/models/category_model.dart';
import 'package:reachify_app/models/seller_model.dart';
import 'package:reachify_app/models/wish_list_model.dart';

class ProductModel {
  int id;
  String addedBy;
  int sellerId;
  String name;
  String slug;
  String details;
  String productType;
  List<CategoryModel> categoryIds;
  String categoryId;
  String subCategoryId;
  int brandId;
  int businessCategoryId;
  List<String> images;
  String thumbnail;
  String videoUrl;
  String state;
  String country;
  int enablePushNotification;
  DateTime scheduleAt;
  DateTime createdAt;
  DateTime updatedAt;
  int status;
  int reviewsCount;
  SellerModel seller;
  List<WishListModel> wishList;
  List<dynamic> translations;
  List<dynamic> reviews;

  ProductModel({
    this.id = 0,
    this.addedBy = '',
    this.sellerId = 0,
    this.name = '',
    this.slug = '',
    this.details = '',
    this.productType = '',
    List<CategoryModel>? categoryIds,
    this.categoryId = '',
    this.subCategoryId = '',
    this.brandId = 0,
    this.businessCategoryId = 0,
    List<String>? images,
    this.thumbnail = '',
    this.videoUrl = '',
    this.state = '',
    this.country = '',
    this.enablePushNotification = 0,
    DateTime? scheduleAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.status = 0,
    this.reviewsCount = 0,
    SellerModel? seller,
    List<WishListModel>? wishList,
    List<dynamic>? translations,
    List<dynamic>? reviews,
  }) : categoryIds = categoryIds ?? <CategoryModel>[],
       images = images ?? <String>[],
       scheduleAt = scheduleAt ?? DateTime.now(),
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now(),
       seller = seller ?? SellerModel(),
       wishList = wishList ?? <WishListModel>[],
       translations = translations ?? [],
       reviews = reviews ?? [];

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
    id: json['id'] ?? 0,
    addedBy: json['added_by'] ?? '',
    sellerId: json['seller_id'] ?? 0,
    name: json['name'] ?? '',
    slug: json['slug'] ?? '',
    details: json['details'] ?? '',
    productType: json['product_type'] ?? '',
    categoryIds: json['category_ids'] == null
        ? <CategoryModel>[]
        : List<CategoryModel>.from(
            json['category_ids'].map((x) => CategoryModel.fromJson(x)),
          ),
    categoryId: json['category_id'] ?? '',
    subCategoryId: json['sub_category_id'] ?? '',
    brandId: json['brand_id'] ?? 0,
    businessCategoryId: json['business_category_id'] ?? 0,
    images: json['images'] == null
        ? <String>[]
        : List<String>.from(json['images'].map((x) => x)),
    thumbnail: json['thumbnail'] ?? '',
    videoUrl: json['video_url'] ?? '',
    state: json['state'] ?? '',
    country: json['country'] ?? '',
    enablePushNotification: json['enable_push_notification'] ?? 0,
    scheduleAt: json['schedule_at'] == null
        ? DateTime.now()
        : DateTime.parse(json['schedule_at']),
    createdAt: json['created_at'] == null
        ? DateTime.now()
        : DateTime.parse(json['created_at']),
    updatedAt: json['updated_at'] == null
        ? DateTime.now()
        : DateTime.parse(json['updated_at']),
    status: json['status'] ?? 0,
    reviewsCount: json['reviews_count'] ?? 0,
    seller: json['seller'] == null
        ? SellerModel()
        : SellerModel.fromJson(json['seller']),
    wishList: json['wish_list'] == null
        ? <WishListModel>[]
        : List<WishListModel>.from(
            json['wish_list'].map((x) => WishListModel.fromJson(x)),
          ),
    translations: json['translations'] == null
        ? []
        : List<dynamic>.from(json['translations'].map((x) => x)),
    reviews: json['reviews'] == null
        ? []
        : List<dynamic>.from(json['reviews'].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'added_by': addedBy,
    'seller_id': sellerId,
    'name': name,
    'slug': slug,
    'details': details,
    'product_type': productType,
    'category_ids': List<dynamic>.from(categoryIds.map((x) => x.toJson())),
    'category_id': categoryId,
    'sub_category_id': subCategoryId,
    'brand_id': brandId,
    'business_category_id': businessCategoryId,
    'images': List<dynamic>.from(images.map((x) => x)),
    'thumbnail': thumbnail,
    'video_url': videoUrl,
    'state': state,
    'country': country,
    'enable_push_notification': enablePushNotification,
    'schedule_at': scheduleAt.toIso8601String(),
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
    'status': status,
    'reviews_count': reviewsCount,
    'seller': seller.toJson(),
    'wish_list': List<dynamic>.from(wishList.map((x) => x.toJson())),
    'translations': List<dynamic>.from(translations.map((x) => x)),
    'reviews': List<dynamic>.from(reviews.map((x) => x)),
  };
}
