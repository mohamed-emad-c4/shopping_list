// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shopping_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ShoppingItemAdapter extends TypeAdapter<ShoppingItem> {
  @override
  final int typeId = 0;

  @override
  ShoppingItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ShoppingItem(
      id: fields[0] as String,
      name: fields[1] as String,
      quantity: fields[2] as int,
      isPurchased: fields[3] as bool,
      category: fields[4] as String,
      price: fields[5] as double,
      priority: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ShoppingItem obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.quantity)
      ..writeByte(3)
      ..write(obj.isPurchased)
      ..writeByte(4)
      ..write(obj.category)
      ..writeByte(5)
      ..write(obj.price)
      ..writeByte(6)
      ..write(obj.priority);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShoppingItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
