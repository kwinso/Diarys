// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subjects_list.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SubjectsListAdapter extends TypeAdapter<SubjectsList> {
  @override
  final int typeId = 4;

  @override
  SubjectsList read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SubjectsList(
      (fields[0] as List).cast<Subject>(),
    );
  }

  @override
  void write(BinaryWriter writer, SubjectsList obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.list);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubjectsListAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
