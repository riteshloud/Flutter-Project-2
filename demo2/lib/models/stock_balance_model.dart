import 'package:flutter/material.dart';

class StockBalanceModel {
  StockBalanceModel({
    StockBalancePayload? payload,
    bool? success,
    String? message,
    int? code,
  }) {
    _payload = payload;
    _success = success;
    _message = message;
    _code = code;
  }

  StockBalanceModel.fromJson(dynamic json) {
    _payload = json['payload'] != null
        ? StockBalancePayload.fromJson(json['payload'])
        : null;
    _success = json['success'];
    _message = json['message'];
    _code = json['code'];
  }
  StockBalancePayload? _payload;
  bool? _success;
  String? _message;
  int? _code;

  StockBalancePayload? get payload => _payload;
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

class StockBalancePayload {
  StockBalancePayload({
    StockBalanceData? data,
  }) {
    _data = data;
  }

  StockBalancePayload.fromJson(dynamic json) {
    _data =
        json['data'] != null ? StockBalanceData.fromJson(json['data']) : null;
  }
  StockBalanceData? _data;

  StockBalanceData? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    return map;
  }
}

class StockBalanceData {
  StockBalanceData({
    List<TradeLogsObject>? arrTradeRequest,
    List<TradeLogsObject>? arrTradeLogs,
    StockHistoryObject? objStockHistory,
    List<StockRow>? arrRows,
  }) {
    _arrTradeRequest = arrTradeRequest;
    _arrTradeLogs = arrTradeLogs;
    _objStockHistory = objStockHistory;
    _arrRows = arrRows;
  }

  StockBalanceData.fromJson(dynamic json) {
    if (json['pending_trade_log'] != null) {
      _arrTradeRequest = [];
      json['pending_trade_log'].forEach((v) {
        _arrTradeRequest?.add(TradeLogsObject.fromJson(v));
      });
    }

    if (json['trade_log'] != null) {
      _arrTradeLogs = [];
      json['trade_log'].forEach((v) {
        _arrTradeLogs?.add(TradeLogsObject.fromJson(v));
      });
    }

    _objStockHistory = json['stock_history'] != null
        ? StockHistoryObject.fromJson(json['stock_history'])
        : null;

    if (json['rows'] != null) {
      _arrRows = [];
      json['rows'].forEach((v) {
        _arrRows?.add(StockRow.fromJson(v));
      });
    }
  }

  List<TradeLogsObject>? _arrTradeRequest;
  List<TradeLogsObject>? _arrTradeLogs;
  StockHistoryObject? _objStockHistory;
  List<StockRow>? _arrRows;

