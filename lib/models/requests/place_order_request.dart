class PlaceOrderRequest {
  final int? address;
  final double? latitude;
  final double? longitude;
  final String? instructions;
  final int? location;

  PlaceOrderRequest({
    this.address,
    this.latitude,
    this.longitude,
    this.instructions,
    this.location,
  });

  factory PlaceOrderRequest.fromJson(Map<String, dynamic> json) {
    return PlaceOrderRequest(
      address: json['address'] as int?,
      latitude: (json['latitude'] != null)
          ? (json['latitude'] as num).toDouble()
          : null,
      longitude: (json['longitude'] != null)
          ? (json['longitude'] as num).toDouble()
          : null,
      instructions: json['instructions'] as String?,
      location: json['location'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'instructions': instructions,
      'location': location,
    };
  }
}
