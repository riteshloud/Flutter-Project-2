import 'package:flutter/foundation.dart';
import 'package:demo2/database/db_helper.dart';
import 'package:demo2/models/datewise_sales_history_model.dart';

class GetProjectListModel {
  GetProjectListModel({
    ProjectListPayload? payload,
    bool? success,
    String? message,
    int? code,
  }) {
    _payload = payload;
    _success = success;
    _message = message;
    _code = code;
  }

  GetProjectListModel.fromJson(dynamic json) {
    _payload = json['payload'] != null
        ? ProjectListPayload.fromJson(json['payload'])
        : null;
    _success = json['success'];
    _message = json['message'];
    _code = json['code'];
  }
  ProjectListPayload? _payload;
  bool? _success;
  String? _message;
  int? _code;

  ProjectListPayload? get payload => _payload;
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

class ProjectListPayload {
  ProjectListPayload({
    Data? data,
  }) {
    _data = data;
  }

  ProjectListPayload.fromJson(dynamic json) {
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  Data? _data;

  Data? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    return map;
  }
}

class Data {
  Data({
    int? count,
    List<Rows>? rows,
    int? notificationCount,
  }) {
    _count = count;
    _rows = rows;
    _notificationCount = notificationCount;
  }

  Data.fromJson(dynamic json) {
    _count = json['count'];
    if (json['rows'] != null) {
      _rows = [];
      json['rows'].forEach((v) {
        _rows?.add(Rows.fromJson(v));
      });
    }
    _notificationCount = json['notificationCount'];
  }
  int? _count;
  List<Rows>? _rows;
  int? _notificationCount;

  int? get count => _count;
  List<Rows>? get rows => _rows;
  int? get notificationCount => _notificationCount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['count'] = _count;
    if (_rows != null) {
      map['rows'] = _rows?.map((v) => v.toJson()).toList();
    }
    map['notificationCount'] = _notificationCount;
    return map;
  }
}

class Rows {
  Rows({
    int? id,
    String? title,
    String? campaignId,
    String? description,
    int? categoryId,
    int? status,
    int? isCompleted,
    String? startDate,
    String? endDate,
    dynamic deletedAt,
    String? createdAt,
    String? updatedAt,
    String? categoryName,
    int? totalUsersCount,
    int? totalSales,
    int? totalQuantity,
    double? totalAmount,
    int? totalOutlet,
    int? visitCount,
    List<Users>? arrUsers,
    SalesLogObject? objSales,
    List<VisitationHistory>? arrVisitationHistory,
  }) {
    _id = id;
    _title = title;
    _campaignId = campaignId;
    _description = description;
    _categoryId = categoryId;
    _status = status;
    _isCompleted = isCompleted;
    _startDate = startDate;
    _endDate = endDate;
    _deletedAt = deletedAt;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _categoryName = categoryName;
    _totalUsersCount = totalUsersCount;
    _totalSales = totalSales;
    _totalQuantity = totalQuantity;
    _totalAmount = totalAmount;
    _totalOutlet = totalOutlet;
    _visitCount = visitCount;
    _arrUsers = arrUsers;
    _objSales = objSales;
    _arrVisitationHistory = arrVisitationHistory;
  }

