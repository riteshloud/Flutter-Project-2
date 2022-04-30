class UserModel {
  UserModel({
    int? id,
    String? systemId,
    String? email,
    String? username,
    String? contactNumber,
    String? profilePicture,
    dynamic qrCode,
    String? resetToken,
    String? lastLogin,
    int? isVerified,
    int? status,
    int? role,
    String? deletedAt,
    String? createdAt,
    String? updatedAt,
    int? acceptRequest,
    String? token,
    String? deviceType,
    String? deviceToken,
    List<LoginHistory>? arrLoginHistory,
    List<Notifications>? arrNotifications,
    List<QRCode>? arrQRCode,
    int? projectsCount,
  }) {
    _id = id;
    _systemId = systemId;
    _email = email;
    _username = username;
    _contactNumber = contactNumber;
    _profilePicture = profilePicture;
    _qrCode = qrCode;
    _resetToken = resetToken;
    _lastLogin = lastLogin;
    _isVerified = isVerified;
    _status = status;
    _role = role;
    _deletedAt = deletedAt;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _acceptRequest = acceptRequest;
    _token = token;
    _deviceType = deviceType;
    _deviceToken = deviceToken;
    _arrLoginHistory = arrLoginHistory;
    _arrNotifications = arrNotifications;
    _arrQRCode = arrQRCode;
    _projectsCount = projectsCount;
  }

  UserModel.fromJson(dynamic json) {
    _id = json['id'];
    _systemId = json['systemId'];
    _email = json['email'];
    _username = json['username'];
    _contactNumber = json['contact_number'];
    _profilePicture = json['profile_picture'];
    _qrCode = json['qr_code'];
    _resetToken = json['resetToken'];
    _lastLogin = json['last_login'];
    _isVerified = json['is_verified'];
    _status = json['status'];
    _role = json['role'];
    _deletedAt = json['deletedAt'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _acceptRequest = json['acceptRequest'];
    _token = json['token'];
    _deviceType = json['device_type'];
    _deviceToken = json['device_token'];
    if (json['LoginHistories'] != null) {
      _arrLoginHistory = [];
      json['LoginHistories'].forEach((v) {
        _arrLoginHistory?.add(LoginHistory.fromJson(v));
      });
    }
    if (json['Notifications'] != null) {
      _arrNotifications = [];
      json['Notifications'].forEach((v) {
        _arrNotifications?.add(Notifications.fromJson(v));
      });
    }
    if (json['qr_code'] != null) {
      _arrQRCode = [];
      json['qr_code'].forEach((v) {
        _arrQRCode?.add(QRCode.fromJson(v));
      });
    }
    if (json['projectsCount'] != null) {
      _projectsCount = json['projectsCount'];
    }
  }
  int? _id;
  String? _systemId;
  String? _email;
  String? _username;
  String? _contactNumber;
  String? _profilePicture;
  dynamic _qrCode;
  String? _resetToken;
  String? _lastLogin;
  int? _isVerified;
  int? _status;
  int? _role;
  String? _deletedAt;
  String? _createdAt;
  String? _updatedAt;
  int? _acceptRequest;
  String? _token;
  String? _deviceType;
  String? _deviceToken;
  List<LoginHistory>? _arrLoginHistory;
  List<Notifications>? _arrNotifications;
  List<QRCode>? _arrQRCode;
  int? _projectsCount;

  int? get id => _id;
  String? get systemId => _systemId;
  String? get email => _email;
  String? get username => _username;
  String? get contactNumber => _contactNumber;
  String? get profilePicture => _profilePicture;
  dynamic get qrCode => _qrCode;
  String? get resetToken => _resetToken;
  String? get lastLogin => _lastLogin;
  int? get isVerified => _isVerified;
  int? get status => _status;
  int? get role => _role;
  String? get deletedAt => _deletedAt;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  int? get acceptRequest => _acceptRequest;
  String? get token => _token;
  String? get deviceType => _deviceType;
  String? get deviceToken => _deviceToken;
  List<LoginHistory>? get arrLoginHistory => _arrLoginHistory;
  List<Notifications>? get arrNotifications => _arrNotifications;
  List<QRCode>? get arrQRCode => _arrQRCode;
  int? get projectsCount => _projectsCount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['systemId'] = _systemId;
    map['email'] = _email;
    map['username'] = _username;
    map['contact_number'] = _contactNumber;
    map['profile_picture'] = _profilePicture;
    map['qr_code'] = _qrCode;
    map['resetToken'] = _resetToken;
    map['last_login'] = _lastLogin;
    map['is_verified'] = _isVerified;
    map['status'] = _status;
    map['role'] = _role;
    map['deletedAt'] = _deletedAt;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    map['acceptRequest'] = _acceptRequest;
    map['token'] = _token;
    map['device_type'] = _deviceType;
    map['device_token'] = _deviceToken;
    if (_arrLoginHistory != null) {
      map['LoginHistories'] = _arrLoginHistory?.map((v) => v.toJson()).toList();
    }
    if (_arrNotifications != null) {
      map['Notifications'] = _arrNotifications?.map((v) => v.toJson()).toList();
    }
    if (_arrQRCode != null) {
      map['qr_code'] = arrQRCode?.map((v) => v.toJson()).toList();
    }
    if (_projectsCount != null) {
      map['projectsCount'] = _projectsCount;
    }

    return map;
  }
}

