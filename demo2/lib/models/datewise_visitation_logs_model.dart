class DatewiseVisitationLogsModel {
  getProjectListModel({
    DatewiseVisitationLogsPayload? payload,
    bool? success,
    String? message,
    int? code,
  }) {
    _payload = payload;
    _success = success;
    _message = message;
    _code = code;
  }

  DatewiseVisitationLogsModel.fromJson(dynamic json) {
    _payload = json['payload'] != null
        ? DatewiseVisitationLogsPayload.fromJson(json['payload'])
        : null;
    _success = json['success'];
    _message = json['message'];
    _code = json['code'];
  }
  DatewiseVisitationLogsPayload? _payload;
  bool? _success;
  String? _message;
  int? _code;

  DatewiseVisitationLogsPayload? get payload => _payload;
  bool? get success => _success;
  String? get message => _message;
  int? get code => _code;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_payload != null) {
      map['payload'] = _payload?.toJson();
    }
    map['success'] = _success;
    map['message'] = _message;
    map['code'] = _code;
    return map;
  }
}

class DatewiseVisitationLogsPayload {
  projectListPayload({
    List<VisitationDateObject>? arrVisitationDates,
  }) {
    _arrVisitationDates = arrVisitationDates;
  }

  DatewiseVisitationLogsPayload.fromJson(dynamic json) {
    if (json['data'] != null) {
      _arrVisitationDates = [];
      json['data'].forEach((v) {
        _arrVisitationDates?.add(VisitationDateObject.fromJson(v));
      });
    }
  }

  List<VisitationDateObject>? _arrVisitationDates;

  List<VisitationDateObject>? get arrVisitationDates => _arrVisitationDates;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_arrVisitationDates != null) {
      map['data'] = _arrVisitationDates?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class VisitationDateObject {
  data({
    String? date,
    List<VisitationLogsObject>? arrVisitationLogs,
  }) {
    _date = date;
    _arrVisitationLogs = arrVisitationLogs;
  }

  VisitationDateObject.fromJson(dynamic json) {
    _date = json['date'];
    if (json['logs'] != null) {
      _arrVisitationLogs = [];
      json['logs'].forEach((v) {
        _arrVisitationLogs?.add(VisitationLogsObject.fromJson(v));
      });
    }
  }
  String? _date;
  List<VisitationLogsObject>? _arrVisitationLogs;

  String? get date => _date;
  List<VisitationLogsObject>? get arrVisitationLogs => _arrVisitationLogs;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['date'] = _date;
    if (_arrVisitationLogs != null) {
      map['logs'] = _arrVisitationLogs?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class VisitationLogsObject {
  VisitationLogsObject({
    int? id,
    int? userId,
    int? projectId,
    int? outletId,
    int? type,
    String? checkIn,
    String? checkOut,
    String? feedbackTitle,
    String? feedbackDescription,
    String? outletName,
    String? address,
    String? outletUrl,
  }) {
    _id = id;
    _userId = userId;
    _projectId = projectId;
    _outletId = outletId;
    _type = type;
    _checkIn = checkIn;
    _checkOut = checkOut;
    _feedbackTitle = feedbackTitle;
    _feedbackDescription = feedbackDescription;
    _outletName = outletName;
    _address = address;
    _outletUrl = outletUrl;
  }

  VisitationLogsObject.fromJson(dynamic json) {
    _id = json['id'];
    _userId = json['userId'];
    _projectId = json['projectId'];
    _outletId = json['outletId'];
    _type = json['type'];
    _checkIn = json['checkIn'];
    _checkOut = json['checkOut'];

    _feedbackTitle = json['feedbackTitle'];
    _feedbackDescription = json['feedbackDescription'];
    _outletName = json['outletName'];
    _address = json['address'];
    _outletUrl = json['outletUrl'];
  }
  int? _id;
  int? _userId;
  int? _projectId;
  int? _outletId;
  int? _type;
  String? _checkIn;
  String? _checkOut;
  String? _feedbackTitle;
  String? _feedbackDescription;
  String? _outletName;
  String? _address;
  String? _outletUrl;

  int? get id => _id;
  int? get userId => _userId;
  int? get projectId => _projectId;
  int? get outletId => _outletId;
  int? get type => _type;
  String? get checkIn => _checkIn;
  String? get checkOut => _checkOut;
  String? get feedbackTitle => _feedbackTitle;
  String? get feedbackDescription => _feedbackDescription;
  String? get outletName => _outletName;
  String? get address => _address;
  String? get outletUrl => _outletUrl;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['userId'] = _userId;
    map['projectId'] = _projectId;
    map['outletId'] = _outletId;
    map['type'] = _type;
    map['checkIn'] = _checkIn;
    map['checkOut'] = _checkOut;
    map['feedbackTitle'] = _feedbackTitle;
    map['feedbackDescription'] = _feedbackDescription;
    map['outletName'] = _outletName;
    map['address'] = _address;
    map['outletUrl'] = _outletUrl;

    return map;
  }
}
