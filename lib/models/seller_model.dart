class SellerModel {
  int id;
  String fName;
  String lName;
  String brand;
  String whatsappLink;
  String phoneNumber;
  String email;
  String website;
  String companyName;
  String companyAddress;
  String status;
  DateTime createdAt;
  DateTime updatedAt;

  SellerModel({
    this.id = 0,
    this.fName = '',
    this.lName = '',
    this.brand = '',
    this.whatsappLink = '',
    this.phoneNumber = '',
    this.email = '',
    this.website = '',
    this.companyName = '',
    this.companyAddress = '',
    this.status = '',
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory SellerModel.fromJson(Map<String, dynamic> json) => SellerModel(
    id: json['id'] ?? 0,
    fName: json['f_name'] ?? '',
    lName: json['l_name'] ?? '',
    brand: json['brand'] ?? '',
    whatsappLink: json['whatsapp_link'] ?? '',
    phoneNumber: json['phone_number'] ?? '',
    email: json['email'] ?? '',
    website: json['website'] ?? '',
    companyName: json['company_name'] ?? '',
    companyAddress: json['company_address'] ?? '',
    status: json['status'] ?? '',
    createdAt: json['created_at'] == null
        ? DateTime.now()
        : DateTime.parse(json['created_at']),
    updatedAt: json['updated_at'] == null
        ? DateTime.now()
        : DateTime.parse(json['updated_at']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'f_name': fName,
    'l_name': lName,
    'brand': brand,
    'whatsapp_link': whatsappLink,
    'phone_number': phoneNumber,
    'email': email,
    'website': website,
    'company_name': companyName,
    'company_address': companyAddress,
    'status': status,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };
}
