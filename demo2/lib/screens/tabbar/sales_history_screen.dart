import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:demo2/helpers/api_constant.dart';
import 'package:demo2/models/datewise_sales_history_model.dart';
import 'package:demo2/service/api_service.dart';

import '../../helpers/colors.dart';
import '../../helpers/constant.dart';
import '../../helpers/singleton.dart';
import '../../helpers/strings.dart';

import '../../models/get_project_list_model.dart';

class SalesHistoryScreen extends StatefulWidget {
  final bool fromBottom;
  final Rows objSelectedProject;
  const SalesHistoryScreen(this.fromBottom, this.objSelectedProject, {Key? key})
      : super(key: key);

  @override
  _SalesHistoryScreenState createState() => _SalesHistoryScreenState();
}

class _SalesHistoryScreenState extends State<SalesHistoryScreen> {
  List<SalesHistoryDateObject> arrSalesDate = [];

  @override
  void initState() {
    if (kDebugMode) {
      print("VISITATION LOGS INIT STATE CALLED");
    }

    Singleton.instance.isInternetConnected().then((intenet) {
      if (intenet) {
        getSalesHistory();
      } else {}
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        appBar: Singleton.instance.commonAppbar(
            appbarText: Strings.outletSalesHistory,
            leadingClickEvent: () {
              Navigator.pop(context, false);
            },
            hideBackbutton: !widget.fromBottom,
            backgroundColor: ColorCodes.backgroundColor,
            iconColor: Colors.black,
            endText: "",
            endTextClickEvent: () {}),
        body: Container(
          color: ColorCodes.backgroundColor,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: arrSalesDate.isEmpty
              ? Center(
                  child: Text(
                    "No data available",
                    style: Singleton.instance.setTextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: TextSize.text_14,
                        textColor: ColorCodes.black),
                  ),
                )
              : salesHistoryDateList(context),
        ),
      ),
    );
  }

  Widget salesHistoryDateList(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 0, left: 0, right: 0, bottom: 0),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        var objSalesHistory = arrSalesDate[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                objSalesHistory.date ?? "",
                style: Singleton.instance.setTextStyle(
                    fontSize: TextSize.text_14,
                    textColor: ColorCodes.lightBlack,
                    fontWeight: FontWeight.w700),
              ),
              const SizedBox(
                height: 16,
              ),
              salesHistoryDataList(context, objSalesHistory),
            ],
          ),
        );
      },
      itemCount: arrSalesDate.length,
    );
  }

  Widget salesHistoryDataList(
      BuildContext context, SalesHistoryDateObject objSalesHistoryDate) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 0, left: 0, right: 0, bottom: 0),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return listTileWidget(context, objSalesHistoryDate.objSalesHistoryLog!);
      },
      itemCount: 1,
    );
  }

  Widget listTileWidget(BuildContext context, SalesLogObject objSalesLog) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 0, left: 0, right: 0, bottom: 0),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18), color: Colors.white),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: const EdgeInsets.only(
                            top: 0, left: 0, right: 0, bottom: 0),
                        itemBuilder: (context, index) {
                          var objSales = objSalesLog.arrSales![index];
                          return Text(
                            "${objSales.productName}: ${objSales.quantity}",
                            style: Singleton.instance.setTextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: TextSize.text_14,
                                textColor: Colors.black),
                          );
                        },
                        itemCount: objSalesLog.arrSales!.length,
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "Total Sales".toUpperCase(),
                          style: Singleton.instance.setTextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: TextSize.text_11,
                              textColor: ColorCodes.lightBlack),
                        ),
                        Text(
                          objSalesLog.totalSales.toString(),
                          style: Singleton.instance.setTextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: TextSize.text_24,
                              textColor: ColorCodes.primary),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Singleton.instance.dividerWTOPAC(),
              ),
              const SizedBox(
                height: 8,
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Smoker Contact FC : ${objSalesLog.smokerContactFc}",
                          style: Singleton.instance.setTextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: TextSize.text_14,
                              textColor: ColorCodes.lightBlack),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Text(
                          "Smoker Contact SOB : ${objSalesLog.smokerContactSob}",
                          style: Singleton.instance.setTextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: TextSize.text_14,
                              textColor: ColorCodes.lightBlack),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Text(
                          "Effective Contact FC : ${objSalesLog.effectveContactFc}",
                          style: Singleton.instance.setTextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: TextSize.text_14,
                              textColor: ColorCodes.lightBlack),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Text(
                          "Effective SOB : ${objSalesLog.effectiveContactSob}",
                          style: Singleton.instance.setTextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: TextSize.text_14,
                              textColor: ColorCodes.lightBlack),
                        ),
                      ],
                    )),
                    const SizedBox(
                      width: 16,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "OTP Contact : ${objSalesLog.otpContact}",
                          style: Singleton.instance.setTextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: TextSize.text_14,
                              textColor: ColorCodes.lightBlack),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Text(
                          "Without OTP : ${objSalesLog.withoutOtp}",
                          style: Singleton.instance.setTextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: TextSize.text_14,
                              textColor: ColorCodes.lightBlack),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
      itemCount: 1,
    );
  }

  // ******** API CALL ********
  Future<void> getSalesHistory() async {
    late Map<String, String> header;
    header = {
      HttpHeaders.authorizationHeader: Singleton.instance.authToken,
    };

    late Map<String, String> body;
    Uri url = Uri.parse("");

    if (!widget.fromBottom) {
      body = {
        ApiParamters.projectID: widget.objSelectedProject.id.toString(),
      };

      url = Uri.parse(ApiConstants.baseUrl +
          ApiConstants.baseUrlHost +
          ApiConstants.salesHistory +
          "?" +
          Uri(queryParameters: body).query);
    } else {
      url = Uri.parse(ApiConstants.baseUrl +
          ApiConstants.baseUrlHost +
          ApiConstants.salesHistory);
    }

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
          DatewiseSalesHistoryModel responseModel =
              DatewiseSalesHistoryModel.fromJson(json.decode(response.body));

          arrSalesDate.clear();
          if (responseModel.payload!.arrSalesHistoryDates != null) {
            if (responseModel.payload!.arrSalesHistoryDates!.isNotEmpty) {
              arrSalesDate = responseModel.payload!.arrSalesHistoryDates!;
            } else {
              arrSalesDate = [];
            }
          } else {
            arrSalesDate = [];
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
}
