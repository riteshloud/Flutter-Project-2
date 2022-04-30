import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:demo2/database/db_helper.dart';

import '../../screens/sales/brand_list_screen.dart';
import '../../screens/sales/pdpa_screen.dart';

import '../../helpers/api_constant.dart';
import '../../helpers/colors.dart';
import '../../helpers/constant.dart';
import '../../helpers/singleton.dart';
import '../../helpers/strings.dart';

import '../../models/coverage_model.dart';
import '../../models/general_config_model.dart';
import '../../models/stock_balance_model.dart';
import '../../models/get_project_list_model.dart';
import '../../service/api_service.dart';

import '../../widgets/common_button.dart';

class AddSalesScreen extends StatefulWidget {
  final Rows objSelectedProject;
  final OutletObject objselectedOutlet;

  const AddSalesScreen(
      {Key? key,
      required this.objSelectedProject,
      required this.objselectedOutlet})
      : super(key: key);

  @override
  _AddSalesScreenState createState() => _AddSalesScreenState();
}

class _AddSalesScreenState extends State<AddSalesScreen> {
  bool iscustomerInfoClicked = true;
  bool isEffectiveContactClicked = true;
  bool isengagementClicked = true;
  bool isFemaleClicked = false;
  bool ismaleClicked = true;
  final remarkController = TextEditingController();
  final FocusNode remarkNode = FocusNode();
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final contactController = TextEditingController();
  final FocusNode emailNode = FocusNode();
  final FocusNode contactNode = FocusNode();
  final FocusNode nameNode = FocusNode();

  String gender = "";
  String ageGroup = "";
  String groupSegment = "";
  List<String> brandAndVariant = [];

  bool valueGift = false;
  bool contactVarified = false;

  List<GenderObject> arrGender = [];
  List<AgeGroupObject> arrAgeGroup = [];
  List<GroupSegmentObject> arrGroupSegment = [];
  List<BrandVariantMainObject> arrBrandVarient = [];

  int selectedBrandNumber = 0;
  List<StockRowProduct> arrSelectedProducts = [];
  double productTotalAmount = 0.0;

  @override
  void initState() {
    Singleton.instance.isInternetConnected().then((intenet) {
      if (intenet) {
        getGeneralConfiguration();
      } else {
        getGeneralConfigurationFromDB();
      }
    });
    super.initState();
  }

  bool isSwitched = false;

  void _submitNewSalesRequest() {
    FocusScope.of(context).unfocus();
    if (gender.isEmpty) {
      Singleton.instance.showAlertDialogWithOkAction(
          context, Constant.alert, "Please select gender");
    } else if (ageGroup.isEmpty) {
      Singleton.instance.showAlertDialogWithOkAction(
          context, Constant.alert, "Please select age group");
    } else if (groupSegment.isEmpty) {
      Singleton.instance.showAlertDialogWithOkAction(
          context, Constant.alert, "Please select group segment");
    } else {
      List<Map<String, dynamic>> arrProducts = [];

      for (int j = 0; j < arrSelectedProducts.length; j++) {
        var objProduct = arrSelectedProducts[j];

        Map<String, dynamic> dictProduct = {};

        dictProduct["productId"] = objProduct.id;
        dictProduct["quantity"] = "${objProduct.updatedBalance}";
        dictProduct["amount"] = "${(objProduct.amount ?? 0.0).toPrecision(2)}"
            .replaceAll(Singleton.instance.regex, "");
        dictProduct["isOutletStock"] = (objProduct.isOutlet == true)
            ? "1"
            : "0"; //"${objProduct.isOutlet}";
        arrProducts.add(dictProduct);
      }
      String strProducts = jsonEncode(arrProducts);

      Singleton.instance.isInternetConnected().then((intenet) {
        if (intenet) {
          addSalesAPI(strProducts);
        } else {
          addSalesInDB(strProducts);
        }
      });
    }
  }

