// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stats.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DayStatsAdapter extends TypeAdapter<DayStats> {
  @override
  final int typeId = 1;

  @override
  DayStats read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DayStats(
      day: fields[0] as String,
      completed: fields[1] as int,
      date: fields[2] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, DayStats obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.day)
      ..writeByte(1)
      ..write(obj.completed)
      ..writeByte(2)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DayStatsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
