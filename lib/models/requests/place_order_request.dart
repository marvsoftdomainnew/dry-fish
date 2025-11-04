class PlaceOrderRequest {
  final int? address;
  final double? latitude;
  final double? longitude;
  final String? instructions;

  PlaceOrderRequest({
    this.address,
    this.latitude,
    this.longitude,
    this.instructions,
  });

  factory PlaceOrderRequest.fromJson(Map<String, dynamic> json) {
    return PlaceOrderRequest(
      address: json['address'] as int?,
      latitude: (json['lattitude'] != null)
          ? (json['lattitude'] as num).toDouble()
          : null,
      longitude: (json['longitude'] != null)
          ? (json['longitude'] as num).toDouble()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'lattitude': latitude,
      'longitude': longitude,
      'instructions': instructions, 
    };
  }
}
