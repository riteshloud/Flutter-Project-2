import 'dart:convert';

import 'package:demo2/database/db_helper.dart';
import 'package:demo2/helpers/strings.dart';
import 'package:demo2/models/get_project_list_model.dart';
import 'package:demo2/models/user_model.dart';

class OfflineDataModel {
  OfflineDataModel({
    OfflineDataPayload? payload,
    bool? success,
    String? message,
    int? code,
  }) {
    _payload = payload;
    _success = success;
    _message = message;
    _code = code;
  }

  OfflineDataModel.fromJson(dynamic json) {
    _payload = json['payload'] != null
        ? OfflineDataPayload.fromJson(json['payload'])
        : null;
    _success = json['success'];
    _message = json['message'];
    _code = json['code'];
  }
  OfflineDataPayload? _payload;
  bool? _success;
  String? _message;
  int? _code;

  OfflineDataPayload? get payload => _payload;
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

class OfflineDataPayload {
  OfflineDataPayload({
    int? count,
    List<ProjectObject>? arrProjects,
  }) {
    _count = count;
    _arrProjects = arrProjects;
  }

  OfflineDataPayload.fromJson(dynamic json) {
    _count = json['count'];
    if (json['rows'] != null) {
      _arrProjects = [];
      json['rows'].forEach((v) {
        arrProjects?.add(ProjectObject.fromJson(v));
      });
    }
  }
  int? _count;
  List<ProjectObject>? _arrProjects;

