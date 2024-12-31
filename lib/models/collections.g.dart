// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collections.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CollectionAdapter extends TypeAdapter<Collection> {
  @override
  final int typeId = 0;

  @override
  Collection read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Collection(
      name: fields[0] as String,
      amount: fields[1] as double,
      qp: fields[2] as String,
      uq: fields[3] as String,
      sp: fields[4] as String,
      nb: fields[5] as String,
      rt: fields[6] as String,
      rv: fields[7] as String,
      date: fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Collection obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.amount)
      ..writeByte(2)
      ..write(obj.qp)
      ..writeByte(3)
      ..write(obj.uq)
      ..writeByte(4)
      ..write(obj.sp)
      ..writeByte(5)
      ..write(obj.nb)
      ..writeByte(6)
      ..write(obj.rt)
      ..writeByte(7)
      ..write(obj.rv)
      ..writeByte(8)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CollectionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