  List<TradeLogsObject>? get arrTradeRequest => _arrTradeRequest;
  List<TradeLogsObject>? get arrTradeLogs => _arrTradeLogs;
  StockHistoryObject? get objStockHistory => _objStockHistory;
  List<StockRow>? get arrRows => _arrRows;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};

    if (_arrTradeRequest != null) {
      map['pending_trade_log'] =
          _arrTradeRequest?.map((v) => v.toJson()).toList();
    }
    if (_arrTradeLogs != null) {
      map['trade_log'] = _arrTradeLogs?.map((v) => v.toJson()).toList();
    }
    if (_objStockHistory != null) {
      map['stock_history'] = _objStockHistory?.toJson();
    }
    if (_arrRows != null) {
      map['rows'] = _arrRows?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

//********** TRADE LOGS ***********/
class TradeLogsObject {
  TradeLogsObject({
    String? imageUrl,
    int? id,
    int? userId,
    String? campaignId,
    int? projectId,
    String? description,
    String? deletedAt,
    String? createdAt,
    String? updatedAt,
    List<TradeLogProductObject>? arrTradeLogProduct,
    String? username,
    String? systemId,
    int? status,
    int? totalQuantity,
    int? acceptRequest,
  }) {
    _imageUrl = imageUrl;
    _id = id;
    _userId = userId;
    _campaignId = campaignId;
    _projectId = projectId;
    _description = description;
    _deletedAt = deletedAt;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _arrTradeLogProduct = arrTradeLogProduct;
    _username = username;
    _systemId = systemId;
    _status = status;
    _totalQuantity = totalQuantity;
    _acceptRequest = acceptRequest;
  }

  TradeLogsObject.fromJson(dynamic json) {
    _imageUrl = json['imageUrl'];
    _id = json['id'];
    _userId = json['userId'];
    _campaignId = json['campaignId'];
    _projectId = json['projectId'];
    _description = json['description'];
    _deletedAt = json['deletedAt'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];

    if (json['TradeProducts'] != null) {
      _arrTradeLogProduct = [];
      json['TradeProducts'].forEach((v) {
        _arrTradeLogProduct?.add(TradeLogProductObject.fromJson(v));
      });
    }

    _username = json['username'];
    _systemId = json['systemId'];
    _status = json['status'];
    _totalQuantity = json['totalQuantity'];
    _acceptRequest = json['acceptRequest'];
  }

  String? _imageUrl;
  int? _id;
  int? _userId;
  String? _campaignId;
  int? _projectId;
  String? _description;
  String? _deletedAt;
  String? _createdAt;
  String? _updatedAt;
  List<TradeLogProductObject>? _arrTradeLogProduct;
  String? _username;
  String? _systemId;
  int? _status;
  int? _totalQuantity;
  int? _acceptRequest;

  String? get imageUrl => _imageUrl;
  int? get id => _id;
  int? get userId => _userId;
  String? get campaignId => _campaignId;
  int? get projectId => _projectId;
  String? get description => _description;
  String? get deletedAt => _deletedAt;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  List<TradeLogProductObject>? get arrTradeLogProduct => _arrTradeLogProduct;
  String? get username => _username;
  String? get systemId => _systemId;
  int? get status => _status;
  int? get totalQuantity => _totalQuantity;
  int? get acceptRequest => _acceptRequest;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['imageUrl'] = _imageUrl;
    map['id'] = _id;
    map['userId'] = _userId;
    map['campaignId'] = _campaignId;
    map['projectId'] = _projectId;
    map['description'] = _description;
    map['deletedAt'] = _deletedAt;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;

    if (_arrTradeLogProduct != null) {
      map['TradeProducts'] =
          _arrTradeLogProduct?.map((v) => v.toJson()).toList();
    }

    map['username'] = _username;
    map['systemId'] = _systemId;
    map['status'] = _status;
    map['totalQuantity'] = _totalQuantity;
    map['acceptRequest'] = _acceptRequest;

    return map;
  }
}

//********** TRADE LOG PRODUCTS ***********/
class TradeLogProductObject {
  tradeLogsObject({
    int? id,
    int? tradeId,
    int? productId,
    int? quantity,
    int? status,
    String? deletedAt,
    String? createdAt,
    String? updatedAt,
    int? projectId,
    String? productName,
    double? productAmount,
  }) {
    _id = id;
    _tradeId = tradeId;
    _productId = productId;
    _quantity = quantity;
    _status = status;
    _deletedAt = deletedAt;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _projectId = projectId;
    _productName = productName;
    _productAmount = productAmount;
  }

  TradeLogProductObject.fromJson(dynamic json) {
    _id = json['id'];
    _tradeId = json['tradeId'];
    _productId = json['productId'];
    _quantity = json['quantity'];
    _status = json['status'];
    _deletedAt = json['deletedAt'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _projectId = json['projectId'];
    _productName = json['productName'];

    if (json['productAmount'] is int) {
      _productAmount = json['productAmount'].toDouble();
    } else {
      _productAmount = json['productAmount'];
    }
  }

  int? _id;
  int? _tradeId;
  int? _productId;
  int? _quantity;
  int? _status;
  String? _deletedAt;
  String? _createdAt;
  String? _updatedAt;
  int? _projectId;
  String? _productName;
  double? _productAmount;

  int? get id => _id;
  int? get tradeId => _tradeId;
  int? get productId => _productId;
  int? get quantity => _quantity;
  int? get status => _status;
  String? get deletedAt => _deletedAt;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  int? get projectId => _projectId;
  String? get productName => _productName;
  double? get productAmount => _productAmount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['tradeId'] = _tradeId;
    map['productId'] = _productId;
    map['quantity'] = _quantity;
    map['status'] = _status;
    map['deletedAt'] = _deletedAt;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    map['projectId'] = _projectId;
    map['productName'] = _productName;
    map['productAmount'] = _productAmount;

    return map;
  }
}

