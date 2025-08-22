// import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  UserModel({
    this.id = 0,
    this.token = '',
    this.name = '',
    this.phone = '',
    this.image = '',
    this.selectedCategory = 0,
    this.businessCategory = 0,
    this.businessName = '',
    this.email = '',
    DateTime? emailVerifiedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.country = '',
    this.state = '',
    this.city = '',
    this.cmFirebaseToken = '',
    this.isActive = 0,
    this.isVerify = 0,
    this.isPhoneVerified = 0,
    this.isEmailVerified = 0,
    this.isTempBlocked = 0,
    this.tempBlockTime = 0,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now(),
       emailVerifiedAt = emailVerifiedAt ?? DateTime.now();

  int id;
  String token;
  String name;
  String phone;
  String image;
  int selectedCategory;
  int businessCategory;
  String businessName;
  String email;
  DateTime emailVerifiedAt;
  DateTime createdAt;
  DateTime updatedAt;
  String country;
  String state;
  String city;
  String cmFirebaseToken;
  int isActive;
  int isVerify;
  int isPhoneVerified;
  int isEmailVerified;
  int isTempBlocked;
  dynamic tempBlockTime;

  factory UserModel.fromJson({required Map<String, dynamic> json}) {
    final r = UserModel(
      id: json['id'] ?? 0,
      token: json['token'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      image: json['image'] ?? '',
      selectedCategory: json['selected_category'] ?? 0,
      businessCategory: json['business_category'] ?? 0,
      businessName: json['business_name'] ?? '',
      email: json['email'] ?? '',
      emailVerifiedAt: json['email_verified_at'] == null
          ? DateTime.now()
          : DateTime.parse(json['email_verified_at']),
      createdAt: json['created_at'] == null
          ? DateTime.now()
          : DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] == null
          ? DateTime.now()
          : DateTime.parse(json['updated_at']),
      country: json['country'] ?? '',
      state: json['state'] ?? '',
      city: json['city'] ?? '',
      cmFirebaseToken: json['cm_firebase_token'] ?? '',
      isActive: json['is_active'] ?? '',
      isVerify: json['is_verify'] ?? '',
      isPhoneVerified: json['is_phone_verified'] ?? '',
      isEmailVerified: json['is_email_verified'] ?? '',
      isTempBlocked: json['is_temp_blocked'] ?? '',
      tempBlockTime: json['temp_block_time'] ?? '',
    );
    return r;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'token': token,
    'name': name,
    'phone': phone,
    'image': image,
    'selected_category': selectedCategory,
    'business_category': businessCategory,
    'business_name': businessName,
    'email': email,
    'email_verified_at': emailVerifiedAt,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
    'country': country,
    'state': state,
    'city': city,
    'cm_firebase_token': cmFirebaseToken,
    'is_active': isActive,
    'is_verify': isVerify,
    'is_phone_verified': isPhoneVerified,
    'is_email_verified': isEmailVerified,
    'is_temp_blocked': isTempBlocked,
    'temp_block_time': tempBlockTime,
  };
}

// // To parse this JSON data, do
// //
// //     final userModel = userModelFromJson(jsonString);
//
// import 'dart:convert';
//
// UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));
//
// String userModelToJson(UserModel data) => json.encode(data.toJson());
//
// class UserModel {
//   int id;
//   String name;
//   String phone;
//   String image;
//   int selectedCategory;
//   int businessCategory;
//   String businessName;
//   String email;
//   dynamic emailVerifiedAt;
//   DateTime createdAt;
//   DateTime updatedAt;
//   String country;
//   String state;
//   String city;
//   dynamic cmFirebaseToken;
//   int isActive;
//   int isVerify;
//   int isPhoneVerified;
//   int isEmailVerified;
//   int isTempBlocked;
//   dynamic tempBlockTime;
//
//   UserModel({
//     required this.id,
//     required this.name,
//     required this.phone,
//     required this.image,
//     required this.selectedCategory,
//     required this.businessCategory,
//     required this.businessName,
//     required this.email,
//     required this.emailVerifiedAt,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.country,
//     required this.state,
//     required this.city,
//     required this.cmFirebaseToken,
//     required this.isActive,
//     required this.isVerify,
//     required this.isPhoneVerified,
//     required this.isEmailVerified,
//     required this.isTempBlocked,
//     required this.tempBlockTime,
//   });
//
//   factory UserModel.fromJson(Map<String, dynamic> json) =>
//       UserModel(
//         id: json["id"],
//         name: json["name"],
//         phone: json["phone"],
//         image: json["image"],
//         selectedCategory: json["selected_category"],
//         businessCategory: json["business_category"],
//         businessName: json["business_name"],
//         email: json["email"],
//         emailVerifiedAt: json["email_verified_at"],
//         createdAt: DateTime.parse(json["created_at"]),
//         updatedAt: DateTime.parse(json["updated_at"]),
//         country: json["country"],
//         state: json["state"],
//         city: json["city"],
//         cmFirebaseToken: json["cm_firebase_token"],
//         isActive: json["is_active"],
//         isVerify: json["is_verify"],
//         isPhoneVerified: json["is_phone_verified"],
//         isEmailVerified: json["is_email_verified"],
//         isTempBlocked: json["is_temp_blocked"],
//         tempBlockTime: json["temp_block_time"],
//       );
//
//   Map<String, dynamic> toJson() =>
//       {
//         "id": id,
//         "name": name,
//         "phone": phone,
//         "image": image,
//         "selected_category": selectedCategory,
//         "business_category": businessCategory,
//         "business_name": businessName,
//         "email": email,
//         "email_verified_at": emailVerifiedAt,
//         "created_at": createdAt.toIso8601String(),
//         "updated_at": updatedAt.toIso8601String(),
//         "country": country,
//         "state": state,
//         "city": city,
//         "cm_firebase_token": cmFirebaseToken,
//         "is_active": isActive,
//         "is_verify": isVerify,
//         "is_phone_verified": isPhoneVerified,
//         "is_email_verified": isEmailVerified,
//         "is_temp_blocked": isTempBlocked,
//         "temp_block_time": tempBlockTime,
//       };
// }
