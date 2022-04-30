import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:demo2/models/datewise_sales_history_model.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../screens/tabbar/sales_history_screen.dart';
import '../../screens/tabbar/visitation_log_screen.dart';

import '../../helpers/api_constant.dart';
import '../../helpers/colors.dart';
import '../../helpers/constant.dart';
import '../../helpers/singleton.dart';
import '../../helpers/strings.dart';

import '../../models/get_project_list_model.dart';
import '../../models/project_detail_model.dart';

import '../../service/api_service.dart';

class ProjectAchievementScreen extends StatefulWidget {
  final Rows objSelectedProject;
  const ProjectAchievementScreen({Key? key, required this.objSelectedProject})
      : super(key: key);

  @override
  _ProjectAchievementScreenState createState() =>
      _ProjectAchievementScreenState();
}

class _ProjectAchievementScreenState extends State<ProjectAchievementScreen> {
  ProjectDetailModel objProjectDetail = ProjectDetailModel();
  List<VisitationHistory> arrVisitationLogs = [];
  SalesLogObject objSalesData = SalesLogObject(
      smokerContactFc: 0,
      smokerContactSob: 0,
      effectveContactFc: 0,
      effectiveContactSob: 0,
      otpContact: 0,
      withoutOtp: 0,
      arrSales: [],
      totalSales: 0);