//********** STOCK HISTORY ***********/
class StockHistoryObject {
  StockHistoryObject({
    int? closeStock,
    int? openStock,
    int? balanceStock,
  }) {
    _closeStock = closeStock;
    _openStock = openStock;
    _balanceStock = balanceStock;
  }

  StockHistoryObject.fromJson(dynamic json) {
    _closeStock = json['closeStock'];
    _openStock = json['openStock'];
    _balanceStock = json['balanceStock'];
  }

  int? _closeStock;
  int? _openStock;
  int? _balanceStock;

  int? get closeStock => _closeStock;
  int? get openStock => _openStock;
  int? get balanceStock => _balanceStock;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['closeStock'] = _closeStock;
    map['openStock'] = _openStock;
    map['balanceStock'] = _balanceStock;

    return map;
  }
}

//********** ROWS DATA ***********/
class StockRow {
  StockRow({
    int? id,
    String? name,
    List<StockRowProduct>? arrProducts,
    List<TextEditingController>? arrControllers,
  }) {
    _id = id;
    _name = name;
    _arrProducts = arrProducts;
    _arrControllers = arrControllers;
  }

  StockRow.fromJson(dynamic json) {
    if (json['id'] != null) {
      _id = json['id'];
    }
    _name = json['name'];
    if (json['Products'] != null) {
      _arrProducts = [];
      json['Products'].forEach((v) {
        _arrProducts?.add(StockRowProduct.fromJson(v));
      });
    }
  }
  int? _id;
  String? _name;
  List<StockRowProduct>? _arrProducts;
  List<TextEditingController>? _arrControllers;

  int? get id => _id;
  String? get name => _name;
  List<StockRowProduct>? get arrProducts => _arrProducts;
  List<TextEditingController>? get arrControllers => _arrControllers;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (map['id'] != null) {
      map['id'] = _id;
    }
    map['name'] = _name;

    if (_arrProducts != null) {
      map['Products'] = _arrProducts?.map((v) => v.toJson()).toList();
    }
    return map;
  }

  set arrControllersData(List<TextEditingController>? value) {
    _arrControllers = value;
  }
}

//********** ROW PRODUCTS DATA ***********/
class StockRowProduct {
  StockRowProduct({
    String? imageUrl,
    int? id,
    String? name,
    int? stockId,
    int? balance,
    int? updatedBalance,
    double? amount,
    bool? isOutlet,
    bool? isdiable,
  }) {
    _imageUrl = imageUrl;
    _id = id;
    _name = name;
    _stockId = stockId;
    _balance = balance;
    _updatedBalance = updatedBalance;
    _amount = amount;
    _isOutlet = isOutlet;
    _isdiable = isdiable;
  }

  StockRowProduct.fromJson(dynamic json) {
    _imageUrl = json['imageUrl'];
    _id = json['id'];
    _name = json['name'];
    _stockId = json['stockId'];
    _balance = json['balance'];
    if (json['amount'] is int) {
      _amount = json['amount'].toDouble();
    } else {
      _amount = json['amount'];
    }
    _isOutlet = false;
    _isdiable = true;
  }
  String? _imageUrl;
  int? _id;
  String? _name;
  int? _stockId;
  int? _balance;
  int? _updatedBalance;
  double? _amount;
  bool? _isOutlet;
  bool? _isdiable;

  String? get imageUrl => _imageUrl;
  int? get id => _id;
  String? get name => _name;
  int? get stockId => _stockId;
  int? get balance => _balance;
  int? get updatedBalance => _updatedBalance;
  double? get amount => _amount;
  bool? get isOutlet => _isOutlet;
  bool? get isdiable => _isdiable;

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

  set balanceData(int? value) {
    _balance = value;
  }

  set updatedBalanceData(int? value) {
    _updatedBalance = value;
  }

  set isOutletData(bool? value) {
    _isOutlet = value;
  }

  set isdisableData(bool? value) {
    _isdiable = value;
  }
}