  int? get count => _count;
  List<ProjectObject>? get arrProjects => _arrProjects;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['count'] = _count;
    if (_arrProjects != null) {
      map['rows'] = _arrProjects?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

//********** PROJECT OBJECT ***********/
class ProjectObject {
  ProjectObject({
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
    List<Users>? arrUsers,
    List<OutletObject>? arrOutlets,
    List<ProjectProductObject>? arrProjectProducts,
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
    _arrUsers = arrUsers;
    _arrOutlets = arrOutlets;
    _arrProjectProducts = arrProjectProducts;
  }

  ProjectObject.fromJson(dynamic json) {
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
    if (json['Users'] != null) {
      _arrUsers = [];
      json['Users'].forEach((v) {
        _arrUsers?.add(Users.fromJson(v));
      });
    }

    if (json['Outlets'] != null) {
      _arrOutlets = [];
      json['Outlets'].forEach((v) {
        _arrOutlets?.add(OutletObject.fromJson(v, (_id ?? 0)));
      });
    }

    if (json['Product_stock'] != null) {
      _arrProjectProducts = [];
      json['Product_stock'].forEach((v) {
        _arrProjectProducts?.add(ProjectProductObject.fromJson(v, (_id ?? 0)));
      });
    }

    //ADD PROJECTS DATA INTO DB
    DBHelper.insert(Strings.tableProjects, {
      DBHelper.id: _id,
      DBHelper.title: _title,
      DBHelper.campaignId: _campaignId,
      DBHelper.description: _description,
      DBHelper.categoryId: _categoryId,
      DBHelper.status: _status,
      DBHelper.isCompleted: _isCompleted,
      DBHelper.startDate: _startDate,
      DBHelper.endDate: _endDate,
      DBHelper.createdAt: _createdAt,
      DBHelper.updatedAt: _updatedAt,
      DBHelper.categoryName: _categoryName,
      DBHelper.totalUsersCount: _totalUsersCount,
      DBHelper.totalSales: _totalSales,
      DBHelper.totalQuantity: _totalQuantity,
      DBHelper.totalAmount: _totalAmount,
      DBHelper.totalOutlet: _totalOutlet,
      DBHelper.users: jsonEncode(json['Users']),
    });
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
  List<Users>? _arrUsers;
  List<OutletObject>? _arrOutlets;
  List<ProjectProductObject>? _arrProjectProducts;

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
  List<Users>? get arrUsers => _arrUsers;
  List<OutletObject>? get arrOutlets => _arrOutlets;
  List<ProjectProductObject>? get arrProjectProducts => _arrProjectProducts;

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

    if (_arrOutlets != null) {
      map['Outlets'] = _arrOutlets?.map((v) => v.toJson()).toList();
    }

    if (_arrProjectProducts != null) {
      map['Product_stock'] =
          _arrProjectProducts?.map((v) => v.toJson()).toList();
    }

    map['total_outlet'] = _totalOutlet;
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

//********** PROJECT OUTLET ***********/
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
    OutletDetailObject? objOutletDetail,
    List<ExecutionPhoto>? arrExecutionPhoto,
    int? isOffline,
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
    _objOutletDetail = objOutletDetail;
    _arrExecutionPhoto = arrExecutionPhoto;
    _isOffline = isOffline;
  }

  OutletObject.fromJson(dynamic json, int projectID) {
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
    _projectId = json['projectId'];
    _checkInStatus = json['checkInStatus'];
    _visitationId = json['visitationId'];
    _day = json['day'];

    if (json['is_offline'] != null) {
      _isOffline = json['is_offline'];
    }

    _objOutletDetail = json['detail'] != null
        ? OutletDetailObject.fromJson(json['detail'], (_id ?? 0), projectID)
        : null;

    if (json['execution_url'] != null) {
      _arrExecutionPhoto = [];
      json['execution_url'].forEach((v) {
        _arrExecutionPhoto?.add(ExecutionPhoto.fromJson(v));

        //ADD PROJECT OUTLETS EXECUTION PHOTOS DATA INTO DB
        DBHelper.insert(Strings.tableOutletExecutionPhotos, {
          DBHelper.outletId: _id,
          DBHelper.projectId: projectID,
          DBHelper.visitationId: _visitationId,
          DBHelper.imageUrl: v['url'],
          DBHelper.isDeleted: 0,
          DBHelper.isOffline: 0,
        });
      });
    }

    //ADD PROJECT OUTLETS DATA INTO DB
    DBHelper.insert(Strings.tableProjectOutlets, {
      DBHelper.id: _id,
      DBHelper.outletUrl: _outletUrl,
      DBHelper.address: _address,
      DBHelper.outletName: _outletName,
      DBHelper.outletEmail: _outletEmail,
      DBHelper.outletContact: _outletContact,
      DBHelper.ownerName: _ownerName,
      DBHelper.ownerEmail: _ownerEmail,
      DBHelper.ownerContact: _ownerContact,
      DBHelper.personName: _personName,
      DBHelper.personEmail: _personEmail,
      DBHelper.personContact: _personContact,
      DBHelper.status: _status,
      DBHelper.createdAt: _createdAt,
      DBHelper.updatedAt: _updatedAt,
      DBHelper.projectId: _projectId,
      DBHelper.checkInStatus: _checkInStatus,
      DBHelper.visitationId: _visitationId,
      DBHelper.day: _day,
      DBHelper.isOffline: 0,
    });
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
  OutletDetailObject? _objOutletDetail;
  List<ExecutionPhoto>? _arrExecutionPhoto;
  int? _isOffline;

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
  OutletDetailObject? get objOutletDetail => _objOutletDetail;
  List<ExecutionPhoto>? get arrExecutionPhoto => _arrExecutionPhoto;
  int? get isOffline => _isOffline;

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
    map['projectId'] = _projectId;
    map['checkInStatus'] = _checkInStatus;
    map['visitationId'] = visitationId;
    map['day'] = day;

    if (_objOutletDetail != null) {
      map['detail'] = _objOutletDetail?.toJson();
    }

    if (_arrExecutionPhoto != null) {
      map['execution_url'] =
          _arrExecutionPhoto?.map((v) => v.toJson()).toList();
    }

    if (_isOffline != null) {
      map['is_offline'] = _isOffline;
    }

    return map;
  }

  set checkInStatuss(String? value) {
    _checkInStatus = value;
  }

  set visitationIdd(int? value) {
    _visitationId = value;
  }
}

//********** PROJECT OUTLET DETAIL ***********/
class OutletDetailObject {
  OutletDetailObject({
    int? totalSold,
    int? effectiveCount,
    String? startTime,
    String? endTime,
    List<EffectiveNonEffectiveDataObject>? arrEffectiveData,
    List<EffectiveNonEffectiveDataObject>? arrNonEffectiveData,
    int? visitationId,
    String? checkInStatus,
  }) {
    _totalSold = totalSold;
    _effectiveCount = effectiveCount;
    _startTime = startTime;
    _endTime = endTime;
    _arrEffectiveData = arrEffectiveData;
    _arrNonEffectiveData = arrNonEffectiveData;
    _visitationId = visitationId;
    _checkInStatus = checkInStatus;
  }

  OutletDetailObject.fromJson(dynamic json, int outletID, int projectID) {
    _totalSold = json['totalSold'];
    _effectiveCount = json['effectiveCount'];
    _startTime = json['startTime'];
    _endTime = json['endTime'];

    if (json['effectiveData'] != null) {
      _arrEffectiveData = [];
      json['effectiveData'].forEach((v) {
        _arrEffectiveData?.add(EffectiveNonEffectiveDataObject.fromJson(v));
      });
    }

    if (json['non_effectiveData'] != null) {
      _arrNonEffectiveData = [];
      json['non_effectiveData'].forEach((v) {
        _arrNonEffectiveData?.add(EffectiveNonEffectiveDataObject.fromJson(v));
      });
    }

    _visitationId = json['visitationId'];
    _checkInStatus = json['checkInStatus'];

    //ADD PROJECT OUTLETS DATA INTO DB
    DBHelper.insert(Strings.tableProjectOutletDetail, {
      DBHelper.outletId: outletID,
      DBHelper.projectId: projectID,
      DBHelper.totalSold: _totalSold,
      DBHelper.effectiveCount: _effectiveCount,
      DBHelper.visitationId: _visitationId,
      DBHelper.checkInStatus: _checkInStatus,
      DBHelper.isOffline: 0,
      DBHelper.createdAt:
          (DateTime.now().toUtc().toString().replaceAll(' ', 'T')),
      DBHelper.updatedAt:
          (DateTime.now().toUtc().toString().replaceAll(' ', 'T')),
    });
  }

  int? _totalSold;
  int? _effectiveCount;
  String? _startTime;
  String? _endTime;
  List<EffectiveNonEffectiveDataObject>? _arrEffectiveData;
  List<EffectiveNonEffectiveDataObject>? _arrNonEffectiveData;
  int? _visitationId;
  String? _checkInStatus;

  int? get totalSold => _totalSold;
  int? get effectiveCount => _effectiveCount;
  String? get startTime => _startTime;
  String? get endTime => _endTime;
  List<EffectiveNonEffectiveDataObject>? get arrEffectiveData =>
      _arrEffectiveData;
  List<EffectiveNonEffectiveDataObject>? get arrNonEffectiveData =>
      _arrNonEffectiveData;
  int? get visitationId => _visitationId;
  String? get checkInStatus => _checkInStatus;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};

    map['totalSold'] = _totalSold;
    map['effectiveCount'] = _effectiveCount;
    map['startTime'] = _startTime;
    map['endTime'] = _endTime;

    if (_arrEffectiveData != null) {
      map['effectiveData'] = _arrEffectiveData?.map((v) => v.toJson()).toList();
    }
    if (_arrNonEffectiveData != null) {
      map['non_effectiveData'] =
          _arrNonEffectiveData?.map((v) => v.toJson()).toList();
    }

    map['visitationId'] = _visitationId;
    map['checkInStatus'] = _checkInStatus;
    return map;
  }
}

//********** OUTLET EFFECTIVE / NON EFFECTIVE DATA ***********/
class EffectiveNonEffectiveDataObject {
  EffectiveNonEffectiveDataObject({
    List<String>? arrBrandsVariant,
    int? id,
    int? projectId,
    int? outletId,
    int? visitationId,
    int? userId,
    int? status,
    int? isEffective,
    int? isFree,
    int? isVerified,
    String? description,
    String? gender,
    String? ageGroup,
    String? groupSegment,
    String? effectiveName,
    String? effectiveEmail,
    String? effectiveContact,
    String? deletedAt,
    String? createdAt,
    String? updatedAt,
    bool? isNextDay,
    double? orderTotalAmount,
    List<ProductDataObject>? arrProducts,
  }) {
    _arrBrandsVariant = arrBrandsVariant;
    _id = id;
    _projectId = projectId;
    _outletId = outletId;
    _visitationId = visitationId;
    _userId = userId;
    _status = status;
    _isEffective = isEffective;
    _isFree = isFree;
    _isVerified = isVerified;
    _description = description;
    _gender = gender;
    _ageGroup = ageGroup;
    _groupSegment = groupSegment;
    _effectiveName = effectiveName;
    _effectiveEmail = effectiveEmail;
    _effectiveContact = effectiveContact;
    _deletedAt = deletedAt;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _isNextDay = isNextDay;
    _orderTotalAmount = orderTotalAmount;
    _arrProducts = arrProducts;
  }