  Future<void> addSalesInDB(String products) async {
    int number = Singleton.instance.randomDigits(4);

    bool isEffective = false;

    if (products.trim().isEmpty || products.trim() == "[]") {
      isEffective = false;
    } else {
      isEffective = true;
    }

    //ADD OUTLET CONTACTS DATA INTO DB
    DBHelper.insert(Strings.tableOutletContacts, {
      DBHelper.id: number,
      DBHelper.outletId: widget.objselectedOutlet.id,
      DBHelper.projectId: widget.objSelectedProject.id,
      DBHelper.visitationId: widget.objselectedOutlet.visitationId,
      DBHelper.userId: Singleton.instance.objLoginUser.id,
      DBHelper.status: 1,
      DBHelper.isEffective: isEffective ? 1 : 0,
      DBHelper.isFree: valueGift ? 1 : 0,
      DBHelper.isVerified: 0,
      DBHelper.description: remarkController.text,
      DBHelper.gender: gender,
      DBHelper.ageGroup: ageGroup,
      DBHelper.groupSegment: groupSegment,
      DBHelper.effectiveName: nameController.text,
      DBHelper.effectiveEmail: emailController.text,
      DBHelper.effectiveContact: contactController.text,
      DBHelper.createdAt:
          (DateTime.now().toUtc().toString().replaceAll(' ', 'T')),
      DBHelper.updatedAt:
          (DateTime.now().toUtc().toString().replaceAll(' ', 'T')),
      DBHelper.orderTotalAmount: productTotalAmount,
      DBHelper.isOffline: 1,
    });

    //ADD OUTLET CONTACT PRODUCTS DATA INTO DB
    if (arrSelectedProducts.isNotEmpty) {
      for (int i = 0; i < arrSelectedProducts.length; i++) {
        StockRowProduct objProduct = arrSelectedProducts[i];

        int number1 = Singleton.instance.randomDigits(4);

        DBHelper.insert(Strings.tableOutletContactSales, {
          DBHelper.id: number1,
          DBHelper.outletId: widget.objselectedOutlet.id,
          DBHelper.projectId: widget.objSelectedProject.id,
          DBHelper.visitationId: widget.objselectedOutlet.visitationId,
          DBHelper.orderId: number,
          DBHelper.productId: objProduct.id,
          DBHelper.amount: objProduct.amount,
          DBHelper.quantity: objProduct.updatedBalance,
          DBHelper.totalAmount: ((objProduct.updatedBalance!).toDouble() *
              (objProduct.amount ?? 1)),
          DBHelper.isOutletStock: (objProduct.isOutlet == true) ? 1 : 0,
          DBHelper.createdAt:
              (DateTime.now().toUtc().toString().replaceAll(' ', 'T')),
          DBHelper.updatedAt:
              (DateTime.now().toUtc().toString().replaceAll(' ', 'T')),
          DBHelper.productName: objProduct.name,
          DBHelper.isOffline: 1,
        });
      }
    }

    //ADD OUTLET CONTACT BRANDS & VARIANTS DATA INTO DB
    if (brandAndVariant.isNotEmpty) {
      DBHelper.insert(Strings.tableOutletContactSalesBrandsVariant, {
        DBHelper.id: number,
        DBHelper.outletId: widget.objselectedOutlet.id,
        DBHelper.projectId: widget.objSelectedProject.id,
        DBHelper.brandVariant: brandAndVariant.join(', '),
        DBHelper.visitationId: widget.objselectedOutlet.visitationId,
        DBHelper.isOffline: 1,
      });
    }

    var isWantToUpdate = await Singleton.instance
        .showAlertDialogWithGoPreviousOptions(context, Constant.appName,
            "Sales order placed successfully!", "Ok");

    if (isWantToUpdate == true) {
      Navigator.pop(context, true);
    }
    // getExecutionPhotoListFromDB();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, false);
        return true;
      },
      child: AnnotatedRegion(
        value: SystemUiOverlayStyle.dark,
        child: Scaffold(
          backgroundColor: ColorCodes.backgroundColor,
          appBar: Singleton.instance.commonAppbar(
              appbarText: Strings.addSalesScreen,
              leadingClickEvent: () {
                Navigator.pop(context, false);
              },
              hideBackbutton: true,
              backgroundColor: Colors.white,
              iconColor: Colors.black,
              endText: Strings.submit,
              search: false,
              endTextClickEvent: () {
                _submitNewSalesRequest();
              }),
          body: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  customerInfo(),
                  const SizedBox(
                    height: 20,
                  ),
                  engagement(),
                  efffectiveContact(),
                  if (Singleton.instance.isInternet) qrScanImage(),
                  if (Singleton.instance.isInternet)
                    const SizedBox(
                      height: 20,
                    ),
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(bottom: 16),
                    child: CommonButton(
                      width: MediaQuery.of(context).size.width / 2,
                      onPressed: () {
                        _submitNewSalesRequest();
                      },
                      title: Strings.submit,
                      setFillColor: true,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget customerInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
            onTap: () {
              setState(() {
                iscustomerInfoClicked = !iscustomerInfoClicked;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  Strings.step_1 + ": " + "SMOKER PROFILE",
                  style: Singleton.instance.setTextStyle(
                      fontSize: TextSize.text_13,
                      fontWeight: FontWeight.w700,
                      textColor: ColorCodes.lightBlack),
                ),
                iscustomerInfoClicked
                    ? const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 21,
                        color: ColorCodes.primary,
                      )
                    : const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 14,
                        color: ColorCodes.primary,
                      )
              ],
            )),
        const SizedBox(
          height: 10,
        ),
        Singleton.instance.dividerWTOPAC(),
        const SizedBox(
          height: 10,
        ),
        Visibility(
            visible: iscustomerInfoClicked,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  Strings.gender,
                  style: Singleton.instance.setTextStyle(
                      fontSize: TextSize.text_13,
                      fontWeight: FontWeight.w600,
                      textColor: ColorCodes.black),
                ),
                const SizedBox(
                  height: 4,
                ),
                genderListView(),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  Strings.ageGroup,
                  style: Singleton.instance.setTextStyle(
                      fontSize: TextSize.text_13,
                      fontWeight: FontWeight.w600,
                      textColor: ColorCodes.black),
                ),
                const SizedBox(
                  height: 4,
                ),
                ageGroupListView(),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  Strings.groupSegment,
                  style: Singleton.instance.setTextStyle(
                      fontSize: TextSize.text_13,
                      fontWeight: FontWeight.w600,
                      textColor: ColorCodes.black),
                ),
                const SizedBox(
                  height: 4,
                ),
                groupSegListView(),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Brands and Variants",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: Singleton.instance.setTextStyle(
                          fontSize: TextSize.text_13,
                          fontWeight: FontWeight.w700,
                          textColor: ColorCodes.black),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Flexible(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          (selectedBrandNumber <= 0)
                              ? Flexible(
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: CommonButton(
                                      onPressed: () async {
                                        arrBrandVarient = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  BrandListScreen(
                                                    arrBrandVarient:
                                                        arrBrandVarient,
                                                  )),
                                        );

                                        brandAndVariant.clear();
                                        selectedBrandNumber = 0;
                                        for (int i = 0;
                                            i < arrBrandVarient.length;
                                            i++) {
                                          BrandVariantMainObject objMainObject =
                                              arrBrandVarient[i];
                                          for (int j = 0;
                                              j <
                                                  objMainObject
                                                      .arrBrandVariants!.length;
                                              j++) {
                                            BrandVarientObject objBrand =
                                                objMainObject
                                                    .arrBrandVariants![j];

                                            if (objBrand.isSelected == true) {
                                              selectedBrandNumber =
                                                  selectedBrandNumber + 1;
                                              brandAndVariant
                                                  .add(objBrand.value);
                                            }
                                          }
                                        }

                                        setState(() {});
                                      },
                                      title: Strings.clickToSelect,
                                      setFillColor: true,
                                    ),
                                  ),
                                )
                              : Flexible(
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: CommonButton(
                                      onPressed: () async {
                                        arrBrandVarient = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  BrandListScreen(
                                                    arrBrandVarient:
                                                        arrBrandVarient,
                                                  )),
                                        );

                                        brandAndVariant.clear();
                                        selectedBrandNumber = 0;
                                        for (int i = 0;
                                            i < arrBrandVarient.length;
                                            i++) {
                                          BrandVariantMainObject objMainObject =
                                              arrBrandVarient[i];
                                          for (int j = 0;
                                              j <
                                                  objMainObject
                                                      .arrBrandVariants!.length;
                                              j++) {
                                            BrandVarientObject objBrand =
                                                objMainObject
                                                    .arrBrandVariants![j];

                                            if (objBrand.isSelected == true) {
                                              selectedBrandNumber =
                                                  selectedBrandNumber + 1;
                                              brandAndVariant
                                                  .add(objBrand.value);
                                            }
                                          }
                                        }

                                        setState(() {});
                                      },
                                      title: brandAndVariant[0],
                                      setFillColor: true,
                                    ),
                                  ),
                                ),
                          const SizedBox(
                            width: 1,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            )),
      ],
    );
  }

  Widget genderListView() {
    return SizedBox(
      height: MediaQuery.of(context).size.width / 13,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          var objGender = arrGender[index];

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  for (var element in arrGender) {
                    element.isSelected = false;
                  }
                  arrGender[index].isSelected = true;

                  var obj = arrGender
                      .firstWhere((element) => element.isSelected == true);
                  gender = obj.value;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: objGender.isSelected
                        ? ColorCodes.primary
                        : Colors.white),
                child: Text(
                  objGender.value.capitalized(),
                  style: Singleton.instance.setTextStyle(
                      fontSize: TextSize.text_12,
                      fontWeight: FontWeight.w400,
                      textColor: objGender.isSelected
                          ? Colors.white
                          : ColorCodes.black),
                ),
              ),
            ),
          );
        },
        itemCount: arrGender.length,
      ),
    );
  }

  Widget ageGroupListView() {
    return SizedBox(
      height: MediaQuery.of(context).size.width / 13,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          var objAgeGroup = arrAgeGroup[index];
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  for (var element in arrAgeGroup) {
                    element.isSelected = false;
                  }
                  arrAgeGroup[index].isSelected = true;

                  var obj = arrAgeGroup
                      .firstWhere((element) => element.isSelected == true);
                  ageGroup = obj.value;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: objAgeGroup.isSelected
                        ? ColorCodes.primary
                        : Colors.white),
                child: Text(
                  objAgeGroup.value.capitalized(),
                  style: Singleton.instance.setTextStyle(
                      fontSize: TextSize.text_12,
                      fontWeight: FontWeight.w400,
                      textColor: objAgeGroup.isSelected
                          ? Colors.white
                          : ColorCodes.black),
                ),
              ),
            ),
          );
        },
        itemCount: arrAgeGroup.length,
      ),
    );
  }

  Widget groupSegListView() {
    return SizedBox(
      height: MediaQuery.of(context).size.width / 13,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          var objGroupSegment = arrGroupSegment[index];
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  for (var element in arrGroupSegment) {
                    element.isSelected = false;
                  }
                  arrGroupSegment[index].isSelected = true;

                  var obj = arrGroupSegment
                      .firstWhere((element) => element.isSelected == true);
                  groupSegment = obj.value;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: objGroupSegment.isSelected
                        ? ColorCodes.primary
                        : Colors.white),
                child: Text(
                  objGroupSegment.value.capitalized(),
                  style: Singleton.instance.setTextStyle(
                      fontSize: TextSize.text_12,
                      fontWeight: FontWeight.w400,
                      textColor: objGroupSegment.isSelected
                          ? Colors.white
                          : ColorCodes.black),
                ),
              ),
            ),
          );
        },
        itemCount: arrGroupSegment.length,
      ),
    );
  }

  Widget efffectiveContact() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
            onTap: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  (Strings.step_3 + ": " + "EFFECTIVE CONTACT"),
                  style: Singleton.instance.setTextStyle(
                      fontSize: TextSize.text_13,
                      fontWeight: FontWeight.w700,
                      textColor: ColorCodes.lightBlack),
                ),
                GestureDetector(
                    onTap: () async {},
                    child: Image.asset(
                      "",
                      width: 26,
                      height: 26,
                    )),
              ],
            )),
        const SizedBox(
          height: 4,
        ),
        Singleton.instance.dividerWTOPAC(),
        const SizedBox(
          height: 10,
        ),
        Visibility(
            visible: isEffectiveContactClicked,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                productListview(),
                arrSelectedProducts.isEmpty
                    ? Container()
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            Strings.totalSale.toUpperCase(),
                            style: Singleton.instance.setTextStyle(
                                fontSize: TextSize.text_11,
                                fontWeight: FontWeight.w400,
                                textColor: ColorCodes.lightBlack),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(
                            "RM ${productTotalAmount.toPrecision(2)}"
                                .replaceAll(Singleton.instance.regex, ""),
                            style: Singleton.instance.setTextStyle(
                                fontSize: TextSize.text_16,
                                fontWeight: FontWeight.w700,
                                textColor: ColorCodes.primary),
                          ),
                        ],
                      )
              ],
            )),
        if (arrSelectedProducts.isNotEmpty)
          const SizedBox(
            height: 10,
          ),
        if (arrSelectedProducts.isNotEmpty) Singleton.instance.dividerWTOPAC(),
        const SizedBox(
          height: 12,
        ),
      ],
    );
  }

  Widget qrScanImage() {
    return GestureDetector(
      onTap: () {},
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            Strings.qrScanImage,
            style: Singleton.instance.setTextStyle(
                fontSize: TextSize.text_13,
                fontWeight: FontWeight.w700,
                textColor: ColorCodes.lightBlack),
          ),
          const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 14,
            color: ColorCodes.primary,
          )
        ],
      ),
    );
  }