class LoginHistory {
  LoginHistory({
    String? type,
    String? createdAt,
  }) {
    _type = type;
    _createdAt = createdAt;
  }

  LoginHistory.fromJson(dynamic json) {
    _type = json['type'];
    _createdAt = json['createdAt'];
  }
  String? _type;
  String? _createdAt;

  String? get type => _type;
  String? get createdAt => _createdAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['type'] = _type;
    map['createdAt'] = _createdAt;
    return map;
  }
}

class Notifications {
  Notifications({
    String? title,
    String? data,
    String? createdAt,
  }) {
    _title = title;
    _data = data;
    _createdAt = createdAt;
  }

  Notifications.fromJson(dynamic json) {
    _title = json['title'];
    if (json['data'] != null) {
      _data = json['data'];
    }
    _createdAt = json['createdAt'];
  }
  String? _title;
  String? _data;
  String? _createdAt;

  String? get title => _title;
  String? get data => _data;
  String? get createdAt => _createdAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title'] = _title;
    if (map['data'] != null) {
      map['data'] = _data;
    }
    map['createdAt'] = _createdAt;
    return map;
  }
}

class QRCode {
  QRCode({
    String? url,
  }) {
    _url = url;
  }

  QRCode.fromJson(dynamic json) {
    _url = json["url"];
  }
  String? _url;

  String? get url => _url;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map["url"] = _url;

    return map;
  }
}

class ExecutionPhoto {
  ExecutionPhoto({
    int? id,
    String? url,
    int? isDeleted,
    int? isOffline,
    int? outletId,
    int? projectId,
    int? visitationId,
    List<String>? arrImages,
  }) {
    _id = id;
    _url = url;
    _isDeleted = isDeleted;
    _isOffline = isOffline;
    _outletId = outletId;
    _projectId = projectId;
    _visitationId = visitationId;
    _arrImages = arrImages;
  }

  ExecutionPhoto.fromJson(dynamic json) {
    if (json["id"] != null) {
      _id = json["id"];
    }

    _url = json["url"];

    if (json["is_deleted"] != null) {
      _isDeleted = json["is_deleted"];
    }

    if (json["is_offline"] != null) {
      _isOffline = json["is_offline"];
    }

    if (json["outletId"] != null) {
      _outletId = json["outletId"];
    }

    if (json["projectId"] != null) {
      _projectId = json["projectId"];
    }

    if (json["visitationId"] != null) {
      _visitationId = json["visitationId"];
    }
  }
  int? _id;
  String? _url;
  int? _isDeleted;
  int? _isOffline;
  int? _outletId;
  int? _projectId;
  int? _visitationId;
  List<String>? _arrImages;

  int? get id => _id;
  String? get url => _url;
  int? get isDeleted => _isDeleted;
  int? get isOffline => _isOffline;
  int? get outletId => _outletId;
  int? get projectId => _projectId;
  int? get visitationId => _visitationId;
  List<String>? get arrImages => _arrImages;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_id != null) {
      map["id"] = _id;
    }
    map["url"] = _url;

    if (_isDeleted != null) {
      map["is_deleted"] = _isDeleted;
    }
    if (_isOffline != null) {
      map["is_offline"] = _isOffline;
    }
    if (_outletId != null) {
      map["outletId"] = _outletId;
    }
    if (_projectId != null) {
      map["projectId"] = _projectId;
    }
    if (_visitationId != null) {
      map["visitationId"] = _visitationId;
    }
    return map;
  }

  set arrImagesData(List<String>? value) {
    _arrImages = value;
  }
}
