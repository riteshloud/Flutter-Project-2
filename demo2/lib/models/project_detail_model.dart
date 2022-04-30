import 'get_project_list_model.dart';

class ProjectDetailModel {
  ProjectDetailModel({
    ProjectDetailPayload? payload,
    bool? success,
    String? message,
    int? code,
  }) {
    _payload = payload;
    _success = success;
    _message = message;
    _code = code;
  }

  ProjectDetailModel.fromJson(dynamic json) {
    _payload = json['payload'] != null
        ? ProjectDetailPayload.fromJson(json['payload'])
        : null;
    _success = json['success'];
    _message = json['message'];
    _code = json['code'];
  }
  ProjectDetailPayload? _payload;
  bool? _success;
  String? _message;
  int? _code;

  ProjectDetailPayload? get payload => _payload;
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

class ProjectDetailPayload {
  ProjectDetailPayload({
    List<Rows>? data,
  }) {
    _data = data;
  }

  ProjectDetailPayload.fromJson(dynamic json) {
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Rows.fromJson(v));
      });
    }
  }
  List<Rows>? _data;
  List<Rows>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
