import '../models/user_model.dart';

class LoginResponseModel {
  LoginResponseModel({
    UserModel? payload,
    bool? success,
    String? message,
    int? code,
  }) {
    _payload = payload;
    _success = success;
    _message = message;
    _code = code;
  }

  LoginResponseModel.fromJson(dynamic json) {
    _payload =
        json['payload'] != null ? UserModel.fromJson(json['payload']) : null;
    _success = json['success'];
    _message = json['message'];
    _code = json['code'];
  }
  UserModel? _payload;
  bool? _success;
  String? _message;
  int? _code;

  UserModel? get payload => _payload;
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