  Rows.fromJson(dynamic json) {
    _id = json['id'];
    _title = json['title'];
    _campaignId = json['campaignId'];
    _description = json['description'];
    _categoryId = json['category_id'];
    _status = json['status'];
    _isCompleted = json['isCompleted'];
    _startDate = json['start_date'];
    _endDate = json['end_date'];
    _deletedAt = json['deletedAt'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    if (json['category_name'] != null) {
      _categoryName = json['category_name'];
    } else {
      _categoryName = "";
    }

    _totalUsersCount = json['totalUsersCount'];
    _totalSales = json['total_sales'];
    _totalQuantity = json['total_quantity'];

    if (json['totalAmount'] is int) {
      _totalAmount = json['totalAmount'].toDouble();
    } else {
      _totalAmount = json['totalAmount'];
    }

    _totalOutlet = json['total_outlet'];
    _visitCount = json['visitCount'];
    if (json['Users'] != null) {
      _arrUsers = [];
      json['Users'].forEach((v) {
        _arrUsers?.add(Users.fromJson(v));
      });
    }

    if (json['Sales'] != null) {
      _objSales = SalesLogObject.fromJson(json['Sales']);
    }

    if (json['Visits'] != null) {
      _arrVisitationHistory = [];
      json['Visits'].forEach((v) {
        _arrVisitationHistory?.add(VisitationHistory.fromJson(v));
      });
    }
  }
  int? _id;
  String? _title;
  String? _campaignId;
  String? _description;
  int? _categoryId;
  int? _status;
  int? _isCompleted;
  String? _startDate;
  String? _endDate;
  dynamic _deletedAt;
  String? _createdAt;
  String? _updatedAt;
  String? _categoryName;
  int? _totalUsersCount;
  int? _totalSales;
  int? _totalQuantity;
  double? _totalAmount;
  int? _totalOutlet;
  int? _visitCount;
  List<Users>? _arrUsers;
  SalesLogObject? _objSales;
  List<VisitationHistory>? _arrVisitationHistory;

  int? get id => _id;
  String? get title => _title;
  String? get campaignId => _campaignId;
  String? get description => _description;
  int? get categoryId => _categoryId;
  int? get status => _status;
  int? get isCompleted => _isCompleted;
  String? get startDate => _startDate;
  String? get endDate => _endDate;
  dynamic get deletedAt => _deletedAt;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  String? get categoryName => _categoryName;
  int? get totalUsersCount => _totalUsersCount;
  int? get totalSales => _totalSales;
  int? get totalQuantity => _totalQuantity;
  double? get totalAmount => _totalAmount;
  int? get totalOutlet => _totalOutlet;
  int? get visitCount => _visitCount;
  List<Users>? get arrUsers => _arrUsers;
  SalesLogObject? get objSales => _objSales;
  List<VisitationHistory>? get arrVisitationHistory => _arrVisitationHistory;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['title'] = _title;
    map['description'] = _description;
    map['category_id'] = _categoryId;
    map['status'] = _status;
    map['deletedAt'] = _deletedAt;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    if (_categoryName != null) {
      map['category_name'] = _categoryName;
    }
    map['totalUsersCount'] = _totalUsersCount;
    map['total_sales'] = _totalSales;
    map['total_quantity'] = _totalQuantity;
    map['totalAmount'] = _totalAmount;
    if (_arrUsers != null) {
      map['Users'] = _arrUsers?.map((v) => v.toJson()).toList();
    }
    if (map['Sales'] != null) {
      map['Sales'] = _objSales;
    }

    if (_arrVisitationHistory != null) {
      map['Visits'] = _arrVisitationHistory?.map((v) => v.toJson()).toList();
    }

    map['total_outlet'] = _totalOutlet;
    map['visitCount'] = _visitCount;
    return map;
  }

  Map<String, dynamic> toMap(dynamic json) {
    return {
      DBHelper.id: json['id'],
      DBHelper.title: json['title'],
      DBHelper.campaignId: json['campaignId'],
      DBHelper.description: json['description'],
      DBHelper.categoryId: json['category_id'],
      DBHelper.status: json['status'],
      DBHelper.isCompleted: json['isCompleted'],
      DBHelper.startDate: json['start_date'],
      DBHelper.endDate: json['end_date'],
      DBHelper.createdAt: json['createdAt'],
      DBHelper.updatedAt: json['updatedAt'],
      DBHelper.categoryName:
          (json['category_name'] != null) ? json['category_name'] : "",
      DBHelper.totalUsersCount: json['totalUsersCount'],
      DBHelper.totalSales: json['total_sales'],
      DBHelper.totalQuantity: json['total_quantity'],
      DBHelper.totalAmount: (json['totalAmount'] is int)
          ? json['totalAmount'].toDouble()
          : json['totalAmount'],
      DBHelper.totalOutlet: _totalOutlet,
      DBHelper.users: json['Users'].toString(),
    };
  }
}

