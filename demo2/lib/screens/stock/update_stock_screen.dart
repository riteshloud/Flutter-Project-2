import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../helpers/api_constant.dart';
import '../../helpers/colors.dart';
import '../../helpers/constant.dart';
import '../../helpers/singleton.dart';
import '../../helpers/strings.dart';

import '../../models/stock_balance_model.dart';

import '../../service/api_service.dart';

import '../../widgets/common_button.dart';

class UpdateStockScreen extends StatefulWidget {
  final int projectID;

  const UpdateStockScreen({Key? key, required this.projectID})
      : super(key: key);

  @override
  _UpdateStockScreenState createState() => _UpdateStockScreenState();
}

class _UpdateStockScreenState extends State<UpdateStockScreen> {
  bool value = false;

  List<StockRow> arrStocks = [];

  @override
  void initState() {
    getProductsList(widget.projectID.toString());
    super.initState();
  }

  @override
  void dispose() {
    for (var objStock in arrStocks) {
      for (var controller in objStock.arrControllers!) {
        controller.dispose();
      }
    }
    super.dispose();
  }

  void _updateStock() {
    if (kDebugMode) {
      print(arrStocks);
    }

    List<Map<String, dynamic>> arrProducts = [];

    for (int i = 0; i < arrStocks.length; i++) {
      var objStock = arrStocks[i];

      for (int j = 0; j < objStock.arrProducts!.length; j++) {
        var objProduct = objStock.arrProducts![j];

        Map<String, dynamic> dictProduct = {};
        bool isNeedToAddInArray = false;

        //STOCK ID IS NULL THEN PASS PRODUCT ID
        if (objProduct.stockId == null || objProduct.stockId! <= 0) {
          dictProduct["productId"] = objProduct.id;
        } else {
          dictProduct["stockId"] = objProduct.stockId;
        }

        if (objProduct.updatedBalance == null) {
          dictProduct["quantity"] = objProduct.balance;
        } else {
          //BALANCE NOT UPDATED
          if ((objProduct.updatedBalance ?? 0) == (objProduct.balance ?? 0)) {
            dictProduct["quantity"] = "-${objProduct.updatedBalance}";
            isNeedToAddInArray = false;
          }
          //BALANCE UPDATED AND VALUE IS SMALLER THAN PREVIOUS VALUE
          else if ((objProduct.updatedBalance ?? 0) <
              (objProduct.balance ?? 0)) {
            //dictProduct["quantity"] = "-${objProduct.updatedBalance}";
            dictProduct["quantity"] =
                "${(objProduct.updatedBalance ?? 0) - (objProduct.balance ?? 0)}";
            isNeedToAddInArray = true;
          }
          //BALANCE UPDATED AND VALUE IS GREATER THAN PREVIOUS VALUE
          else if ((objProduct.updatedBalance ?? 0) >
              (objProduct.balance ?? 0)) {
            dictProduct["quantity"] =
                "${(objProduct.updatedBalance ?? 0) - (objProduct.balance ?? 0)}";
            isNeedToAddInArray = true;
          }
        }

        if (isNeedToAddInArray) {
          arrProducts.add(dictProduct);
        }
      }
    }

    if (arrProducts.isEmpty) {
      Navigator.pop(context, false);
    } else {
      String strProducts = jsonEncode(arrProducts);
      updateStock(widget.projectID.toString(), strProducts);
    }
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
              appbarText: Strings.updateStockScreen,
              leadingClickEvent: () {
                Navigator.pop(context, false);
              },
              hideBackbutton: true,
              backgroundColor: Colors.white,
              iconColor: Colors.black,
              endText: Strings.update,
              search: false,
              endTextClickEvent: () {
                _updateStock();
              }),
          body: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                productMainList(context),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  alignment: Alignment.center,
                  //width: MediaQuery.of(context).size.width/2.5,
                  child: CommonButton(
                    width: MediaQuery.of(context).size.width / 2,
                    onPressed: () {
                      _updateStock();
                    },
                    title: Strings.update,
                    setFillColor: true,
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget productMainList(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      color: ColorCodes.backgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.separated(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return listtile(arrStocks[index]);
          },
          separatorBuilder: (context, index) {
            return Singleton.instance.dividerWTOPAC();
          },
          itemCount: arrStocks.length),
    );
  }

  Widget listtile(StockRow objStockRow) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Text(
            (objStockRow.name ?? ""),
            style: Singleton.instance.setTextStyle(
                fontSize: TextSize.text_13,
                fontWeight: FontWeight.w700,
                textColor: ColorCodes.lightBlack),
          ),
        ),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.only(top: 8, left: 0, right: 0, bottom: 0),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return productTile(objStockRow.arrProducts![index], index,
                objStockRow.arrProducts!, objStockRow.arrControllers!);
          },
          itemCount: objStockRow.arrProducts!.length,
        )
      ],
    );
  }

  Widget productTile(
      StockRowProduct objProduct,
      int index,
      List<StockRowProduct> arrProducts,
      List<TextEditingController> arrTextController) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(18)),
        margin: const EdgeInsets.only(bottom: 10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: (objProduct.imageUrl == null)
                          ? Singleton.instance.placeholderWidget(48, 48)
                          : CachedNetworkImage(
                              memCacheHeight: null,
                              memCacheWidth: 200,
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
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  "${Strings.balance}: ",
                                  style: Singleton.instance.setTextStyle(
                                      fontSize: TextSize.text_12,
                                      fontWeight: FontWeight.w400,
                                      textColor: ColorCodes.lightBlack),
                                ),
                              ),
                              Flexible(
                                child: Text(
                                  objProduct.balance.toString(),
                                  style: Singleton.instance.setTextStyle(
                                      fontSize: TextSize.text_12,
                                      fontWeight: FontWeight.w400,
                                      textColor: ColorCodes.lightBlack),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: objProduct.isdiable!
                        ? null
                        : () {
                            setState(() {
                              if (objProduct.updatedBalance == null) {
                              } else {
                                if (objProduct.updatedBalance! > 0) {
                                  if (objProduct.updatedBalance! >
                                      objProduct.balance!) {
                                    objProduct.updatedBalanceData =
                                        objProduct.updatedBalance! - 1;

                                    if (objProduct.updatedBalance! >
                                        objProduct.balance!) {
                                      objProduct.isdisableData = false;
                                    } else {
                                      objProduct.isdisableData = true;
                                    }

                                    arrTextController[index].text =
                                        objProduct.updatedBalance.toString();
                                    arrTextController[index].selection =
                                        TextSelection.fromPosition(
                                      TextPosition(
                                          offset: arrTextController[index]
                                              .text
                                              .length),
                                    );
                                  }
                                }
                              }
                            });
                          },
                    child: Image.asset(
                      objProduct.isdiable! ? "" : "",
                      width: 24,
                      height: 24,
                    ),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Container(
                    height: 40,
                    width: 55,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: ColorCodes.grayBgcolor),
                    child: TextFormField(
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(4),
                      ],
                      style: Singleton.instance.setTextStyle(
                          fontSize: TextSize.text_14,
                          fontWeight: FontWeight.w400,
                          textColor: ColorCodes.lightBlack),
                      controller: arrTextController[index],
                      scrollPadding: Constant.textFieldInset,
                      cursorColor: Colors.black,
                      autocorrect: false,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        hintText: "",
                        hintStyle: TextStyle(
                          color: ColorCodes.lightBlack,
                        ),
                      ),
                      onChanged: (text) {
                        takeNumber(text, index, arrProducts, arrTextController);
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (objProduct.updatedBalance == null) {
                          objProduct.updatedBalanceData =
                              objProduct.balance! + 1;

                          if (objProduct.updatedBalance! >
                              objProduct.balance!) {
                            objProduct.isdisableData = false;
                          } else {
                            objProduct.isdisableData = true;
                          }
                          arrTextController[index].text =
                              objProduct.updatedBalance.toString();
                          arrTextController[index].selection =
                              TextSelection.fromPosition(
                            TextPosition(
                                offset: arrTextController[index].text.length),
                          );
                        } else {
                          objProduct.updatedBalanceData =
                              objProduct.updatedBalance! + 1;

                          if (objProduct.updatedBalance! >
                              objProduct.balance!) {
                            objProduct.isdisableData = false;
                          } else {
                            objProduct.isdisableData = true;
                          }

                          arrTextController[index].text =
                              objProduct.updatedBalance.toString();
                          arrTextController[index].selection =
                              TextSelection.fromPosition(
                            TextPosition(
                                offset: arrTextController[index].text.length),
                          );
                        }
                      });
                    },
                    child: Image.asset(
                      "",
                      width: 24,
                      height: 24,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void takeNumber(String text, int index, List<StockRowProduct> arrProducts,
      List<TextEditingController> arrTextController) {
    try {
      int number = int.parse(text);

      if (number >= arrProducts[index].balance!) {
        arrProducts[index].updatedBalanceData = number;

        if (arrProducts[index].updatedBalance! > arrProducts[index].balance!) {
          arrProducts[index].isdisableData = false;
        } else {
          arrProducts[index].isdisableData = true;
        }

        arrTextController[index].text = number.toString();
        arrTextController[index].selection = TextSelection.fromPosition(
            TextPosition(offset: arrTextController[index].text.length));

        setState(() {});
      } else {
        Singleton.instance.showAlertDialogWithOkAction(
            context,
            Constant.appName,
            "Value can't be smaller then available balance for ==> \"${arrProducts[index].name}\"");
      }
    } on FormatException {
      if (kDebugMode) {
        print("");
      }
    }
  }

  // ******** API CALL ********
  Future<void> getProductsList(String projectID) async {
    late Map<String, String> header;
    header = {
      HttpHeaders.authorizationHeader: Singleton.instance.authToken,
    };

    late Map<String, String> body;
    body = {
      ApiParamters.projectID: projectID,
    };

    final url = Uri.parse(ApiConstants.baseUrl +
        ApiConstants.baseUrlHost +
        ApiConstants.getProductStockList +
        "?" +
        Uri(queryParameters: body).query);
    if (kDebugMode) {
      print("url$url");
    }

    Singleton.instance.showDefaultProgress();
    ApiService.getCallwithHeader(url, header, context).then((response) {
      final responseData = json.decode(response.body);
      try {
        if (kDebugMode) {
          print(responseData);
          print("statuscode ${response.statusCode}");
        }

        Singleton.instance.hideProgress();
        if (response.statusCode == 200) {
          var data = json.decode(response.body)["payload"];

          if (data['data'] != null) {
            arrStocks = [];
            data['data'].forEach((v) {
              arrStocks.add(StockRow.fromJson(v));
            });
          }

          for (int i = 0; i < arrStocks.length; i++) {
            var objStock = arrStocks[i];
            objStock.arrControllersData = [];
            for (int j = 0; j < objStock.arrProducts!.length; j++) {
              var objProduct = objStock.arrProducts![j];
              objStock.arrControllers!.add(
                TextEditingController(
                  text: (objProduct.updatedBalance == null)
                      ? objProduct.balance.toString()
                      : objProduct.updatedBalance.toString(),
                ),
              );
            }
          }
          setState(() {});
        } else if (response.statusCode == 401) {
          Singleton.instance.showAInvalidTokenAlert(
              context, Constant.alert, responseData["message"]);
        } else {
          Singleton.instance.showAlertDialogWithOkAction(
              context, Constant.alert, responseData["message"]);
        }
      } on SocketException {
        response.success = false;
        response.message = "Please check internet connection";
      } catch (e) {
        response.success = responseData['success'];
        response.message = responseData['message'];
        response.code = responseData['code'];
      }
    });
  }

  Future<void> updateStock(String projectID, String products) async {
    late Map<String, String> header;
    header = {
      HttpHeaders.authorizationHeader: Singleton.instance.authToken,
    };

    late Map<String, String> body;

    body = {
      ApiParamters.projectID: projectID,
      ApiParamters.products: products,
    };

    final url = Uri.parse(ApiConstants.baseUrl +
        ApiConstants.baseUrlHost +
        ApiConstants.updateStock);
    if (kDebugMode) {
      print("url$url");
    }

    Singleton.instance.showDefaultProgress();
    ApiService.postCallwithHeader(url, body, header, context)
        .then((response) async {
      final responseData = json.decode(response.body);
      try {
        if (kDebugMode) {
          print(responseData);
          print("statuscode ${response.statusCode}");
        }

        if (response.statusCode == 200) {
          getProductsList(widget.projectID.toString());

          var isWantToUpdate = await Singleton.instance
              .showAlertDialogWithGoPreviousOptions(
                  context, Constant.appName, responseData["message"], "Ok");

          if (isWantToUpdate == true) {
            Navigator.pop(context, true);
          }
        } else if (response.statusCode == 401) {
          Singleton.instance.hideProgress();
          Singleton.instance.showAInvalidTokenAlert(
              context, Constant.alert, responseData["message"]);
        } else {
          Singleton.instance.hideProgress();
          Singleton.instance.showAlertDialogWithOkAction(
              context, Constant.alert, responseData["message"]);
        }
      } on SocketException {
        response.success = false;
        response.message = "Please check internet connection";
      } catch (e) {
        response.success = responseData['success'];
        response.message = responseData['message'];
        response.code = responseData['code'];
      }
    });
  }
}
