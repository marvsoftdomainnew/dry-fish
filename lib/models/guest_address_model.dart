import 'package:hive/hive.dart';

part 'guest_address_model.g.dart';

@HiveType(typeId: 2)
class GuestAddressModel extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String phone;

  @HiveField(2)
  String flat;

  @HiveField(3)
  String block;

  @HiveField(4)
  String building;

  @HiveField(5)
  String street;

  @HiveField(6)
  String landmark;

  @HiveField(7)
  String pincode;

  @HiveField(8)
  String locality;

  @HiveField(9)
  String addressType; // HOME / WORK / OTHER

  GuestAddressModel({
    required this.name,
    required this.phone,
    required this.flat,
    required this.block,
    required this.building,
    required this.street,
    required this.landmark,
    required this.pincode,
    required this.locality,
    required this.addressType,
  });
}
