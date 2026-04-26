import 'package:hive/hive.dart';

part 'biodata_model.g.dart';

@HiveType(typeId: 0)
class Biodata extends HiveObject {

  @HiveField(0)  late String   id;
  @HiveField(1)  late String   name;
  @HiveField(2)  late String   age;
  @HiveField(3)  late String   height;
  @HiveField(4)  late String   city;
  @HiveField(5)  late String   education;
  @HiveField(6)  late String   profession;
  @HiveField(7)  late String   fatherName;
  @HiveField(8)  late String   motherName;
  @HiveField(9)  late String   brothers;
  @HiveField(10) late String   sisters;
  @HiveField(11) late String   familyType;
  @HiveField(12) late String   sect;          // kept for backward compat, now free text
  @HiveField(13) late String   religiousness; // kept for backward compat, now free text
  @HiveField(14) late String   photoPath;
  @HiveField(15) late int      templateId;
  @HiveField(16) late String   notes;
  @HiveField(17) late DateTime createdAt;
  @HiveField(18) late String   complexion;
  @HiveField(19) late String   motherTongue;
  @HiveField(20) late String   salary;
  @HiveField(21) late String   whatsappNumber;
  @HiveField(22) late String   institute;
  @HiveField(23) late String   fatherProfession;
  @HiveField(24) late String   caste;
  @HiveField(25) late String   maritalStatus;
  @HiveField(26) late String   brothersMarried;
  @HiveField(27) late String   sistersMarried;
  @HiveField(28) late String   personalNotes;
  @HiveField(29) late String   educationNotes;
  @HiveField(30) late String   familyNotes;
  @HiveField(31) late String   religiousNotes;
  @HiveField(32) late String   religion;      // NEW: e.g. Islam, Christianity, Sikh

  Biodata();

  Biodata.empty() {
    id               = DateTime.now().millisecondsSinceEpoch.toString();
    name             = '';
    age              = '';
    height           = '';
    city             = '';
    education        = '';
    profession       = '';
    fatherName       = '';
    motherName       = '';
    brothers         = '';
    sisters          = '';
    familyType       = '';
    sect             = '';
    religiousness    = '';
    photoPath        = '';
    templateId       = 1;
    notes            = '';
    createdAt        = DateTime.now();
    complexion       = '';
    motherTongue     = '';
    salary           = '';
    whatsappNumber   = '';
    institute        = '';
    fatherProfession = '';
    caste            = '';
    maritalStatus    = '';
    brothersMarried  = '';
    sistersMarried   = '';
    personalNotes    = '';
    educationNotes   = '';
    familyNotes      = '';
    religiousNotes   = '';
    religion         = 'Islam'; // default
  }

  Biodata copyWith({
    String?   name,
    String?   age,
    String?   height,
    String?   city,
    String?   education,
    String?   profession,
    String?   fatherName,
    String?   motherName,
    String?   brothers,
    String?   sisters,
    String?   familyType,
    String?   sect,
    String?   religiousness,
    String?   photoPath,
    int?      templateId,
    String?   notes,
    String?   complexion,
    String?   motherTongue,
    String?   salary,
    String?   whatsappNumber,
    String?   institute,
    String?   fatherProfession,
    String?   caste,
    String?   maritalStatus,
    String?   brothersMarried,
    String?   sistersMarried,
    String?   personalNotes,
    String?   educationNotes,
    String?   familyNotes,
    String?   religiousNotes,
    String?   religion,
  }) {
    final b              = Biodata.empty();
    b.id                 = id;
    b.createdAt          = createdAt;
    b.name               = name            ?? this.name;
    b.age                = age             ?? this.age;
    b.height             = height          ?? this.height;
    b.city               = city            ?? this.city;
    b.education          = education       ?? this.education;
    b.profession         = profession      ?? this.profession;
    b.fatherName         = fatherName      ?? this.fatherName;
    b.motherName         = motherName      ?? this.motherName;
    b.brothers           = brothers        ?? this.brothers;
    b.sisters            = sisters         ?? this.sisters;
    b.familyType         = familyType      ?? this.familyType;
    b.sect               = sect            ?? this.sect;
    b.religiousness      = religiousness   ?? this.religiousness;
    b.photoPath          = photoPath       ?? this.photoPath;
    b.templateId         = templateId      ?? this.templateId;
    b.notes              = notes           ?? this.notes;
    b.complexion         = complexion      ?? this.complexion;
    b.motherTongue       = motherTongue    ?? this.motherTongue;
    b.salary             = salary          ?? this.salary;
    b.whatsappNumber     = whatsappNumber  ?? this.whatsappNumber;
    b.institute          = institute       ?? this.institute;
    b.fatherProfession   = fatherProfession ?? this.fatherProfession;
    b.caste              = caste           ?? this.caste;
    b.maritalStatus      = maritalStatus   ?? this.maritalStatus;
    b.brothersMarried    = brothersMarried ?? this.brothersMarried;
    b.sistersMarried     = sistersMarried  ?? this.sistersMarried;
    b.personalNotes      = personalNotes   ?? this.personalNotes;
    b.educationNotes     = educationNotes  ?? this.educationNotes;
    b.familyNotes        = familyNotes     ?? this.familyNotes;
    b.religiousNotes     = religiousNotes  ?? this.religiousNotes;
    b.religion           = religion        ?? this.religion;
    return b;
  }

