// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'biodata_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BiodataAdapter extends TypeAdapter<Biodata> {
  @override
  final int typeId = 0;

  @override
  Biodata read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Biodata()
      ..id               = fields[0] as String
      ..name             = fields[1] as String
      ..age              = fields[2] as String
      ..height           = fields[3] as String
      ..city             = fields[4] as String
      ..education        = fields[5] as String
      ..profession       = fields[6] as String
      ..fatherName       = fields[7] as String
      ..motherName       = fields[8] as String
      ..brothers         = fields[9] as String
      ..sisters          = fields[10] as String
      ..familyType       = fields[11] as String
      ..sect             = fields[12] as String
      ..religiousness    = fields[13] as String
      ..photoPath        = fields[14] as String
      ..templateId       = fields[15] as int
      ..notes            = fields[16] as String
      ..createdAt        = fields[17] as DateTime
      ..complexion       = fields[18] as String
      ..motherTongue     = fields[19] as String
      ..salary           = fields[20] as String
      ..whatsappNumber   = fields[21] as String
      ..institute        = fields[22] as String
      ..fatherProfession = fields[23] as String
      ..caste            = fields[24] as String
      ..maritalStatus    = fields[25] as String
      ..brothersMarried  = (fields[26] as String?) ?? ''
      ..sistersMarried   = (fields[27] as String?) ?? ''
      ..personalNotes    = (fields[28] as String?) ?? ''
      ..educationNotes   = (fields[29] as String?) ?? ''
      ..familyNotes      = (fields[30] as String?) ?? ''
      ..religiousNotes   = (fields[31] as String?) ?? '';
  }

  @override
  void write(BinaryWriter writer, Biodata obj) {
    writer
      ..writeByte(32)
      ..writeByte(0)  ..write(obj.id)
      ..writeByte(1)  ..write(obj.name)
      ..writeByte(2)  ..write(obj.age)
      ..writeByte(3)  ..write(obj.height)
      ..writeByte(4)  ..write(obj.city)
      ..writeByte(5)  ..write(obj.education)
      ..writeByte(6)  ..write(obj.profession)
      ..writeByte(7)  ..write(obj.fatherName)
      ..writeByte(8)  ..write(obj.motherName)
      ..writeByte(9)  ..write(obj.brothers)
      ..writeByte(10) ..write(obj.sisters)
      ..writeByte(11) ..write(obj.familyType)
      ..writeByte(12) ..write(obj.sect)
      ..writeByte(13) ..write(obj.religiousness)
      ..writeByte(14) ..write(obj.photoPath)
      ..writeByte(15) ..write(obj.templateId)
      ..writeByte(16) ..write(obj.notes)
      ..writeByte(17) ..write(obj.createdAt)
      ..writeByte(18) ..write(obj.complexion)
      ..writeByte(19) ..write(obj.motherTongue)
      ..writeByte(20) ..write(obj.salary)
      ..writeByte(21) ..write(obj.whatsappNumber)
      ..writeByte(22) ..write(obj.institute)
      ..writeByte(23) ..write(obj.fatherProfession)
      ..writeByte(24) ..write(obj.caste)
      ..writeByte(25) ..write(obj.maritalStatus)
      ..writeByte(26) ..write(obj.brothersMarried)
      ..writeByte(27) ..write(obj.sistersMarried)
      ..writeByte(28) ..write(obj.personalNotes)
      ..writeByte(29) ..write(obj.educationNotes)
      ..writeByte(30) ..write(obj.familyNotes)
      ..writeByte(31) ..write(obj.religiousNotes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is BiodataAdapter &&
              runtimeType == other.runtimeType &&
              typeId == other.typeId;
}