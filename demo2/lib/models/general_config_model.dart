class GeneralConfigModel {
  GeneralConfigModel({
    List<GenderObject>? arrGender,
    List<AgeGroupObject>? arrAgeGroup,
    List<GroupSegmentObject>? arrGroupSegment,
    List<BrandVariantMainObject>? arrBrandVarient,
    List<PDPAObject>? arrPDPA,
  }) {
    _arrGender = arrGender;
    _arrAgeGroup = arrAgeGroup;
    _arrGroupSegment = arrGroupSegment;
    _arrBrandVarient = arrBrandVarient;
    _arrPDPA = arrPDPA;
  }

  GeneralConfigModel.fromJson(dynamic json) {
    if (json['gender'] != null) {
      _arrGender = [];
      json['gender'].forEach((v) {
        _arrGender?.add(GenderObject(value: v, isSelected: false));
      });
    }

    if (json['ageGroup'] != null) {
      _arrAgeGroup = [];
      json['ageGroup'].forEach((v) {
        _arrAgeGroup?.add(AgeGroupObject(value: v, isSelected: false));
      });
    }

    if (json['groupSegment'] != null) {
      _arrGroupSegment = [];
      json['groupSegment'].forEach((v) {
        _arrGroupSegment?.add(GroupSegmentObject(value: v, isSelected: false));
      });
    }

    if (json['brands_variant'] != null) {
      _arrBrandVarient = [];
      json['brands_variant'].forEach((v) {
        _arrBrandVarient?.add(BrandVariantMainObject.fromJson(v));
      });
    }

    if (json['PDPA'] != null) {
      _arrPDPA = [];
      json['PDPA'].forEach((v) {
        _arrPDPA?.add(PDPAObject.fromJson(v));
      });
    }
  }
  List<GenderObject>? _arrGender;
  List<AgeGroupObject>? _arrAgeGroup;
  List<GroupSegmentObject>? _arrGroupSegment;
  List<BrandVariantMainObject>? _arrBrandVarient;
  List<PDPAObject>? _arrPDPA;

  List<GenderObject>? get arrGender => _arrGender;
  List<AgeGroupObject>? get arrAgeGroup => _arrAgeGroup;
  List<GroupSegmentObject>? get arrGroupSegment => _arrGroupSegment;
  List<BrandVariantMainObject>? get arrBrandVarient => _arrBrandVarient;
  List<PDPAObject>? get arrPDPA => _arrPDPA;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_arrGender != null) {
      map['gender'] = _arrGender?.map((v) => v).toList();
    }
    if (_arrAgeGroup != null) {
      map['ageGroup'] = _arrAgeGroup?.map((v) => v).toList();
    }
    if (_arrGroupSegment != null) {
      map['groupSegment'] = _arrGroupSegment?.map((v) => v).toList();
    }
    if (_arrBrandVarient != null) {
      map['brands_variant'] = _arrBrandVarient?.map((v) => v).toList();
    }
    if (_arrPDPA != null) {
      map['PDPA'] = _arrPDPA?.map((v) => v).toList();
    }

    return map;
  }
}

//********** GENDER OBJECT ***********/
class GenderObject {
  String value;
  bool isSelected;

  GenderObject({
    required this.value,
    required this.isSelected,
  });
}

//********** AGE GROUP OBJECT ***********/
class AgeGroupObject {
  String value;
  bool isSelected;

  AgeGroupObject({
    required this.value,
    required this.isSelected,
  });
}

//********** GROUP SEGMENT OBJECT ***********/
class GroupSegmentObject {
  String value;
  bool isSelected;

  GroupSegmentObject({
    required this.value,
    required this.isSelected,
  });
}

//********** BRAND VARIANT OBJECT ***********/
class BrandVarientObject {
  String value;
  bool isSelected;

  BrandVarientObject({
    required this.value,
    required this.isSelected,
  });
}

class BrandVariantMainObject {
  BrandVariantMainObject({
    int? id,
    String? brands,
    List<BrandVarientObject>? arrBrandVariants,
  }) {
    _id = id;
    _brands = brands;
    _arrBrandVariants = arrBrandVariants;
  }

  BrandVariantMainObject.fromJson(dynamic json) {
    _id = json['id'];
    _brands = json['brands'];
    if (json['variants'] != null) {
      _arrBrandVariants = [];
      json['variants'].forEach((v) {
        _arrBrandVariants?.add(BrandVarientObject(value: v, isSelected: false));
      });
    }
  }
  int? _id;
  String? _brands;
  List<BrandVarientObject>? _arrBrandVariants;

  int? get id => _id;
  String? get brands => _brands;
  List<BrandVarientObject>? get arrBrandVariants => _arrBrandVariants;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['brands'] = _brands;
    if (_arrBrandVariants != null) {
      map['variants'] = _arrBrandVariants?.map((v) => v).toList();
    }
    return map;
  }
}

//PDPA OBJECT
class PDPAObject {
  PDPAObject({
    int? id,
    String? type,
    String? title,
    String? description,
    String? radioText,
    String? confirmText,
  }) {
    _id = id;
    _type = type;
    _title = title;
    _description = description;
    _radioText = radioText;
    _confirmText = confirmText;
  }

  PDPAObject.fromJson(dynamic json) {
    _id = json['id'];
    _type = json['type'];
    _title = json['title'];
    _description = json['description'];
    _radioText = json['radio_text'];
    _confirmText = json['confirm_text'];
  }

  int? _id;
  String? _type;
  String? _title;
  String? _description;
  String? _radioText;
  String? _confirmText;

  int? get id => _id;
  String? get type => _type;
  String? get title => _title;
  String? get description => _description;
  String? get radioText => _radioText;
  String? get confirmText => _confirmText;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['type'] = _type;
    map['title'] = _title;
    map['description'] = _description;
    map['radio_text'] = _radioText;
    map['confirm_text'] = _confirmText;
    return map;
  }
}
