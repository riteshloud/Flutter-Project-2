import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:demo2/helpers/api_constant.dart';
import 'package:demo2/models/datewise_visitation_logs_model.dart';
import 'package:demo2/models/get_project_list_model.dart';
import 'package:demo2/service/api_service.dart';
import 'package:intl/intl.dart';

import '../../helpers/colors.dart';
import '../../helpers/constant.dart';
import '../../helpers/singleton.dart';
import '../../helpers/strings.dart';

class VisitationLogScreen extends StatefulWidget {
  final bool fromBottom;
  final Rows objSelectedProject;
  const VisitationLogScreen(this.fromBottom, this.objSelectedProject,
      {Key? key})
      : super(key: key);

  @override
  _VisitationLogScreenState createState() => _VisitationLogScreenState();
}

class _VisitationLogScreenState extends State<VisitationLogScreen> {
  List<VisitationDateObject> arrVisitationDates = [];

  @override
  void initState() {
    if (kDebugMode) {
      print("VISITATION LOGS INIT STATE CALLED");
    }

    Singleton.instance.isInternetConnected().then((intenet) {
      if (intenet) {
        getVisitationLogsList();
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: ColorCodes.backgroundColor,
        appBar: Singleton.instance.commonAppbar(
            appbarText: Strings.visitationScreen,
            leadingClickEvent: () {
              Navigator.pop(context, false);
            },
            hideBackbutton: !widget.fromBottom,
            backgroundColor: Colors.white,
            iconColor: Colors.black,
            endText: "",
            endTextClickEvent: () {}),
        body: Container(
          color: ColorCodes.backgroundColor,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: arrVisitationDates.isEmpty
              ? Center(
                  child: Text(
                    "No data available",
                    style: Singleton.instance.setTextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: TextSize.text_14,
                        textColor: ColorCodes.black),
                  ),
                )
              : visitationDateList(context),
        ),
      ),
    );
  }

  Widget visitationDateList(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 0, left: 0, right: 0, bottom: 0),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        var objVisitationDate = arrVisitationDates[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          // color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                objVisitationDate.date ?? "",
                style: Singleton.instance.setTextStyle(
                    fontSize: TextSize.text_14,
                    textColor: ColorCodes.lightBlack,
                    fontWeight: FontWeight.w700),
              ),
              visitationDataList(context, objVisitationDate),
            ],
          ),
        );
      },
      itemCount: arrVisitationDates.length,
    );
  }

  Widget visitationDataList(
      BuildContext context, VisitationDateObject objVisitationDate) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 0, left: 0, right: 0, bottom: 0),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return listTileWidget(
            context, objVisitationDate.arrVisitationLogs![index]);
      },
      itemCount: objVisitationDate.arrVisitationLogs!.length,
    );
  }

  Widget listTileWidget(
      BuildContext context, VisitationLogsObject objVisitationLog) {
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
                  child: (objVisitationLog.outletUrl ?? "").isEmpty
                      ? Singleton.instance.placeholderWidget(48, 48)
                      : CachedNetworkImage(
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

  // ******** API CALL ********
  Future<void> getVisitationLogsList() async {
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
          ApiConstants.visitationLogs +
          "?" +
          Uri(queryParameters: body).query);
    } else {
      url = Uri.parse(ApiConstants.baseUrl +
          ApiConstants.baseUrlHost +
          ApiConstants.visitationLogs);
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
          DatewiseVisitationLogsModel responseModel =
              DatewiseVisitationLogsModel.fromJson(json.decode(response.body));

          arrVisitationDates.clear();
          if (responseModel.payload!.arrVisitationDates != null) {
            if (responseModel.payload!.arrVisitationDates!.isNotEmpty) {
              arrVisitationDates = responseModel.payload!.arrVisitationDates!;
            } else {
              arrVisitationDates = [];
            }
          } else {
            arrVisitationDates = [];
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
