class WishListModel {
  int id;
  int customerId;
  int productId;
  DateTime createdAt;
  DateTime updatedAt;

  WishListModel({
    this.id = 0,
    this.customerId = 0,
    this.productId = 0,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory WishListModel.fromJson(Map<String, dynamic> json) => WishListModel(
    id: json['id'] ?? 0,
    customerId: json['customer_id'] ?? 0,
    productId: json['product_id'] ?? 0,
    createdAt: json['created_at'] == null
        ? DateTime.now()
        : DateTime.parse(json['created_at']),
    updatedAt: json['updated_at'] == null
        ? DateTime.now()
        : DateTime.parse(json['updated_at']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'customer_id': customerId,
    'product_id': productId,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };
}