  bool get isValid => name.trim().isNotEmpty || age.trim().isNotEmpty;
  String get displayName => name.trim().isEmpty ? 'Unnamed Biodata' : name.trim();

  double get completionPercent {
    final fields = [
      name, age, height, city, education, profession,
      fatherName, religion,
    ];
    final filled = fields.where((f) => f.trim().isNotEmpty).length;
    return filled / fields.length;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'age': age,
    'height': height,
    'city': city,
    'education': education,
    'profession': profession,
    'fatherName': fatherName,
    'motherName': motherName,
    'brothers': brothers,
    'sisters': sisters,
    'familyType': familyType,
    'sect': sect,
    'religiousness': religiousness,
    'photoPath': photoPath,
    'templateId': templateId,
    'notes': notes,
    'createdAt': createdAt.toIso8601String(),
    'complexion': complexion,
    'motherTongue': motherTongue,
    'salary': salary,
    'whatsappNumber': whatsappNumber,
    'institute': institute,
    'fatherProfession': fatherProfession,
    'caste': caste,
    'maritalStatus': maritalStatus,
    'brothersMarried': brothersMarried,
    'sistersMarried': sistersMarried,
    'personalNotes': personalNotes,
    'educationNotes': educationNotes,
    'familyNotes': familyNotes,
    'religiousNotes': religiousNotes,
    'religion': religion,
  };

  factory Biodata.fromJson(Map<String, dynamic> json) {
    final b = Biodata.empty();
    b.id               = json['id'] ?? b.id;
    b.name             = json['name'] ?? '';
    b.age              = json['age'] ?? '';
    b.height           = json['height'] ?? '';
    b.city             = json['city'] ?? '';
    b.education        = json['education'] ?? '';
    b.profession       = json['profession'] ?? '';
    b.fatherName       = json['fatherName'] ?? '';
    b.motherName       = json['motherName'] ?? '';
    b.brothers         = json['brothers'] ?? '';
    b.sisters          = json['sisters'] ?? '';
    b.familyType       = json['familyType'] ?? '';
    b.sect             = json['sect'] ?? '';
    b.religiousness    = json['religiousness'] ?? '';
    b.photoPath        = json['photoPath'] ?? '';
    b.templateId       = json['templateId'] ?? 1;
    b.notes            = json['notes'] ?? '';
    b.createdAt        = DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now();
    b.complexion       = json['complexion'] ?? '';
    b.motherTongue     = json['motherTongue'] ?? '';
    b.salary           = json['salary'] ?? '';
    b.whatsappNumber   = json['whatsappNumber'] ?? '';
    b.institute        = json['institute'] ?? '';
    b.fatherProfession = json['fatherProfession'] ?? '';
    b.caste            = json['caste'] ?? '';
    b.maritalStatus    = json['maritalStatus'] ?? '';
    b.brothersMarried  = json['brothersMarried'] ?? '';
    b.sistersMarried   = json['sistersMarried'] ?? '';
    b.personalNotes    = json['personalNotes'] ?? '';
    b.educationNotes   = json['educationNotes'] ?? '';
    b.familyNotes      = json['familyNotes'] ?? '';
    b.religiousNotes   = json['religiousNotes'] ?? '';
    b.religion         = json['religion'] ?? 'Islam';
    return b;
  }
}