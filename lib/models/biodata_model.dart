import 'package:hive/hive.dart';

part 'biodata_model.g.dart';

@HiveType(typeId: 0)
class Biodata extends HiveObject {

  @HiveField(0)
  late String id;

  @HiveField(1)
  late String name;

  @HiveField(2)
  late String age;

  @HiveField(3)
  late String height;

  @HiveField(4)
  late String city;

  @HiveField(5)
  late String education;

  @HiveField(6)
  late String profession;

  @HiveField(7)
  late String fatherName;

  @HiveField(8)
  late String motherName;

  @HiveField(9)
  late String brothers;

  @HiveField(10)
  late String sisters;

  @HiveField(11)
  late String familyType;

  @HiveField(12)
  late String sect;

  @HiveField(13)
  late String religiousness;

  @HiveField(14)
  late String photoPath;

  @HiveField(15)
  late int templateId;

  @HiveField(16)
  late String notes;

  @HiveField(17)
  late DateTime createdAt;

  Biodata();

  Biodata.empty() {
    id = DateTime.now().millisecondsSinceEpoch.toString();
    name = '';
    age = '';
    height = '';
    city = '';
    education = '';
    profession = '';
    fatherName = '';
    motherName = '';
    brothers = '0';
    sisters = '0';
    familyType = 'separate';
    sect = '';
    religiousness = '';
    photoPath = '';
    templateId = 1;
    notes = '';
    createdAt = DateTime.now();
  }

  Biodata copyWith({
    String? name,
    String? age,
    String? height,
    String? city,
    String? education,
    String? profession,
    String? fatherName,
    String? motherName,
    String? brothers,
    String? sisters,
    String? familyType,
    String? sect,
    String? religiousness,
    String? photoPath,
    int? templateId,
    String? notes,
  }) {
    final b = Biodata.empty();
    b.id = id;
    b.createdAt = createdAt;
    b.name = name ?? this.name;
    b.age = age ?? this.age;
    b.height = height ?? this.height;
    b.city = city ?? this.city;
    b.education = education ?? this.education;
    b.profession = profession ?? this.profession;
    b.fatherName = fatherName ?? this.fatherName;
    b.motherName = motherName ?? this.motherName;
    b.brothers = brothers ?? this.brothers;
    b.sisters = sisters ?? this.sisters;
    b.familyType = familyType ?? this.familyType;
    b.sect = sect ?? this.sect;
    b.religiousness = religiousness ?? this.religiousness;
    b.photoPath = photoPath ?? this.photoPath;
    b.templateId = templateId ?? this.templateId;
    b.notes = notes ?? this.notes;
    return b;
  }
}