/*
hone no limit is extended to 14 as need to add 0091 prefix
 */
  Widget engagement() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
            onTap: () {
              setState(() {
                isengagementClicked = !isengagementClicked;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  Strings.step_2 + ": " + "DATA COLLECTION",
                  style: Singleton.instance.setTextStyle(
                      fontSize: TextSize.text_13,
                      fontWeight: FontWeight.w700,
                      textColor: ColorCodes.lightBlack),
                ),
                isengagementClicked
                    ? const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 21,
                        color: ColorCodes.primary,
                      )
                    : const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 14,
                        color: ColorCodes.primary,
                      )
              ],
            )),
        const SizedBox(
          height: 10,
        ),
        Singleton.instance.dividerWTOPAC(),
        const SizedBox(
          height: 10,
        ),
        Visibility(
            visible: isengagementClicked,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: ColorCodes.black.withOpacity(0.07)),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Singleton.instance.addGreyTextField(
                        nameNode,
                        nameController,
                        TextInputType.text,
                        false,
                        Strings.enterName,
                        TextInputAction.next),
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: ColorCodes.black.withOpacity(0.07)),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Singleton.instance.addGreyTextField(
                        emailNode,
                        emailController,
                        TextInputType.emailAddress,
                        false,
                        Strings.enterEmail,
                        TextInputAction.next),
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Row(
                  children: [
                    Flexible(
                      flex: 2,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: ColorCodes.black.withOpacity(0.07)),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextField(
                            enabled: !contactVarified ? true : false,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            textInputAction: TextInputAction.done,
                            scrollPadding: Constant.textFieldInset,
                            focusNode: contactNode,
                            controller: contactController,
                            cursorColor: ColorCodes.lightBlack,
                            autocorrect: false,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.left,
                            obscureText: false,
                            decoration: Singleton.instance
                                .setTextFieldDecoration(Strings.enterContactNo),
                            style: Singleton.instance.setTextStyle(
                              fontFamily: Constant.latoFontFamily,
                              fontWeight: FontWeight.normal,
                              fontSize: TextSize.text_14,
                              textColor: ColorCodes.lightBlack,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      child: GestureDetector(
                        onTap: () async {
                          if (!contactVarified) {
                            if (Singleton.instance.isInternet) {
                              bool isContactVerified = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PDPAScreen(
                                    contactNo: contactController.text,
                                  ),
                                ),
                              );

                              contactVarified = isContactVerified;
                              setState(() {});
                            }
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(
                              vertical: 14, horizontal: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: ColorCodes.primary),
                          child: Text(
                            !contactVarified
                                ? Strings.verify.toUpperCase()
                                : "verified".toUpperCase(),
                            style: Singleton.instance.setTextStyle(
                                fontSize: TextSize.text_14,
                                fontWeight: FontWeight.w400,
                                textColor: Colors.white),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                      value: valueGift,
                      onChanged: contactVarified
                          ? (bool? value) {
                              setState(() {
                                valueGift = value!;
                              });
                            }
                          : null,
                    ),
                    Text(
                      "Token given",
                      style: Singleton.instance.setTextStyle(
                          fontSize: TextSize.text_12,
                          fontWeight: FontWeight.w400,
                          textColor: ColorCodes.lightBlack),
                    ),
                  ],
                )
              ],
            )),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }

  Widget productListview() {
    return ListView.builder(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return productTile(arrSelectedProducts[index]);
      },
      itemCount: arrSelectedProducts.length,
    );
  }

  Widget productTile(StockRowProduct objProduct) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(18)),
        margin: const EdgeInsets.only(bottom: 10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: (objProduct.imageUrl ?? "").isEmpty ||
                              (!Singleton.instance.isInternet)
                          ? Singleton.instance.placeholderWidget(48, 48)
                          : CachedNetworkImage(
                              imageUrl: objProduct.imageUrl ?? "",
                              height: 48,
                              width: 48,
                              fit: BoxFit.cover,
                              placeholder: (context, url) =>
                                  Singleton.instance.placeholderWidget(48, 48),
                              errorWidget: (context, url, error) =>
                                  Singleton.instance.placeholderWidget(48, 48),
                            ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            objProduct.name ?? "",
                            style: Singleton.instance.setTextStyle(
                                fontSize: TextSize.text_16,
                                fontWeight: FontWeight.w600,
                                textColor: ColorCodes.black),
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          Flexible(
                            child: Text(
                              (objProduct.updatedBalance == null)
                                  ? "RM: -"
                                  : "RM: ${((objProduct.updatedBalance!).toDouble() * (objProduct.amount ?? 1)).toPrecision(2)}"
                                      .replaceAll(Singleton.instance.regex, ""),
                              style: Singleton.instance.setTextStyle(
                                  fontSize: TextSize.text_12,
                                  fontWeight: FontWeight.w400,
                                  textColor: ColorCodes.lightBlack),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        (objProduct.updatedBalance == null)
                            ? "0"
                            : objProduct.updatedBalance.toString(),
                        style: Singleton.instance.setTextStyle(
                            fontSize: TextSize.text_20,
                            fontWeight: FontWeight.w400,
                            textColor: ColorCodes.primary),
                      ),
                      objProduct.isOutlet!
                          ? Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(18),
                                  color: ColorCodes.lightYellowColor),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Outlet",
                                    style: Singleton.instance.setTextStyle(
                                        fontSize: TextSize.text_10,
                                        fontWeight: FontWeight.w600,
                                        textColor: ColorCodes.buttonTextColor),
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  Image.asset(
                                    "",
                                    width: 12,
                                    height: 12,
                                    color: ColorCodes.buttonTextColor,
                                  )
                                ],
                              ),
                            )
                          : Container()
                    ],
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        arrSelectedProducts.removeWhere(
                            (element) => element.id == objProduct.id);
                        if (kDebugMode) {
                          print(arrSelectedProducts.length);
                          setState(() {});
                          print("REMOVE PRODUCT TAPPED");
                        }
                      },
                      child: Container(
                        // color: Colors.green,
                        padding: const EdgeInsets.all(5),
                        child: const Icon(
                          Icons.close,
                          size: 20,
                          color: Colors.red,
                        ),
                      )),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void getGeneralConfigurationFromDB() async {
    List<Map<String, dynamic>> arrGenderDB =
        await DBHelper.getData(Strings.tableGender);

    if (arrGenderDB.isEmpty) {
      arrGender = [];
    } else {
      for (int i = 0; i < arrGenderDB.length; i++) {
        GenderObject objGender =
            GenderObject(value: arrGenderDB[i]["value"], isSelected: false);
        arrGender.add(objGender);
      }
    }

    final arrAgeGroupDB = await DBHelper.getData(Strings.tableAgeGroup);
    if (arrAgeGroupDB.isEmpty) {
      arrAgeGroup = [];
    } else {
      for (int i = 0; i < arrAgeGroupDB.length; i++) {
        AgeGroupObject objGender =
            AgeGroupObject(value: arrAgeGroupDB[i]["value"], isSelected: false);
        arrAgeGroup.add(objGender);
      }
    }

    final arrGroupSegmentDB = await DBHelper.getData(Strings.tableGroupSegment);
    if (arrGroupSegmentDB.isEmpty) {
      arrGroupSegment = [];
    } else {
      for (int i = 0; i < arrGroupSegmentDB.length; i++) {
        GroupSegmentObject objGender = GroupSegmentObject(
            value: arrGroupSegmentDB[i]["value"], isSelected: false);
        arrGroupSegment.add(objGender);
      }
    }

    final arrBrandVariantDB = await DBHelper.getData(Strings.tableBrandVariant);
    if (arrBrandVariantDB.isEmpty) {
      arrBrandVarient = [];
    } else {
      List list = arrBrandVariantDB.map((array) => array['brand']).toList();

      var uniqueItems = list.toSet().toList();
      for (int i = 0; i < uniqueItems.length; i++) {
        String title = uniqueItems[i];
        BrandVariantMainObject objMainBrand =
            BrandVariantMainObject(id: 0, brands: title, arrBrandVariants: []);
        arrBrandVarient.add(objMainBrand);
      }

      for (int i = 0; i < arrBrandVarient.length; i++) {
        BrandVariantMainObject objMainBrand = arrBrandVarient[i];

        for (int j = 0; j < arrBrandVariantDB.length; j++) {
          Map<String, dynamic> dictBrand = arrBrandVariantDB[j];

          if (dictBrand['brand'] == objMainBrand.brands) {
            BrandVarientObject objBrandVariant = BrandVarientObject(
                value: dictBrand['value'], isSelected: false);
            objMainBrand.arrBrandVariants!.add(objBrandVariant);
          }
        }
      }
    }

    setState(() {});
  }

  Future<void> getGeneralConfiguration() async {
    late Map<String, String> header;
    header = {
      HttpHeaders.authorizationHeader: Singleton.instance.authToken,
    };

    GeneralConfigModel configModel;

    Singleton.instance.showDefaultProgress();
    final url = Uri.parse(ApiConstants.baseUrl +
        ApiConstants.baseUrlHost +
        ApiConstants.generalConfiguration);
    if (kDebugMode) {
      print("url$url");
    }

    ApiService.getCallwithHeader(url, header, context).then((response) {
      if (kDebugMode) {
        print(response);
      }
      if (response.body.isNotEmpty) {
        final responseData = json.decode(response.body);
        try {
          Singleton.instance.hideProgress();
          if (response.statusCode == 200) {
            var data = json.decode(response.body);

            configModel = GeneralConfigModel.fromJson(data["payload"]);
            Singleton.instance.objGeneralConfig = configModel;

            arrGender.clear();
            arrAgeGroup.clear();
            arrGroupSegment.clear();
            arrBrandVarient.clear();

            if (Singleton.instance.objGeneralConfig.arrGender == null) {
              arrGender = [];
            } else {
              arrGender = Singleton.instance.objGeneralConfig.arrGender!;
              // arrGender[0].isSelected = true;
              // gender = arrGender[0].value;
            }

            if (Singleton.instance.objGeneralConfig.arrAgeGroup == null) {
              arrAgeGroup = [];
            } else {
              arrAgeGroup = Singleton.instance.objGeneralConfig.arrAgeGroup!;
            }

            if (Singleton.instance.objGeneralConfig.arrGroupSegment == null) {
              arrGroupSegment = [];
            } else {
              arrGroupSegment =
                  Singleton.instance.objGeneralConfig.arrGroupSegment!;
            }

            if (Singleton.instance.objGeneralConfig.arrBrandVarient == null) {
              arrBrandVarient = [];
            } else {
              arrBrandVarient =
                  Singleton.instance.objGeneralConfig.arrBrandVarient!;
            }

            setState(() {});
          } else if (response.statusCode == 401) {
            Singleton.instance.showAInvalidTokenAlert(
                context, Constant.alert, responseData["message"]);
          } else {
            Singleton.instance.showAlertDialogWithOkAction(
                context, Constant.alert, responseData["message"]);
          }
        } on SocketException catch (e) {
          Singleton.instance.hideProgress();
          if (kDebugMode) {
            print(e.message);
          }
          response.success = false;
          response.message = "Please check internet connection";
        } catch (e) {
          Singleton.instance.hideProgress();
          response.success = responseData['success'];
          response.message = responseData['message'];
          response.code = responseData['code'];
        }
      } else {
        if (kDebugMode) {}
      }
    });
  }

  Future<void> addSalesAPI(String products) async {
    final url = Uri.parse(ApiConstants.baseUrl +
        ApiConstants.baseUrlHost +
        ApiConstants.addSales);
    if (kDebugMode) {
      print("url$url");
    }

    late Map<String, String> header;
    header = {
      HttpHeaders.authorizationHeader: Singleton.instance.authToken,
    };

    late Map<String, String> body;
    if (brandAndVariant.isEmpty) {}

    body = {
      ApiParamters.projectID: widget.objSelectedProject.id.toString(),
      ApiParamters.outletId: widget.objselectedOutlet.id.toString(),
      ApiParamters.visitationId:
          widget.objselectedOutlet.visitationId.toString(),
      ApiParamters.effectiveName: nameController.text,
      if (emailController.text.isNotEmpty)
        ApiParamters.effectiveEmail: emailController.text,
      ApiParamters.effectiveContact: contactController.text,
      ApiParamters.isFree: valueGift ? "1" : "0",
      ApiParamters.gender: gender,
      ApiParamters.ageGroup: ageGroup,
      ApiParamters.groupSegment: groupSegment,
      if (brandAndVariant.isNotEmpty)
        ApiParamters.brandsVariant: jsonEncode(brandAndVariant),
      if (products != "[]") ApiParamters.products: products,
      ApiParamters.isVerified: contactVarified ? "1" : "0",
    };

    if (kDebugMode) {
      print("url$url");
    }

    Singleton.instance.showDefaultProgress();
    ApiService.postCallwithHeader(url, body, header, context)
        .then((response) async {
      if (response.body.isNotEmpty) {
        final responseData = json.decode(response.body);
        try {
          if (kDebugMode) {
            print(responseData);
            print("statuscode ${response.statusCode}");
          }
          Singleton.instance.hideProgress();
          if (response.statusCode == 200) {
            var isWantToUpdate = await Singleton.instance
                .showAlertDialogWithGoPreviousOptions(
                    context, Constant.appName, responseData["message"], "Ok");

            if (isWantToUpdate == true) {
              Navigator.pop(context, true);
            }
          } else if (response.statusCode == 401) {
            Singleton.instance.showAInvalidTokenAlert(
                context, Constant.alert, responseData["message"]);
          } else {
            Singleton.instance.showAlertDialogWithOkAction(
                context, Constant.alert, responseData["message"]);
          }
        } on SocketException catch (e) {
          Singleton.instance.hideProgress();
          if (kDebugMode) {
            print(e.message);
          }
          response.success = false;
          response.message = "Please check internet connection";
        } catch (e) {
          Singleton.instance.hideProgress();
          response.success = responseData['success'];
          response.message = responseData['message'];
          response.code = responseData['code'];
        }
      } else {
        if (kDebugMode) {}
      }
    });
  }
}

extension StringExtension on String {
  String capitalized() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}
