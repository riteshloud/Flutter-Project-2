class OutletDetailModel {
  OutletDetailModel({
    OutletDetailPayload? payload,
    bool? success,
    String? message,
    int? code,
  }) {
    _payload = payload;
    _success = success;
    _message = message;
    _code = code;
  }

  OutletDetailModel.fromJson(dynamic json) {
    _payload = json['payload'] != null
        ? OutletDetailPayload.fromJson(json['payload'])
        : null;
    _success = json['success'];
    _message = json['message'];
    _code = json['code'];
  }
  OutletDetailPayload? _payload;
  bool? _success;
  String? _message;
  int? _code;

  OutletDetailPayload? get payload => _payload;
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

  set payloadData(OutletDetailPayload? value) {
    _payload = value;
  }
}

class OutletDetailPayload {
  OutletDetailPayload({
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

  OutletDetailPayload.fromJson(dynamic json) {
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

  set totalSoldData(int? value) {
    _totalSold = value;
  }

  set effectiveCountData(int? value) {
    _effectiveCount = value;
  }

  set startTimeData(String? value) {
    _startTime = value;
  }

  set endTimeData(String? value) {
    _endTime = value;
  }

  set arrEffectiveDataSet(List<EffectiveNonEffectiveDataObject>? value) {
    _arrEffectiveData = value;
  }

  set arrNonEffectiveDataSet(List<EffectiveNonEffectiveDataObject>? value) {
    _arrNonEffectiveData = value;
  }

  set checkInStatusData(String? value) {
    _checkInStatus = value;
  }

  set visitationIdData(int? value) {
    _visitationId = value;
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
    String? effectivecontact,
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
    _effectivecontact = effectivecontact;
    _deletedAt = deletedAt;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _isNextDay = isNextDay;
    _orderTotalAmount = orderTotalAmount;
    _arrProducts = arrProducts;
  }

  EffectiveNonEffectiveDataObject.fromJson(dynamic json) {
    if (json['brands_variant'] != null) {
      _arrBrandsVariant = [];
      json['brands_variant'].forEach((v) {
        _arrBrandsVariant?.add(v);
      });
    }

    _id = json['id'];
    _projectId = json['projectId'];
    _outletId = json['outletId'];
    _visitationId = json['visitationId'];
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
    _effectivecontact = json['effectivecontact'];

    _deletedAt = json['deletedAt'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];

    if (_createdAt != null) {
      DateTime startDate = DateTime.parse(_createdAt ?? "").toLocal();
      DateTime dtEnd = startDate.add(const Duration(days: 1));
      // startDate = startDate.add(const Duration(days: 2));

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
        _arrProducts?.add(ProductDataObject.fromJson(v));
      });
    }
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
  String? _effectivecontact;
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
  String? get effectivecontact => _effectivecontact;
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
    map['effectivecontact'] = _effectivecontact;
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
    int? outletId,
    int? projectId,
    int? visitationId,
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
  }) {
    _id = id;
    _outletId = outletId;
    _projectId = projectId;
    _visitationId = visitationId;
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
  }

  ProductDataObject.fromJson(dynamic json) {
    _id = json['id'];

    if (json['outletId'] != null) {
      _outletId = json['outletId'];
    }

    if (json['projectId'] != null) {
      _projectId = json['projectId'];
    }

    if (json['visitationId'] != null) {
      _visitationId = json['visitationId'];
    }

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
  }

  int? _id;
  int? _outletId;
  int? _projectId;
  int? _visitationId;
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

  int? get id => _id;
  int? get outletId => _outletId;
  int? get projectId => _projectId;
  int? get visitationId => _visitationId;
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

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    if (_outletId != null) {
      map['outletId'] = _outletId;
    }
    if (_projectId != null) {
      map['projectId'] = _projectId;
    }
    if (_visitationId != null) {
      map['visitationId'] = _visitationId;
    }
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

    return map;
  }
}