class Users {
  Users({
    String? username,
    String? email,
    String? profilePicture,
  }) {
    _username = username;
    _email = email;
    _profilePicture = profilePicture;
  }

  Users.fromJson(dynamic json) {
    _username = json['username'];
    _email = json['email'];
    _profilePicture = json['profile_picture'];
  }
  String? _username;
  String? _email;
  String? _profilePicture;

  String? get username => _username;
  String? get email => _email;
  String? get profilePicture => _profilePicture;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['username'] = _username;
    map['email'] = _email;
    map['profile_picture'] = _profilePicture;
    return map;
  }
}

class SalesOrderDetail {
  SalesOrderDetail({
    int? quantity,
    double? totalAmount,
    String? productname,
  }) {
    _quantity = quantity;
    _totalAmount = totalAmount;
    _productname = productname;
  }

  SalesOrderDetail.fromJson(dynamic json) {
    _quantity = json['quantity'];

    if (json['totalAmount'] is int) {
      _totalAmount = json['totalAmount'].toDouble();
    } else {
      _totalAmount = json['totalAmount'];
    }

    if (json["Product"] != null) {
      var objProduct = json["Product"];
      _productname = objProduct["name"];
      if (kDebugMode) {
        print(_productname);
      }
    }
  }
  int? _quantity;
  double? _totalAmount;
  String? _productname;

  int? get quantity => _quantity;
  double? get totalAmount => _totalAmount;
  String? get productname => _productname;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['quantity'] = _quantity;
    map['totalAmount'] = _totalAmount;
    map['name'] = _productname;
    return map;
  }
}

class SalesProduct {
  SalesProduct({
    String? name,
  }) {
    _name = name;
  }

  SalesProduct.fromJson(dynamic json) {
    _name = json['name'];
  }
  String? _name;

  String? get name => _name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = _name;
    return map;
  }
}

class VisitationHistory {
  VisitationHistory({
    int? id,
    int? userId,
    int? projectId,
    int? outletId,
    int? type,
    String? checkIn,
    String? checkOut,
    String? feedbackTitle,
    String? feedbackDescription,
    String? deletedAt,
    String? createdAt,
    String? updatedAt,
    String? outletUrl,
    String? address,
    String? outletName,
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
    _deletedAt = deletedAt;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _outletUrl = outletUrl;
    _address = address;
    _outletName = outletName;
  }

  VisitationHistory.fromJson(dynamic json) {
    _id = json['id'];
    _userId = json['userId'];
    _projectId = json['projectId'];
    _outletId = json['outletId'];
    _type = json['type'];
    _checkIn = json['checkIn'];
    _checkOut = json['checkOut'];
    _feedbackTitle = json['feedbackTitle'];
    _feedbackDescription = json['feedbackDescription'];
    _deletedAt = json['deletedAt'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _outletUrl = json['outletUrl'];
    _address = json['address'];
    _outletName = json['outletName'];
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
  String? _deletedAt;
  String? _createdAt;
  String? _updatedAt;
  String? _outletUrl;
  String? _address;
  String? _outletName;

  int? get id => _id;
  int? get userId => _userId;
  int? get projectId => _projectId;
  int? get outletId => _outletId;
  int? get type => _type;
  String? get checkIn => _checkIn;
  String? get checkOut => _checkOut;
  String? get feedbackTitle => _feedbackTitle;
  String? get feedbackDescription => _feedbackDescription;
  String? get deletedAt => _deletedAt;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  String? get outletUrl => _outletUrl;
  String? get address => _address;
  String? get outletName => _outletName;

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
    map['deletedAt'] = _deletedAt;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    map['outletUrl'] = _outletUrl;
    map['address'] = _address;
    map['outletName'] = _outletName;
    return map;
  }
}
