class OrderDetailsResponse {
  final String status;
  final OrderData order;

  OrderDetailsResponse({
    required this.status,
    required this.order,
  });

  factory OrderDetailsResponse.fromJson(Map<String, dynamic> json) {
    return OrderDetailsResponse(
      status: json['status'] ?? '',
      order: OrderData.fromJson(json['order']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "status": status,
      "order": order.toJson(),
    };
  }
}
class OrderData {
  final int id;
  final String orderNumber;
  final int userId;
  final int? partnerId;
  final String? recipientName;
  final String? recipientPhone;
  final String? deliveryAddress;
  final String? deliveryCity;
  final String? deliveryState;
  final String? deliveryPostcode;
  final String? latitude;
  final String? longitude;
  final String totalAmount;
  final String paymentStatus;
  final String orderStatus;
  final String? notes;
  final String? dispatchedAt;
  final String? deliveredAt;
  final String? cancelledAt;
  final int address;
  final String createdAt;
  final String updatedAt;
  final List<OrderItem> orderItems;

  OrderData({
    required this.id,
    required this.orderNumber,
    required this.userId,
    this.partnerId,
    this.recipientName,
    this.recipientPhone,
    this.deliveryAddress,
    this.deliveryCity,
    this.deliveryState,
    this.deliveryPostcode,
    this.latitude,
    this.longitude,
    required this.totalAmount,
    required this.paymentStatus,
    required this.orderStatus,
    this.notes,
    this.dispatchedAt,
    this.deliveredAt,
    this.cancelledAt,
    required this.address,
    required this.createdAt,
    required this.updatedAt,
    required this.orderItems,
  });

  factory OrderData.fromJson(Map<String, dynamic> json) {
    return OrderData(
      id: json['id'],
      orderNumber: json['order_number'] ?? '',
      userId: json['user_id'],
      partnerId: json['partner_id'],
      recipientName: json['recipient_name'],
      recipientPhone: json['recipient_phone'],
      deliveryAddress: json['delivery_address'],
      deliveryCity: json['delivery_city'],
      deliveryState: json['delivery_state'],
      deliveryPostcode: json['delivery_postcode'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      totalAmount: json['total_amount'] ?? '0',
      paymentStatus: json['payment_status'] ?? '',
      orderStatus: json['order_status'] ?? '',
      notes: json['notes'],
      dispatchedAt: json['dispatched_at'],
      deliveredAt: json['delivered_at'],
      cancelledAt: json['cancelled_at'],
      address: json['address'] ?? 0,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      orderItems: List<OrderItem>.from(
        json['order_items'].map((x) => OrderItem.fromJson(x)),
      ),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "order_number": orderNumber,
        "user_id": userId,
        "partner_id": partnerId,
        "recipient_name": recipientName,
        "recipient_phone": recipientPhone,
        "delivery_address": deliveryAddress,
        "delivery_city": deliveryCity,
        "delivery_state": deliveryState,
        "delivery_postcode": deliveryPostcode,
        "latitude": latitude,
        "longitude": longitude,
        "total_amount": totalAmount,
        "payment_status": paymentStatus,
        "order_status": orderStatus,
        "notes": notes,
        "dispatched_at": dispatchedAt,
        "delivered_at": deliveredAt,
        "cancelled_at": cancelledAt,
        "address": address,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "order_items": orderItems.map((x) => x.toJson()).toList(),
      };
}
class OrderItem {
  final int id;
  final int orderId;
  final int productId;
  final int quantity;
  final String? cuttingType;
  final String? weight;
  final String price;
  final String total;
  final String status;
  final String createdAt;
  final String updatedAt;
  final ProductDetails product;

  OrderItem({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.quantity,
    this.cuttingType,
    this.weight,
    required this.price,
    required this.total,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.product,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      orderId: json['order_id'],
      productId: json['product_id'],
      quantity: json['quantity'],
      cuttingType: json['cutting_type'],
      weight: json['weight'],
      price: json['price'],
      total: json['total'],
      status: json['status'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      product: ProductDetails.fromJson(json['product']),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "order_id": orderId,
        "product_id": productId,
        "quantity": quantity,
        "cutting_type": cuttingType,
        "weight": weight,
        "price": price,
        "total": total,
        "status": status,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "product": product.toJson(),
      };
}
class ProductDetails {
  final int id;
  final int categoryId;
  final int subCategoryId;
  final String name;
  final String description;
  final String price;
  final String image;
  final int stock;

  ProductDetails({
    required this.id,
    required this.categoryId,
    required this.subCategoryId,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.stock,
  });

  factory ProductDetails.fromJson(Map<String, dynamic> json) {
    return ProductDetails(
      id: json['id'],
      categoryId: json['category_id'],
      subCategoryId: json['sub_category_id'],
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: json['price'] ?? '0',
      image: json['image'] ?? '',
      stock: json['stock'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "category_id": categoryId,
        "sub_category_id": subCategoryId,
        "name": name,
        "description": description,
        "price": price,
        "image": image,
        "stock": stock,
      };
}