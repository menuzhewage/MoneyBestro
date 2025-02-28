// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transfers.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TransferAdapter extends TypeAdapter<Transfer> {
  @override
  final int typeId = 1;

  @override
  Transfer read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Transfer(
      name: fields[0] as String,
      amount: fields[1] as double,
      date: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Transfer obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.amount)
      ..writeByte(2)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransferAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