  @override
  void initState() {
    Singleton.instance.isInternetConnected().then((intenet) {
      if (intenet) {
        getProjectDetailAPI(widget.objSelectedProject.id.toString());
      } else {}
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
        value: SystemUiOverlayStyle.dark,
        child: Scaffold(
            backgroundColor: ColorCodes.backgroundColor,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  headerLayout(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 25,
                        ),
                        salesToday(),
                        const SizedBox(
                          height: 25,
                        ),
                        Singleton.instance.dividerWTOPAC(),
                        const SizedBox(
                          height: 16,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              Strings.visitationScreen.toUpperCase(),
                              style: Singleton.instance.setTextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: TextSize.text_13,
                                  textColor: ColorCodes.lightBlack),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => VisitationLogScreen(
                                          false, widget.objSelectedProject)),
                                );
                              },
                              child: Text(
                                "View All",
                                style: Singleton.instance.setTextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: TextSize.text_13,
                                    textColor: ColorCodes.primary),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        visitationLogsList(context),
                      ],
                    ),
                  )
                ],
              ),
            )));
  }

  Widget headerLayout() {
    return Card(
      margin: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      elevation: 2,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.only(left: 5, top: 45),
        child: Column(
          children: [
            Row(
              children: [
                Visibility(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Image.asset(
                      "",
                      width: 36,
                      height: 36,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  Strings.projectDetail,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Singleton.instance.setTextStyle(
                      fontSize: TextSize.text_16,
                      fontWeight: FontWeight.w600,
                      textColor: ColorCodes.black),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 45, top: 15),
              child: Singleton.instance.dividerWTOPAC(),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 45),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FittedBox(
                                  fit: BoxFit.cover,
                                  child: Text(
                                    Strings.totalSale.toUpperCase(),
                                    style: Singleton.instance.setTextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: TextSize.text_11,
                                        textColor: ColorCodes.lightBlack),
                                  ),
                                ),
                                const SizedBox(
                                  height: 2,
                                ),
                                FittedBox(
                                  fit: BoxFit.cover,
                                  child: Text(
                                    (objProjectDetail.payload == null)
                                        ? "-"
                                        : objProjectDetail
                                            .payload!.data![0].totalSales
                                            .toString(),
                                    style: Singleton.instance.setTextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: TextSize.text_24,
                                        textColor: ColorCodes.primary),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // const SizedBox(
                        //   width: 30,
                        // ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          color: ColorCodes.dividerShade,
                          width: 2,
                          height: MediaQuery.of(context).size.height * 0.1,
                        ),
                        // const SizedBox(
                        //   width: 20,
                        // ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FittedBox(
                                  fit: BoxFit.cover,
                                  child: Text(
                                    Strings.totalAmount.toUpperCase(),
                                    style: Singleton.instance.setTextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: TextSize.text_11,
                                        textColor: ColorCodes.lightBlack),
                                  ),
                                ),
                                const SizedBox(
                                  height: 2,
                                ),
                                FittedBox(
                                  fit: BoxFit.cover,
                                  child: Text(
                                    (objProjectDetail.payload == null)
                                        ? "-"
                                        : "RM ${objProjectDetail.payload!.data![0].totalAmount.toString()}",
                                    style: Singleton.instance.setTextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: TextSize.text_24,
                                        textColor: ColorCodes.textColorDark),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 45),
              child: Singleton.instance.dividerWTOPAC(),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 45),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FittedBox(
                                  fit: BoxFit.cover,
                                  child: Text(
                                    Strings.reimbursment.toUpperCase(),
                                    style: Singleton.instance.setTextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: TextSize.text_11,
                                        textColor: ColorCodes.lightBlack),
                                  ),
                                ),
                                const SizedBox(
                                  height: 2,
                                ),
                                FittedBox(
                                  fit: BoxFit.cover,
                                  child: Text(
                                    (objProjectDetail.payload == null)
                                        ? "-"
                                        : "RM ${((objProjectDetail.payload!.data![0].totalQuantity ?? 0).toDouble() * 1).toPrecision(2)}"
                                            .replaceAll(
                                                Singleton.instance.regex, ""),
                                    style: Singleton.instance.setTextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: TextSize.text_24,
                                        textColor: ColorCodes.primary),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // const SizedBox(
                        //   width: 30,
                        // ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          color: ColorCodes.dividerShade,
                          width: 2,
                          height: MediaQuery.of(context).size.height * 0.1,
                        ),
                        // const SizedBox(
                        //   width: 20,
                        // ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FittedBox(
                                  fit: BoxFit.cover,
                                  child: Text(
                                    Strings.totalVisitToday.toUpperCase(),
                                    style: Singleton.instance.setTextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: TextSize.text_11,
                                        textColor: ColorCodes.lightBlack),
                                  ),
                                ),
                                const SizedBox(
                                  height: 2,
                                ),
                                FittedBox(
                                  fit: BoxFit.cover,
                                  child: Text(
                                    (objProjectDetail.payload == null)
                                        ? "-"
                                        : objProjectDetail
                                            .payload!.data![0].visitCount
                                            .toString(),
                                    style: Singleton.instance.setTextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: TextSize.text_24,
                                        textColor: ColorCodes.textColorDark),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget salesToday() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              Strings.salesToday.toUpperCase(),
              style: Singleton.instance.setTextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: TextSize.text_13,
                  textColor: ColorCodes.lightBlack),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          SalesHistoryScreen(false, widget.objSelectedProject)),
                );
              },
              child: Text(
                Strings.viewHistory,
                style: Singleton.instance.setTextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: TextSize.text_13,
                    textColor: ColorCodes.primary),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 16,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: ColorCodes.lightYellowColor),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              objSalesData.arrSales!.isEmpty
                  ? Text(
                      "No data available",
                      style: Singleton.instance.setTextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: TextSize.text_14,
                          textColor: ColorCodes.buttonTextColor),
                    )
                  : Expanded(
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: const EdgeInsets.only(
                            top: 0, left: 0, right: 0, bottom: 0),
                        itemBuilder: (context, index) {
                          var objSales = objSalesData.arrSales![index];
                          return Text(
                            "${objSales.productName} : ${objSales.quantity}",
                            style: Singleton.instance.setTextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: TextSize.text_14,
                                textColor: ColorCodes.buttonTextColor),
                          );
                        },
                        itemCount: objSalesData.arrSales!.length,
                      ),
                    ),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: ColorCodes.tabSelectedColor.withOpacity(0.08)),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                Strings.smokerContactfC +
                    ": " +
                    objSalesData.smokerContactFc.toString(),
                style: Singleton.instance.setTextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: TextSize.text_14,
                    textColor: ColorCodes.tabSelectedColor.withOpacity(0.6)),
              ),
              Text(
                Strings.smokerContactSOB +
                    ": " +
                    objSalesData.smokerContactSob.toString(),
                style: Singleton.instance.setTextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: TextSize.text_14,
                    textColor: ColorCodes.tabSelectedColor.withOpacity(0.6)),
              ),
              Text(
                Strings.effectiveContactfC +
                    ": " +
                    objSalesData.effectveContactFc.toString(),
                style: Singleton.instance.setTextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: TextSize.text_14,
                    textColor: ColorCodes.tabSelectedColor.withOpacity(0.6)),
              ),
              Text(
                Strings.effectiveSOB +
                    ": " +
                    objSalesData.effectiveContactSob.toString(),
                style: Singleton.instance.setTextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: TextSize.text_14,
                    textColor: ColorCodes.tabSelectedColor.withOpacity(0.6)),
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                "Otp Contact: ${objSalesData.otpContact.toString()}",
                style: Singleton.instance.setTextStyle(
                    //height: 0.5,
                    fontWeight: FontWeight.w400,
                    fontSize: TextSize.text_14,
                    textColor: ColorCodes.tabSelectedColor.withOpacity(0.6)),
              ),
              Text(
                "Without OTP: ${objSalesData.withoutOtp.toString()}",
                style: Singleton.instance.setTextStyle(
                    //height: 0.5,
                    fontWeight: FontWeight.w400,
                    fontSize: TextSize.text_14,
                    textColor: ColorCodes.tabSelectedColor.withOpacity(0.6)),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget visitationLogsList(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(top: 0, left: 0, right: 0, bottom: 0),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return listTileWidget(context, arrVisitationLogs[index]);
      },
      itemCount: arrVisitationLogs.length,
    );
  }

  Widget listTileWidget(
      BuildContext context, VisitationHistory objVisitationLog) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18), color: Colors.white),
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: (objVisitationLog.outletUrl == null)
                      ? Singleton.instance.placeholderWidget(48, 48)
                      : CachedNetworkImage(
                          memCacheHeight: null,
                          memCacheWidth: 200,
                          imageUrl: objVisitationLog.outletUrl ?? "",
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
                  width: 8,
                ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        objVisitationLog.outletName ?? "",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Singleton.instance.setTextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: TextSize.text_16,
                            textColor: ColorCodes.black),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Flexible(
                          child: Text(
                        objVisitationLog.address ?? "",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Singleton.instance.setTextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: TextSize.text_14,
                            textColor: Colors.black.withOpacity(0.5)),
                      )),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                DateFormat("dd/MM/yyyy").format(DateTime.parse(
                    (objVisitationLog.type == 0)
                        ? (objVisitationLog.checkIn ?? "")
                        : (objVisitationLog.checkOut ?? ""))),
                style: Singleton.instance.setTextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: TextSize.text_12,
                    textColor: ColorCodes.black),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                DateFormat("hh:mm a").format(DateTime.parse(
                    DateFormat("yyyy-MM-ddTHH:mm:ssZ")
                        .parse(
                            (objVisitationLog.type == 0)
                                ? (objVisitationLog.checkIn ?? "")
                                : (objVisitationLog.checkOut ?? ""),
                            true)
                        .toLocal()
                        .toString())),
                style: Singleton.instance.setTextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: TextSize.text_12,
                    textColor: ColorCodes.black),
              ),
              GestureDetector(
                onTap: () {
                  if (objVisitationLog.type == 2) {
                    Singleton.instance.showAlertDialogWithOkAction(
                        context,
                        objVisitationLog.feedbackTitle ?? "",
                        objVisitationLog.feedbackDescription ?? "");
                  }
                },
                child: Image.asset(
                  (objVisitationLog.type == 0)
                      ? ""
                      : (objVisitationLog.type == 1)
                          ? ""
                          : "",
                  width: 26,
                  height: 26,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<void> getProjectDetailAPI(String id) async {
    late Map<String, String> header;
    header = {
      HttpHeaders.authorizationHeader: Singleton.instance.authToken,
    };

    late Map<String, String> body;

    body = {
      ApiParamters.id: id,
    };

    final url = Uri.parse(ApiConstants.baseUrl +
        ApiConstants.baseUrlHost +
        ApiConstants.projectDetail +
        "?" +
        Uri(queryParameters: body).query);
    if (kDebugMode) {
      print("url$url");
    }

    Singleton.instance.showDefaultProgress();
    ApiService.getCallwithHeader(url, header, context).then((response) async {
      if (kDebugMode) {
        print(response);
      }
      final responseData = json.decode(response.body);
      try {
        if (kDebugMode) {
          print(responseData);
        }
        Singleton.instance.hideProgress();
        if (response.statusCode == 200) {
          objProjectDetail =
              ProjectDetailModel.fromJson(json.decode(response.body));

          arrVisitationLogs.clear();

          if (objProjectDetail
              .payload!.data![0].arrVisitationHistory!.isEmpty) {
            arrVisitationLogs = [];
          } else {
            arrVisitationLogs =
                objProjectDetail.payload!.data![0].arrVisitationHistory!;
          }

          objSalesData = objProjectDetail.payload!.data![0].objSales!;

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
