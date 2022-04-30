class CoverageModel {
  CoverageModel({
    List<CoverageDaysObject>? arrCoverageDays,
    bool? success,
    String? message,
    int? code,
  }) {
    _arrCoverageDays = arrCoverageDays;
    _success = success;
    _message = message;
    _code = code;
  }

  CoverageModel.fromJson(dynamic json) {
    if (json['payload'] != null) {
      _arrCoverageDays = [];
      json['payload'].forEach((v) {
        _arrCoverageDays?.add(CoverageDaysObject.fromJson(v));
      });
    }
    _success = json['success'];
    _message = json['message'];
    _code = json['code'];
  }
  List<CoverageDaysObject>? _arrCoverageDays;
  bool? _success;
  String? _message;
  int? _code;

  List<CoverageDaysObject>? get arrCoverageDays => _arrCoverageDays;
  bool? get success => _success;
  String? get message => _message;
  int? get code => _code;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_arrCoverageDays != null) {
      map['payload'] = _arrCoverageDays?.map((v) => v.toJson()).toList();
    }
    map['success'] = _success;
    map['message'] = _message;
    map['code'] = _code;
    return map;
  }
}

class CoverageDaysObject {
  CoverageDaysObject({
    String? day,
    String? date,
    List<OutletObject>? arrCoverageOutlets,
  }) {
    _day = day;
    _date = date;
    _arrCoverageOutlets = arrCoverageOutlets;
  }

  CoverageDaysObject.fromJson(dynamic json) {
    _day = json['day'];
    _date = json['date'];
    if (json['Outlets'] != null) {
      _arrCoverageOutlets = [];
      json['Outlets'].forEach((v) {
        _arrCoverageOutlets?.add(OutletObject.fromJson(v));
      });
    }
  }

  String? _day;
  String? _date;
  List<OutletObject>? _arrCoverageOutlets;

  String? get day => _day;
  String? get date => _date;
  List<OutletObject>? get arrCoverageOutlets => _arrCoverageOutlets;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['day'] = _day;
    map['date'] = _date;
    if (_arrCoverageOutlets != null) {
      map['Outlets'] = _arrCoverageOutlets?.map((v) => v.toJson()).toList();
    }

    return map;
  }
}

//********** COVERAGE OUTLET ***********/
class OutletObject {
  OutletObject({
    String? outletUrl,
    int? id,
    String? outletName,
    String? outletEmail,
    String? outletContact,
    String? address,
    String? ownerName,
    String? ownerEmail,
    String? ownerContact,
    String? personName,
    String? personEmail,
    String? personContact,
    int? status,
    String? feedback,
    String? deletedAt,
    String? createdAt,
    String? updatedAt,
    int? projectId,
    String? checkInStatus,
    int? visitationId,
    String? day,
  }) {
    _outletUrl = outletUrl;
    _id = id;
    _outletName = outletName;
    _outletEmail = outletEmail;
    _outletContact = outletContact;
    _address = address;
    _ownerName = ownerName;
    _ownerEmail = ownerEmail;
    _ownerContact = ownerContact;
    _personName = personName;
    _personEmail = personEmail;
    _personContact = personContact;
    _status = status;
    _feedback = feedback;
    _deletedAt = deletedAt;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _projectId = projectId;
    _checkInStatus = checkInStatus;
    _visitationId = visitationId;
    _day = day;
  }

  OutletObject.fromJson(dynamic json) {
    _outletUrl = json['outletUrl'];
    _id = json['id'];
    _outletName = json['outletName'];
    _outletEmail = json['outletEmail'];
    _outletContact = json['outletContact'];
    _address = json['address'];
    _ownerName = json['ownerName'];
    _ownerEmail = json['ownerEmail'];
    _ownerContact = json['ownerContact'];
    _personName = json['personName'];
    _personEmail = json['personEmail'];
    _personContact = json['personContact'];
    _status = json['status'];
    _feedback = json['feedback'];
    _deletedAt = json['deletedAt'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];

    if (json['projectId'] != null) {
      _projectId = json['projectId'];
    }
    _checkInStatus = json['checkInStatus'];
    _visitationId = json['visitationId'];
    _day = json['day'];
  }

  String? _outletUrl;
  int? _id;
  String? _outletName;
  String? _outletEmail;
  String? _outletContact;
  String? _address;
  String? _ownerName;
  String? _ownerEmail;
  String? _ownerContact;
  String? _personName;
  String? _personEmail;
  String? _personContact;
  int? _status;
  String? _feedback;
  String? _deletedAt;
  String? _createdAt;
  String? _updatedAt;
  int? _projectId;
  String? _checkInStatus;
  int? _visitationId;
  String? _day;

  String? get outletUrl => _outletUrl;
  int? get id => _id;
  String? get outletName => _outletName;
  String? get outletEmail => _outletEmail;
  String? get outletContact => _outletContact;
  String? get address => _address;
  String? get ownerName => _ownerName;
  String? get ownerEmail => _ownerEmail;
  String? get ownerContact => _ownerContact;
  String? get personName => _personName;
  String? get personEmail => _personEmail;
  String? get personContact => _personContact;
  int? get status => _status;
  String? get feedback => _feedback;
  String? get deletedAt => _deletedAt;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  int? get projectId => _projectId;
  String? get checkInStatus => _checkInStatus;
  int? get visitationId => _visitationId;
  String? get day => _day;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['outletUrl'] = _outletUrl;
    map['id'] = _id;
    map['outletName'] = _outletName;
    map['outletEmail'] = _outletEmail;
    map['outletContact'] = _outletContact;
    map['address'] = _address;
    map['ownerName'] = _ownerName;
    map['ownerEmail'] = _ownerEmail;
    map['ownerContact'] = _ownerContact;
    map['personName'] = _personName;
    map['personEmail'] = _personEmail;
    map['personContact'] = _personContact;
    map['status'] = _status;
    map['feedback'] = _feedback;
    map['deletedAt'] = _deletedAt;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;

    if (_projectId != null) {
      map['projectId'] = _projectId;
    }
    map['checkInStatus'] = _checkInStatus;
    map['visitationId'] = visitationId;
    map['day'] = day;

    return map;
  }

  set checkInStatuss(String? value) {
    _checkInStatus = value;
  }

  set visitationIds(int? value) {
    _visitationId = value;
  }
}

//********** OUTLET LOCATION OBJECT ***********/
class OutletLocationObject {
  String outletName;
  String outletEmail;
  String outletContact;
  String outletAddress;
  String outletPostalCode;
  String outletCity;
  String outletState;

  OutletLocationObject({
    required this.outletName,
    required this.outletEmail,
    required this.outletContact,
    required this.outletAddress,
    required this.outletPostalCode,
    required this.outletCity,
    required this.outletState,
  });
}