  EffectiveNonEffectiveDataObject.fromJson(dynamic json) {
    _id = json['id'];
    _projectId = json['projectId'];
    _outletId = json['outletId'];

    if (json['brands_variant'] != null) {
      _arrBrandsVariant = [];
      json['brands_variant'].forEach((v) {
        _arrBrandsVariant?.add(v);
      });
    }

    _visitationId = json['visitationId'];

    //ADD OUTLET CONTACT BRAND & VARIANT DATA INTO DB
    if (_arrBrandsVariant != null && _arrBrandsVariant!.isNotEmpty) {
      DBHelper.insert(Strings.tableOutletContactSalesBrandsVariant, {
        DBHelper.id: _id,
        DBHelper.outletId: _outletId,
        DBHelper.projectId: _projectId,
        DBHelper.visitationId: _visitationId,
        DBHelper.brandVariant: _arrBrandsVariant?.join(', '),
        DBHelper.isOffline: 0,
      });
    }

    _userId = json['userId'];

    _status = json['status'];
    _isEffective = json['isEffective'];
    _isFree = json['isFree'];
    _isVerified = json['isVerified'];
    _description = json['description'];
    _gender = json['gender'];
    _ageGroup = json['ageGroup'];

    _groupSegment = json['groupSegment'];
    _effectiveName = json['effectiveName'];
    _effectiveEmail = json['effectiveEmail'];
    _effectiveContact = json['effectivecontact'];

    _deletedAt = json['deletedAt'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];

    if (_createdAt != null) {
      DateTime startDate = DateTime.parse(_createdAt ?? "").toLocal();
      DateTime dtEnd = startDate.add(const Duration(days: 1));

      DateTime endDate =
          DateTime(dtEnd.year, dtEnd.month, dtEnd.day, 06, 00, 00, 00, 00);

      bool? isSame = endDate.isBefore(startDate);
      _isNextDay = isSame;
    }

    if (json['orderTotalAmount'] is int) {
      _orderTotalAmount = json['orderTotalAmount'].toDouble();
    } else {
      _orderTotalAmount = json['orderTotalAmount'];
    }

    if (json['OrderDetails'] != null) {
      _arrProducts = [];
      json['OrderDetails'].forEach((v) {
        _arrProducts?.add(ProductDataObject.fromJson(v, (_projectId ?? 0),
            (_outletId ?? 0), (_visitationId ?? 0), (_isEffective ?? 0)));
      });
    }

    //ADD PROJECT OUTLETS DATA INTO DB
    DBHelper.insert(Strings.tableOutletContacts, {
      DBHelper.id: _id,
      DBHelper.outletId: _outletId,
      DBHelper.projectId: _projectId,
      DBHelper.visitationId: _visitationId,
      DBHelper.userId: _userId,
      DBHelper.status: _status,
      DBHelper.isEffective: _isEffective,
      DBHelper.isFree: _isFree,
      DBHelper.isVerified: _isVerified,
      DBHelper.description: _description,
      DBHelper.gender: _gender,
      DBHelper.ageGroup: _ageGroup,
      DBHelper.groupSegment: _groupSegment,
      DBHelper.effectiveName: _effectiveName,
      DBHelper.effectiveEmail: _effectiveEmail,
      DBHelper.effectiveContact: _effectiveContact,
      DBHelper.createdAt: _createdAt,
      DBHelper.updatedAt: _updatedAt,
      DBHelper.orderTotalAmount: _orderTotalAmount,
      DBHelper.isOffline: 0,
    });
  }

