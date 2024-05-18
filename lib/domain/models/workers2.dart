/// id : 7
/// document : "1075 1"
/// firstName : "William"
/// lastName : "Bohorquez"
/// email : "a@gmail.com"
/// user : null
/// modality : null
/// workSchedule : {"id":3,"name":"Noche"}

class Workers2 {
  Workers2({
      num? id, 
      String? document, 
      String? firstName, 
      String? lastName, 
      String? email, 
      dynamic user, 
      dynamic modality, 
      WorkSchedule? workSchedule,}){
    _id = id;
    _document = document;
    _firstName = firstName;
    _lastName = lastName;
    _email = email;
    _user = user;
    _modality = modality;
    _workSchedule = workSchedule;
}

  Workers2.fromJson(dynamic json) {
    _id = json['id'];
    _document = json['document'];
    _firstName = json['firstName'];
    _lastName = json['lastName'];
    _email = json['email'];
    _user = json['user'];
    _modality = json['modality'];
    _workSchedule = json['workSchedule'] != null ? WorkSchedule.fromJson(json['workSchedule']) : null;
  }
  num? _id;
  String? _document;
  String? _firstName;
  String? _lastName;
  String? _email;
  dynamic _user;
  dynamic _modality;
  WorkSchedule? _workSchedule;
Workers2 copyWith({  num? id,
  String? document,
  String? firstName,
  String? lastName,
  String? email,
  dynamic user,
  dynamic modality,
  WorkSchedule? workSchedule,
}) => Workers2(  id: id ?? _id,
  document: document ?? _document,
  firstName: firstName ?? _firstName,
  lastName: lastName ?? _lastName,
  email: email ?? _email,
  user: user ?? _user,
  modality: modality ?? _modality,
  workSchedule: workSchedule ?? _workSchedule,
);
  num? get id => _id;
  String? get document => _document;
  String? get firstName => _firstName;
  String? get lastName => _lastName;
  String? get email => _email;
  dynamic get user => _user;
  dynamic get modality => _modality;
  WorkSchedule? get workSchedule => _workSchedule;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['document'] = _document;
    map['firstName'] = _firstName;
    map['lastName'] = _lastName;
    map['email'] = _email;
    map['user'] = _user;
    map['modality'] = _modality;
    if (_workSchedule != null) {
      map['workSchedule'] = _workSchedule?.toJson();
    }
    return map;
  }

}

/// id : 3
/// name : "Noche"

class WorkSchedule {
  WorkSchedule({
      num? id, 
      String? name,}){
    _id = id;
    _name = name;
}

  WorkSchedule.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
  }
  num? _id;
  String? _name;
WorkSchedule copyWith({  num? id,
  String? name,
}) => WorkSchedule(  id: id ?? _id,
  name: name ?? _name,
);
  num? get id => _id;
  String? get name => _name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    return map;
  }

}