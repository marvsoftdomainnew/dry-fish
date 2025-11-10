class CartResponseModel {
  final bool success;
  final List<CartItem> cart;

  CartResponseModel({
    required this.success,
    required this.cart,
  });

  factory CartResponseModel.fromJson(Map<String, dynamic> json) {
    return CartResponseModel(
      success: json['success'] ?? false,
      cart: (json['cart'] as List<dynamic>?)
              ?.map((e) => CartItem.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'cart': cart.map((e) => e.toJson()).toList(),
    };
  }
}

class CartItem {
  final int id;
  final int userId;
  final int productId;
  int quantity;
  final double price;
  final String cuttingType;
  final String weight;
  double total;
  final String status;
  final String createdAt;
  final String updatedAt;
  final Product product;

  CartItem({
    required this.id,
    required this.userId,
    required this.productId,
    required this.quantity,
    required this.price,
    required this.cuttingType,
    required this.weight,
    required this.total,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.product,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      productId: json['product_id'] ?? 0,
      quantity: json['quantity'] ?? 0,
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      cuttingType: json['cutting_type'] ?? '',
      weight: json['weight']?.toString() ?? '',
      total: double.tryParse(json['total'].toString()) ?? 0.0,
      status: json['status'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      product: Product.fromJson(json['product'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'product_id': productId,
      'quantity': quantity,
      'price': price,
      'cutting_type': cuttingType,
      'weight': weight,
      'total': total,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'product': product.toJson(),
    };
  }
}

class Product {
  final int id;
  final int categoryId;
  final int subCategoryId;
  final String name;
  final String description;
  final String price;
  final String image;
  final String? weight;
  final int stock;
  final String createdAt;
  final String updatedAt;

  Product({
    required this.id,
    required this.categoryId,
    required this.subCategoryId,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    this.weight,
    required this.stock,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      categoryId: json['category_id'] ?? 0,
      subCategoryId: json['sub_category_id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: json['price'] ?? '0',
      image: json['image'] ?? '',
      weight: json['weight'],
      stock: json['stock'] ?? 0,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category_id': categoryId,
      'sub_category_id': subCategoryId,
      'name': name,
      'description': description,
      'price': price,
      'image': image,
      'weight': weight,
      'stock': stock,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