  List<String>? _arrBrandsVariant;
  int? _id;
  int? _projectId;
  int? _outletId;
  int? _visitationId;
  int? _userId;
  int? _status;
  int? _isEffective;
  int? _isFree;
  int? _isVerified;
  String? _description;
  String? _gender;
  String? _ageGroup;
  String? _groupSegment;
  String? _effectiveName;
  String? _effectiveEmail;
  String? _effectiveContact;
  String? _deletedAt;
  String? _createdAt;
  String? _updatedAt;
  bool? _isNextDay;
  double? _orderTotalAmount;
  List<ProductDataObject>? _arrProducts;

  List<String>? get arrBrandsVariant => _arrBrandsVariant;
  int? get id => _id;
  int? get projectId => _projectId;
  int? get outletId => _outletId;
  int? get visitationId => _visitationId;
  int? get userId => _userId;
  int? get status => _status;
  int? get isEffective => _isEffective;
  int? get isFree => _isFree;
  int? get isVerified => _isVerified;
  String? get description => _description;
  String? get gender => _gender;
  String? get ageGroup => _ageGroup;
  String? get groupSegment => _groupSegment;
  String? get effectiveName => _effectiveName;
  String? get effectiveEmail => _effectiveEmail;
  String? get effectiveContact => _effectiveContact;
  String? get deletedAt => _deletedAt;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  bool? get isNextDay => _isNextDay;
  double? get orderTotalAmount => _orderTotalAmount;
  List<ProductDataObject>? get arrProducts => _arrProducts;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_arrBrandsVariant != null) {
      map['brands_variant'] = _arrBrandsVariant?.map((v) => v).toList();
    }

