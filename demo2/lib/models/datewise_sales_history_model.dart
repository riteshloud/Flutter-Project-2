class DatewiseSalesHistoryModel {
  DatewiseSalesHistoryModel({
    DatewiseSalesHistoryPayload? payload,
    bool? success,
    String? message,
    int? code,
  }) {
    _payload = payload;
    _success = success;
    _message = message;
    _code = code;
  }

  DatewiseSalesHistoryModel.fromJson(dynamic json) {
    _payload = json['payload'] != null
        ? DatewiseSalesHistoryPayload.fromJson(json['payload'])
        : null;
    _success = json['success'];
    _message = json['message'];
    _code = json['code'];
  }
  DatewiseSalesHistoryPayload? _payload;
  bool? _success;
  String? _message;
  int? _code;

  DatewiseSalesHistoryPayload? get payload => _payload;
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

class DatewiseSalesHistoryPayload {
  projectListPayload({
    List<SalesHistoryDateObject>? arrSalesHistoryDates,
  }) {
    _arrSalesHistoryDates = arrSalesHistoryDates;
  }

  DatewiseSalesHistoryPayload.fromJson(dynamic json) {
    if (json['rows'] != null) {
      _arrSalesHistoryDates = [];
      json['rows'].forEach((v) {
        _arrSalesHistoryDates?.add(SalesHistoryDateObject.fromJson(v));
      });
    }
  }

  List<SalesHistoryDateObject>? _arrSalesHistoryDates;

  List<SalesHistoryDateObject>? get arrSalesHistoryDates =>
      _arrSalesHistoryDates;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_arrSalesHistoryDates != null) {
      map['rows'] = _arrSalesHistoryDates?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class SalesHistoryDateObject {
  data({
    String? date,
    SalesLogObject? objSalesHistoryLog,
  }) {
    _date = date;
    _objSalesHistoryLog = objSalesHistoryLog;
  }

  SalesHistoryDateObject.fromJson(dynamic json) {
    _date = json['date'];
    _objSalesHistoryLog = SalesLogObject.fromJson(json['logs']);

    // if (json['logs'] != null) {
    //   _arrSalesHistoryLogs = [];
    //   json['logs'].forEach((v) {
    //     _arrSalesHistoryLogs?.add(SalesHistoryObject.fromJson(v));
    //   });
    // }
  }
  String? _date;
  SalesLogObject? _objSalesHistoryLog;

  String? get date => _date;
  SalesLogObject? get objSalesHistoryLog => _objSalesHistoryLog;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['date'] = _date;
    map['logs'] = _objSalesHistoryLog;
    // if (_arrSalesHistory != null) {
    //   map['logs'] = _arrSalesHistory?.map((v) => v.toJson()).toList();
    // }
    return map;
  }
}

class SalesLogObject {
  SalesLogObject({
    int? smokerContactFc,
    int? smokerContactSob,
    int? effectveContactFc,
    int? effectiveContactSob,
    int? otpContact,
    int? withoutOtp,
    List<SalesHistoryObject>? arrSales,
    int? totalSales,
  }) {
    _smokerContactFc = smokerContactFc;
    _smokerContactSob = smokerContactSob;
    _effectveContactFc = effectveContactFc;
    _effectiveContactSob = effectiveContactSob;
    _otpContact = otpContact;
    _withoutOtp = withoutOtp;
    _arrSales = arrSales;
    _totalSales = totalSales;
  }

  SalesLogObject.fromJson(dynamic json) {
    _smokerContactFc = json['smokerContactFc'];
    _smokerContactSob = json['smokerContactSob'];
    _effectveContactFc = json['effectveContactFc'];
    _effectiveContactSob = json['effectiveContactSob'];
    _otpContact = json['otpContact'];
    _withoutOtp = json['withoutOtp'];

    if (json['data'] != null) {
      _arrSales = [];
      json['data'].forEach((v) {
        _arrSales?.add(SalesHistoryObject.fromJson(v));
      });
    }
    _totalSales = json['totalSales'];
  }

  int? _smokerContactFc;
  int? _smokerContactSob;
  int? _effectveContactFc;
  int? _effectiveContactSob;
  int? _otpContact;
  int? _withoutOtp;
  List<SalesHistoryObject>? _arrSales;
  int? _totalSales;

  int? get smokerContactFc => _smokerContactFc;
  int? get smokerContactSob => _smokerContactSob;
  int? get effectveContactFc => _effectveContactFc;
  int? get effectiveContactSob => _effectiveContactSob;
  int? get otpContact => _otpContact;
  int? get withoutOtp => _withoutOtp;
  List<SalesHistoryObject>? get arrSales => _arrSales;
  int? get totalSales => _totalSales;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['smokerContactFc'] = _smokerContactFc;
    map['smokerContactSob'] = _smokerContactSob;
    map['effectveContactFc'] = _effectveContactFc;
    map['effectiveContactSob'] = _effectiveContactSob;
    map['otpContact'] = _otpContact;
    map['withoutOtp'] = _withoutOtp;
    map['data'] = _arrSales;
    map['totalSales'] = _totalSales;

    return map;
  }
}

class SalesHistoryObject {
  SalesHistoryObject({
    String? productName,
    int? quantity,
  }) {
    _productName = productName;
    _quantity = quantity;
  }

  SalesHistoryObject.fromJson(dynamic json) {
    _productName = json['productName'];
    _quantity = json['quantity'];
  }
  String? _productName;
  int? _quantity;

  String? get productName => _productName;
  int? get quantity => _quantity;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['productName'] = _productName;
    map['quantity'] = _quantity;

    return map;
  }
}
