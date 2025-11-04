class OrderHistoryResponse {
  final String status;
  final List<Order> orders;

  OrderHistoryResponse({
    required this.status,
    required this.orders,
  });

  factory OrderHistoryResponse.fromJson(Map<String, dynamic> json) {
    return OrderHistoryResponse(
      status: json["status"] ?? "",
      orders: json["orders"] != null
          ? List<Order>.from(json["orders"].map((x) => Order.fromJson(x)))
          : [],
    );
  }
}

class Order {
  final int id;
  final String orderNumber;
  final int? partnerId;
  final double totalAmount;
  final String paymentStatus;
  final String orderStatus;
  final String createdAt;
  final List<OrderItem> orderItems;

  Order({
    required this.id,
    required this.orderNumber,
    required this.partnerId,
    required this.totalAmount,
    required this.paymentStatus,
    required this.orderStatus,
    required this.createdAt,
    required this.orderItems,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json["id"] ?? 0,
      orderNumber: json["order_number"] ?? "",
      partnerId: json["partner_id"],
      totalAmount: double.tryParse(json["total_amount"].toString()) ?? 0.0,
      paymentStatus: json["payment_status"] ?? "",
      orderStatus: json["order_status"] ?? "",
      createdAt: json["created_at"] ?? "",
      orderItems: json["order_items"] != null
          ? List<OrderItem>.from(json["order_items"].map((x) => OrderItem.fromJson(x)))
          : [],
    );
  }
}

class OrderItem {
  final int id;
  final int productId;
  final int quantity;
  final double price;
  final double total;
  final String? cuttingType;
  final String? weight;
  final String? status;
  final Product? product;

  OrderItem({
    required this.id,
    required this.productId,
    required this.quantity,
    required this.price,
    required this.total,
    this.cuttingType,
    this.weight,
    this.status,
    this.product,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json["id"] ?? 0,
      productId: json["product_id"] ?? 0,
      quantity: json["quantity"] ?? 0,
      price: double.tryParse(json["price"].toString()) ?? 0.0,
      total: double.tryParse(json["total"].toString()) ?? 0.0,
      cuttingType: json["cutting_type"],
      weight: json["weight"]?.toString(),
      status: json["status"],
      product: json["product"] != null ? Product.fromJson(json["product"]) : null,
    );
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
  final int stock;

  Product({
    required this.id,
    required this.categoryId,
    required this.subCategoryId,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.stock,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json["id"] ?? 0,
      categoryId: json["category_id"] ?? 0,
      subCategoryId: json["sub_category_id"] ?? 0,
      name: json["name"] ?? "",
      description: json["description"] ?? "",
      price: json["price"]?.toString() ?? "0",
      image: json["image"] ?? "",
      stock: json["stock"] ?? 0,
    );
  }
}