    map['id'] = _id;
    map['projectId'] = _projectId;
    map['outletId'] = _outletId;
    map['visitationId'] = _visitationId;
    map['userId'] = _userId;
    map['status'] = _status;
    map['isEffective'] = _isEffective;
    map['isFree'] = _isFree;
    map['isVerified'] = _isVerified;
    map['description'] = _description;
    map['gender'] = _gender;
    map['ageGroup'] = _ageGroup;
    map['groupSegment'] = _groupSegment;
    map['effectiveName'] = _effectiveName;
    map['effectiveEmail'] = _effectiveEmail;
    map['effectivecontact'] = _effectiveContact;
    map['deletedAt'] = _deletedAt;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    map['orderTotalAmount'] = _orderTotalAmount;
    if (_arrProducts != null) {
      map['OrderDetails'] = _arrProducts?.map((v) => v.toJson()).toList();
    }

    return map;
  }
}

//********** OUTLET EFFECTIVE / NON EFFECTIVE PRODUCTS DATA ***********/
class ProductDataObject {
  ProductDataObject({
    int? id,
    int? orderId,
    int? productId,
    double? amount,
    int? quantity,
    double? totalAmount,
    int? isOutletStock,
    String? deletedAt,
    String? createdAt,
    String? updatedAt,
    String? productName,
    int? isEffective,
    int? outletId,
    int? projectId,
    int? visitationId,
  }) {
    _id = id;
    _orderId = orderId;
    _productId = productId;
    _amount = amount;
    _quantity = quantity;
    _totalAmount = totalAmount;
    _isOutletStock = isOutletStock;
    _deletedAt = deletedAt;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _productName = productName;
    _isEffective = isEffective;
    _outletId = outletId;
    _projectId = projectId;
    _visitationId = visitationId;
  }

  ProductDataObject.fromJson(dynamic json, int projectID, int outletID,
      int visitationID, int isEffective) {
    _id = json['id'];
    _orderId = json['orderId'];
    _productId = json['productId'];
    if (json['amount'] is int) {
      _amount = json['amount'].toDouble();
    } else {
      _amount = json['amount'];
    }
    _quantity = json['quantity'];
    if (json['totalAmount'] is int) {
      _totalAmount = json['totalAmount'].toDouble();
    } else {
      _totalAmount = json['totalAmount'];
    }
    _isOutletStock = json['isOutletStock'];
    _deletedAt = json['deletedAt'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _productName = json['productName'];

    if (json['isEffective'] != null) {
      _isEffective = json['isEffective'];
    }

    if (json['outletId'] != null) {
      _outletId = json['outletId'];
    }
    if (json['projectId'] != null) {
      _projectId = json['projectId'];
    }
    if (json['visitationId'] != null) {
      _visitationId = json['visitationId'];
    }

    //ADD PROJECT OUTLETS DATA INTO DB
    DBHelper.insert(Strings.tableOutletContactSales, {
      DBHelper.id: _id,
      DBHelper.outletId: outletID,
      DBHelper.projectId: projectID,
      DBHelper.visitationId: visitationID,
      DBHelper.orderId: _orderId,
      DBHelper.productId: _productId,
      DBHelper.isEffective: isEffective,
      DBHelper.amount: _amount,
      DBHelper.quantity: _quantity,
      DBHelper.totalAmount: _totalAmount,
      DBHelper.isOutletStock: _isOutletStock,
      DBHelper.createdAt: _createdAt,
      DBHelper.updatedAt: _updatedAt,
      DBHelper.productName: _productName,
      DBHelper.isOffline: 0,
    });
  }

  int? _id;
  int? _orderId;
  int? _productId;
  double? _amount;
  int? _quantity;
  double? _totalAmount;
  int? _isOutletStock;
  String? _deletedAt;
  String? _createdAt;
  String? _updatedAt;
  String? _productName;
  int? _isEffective;
  int? _outletId;
  int? _projectId;
  int? _visitationId;

  int? get id => _id;
  int? get orderId => _orderId;
  int? get productId => _productId;
  double? get amount => _amount;
  int? get quantity => _quantity;
  double? get totalAmount => _totalAmount;
  int? get isOutletStock => _isOutletStock;
  String? get deletedAt => _deletedAt;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  String? get productName => _productName;
  int? get isEffective => _isEffective;
  int? get outletId => _outletId;
  int? get projectId => _projectId;
  int? get visitationId => _visitationId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['orderId'] = _orderId;
    map['productId'] = _productId;
    map['amount'] = _amount;
    map['quantity'] = _quantity;
    map['totalAmount'] = _totalAmount;
    map['isOutletStock'] = _isOutletStock;
    map['deletedAt'] = _deletedAt;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    map['productName'] = _productName;

    if (_isEffective != null) {
      map['isEffective'] = _isEffective;
    }
    if (_outletId != null) {
      map['outletId'] = _outletId;
    }
    if (_projectId != null) {
      map['projectId'] = _projectId;
    }
    if (_visitationId != null) {
      map['visitationId'] = _visitationId;
    }
    return map;
  }
}

