class GetAddressesResponse {
  final bool status;
  final String message;
  final List<AddressModel> addresses;

  GetAddressesResponse({
    required this.status,
    required this.message,
    required this.addresses,
  });

  factory GetAddressesResponse.fromJson(Map<String, dynamic> json) {
    return GetAddressesResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      addresses: (json['addresses'] as List<dynamic>?)
          ?.map((e) => AddressModel.fromJson(e))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'addresses': addresses.map((e) => e.toJson()).toList(),
    };
  }
}

class AddressModel {
  final int id;
  final int userId;
  final String name;
  final String phone;
  final String flat;
  final String street;
  final String building;
  final String country;
  final String city;
  final String state;
  final String zip;
  final String landmark;
  final String locality;
  final String addressType;
  final bool isSelected;
  final String createdAt;
  final String updatedAt;

  AddressModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.phone,
    required this.flat,
    required this.street,
    required this.building,
    required this.country,
    required this.city,
    required this.state,
    required this.zip,
    required this.landmark,
    required this.locality,
    required this.addressType,
    required this.isSelected,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      flat: json['flat'] ?? '',
      street: json['street'] ?? '',
      building: json['building'] ?? '',
      country: json['country'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      zip: json['zip'] ?? '',
      landmark: json['landmark'] ?? '',
      locality: json['locality'] ?? '',
      addressType: json['address_type'] ?? '',
      isSelected: (json['is_selected'] ?? 0) == 1,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'phone': phone,
      'flat': flat,
      'street': street,
      'building': building,
      'country': country,
      'city': city,
      'state': state,
      'zip': zip,
      'landmark': landmark,
      'locality': locality,
      'address_type': addressType,
      'is_selected': isSelected ? 1 : 0,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
