import 'dart:convert';

List<CityModel> categoryModelFromJson(String str) =>
    List<CityModel>.from(json.decode(str).map((x) => CityModel.fromJson(x)));

String categoryModelToJson(List<CityModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CityModel {
  String countryName;
  String stateName;
  String name;

  CityModel({this.countryName = '', this.stateName = '', this.name = ''});

  factory CityModel.fromJson(Map<String, dynamic> json) => CityModel(
    countryName: json['country_name'] ?? '',
    stateName: json['state_name'] ?? '',
    name: json['name'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    'country_name': countryName,
    'state_name': stateName,
    'name': name,
  };
}