//********** PROJECT PRODUCTS DATA ***********/
class ProjectProductObject {
  ProjectProductObject({
    String? title,
    String? imageUrl,
    int? id,
    String? name,
    int? stockId,
    int? balance,
    int? updatedBalance,
    double? amount,
    bool? isOutlet,
  }) {
    _title = title;
    _imageUrl = imageUrl;
    _id = id;
    _name = name;
    _stockId = stockId;
    _balance = balance;
    _updatedBalance = updatedBalance;
    _amount = amount;
    _isOutlet = isOutlet;
  }

  ProjectProductObject.fromJson(dynamic json, int projectID) {
    var title = json["name"];
    var products = json["Products"];

    _title = title;

    for (int i = 0; i < products.length; i++) {
      var dictProduct = products[i];

      _imageUrl = dictProduct['imageUrl'];
      _id = dictProduct['id'];
      _name = dictProduct['name'];
      _stockId = dictProduct['stockId'];
      _balance = dictProduct['balance'];
      if (dictProduct['amount'] is int) {
        _amount = dictProduct['amount'].toDouble();
      } else {
        _amount = dictProduct['amount'];
      }
      _isOutlet = false;

      //ADD PROJECT OUTLETS DATA INTO DB
      DBHelper.insert(Strings.tableProducts, {
        DBHelper.id: _id,
        DBHelper.title: _title,
        DBHelper.imageUrl: _imageUrl,
        DBHelper.name: _name,
        DBHelper.amount: _amount,
        DBHelper.stockId: _stockId,
        DBHelper.balance: _balance,
        DBHelper.projectId: projectID,
        DBHelper.isOutlet: (_isOutlet == true) ? 1 : 0,
      });
    }
  }
  String? _title;
  String? _imageUrl;
  int? _id;
  String? _name;
  int? _stockId;
  int? _balance;
  int? _updatedBalance;
  double? _amount;
  bool? _isOutlet;

  String? get title => _title;
  String? get imageUrl => _imageUrl;
  int? get id => _id;
  String? get name => _name;
  int? get stockId => _stockId;
  int? get balance => _balance;
  int? get updatedBalance => _updatedBalance;
  double? get amount => _amount;
  bool? get isOutlet => _isOutlet;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['imageUrl'] = _imageUrl;
    map['id'] = _id;
    map['name'] = _name;
    map['stockId'] = _stockId;
    map['balance'] = _balance;
    map['amount'] = _amount;

    return map;
  }

  set titlee(String? value) {
    _title = value;
  }

  set balancee(int? value) {
    _balance = value;
  }

  set updatedBalancee(int? value) {
    _updatedBalance = value;
  }

  set isOutlett(bool? value) {
    _isOutlet = value;
  }
}
