import 'dart:convert';

CountryModel countryModelFromJson(String str) =>
    CountryModel.fromJson(json.decode(str));

String countryModelToJson(CountryModel data) => json.encode(data.toJson());

class CountryModel {
  int id;
  String name;
  String iso2;
  String phoneCode;
  int regionId;
  int subregionId;

  CountryModel({
    this.id = 0,
    this.name = '',
    this.iso2 = '',
    this.phoneCode = '',
    this.regionId = 0,
    this.subregionId = 0,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) => CountryModel(
    id: json['id'] ?? 0,
    name: json['name'] ?? '',
    iso2: json['iso2'] ?? '',
    phoneCode: json['phonecode'] ?? '',
    regionId: json['region_id'] ?? 0,
    subregionId: json['subregion_id'] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'iso2': iso2,
    'phonecode': phoneCode,
    'region_id': regionId,
    'subregion_id': subregionId,
  };
}
