// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'guest_address_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GuestAddressModelAdapter extends TypeAdapter<GuestAddressModel> {
  @override
  final int typeId = 2;

  @override
  GuestAddressModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GuestAddressModel(
      name: fields[0] as String,
      phone: fields[1] as String,
      flat: fields[2] as String,
      block: fields[3] as String,
      building: fields[4] as String,
      street: fields[5] as String,
      landmark: fields[6] as String,
      pincode: fields[7] as String,
      locality: fields[8] as String,
      addressType: fields[9] as String,
    );
  }

  @override
  void write(BinaryWriter writer, GuestAddressModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.phone)
      ..writeByte(2)
      ..write(obj.flat)
      ..writeByte(3)
      ..write(obj.block)
      ..writeByte(4)
      ..write(obj.building)
      ..writeByte(5)
      ..write(obj.street)
      ..writeByte(6)
      ..write(obj.landmark)
      ..writeByte(7)
      ..write(obj.pincode)
      ..writeByte(8)
      ..write(obj.locality)
      ..writeByte(9)
      ..write(obj.addressType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GuestAddressModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
