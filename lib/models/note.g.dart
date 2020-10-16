// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NoteAdapter extends TypeAdapter<Note> {
  @override
  final int typeId = 1;

  @override
  Note read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Note(
      fields[0] as int,
      (fields[1] as List)?.cast<String>(),
      fields[2] as String,
      (fields[3] as List)?.cast<String>(),
      fields[4] as DateTime,
      fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Note obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.mood)
      ..writeByte(1)
      ..write(obj.achievements)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.imgPaths)
      ..writeByte(4)
      ..write(obj.dateTime)
      ..writeByte(5)
      ..write(obj.isFavorite);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is NoteAdapter &&
              runtimeType == other.runtimeType &&
              typeId == other.typeId;
}