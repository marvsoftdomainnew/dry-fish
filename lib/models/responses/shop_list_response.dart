class ShopListResponse {
  final List<Shop> shops;
  final bool success;

  ShopListResponse({required this.shops, required this.success});

  factory ShopListResponse.fromJson(Map<String, dynamic> json) {
    var shopList = json['shops'] as List;
    List<Shop> shops = shopList.map((shop) => Shop.fromJson(shop)).toList();

    return ShopListResponse(shops: shops, success: json['success']);
  }

  Map<String, dynamic> toJson() {
    return {
      'shops': shops.map((shop) => shop.toJson()).toList(),
      'success': success,
    };
  }
}

class Shop {
  final int id;
  final String name;

  Shop({required this.id, required this.name});

  factory Shop.fromJson(Map<String, dynamic> json) {
    return Shop(id: json['id'], name: json['name']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}
