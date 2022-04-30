import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:demo2/database/db_helper.dart';
import 'package:demo2/screens/tabbar/sales_history_screen.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../screens/sales/add_sales_screen.dart';

import '../../helpers/api_constant.dart';
import '../../helpers/colors.dart';
import '../../helpers/constant.dart';
import '../../helpers/singleton.dart';
import '../../helpers/strings.dart';

import '../../models/coverage_model.dart';
import '../../models/get_project_list_model.dart';
import '../../models/outlet_detail_model.dart';
import '../../service/api_service.dart';
import '../../widgets/common_button.dart';

class OutletDetailScreen extends StatefulWidget {
  final Rows objSelectedProject;
  final OutletObject objselectedOutlet;
  final String outletDate;
  final String outletDay;
  const OutletDetailScreen(
      {Key? key,
      required this.objSelectedProject,
      required this.objselectedOutlet,
      required this.outletDate,
      required this.outletDay})
      : super(key: key);

  @override
  _OutletDetailScreenState createState() => _OutletDetailScreenState();
}

class _OutletDetailScreenState extends State<OutletDetailScreen> {
  OutletDetailModel outletDetailResponseModel = OutletDetailModel();
  List<EffectiveNonEffectiveDataObject> arrEffectiveData = [];
  List<EffectiveNonEffectiveDataObject> arrNonEffectiveData = [];
  List<EffectiveNonEffectiveDataObject> arrEffectiveDataDB = [];
  List<EffectiveNonEffectiveDataObject> arrNonEffectiveDataDB = [];

  int visitationID = 0;
  bool isCheckedIn = false;
  bool isAnyChange = false;

  final controller = TextEditingController();
  final node = FocusNode();
  int totalSoldQuantity = 0;

  @override
  void initState() {
    if (widget.objSelectedProject.id != null) {
      Singleton.instance.isInternetConnected().then((intenet) {
        if (intenet) {
          if (widget.objselectedOutlet.checkInStatus == "Visited") {
            visitationID = 0;
          } else {
            visitationID = widget.objselectedOutlet.visitationId ?? 0;
          }

          getOutletDetails(true);
        } else {
          getOutletDetailsFromDB();
        }
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (isAnyChange) {
          Navigator.pop(context, true);
        } else {
          Navigator.pop(context, false);
        }
        return true;
      },
      child: AnnotatedRegion(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
        ),
        child: Scaffold(
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                (!isCheckedIn)
                    ? !Singleton.instance.isInternet
                        ? Container()
                        : FloatingActionButton(
                            heroTag: Singleton.instance.getRandString(2),
                            backgroundColor: ColorCodes.lightRed,
                            //Floating action button on Scaffold
                            onPressed: () {},
                            child: Image.asset(
                              "",
                              width: 20,
                              height: 20,
                            ), //icon inside button
                          )
                    : (outletDetailResponseModel.payload!.checkInStatus ==
                            "Ongoing")
                        ? Column(
                            children: [
                              FloatingActionButton(
                                heroTag: Singleton.instance.getRandString(2),
                                backgroundColor: ColorCodes.lightRed,
                                //Floating action button on Scaffold
                                onPressed: () {},
                                child: const Icon(
                                  Icons.camera_alt_outlined,
                                  color: Colors.white,
                                  size: 24,
                                ), //icon inside button
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              FloatingActionButton(
                                heroTag: Singleton.instance.getRandString(1),
                                backgroundColor: ColorCodes.lightRed,
                                //Floating action button on Scaffold
                                onPressed: () async {
                                  //code to execute on button press

                                  bool isNeedToReload = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AddSalesScreen(
                                        objSelectedProject:
                                            widget.objSelectedProject,
                                        objselectedOutlet:
                                            widget.objselectedOutlet,
                                      ),
                                    ),
                                  );

                                  if (isNeedToReload) {
                                    Singleton.instance
                                        .isInternetConnected()
                                        .then((intenet) {
                                      if (intenet) {
                                        getOutletDetails(false);
                                      } else {
                                        getOutletDetailsFromDB();
                                      }
                                    });
                                  }
                                },
                                child: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 24,
                                ), //icon inside button
                              ),
                            ],
                          )
                        : Container(),
              ],
            ),
          ),
          body: Container(
            color: ColorCodes.backgroundColor,
            child: Column(
              children: [
                headerLayout(),
                const SizedBox(
                  height: 4,
                ),
                bottomContainer()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget timerSet() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
      color: ColorCodes.primary,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Start time : ${(outletDetailResponseModel.payload!.startTime ?? "").toUpperCase()}",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Singleton.instance.setTextStyle(
                fontSize: TextSize.text_14,
                fontWeight: FontWeight.w600,
                textColor: Colors.white),
          ),
          Text(
            "End time : ${(outletDetailResponseModel.payload!.endTime ?? "").toUpperCase()}",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Singleton.instance.setTextStyle(
                fontSize: TextSize.text_14,
                fontWeight: FontWeight.w600,
                textColor: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget headerLayout() {
    return Card(
      margin: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      elevation: 2,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.only(left: 5, top: 45, bottom: 20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Visibility(
                      child: GestureDetector(
                        onTap: () {
                          if (isAnyChange) {
                            Navigator.pop(context, true);
                          } else {
                            Navigator.pop(context, false);
                          }
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
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: (widget.objselectedOutlet.outletUrl ?? "")
                                  .isEmpty ||
                              (!Singleton.instance.isInternet)
                          ? Singleton.instance.placeholderWidget(48, 48)
                          : CachedNetworkImage(
                              imageUrl:
                                  widget.objselectedOutlet.outletUrl ?? "",
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
                      width: 16,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.objselectedOutlet.outletName ?? "",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Singleton.instance.setTextStyle(
                              fontSize: TextSize.text_16,
                              fontWeight: FontWeight.w600,
                              textColor: ColorCodes.black),
                        ),
                        Text(
                          DateFormat("dd MMM yyyy").format(
                              DateTime.parse(DateTime.now().toString())),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Singleton.instance.setTextStyle(
                              fontSize: TextSize.text_14,
                              fontWeight: FontWeight.w400,
                              textColor: ColorCodes.lightBlack),
                        )
                      ],
                    )
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 24,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 45),
              child: Singleton.instance.dividerWTOPAC(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 10.0,
                      left: 43,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          Strings.totalEffectiveContact.toUpperCase(),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Singleton.instance.setTextStyle(
                              fontSize: TextSize.text_12,
                              fontWeight: FontWeight.w700,
                              textColor: ColorCodes.lightBlack),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          (Singleton.instance.isInternet)
                              ? (outletDetailResponseModel.payload == null)
                                  ? "-"
                                  : outletDetailResponseModel
                                      .payload!.effectiveCount
                                      .toString()
                              : arrEffectiveDataDB.length.toString(),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Singleton.instance.setTextStyle(
                              fontSize: TextSize.text_24,
                              fontWeight: FontWeight.w600,
                              textColor: ColorCodes.primary),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Container(
                  color: ColorCodes.dividerShade,
                  width: 2,
                  height: MediaQuery.of(context).size.height * 0.1,
                ),
                const SizedBox(
                  width: 5,
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0, right: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          Strings.totalPackSold.toUpperCase(),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Singleton.instance.setTextStyle(
                              fontSize: TextSize.text_12,
                              fontWeight: FontWeight.w700,
                              textColor: ColorCodes.lightBlack),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          (Singleton.instance.isInternet)
                              ? (outletDetailResponseModel.payload == null)
                                  ? "-"
                                  : outletDetailResponseModel.payload!.totalSold
                                      .toString()
                              : totalSoldQuantity.toString(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Singleton.instance.setTextStyle(
                              fontSize: TextSize.text_24,
                              fontWeight: FontWeight.w600,
                              textColor: ColorCodes.black),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget bottomContainer() {
    return Expanded(
        child: SingleChildScrollView(
      padding: EdgeInsets.zero,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (Singleton.instance.isInternet)
              Container(
                alignment: Alignment.centerLeft,
                width: double.maxFinite,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: ColorCodes.lightYellowColor),
                child: GestureDetector(
                  onTap: () {
                    if (Singleton.instance.isInternet) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SalesHistoryScreen(
                              false, widget.objSelectedProject),
                        ),
                      );
                    }
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Strings.salesHistoryScreen,
                        style: Singleton.instance.setTextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: TextSize.text_14,
                            textColor: ColorCodes.buttonTextColor),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Text(
                        Strings.viewNow,
                        style: Singleton.instance.setTextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: TextSize.text_14,
                            textColor: ColorCodes.buttonTextColor),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Effective Contact"
                      .toUpperCase(), //Strings.effectivecontact.toUpperCase(),
                  style: Singleton.instance.setTextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: TextSize.text_13,
                      textColor: ColorCodes.lightBlack),
                ),
                if (arrEffectiveData.isNotEmpty)
                  GestureDetector(
                    onTap: () async {},
                    child: Text(
                      Strings.viewAll,
                      style: Singleton.instance.setTextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: TextSize.text_13,
                          textColor: ColorCodes.primary),
                    ),
                  ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            arrEffectiveData.isNotEmpty
                ? effectiveListview()
                : Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 20),
                    child: Text(
                      Strings.noRecord,
                      style: Singleton.instance.setTextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: TextSize.text_16,
                          textColor: ColorCodes.lightBlack),
                    ),
                  ),
            const SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Smoker Contact"
                      .toUpperCase(), //Strings.noneffectivecontact.toUpperCase(),
                  style: Singleton.instance.setTextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: TextSize.text_13,
                      textColor: ColorCodes.lightBlack),
                ),
                if (arrNonEffectiveData.isNotEmpty)
                  GestureDetector(
                    onTap: () async {},
                    child: Text(
                      Strings.viewAll,
                      style: Singleton.instance.setTextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: TextSize.text_13,
                          textColor: ColorCodes.primary),
                    ),
                  ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            arrNonEffectiveData.isNotEmpty
                ? noneffectiveListview()
                : Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 20),
                    child: Text(
                      Strings.noRecord,
                      style: Singleton.instance.setTextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: TextSize.text_16,
                          textColor: ColorCodes.lightBlack),
                    ),
                  ),
            const SizedBox(
              height: 26,
            ),
            (!isCheckedIn)
                ? checkInButton()
                : (outletDetailResponseModel.payload!.checkInStatus ==
                        "Ongoing")
                    ? checkOutButton()
                    : (outletDetailResponseModel.payload!.checkInStatus ==
                            "Visited")
                        ? Container()
                        : checkInButton(),
            const SizedBox(
              height: 16,
            ),
          ],
        ),
      ),
    ));
  }

  Widget effectiveListview() {
    return ListView.builder(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return effectiveListTile(arrEffectiveData[index]);
      },
      itemCount: arrEffectiveData.length,
    );
  }

  Widget effectiveListTile(EffectiveNonEffectiveDataObject item) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18), color: Colors.white),
      child: Column(
        children: [
          (item.arrProducts!.isEmpty)
              ? Container()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          var objProduct = item.arrProducts![index];

                          return Text(
                            (objProduct.productName ?? "") +
                                " x " +
                                objProduct.quantity.toString(),
                            style: Singleton.instance.setTextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: TextSize.text_12,
                                textColor: ColorCodes.black),
                          );
                        },
                        itemCount: item.arrProducts!.length,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          DateFormat("dd/MM/yyyy")
                              .format(DateTime.parse(item.createdAt ?? "")),
                          style: Singleton.instance.setTextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: TextSize.text_10,
                              textColor: ColorCodes.lightBlack),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          DateFormat("hh:mm a").format(DateTime.parse(
                              DateFormat("yyyy-MM-ddTHH:mm:ssZ")
                                  .parse(item.createdAt!, true)
                                  .toLocal()
                                  .toString())),
                          style: Singleton.instance.setTextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: TextSize.text_10,
                              textColor: ColorCodes.lightBlack),
                        ),
                      ],
                    )
                  ],
                ),
          (item.arrProducts!.isEmpty)
              ? Container()
              : const SizedBox(
                  height: 4,
                ),
          (item.arrProducts!.isEmpty)
              ? Container()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total: RM ${(item.orderTotalAmount ?? 0.0).toPrecision(2)}"
                          .replaceAll(Singleton.instance.regex, ""),
                      style: Singleton.instance.setTextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: TextSize.text_13,
                          textColor: ColorCodes.primary),
                    ),
                    (item.isNextDay! == false)
                        ? GestureDetector(
                            onTap: () async {
                              var isWantToDelete = await Singleton.instance
                                  .showAlertDialogWithTwoOptions(
                                      context,
                                      Constant.appName,
                                      "Are you sure you want to cancel this sales?",
                                      "Yes",
                                      "No");

                              if (isWantToDelete == true) {
                                Singleton.instance
                                    .isInternetConnected()
                                    .then((intenet) {
                                  if (intenet) {
                                    cancelSales(item.id.toString());
                                  } else {
                                    cancelSalesInDB(item);
                                  }
                                });
                              }
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width / 5.5,
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24),
                                  color: ColorCodes.red),
                              child: Text(
                                (item.isNextDay! == false) ? "Void" : "-",
                                style: Singleton.instance.setTextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: TextSize.text_10,
                                    textColor: Colors.white),
                              ),
                            ),
                          )
                        : Container()
                  ],
                ),
          ((item.effectiveName ?? "").isEmpty &&
                      (item.effectivecontact ?? "").isEmpty) ||
                  (item.arrProducts!.isEmpty)
              ? Container()
              : const SizedBox(
                  height: 10,
                ),
          ((item.effectiveName ?? "").isEmpty &&
                      (item.effectivecontact ?? "").isEmpty) ||
                  (item.arrProducts!.isEmpty)
              ? Container()
              : Singleton.instance.dividerWTOPAC(),
          ((item.effectiveName ?? "").isEmpty &&
                      (item.effectivecontact ?? "").isEmpty) ||
                  (item.arrProducts!.isEmpty)
              ? Container()
              : const SizedBox(
                  height: 10,
                ),
          ((item.effectiveName ?? "").isEmpty &&
                  (item.effectivecontact ?? "").isEmpty)
              ? Container()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          (((item.effectiveName ?? "").isEmpty &&
                                  (item.effectivecontact ?? "").isEmpty))
                              ? ""
                              : (((item.effectiveName ?? "").isNotEmpty &&
                                      (item.effectivecontact ?? "").isEmpty))
                                  ? (item.effectiveName ?? "")
                                  : (((item.effectiveName ?? "").isEmpty &&
                                          (item.effectivecontact ?? "")
                                              .isNotEmpty))
                                      ? (item.effectivecontact ?? "")
                                      : (item.effectiveName ?? "") +
                                          " (" +
                                          item.effectivecontact.toString() +
                                          ")",
                          style: Singleton.instance.setTextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: TextSize.text_13,
                              textColor: ColorCodes.lightBlack),
                        ),
                        if ((item.effectiveEmail ?? "").isNotEmpty)
                          Text(
                            item.effectiveEmail ?? "",
                            style: Singleton.instance.setTextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: TextSize.text_13,
                                textColor: ColorCodes.lightBlack),
                          ),
                      ],
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          color: ColorCodes.primary),
                      child: Text(
                        (item.isVerified == 0) ? "Not Verified" : "Verified",
                        style: Singleton.instance.setTextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: TextSize.text_10,
                            textColor: Colors.white),
                      ),
                    )
                  ],
                )
        ],
      ),
    );
  }

  Widget noneffectiveListview() {
    return ListView.builder(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return noneffectiveListTile(arrNonEffectiveData[index]);
      },
      itemCount: arrNonEffectiveData.length,
    );
  }

  Widget noneffectiveListTile(EffectiveNonEffectiveDataObject item) {
    String gender = "Gender: ";
    gender = gender + (item.gender ?? " ");

    String ageGroup = "Age Group: ";
    ageGroup = ageGroup + (item.ageGroup ?? " ");

    String groupSegment = "Group Segment: ";
    groupSegment = groupSegment + (item.groupSegment ?? " ");

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18), color: Colors.white),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      gender,
                      style: Singleton.instance.setTextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: TextSize.text_14,
                        textColor: Colors.black,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Text(
                        ageGroup,
                        style: Singleton.instance.setTextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: TextSize.text_14,
                          textColor: Colors.black,
                        ),
                      ),
                    ),
                    Text(
                      groupSegment,
                      style: Singleton.instance.setTextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: TextSize.text_14,
                        textColor: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                // mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    DateFormat("dd/MM/yyyy")
                        .format(DateTime.parse(item.createdAt ?? "")),
                    style: Singleton.instance.setTextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: TextSize.text_10,
                        textColor: ColorCodes.lightBlack),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    DateFormat("hh:mm a").format(DateTime.parse(
                        DateFormat("yyyy-MM-ddTHH:mm:ssZ")
                            .parse(item.createdAt!, true)
                            .toLocal()
                            .toString())),
                    style: Singleton.instance.setTextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: TextSize.text_10,
                        textColor: ColorCodes.lightBlack),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(
            height: 4,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              (item.isNextDay! == false)
                  ? GestureDetector(
                      onTap: () async {
                        var isWantToDelete = await Singleton.instance
                            .showAlertDialogWithTwoOptions(
                                context,
                                Constant.appName,
                                "Are you sure you want to delete this contact?",
                                "Yes",
                                "No");

                        if (isWantToDelete == true) {
                          Singleton.instance
                              .isInternetConnected()
                              .then((intenet) {
                            if (intenet) {
                              cancelSales(item.id.toString());
                            } else {
                              cancelSalesInDB(item);
                            }
                          });
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width / 5.5,
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            color: ColorCodes.red),
                        child: Text(
                          (item.isNextDay! == false) ? "Void" : "-",
                          style: Singleton.instance.setTextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: TextSize.text_10,
                              textColor: Colors.white),
                        ),
                      ),
                    )
                  : Container()
            ],
          ),
          ((item.effectiveName ?? "").isEmpty &&
                  (item.effectivecontact ?? "").isEmpty)
              ? Container()
              : const SizedBox(
                  height: 10,
                ),
          ((item.effectiveName ?? "").isEmpty &&
                  (item.effectivecontact ?? "").isEmpty)
              ? Container()
              : Singleton.instance.dividerWTOPAC(),
          ((item.effectiveName ?? "").isEmpty &&
                  (item.effectivecontact ?? "").isEmpty)
              ? Container()
              : const SizedBox(
                  height: 10,
                ),
          ((item.effectiveName ?? "").isEmpty &&
                  (item.effectivecontact ?? "").isEmpty)
              ? Container()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          (((item.effectiveName ?? "").isEmpty &&
                                  (item.effectivecontact ?? "").isEmpty))
                              ? ""
                              : (((item.effectiveName ?? "").isNotEmpty &&
                                      (item.effectivecontact ?? "").isEmpty))
                                  ? (item.effectiveName ?? "")
                                  : (((item.effectiveName ?? "").isEmpty &&
                                          (item.effectivecontact ?? "")
                                              .isNotEmpty))
                                      ? (item.effectivecontact ?? "")
                                      : (item.effectiveName ?? "") +
                                          " (" +
                                          item.effectivecontact.toString() +
                                          ")",
                          style: Singleton.instance.setTextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: TextSize.text_13,
                              textColor: ColorCodes.lightBlack),
                        ),
                        if ((item.effectiveEmail ?? "").isNotEmpty)
                          Text(
                            item.effectiveEmail ?? "",
                            style: Singleton.instance.setTextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: TextSize.text_13,
                                textColor: ColorCodes.lightBlack),
                          ),
                      ],
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          color: ColorCodes.primary),
                      child: Text(
                        (item.isVerified == 0) ? "Not Verified" : "Verified",
                        style: Singleton.instance.setTextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: TextSize.text_10,
                            textColor: Colors.white),
                      ),
                    )
                  ],
                )
        ],
      ),
    );
  }

  Widget checkInButton() {
    return Align(
      alignment: Alignment.center,
      child: CommonButton(
        onPressed: () {
          _submitCheckInOutRequest();
        },
        width: MediaQuery.of(context).size.width / 2,
        backgroundColor: ColorCodes.primary,
        textColor: Colors.white,
        title: Strings.checkIn,
        setFillColor: true,
      ),
    );
  }

  Widget checkOutButton() {
    return Align(
      alignment: Alignment.center,
      child: CommonButton(
        onPressed: () {
          _submitCheckInOutRequest();
        },
        width: MediaQuery.of(context).size.width / 2,
        backgroundColor: ColorCodes.red,
        textColor: Colors.white,
        title: Strings.checkout,
        setFillColor: true,
      ),
    );
  }

  void _submitCheckInOutRequest() {
    String currentDay = DateFormat('EEEE').format(DateTime.now());

    if (outletDetailResponseModel.payload!.checkInStatus == null ||
        outletDetailResponseModel.payload!.checkInStatus == "Visited") {
      if (widget.objselectedOutlet.day == currentDay.toLowerCase() ||
          widget.objselectedOutlet.day == "others") {
        Singleton.instance.isInternetConnected().then((intenet) {
          if (intenet) {
            changeOutletStatus(0, false, ""); //CHECK IN
          } else {
            changeOutletStatusFromDB(0);
          }
        });
      } else {
        DateTime outletDate = DateTime.parse(widget.outletDate);
        DateTime currentDate = DateTime.now();
        bool? isBefore = outletDate.isBefore(currentDate);

        if (widget.objselectedOutlet.day == "others") {
          Singleton.instance.isInternetConnected().then((intenet) {
            if (intenet) {
              changeOutletStatus(0, false, ""); //CHECK IN
            } else {
              changeOutletStatusFromDB(0);
            }
          });
        } else {
          Singleton.instance.showAlertDialogWithReasonInput(
              context,
              "",
              isBefore
                  ? "Enter reason for past Check-In"
                  : "Enter reason for future Check-In",
              "OK",
              "Cancel",
              controller,
              node,
              positiveButtonClicked);
        }
      }
    } else {
      Singleton.instance.isInternetConnected().then((intenet) {
        if (intenet) {
          changeOutletStatus(1, false, ""); //CHECK OUT
        } else {
          changeOutletStatusFromDB(1);
        }
      });
    }
  }

  void positiveButtonClicked() {
    if (controller.text.isEmpty) {
      Singleton.instance.showAlertDialogWithOkAction(
          context, Constant.alert, "Please enter reason for past checkin.");
    } else {
      Navigator.of(context).pop();
      changeOutletStatus(0, true, controller.text); //CHECK IN
    }
  }

  void getOutletDetailsFromDB() async {
    List<Map<String, dynamic>> arrOutletDetailsDB =
        await DBHelper.getDataWithOutletIDandProjectIDLatestRecord(
            Strings.tableProjectOutletDetail,
            widget.objselectedOutlet.id.toString(),
            widget.objSelectedProject.id.toString());

    var objOutletDetailDB = arrOutletDetailsDB[0];
    outletDetailResponseModel = OutletDetailModel();

    outletDetailResponseModel.payloadData = OutletDetailPayload();
    outletDetailResponseModel.payload!.totalSoldData =
        objOutletDetailDB['totalSold'];
    outletDetailResponseModel.payload!.effectiveCountData =
        objOutletDetailDB['effectiveCount'];
    outletDetailResponseModel.payload!.checkInStatusData =
        objOutletDetailDB['checkInStatus'];
    if (outletDetailResponseModel.payload!.checkInStatus == null ||
        outletDetailResponseModel.payload!.checkInStatus == "Visited") {
      isCheckedIn = false;
    } else {
      isCheckedIn = true;
    }

    outletDetailResponseModel.payload!.visitationIdData =
        objOutletDetailDB['visitationId'];
    if (outletDetailResponseModel.payload!.visitationId == null) {
      visitationID = 0;
    } else {
      visitationID = outletDetailResponseModel.payload!.visitationId!;
    }

    widget.objselectedOutlet.visitationIds = visitationID;

    arrEffectiveData.clear();
    arrNonEffectiveData.clear();

    arrEffectiveDataDB.clear();
    arrNonEffectiveDataDB.clear();

    //OUTLET CONTACT DATA
    List<Map<String, dynamic>> arrOutletContactsDataDB =
        await DBHelper.getAllDataWithOutletIDandProjectIDandVisitationID(
            Strings.tableOutletContacts,
            widget.objselectedOutlet.id.toString(),
            widget.objSelectedProject.id.toString(),
            outletDetailResponseModel.payload!.visitationId.toString());

    //OUTLET CONTACT SALES DATA
    List<Map<String, dynamic>> arrOutletContactSalesDB =
        await DBHelper.getDataWithOutletIDandProjectID(
            Strings.tableOutletContactSales,
            widget.objselectedOutlet.id.toString(),
            widget.objSelectedProject.id.toString());

    for (int i = 0; i < arrOutletContactsDataDB.length; i++) {
      Map<String, dynamic> dictContact = arrOutletContactsDataDB[i];

      bool isNextDay = false;
      String createdAt = dictContact['createdAt'];
      DateTime startDate = DateTime.parse(createdAt).toLocal();
      DateTime dtEnd = startDate.add(const Duration(days: 1));

      DateTime endDate =
          DateTime(dtEnd.year, dtEnd.month, dtEnd.day, 06, 00, 00, 00, 00);

      bool? isSame = endDate.isBefore(startDate);
      isNextDay = isSame;

      if (dictContact['isEffective'] == 1) {
        List<ProductDataObject> arrProducts = [];
        for (int j = 0; j < arrOutletContactSalesDB.length; j++) {
          Map<String, dynamic> dictContactSales = arrOutletContactSalesDB[j];
          ProductDataObject objProduct = ProductDataObject(
            id: dictContactSales['id'],
            outletId: dictContactSales['outletId'],
            projectId: dictContactSales['projectId'],
            visitationId: dictContactSales['visitationId'],
            orderId: dictContactSales['orderId'],
            productId: dictContactSales['productId'],
            amount: (dictContactSales['amount'] is int)
                ? dictContactSales['amount'].toDouble()
                : dictContactSales['amount'],
            quantity: dictContactSales['quantity'],
            totalAmount: (dictContactSales['totalAmount'] is int)
                ? dictContactSales['totalAmount'].toDouble()
                : dictContactSales['totalAmount'],
            isOutletStock: dictContactSales['isOutletStock'],
            createdAt: dictContactSales['createdAt'],
            updatedAt: dictContactSales['updatedAt'],
            productName: dictContactSales['productName'],
          );

          if (objProduct.orderId == dictContact['id']) {
            arrProducts.add(objProduct);
          }
        }

        EffectiveNonEffectiveDataObject objEffectiveContact =
            EffectiveNonEffectiveDataObject(
          id: dictContact['id'],
          outletId: dictContact['outletId'],
          projectId: dictContact['projectId'],
          visitationId: dictContact['visitationId'],
          userId: dictContact['userId'],
          status: dictContact['status'],
          isEffective: dictContact['isEffective'],
          isFree: dictContact['isFree'],
          isVerified: dictContact['isVerified'],
          description: dictContact['description'],
          gender: dictContact['gender'],
          ageGroup: dictContact['ageGroup'],
          groupSegment: dictContact['groupSegment'],
          effectiveName: dictContact['effectiveName'],
          effectiveEmail: dictContact['effectiveEmail'],
          effectivecontact: dictContact['effectivecontact'],
          createdAt: dictContact['createdAt'],
          updatedAt: dictContact['updatedAt'],
          orderTotalAmount: (dictContact['orderTotalAmount'] is int)
              ? dictContact['orderTotalAmount'].toDouble()
              : dictContact['orderTotalAmount'],
          isNextDay: isNextDay,
          arrProducts: arrProducts,
        );

        if (objEffectiveContact.status == 1) {
          arrEffectiveDataDB.add(objEffectiveContact);
        }
      } else {
        List<ProductDataObject> arrProducts = [];
        for (int j = 0; j < arrOutletContactSalesDB.length; j++) {
          Map<String, dynamic> dictContactSales = arrOutletContactSalesDB[j];
          ProductDataObject objProduct = ProductDataObject(
            id: dictContactSales['id'],
            outletId: dictContactSales['outletId'],
            projectId: dictContactSales['projectId'],
            visitationId: dictContactSales['visitationId'],
            orderId: dictContactSales['orderId'],
            productId: dictContactSales['productId'],
            amount: (dictContactSales['amount'] is int)
                ? dictContactSales['amount'].toDouble()
                : dictContactSales['amount'],
            quantity: dictContactSales['quantity'],
            totalAmount: (dictContactSales['totalAmount'] is int)
                ? dictContactSales['totalAmount'].toDouble()
                : dictContactSales['totalAmount'],
            isOutletStock: dictContactSales['isOutletStock'],
            createdAt: dictContactSales['createdAt'],
            updatedAt: dictContactSales['updatedAt'],
            productName: dictContactSales['productName'],
          );
          if (objProduct.orderId == dictContact['id']) {
            arrProducts.add(objProduct);
          }
        }

        EffectiveNonEffectiveDataObject objNonEffectiveContact =
            EffectiveNonEffectiveDataObject(
          id: dictContact['id'],
          outletId: dictContact['outletId'],
          projectId: dictContact['projectId'],
          visitationId: dictContact['visitationId'],
          userId: dictContact['userId'],
          status: dictContact['status'],
          isEffective: dictContact['isEffective'],
          isFree: dictContact['isFree'],
          isVerified: dictContact['isVerified'],
          description: dictContact['description'],
          gender: dictContact['gender'],
          ageGroup: dictContact['ageGroup'],
          groupSegment: dictContact['groupSegment'],
          effectiveName: dictContact['effectiveName'],
          effectiveEmail: dictContact['effectiveEmail'],
          effectivecontact: dictContact['effectivecontact'],
          createdAt: dictContact['createdAt'],
          updatedAt: dictContact['updatedAt'],
          orderTotalAmount: (dictContact['orderTotalAmount'] is int)
              ? dictContact['orderTotalAmount'].toDouble()
              : dictContact['orderTotalAmount'],
          isNextDay: isNextDay,
          arrProducts: arrProducts,
        );

        if (objNonEffectiveContact.status == 1) {
          arrNonEffectiveDataDB.add(objNonEffectiveContact);
        }
      }
    }

    totalSoldQuantity = 0;
    for (int j = 0; j < arrEffectiveDataDB.length; j++) {
      EffectiveNonEffectiveDataObject objSales = arrEffectiveDataDB[j];

      for (int k = 0; k < objSales.arrProducts!.length; k++) {
        ProductDataObject objProduct = objSales.arrProducts![k];
        totalSoldQuantity = totalSoldQuantity + (objProduct.quantity ?? 0);
      }
    }
    if (kDebugMode) {
      print(totalSoldQuantity);
    }

    arrEffectiveDataDB.sort((a, b) =>
        DateTime.parse(b.createdAt!).compareTo(DateTime.parse(a.createdAt!)));
    if (arrEffectiveDataDB.length >= 5) {
      arrEffectiveData = arrEffectiveDataDB.take(5).toList();
    } else {
      arrEffectiveData = arrEffectiveDataDB;
    }

    arrNonEffectiveDataDB.sort((a, b) =>
        DateTime.parse(b.createdAt!).compareTo(DateTime.parse(a.createdAt!)));
    if (arrNonEffectiveDataDB.length >= 5) {
      arrNonEffectiveData = arrNonEffectiveDataDB.take(5).toList();
    } else {
      arrNonEffectiveData = arrNonEffectiveDataDB;
    }

    setState(() {});
  }

  void cancelSalesInDB(EffectiveNonEffectiveDataObject objSales) {
    Map<String, dynamic> dictSales = {};
    dictSales['id'] = objSales.id;
    dictSales['outletId'] = objSales.outletId;
    dictSales['projectId'] = objSales.projectId;
    dictSales['visitationId'] = objSales.visitationId;
    dictSales['userId'] = objSales.userId;
    dictSales['status'] = 2;
    dictSales['isEffective'] = objSales.isEffective;
    dictSales['isFree'] = objSales.isFree;
    dictSales['isVerified'] = objSales.isVerified;
    dictSales['description'] = objSales.description;
    dictSales['gender'] = objSales.gender;
    dictSales['ageGroup'] = objSales.ageGroup;
    dictSales['groupSegment'] = objSales.groupSegment;
    dictSales['effectiveName'] = objSales.effectiveName;
    dictSales['effectiveEmail'] = objSales.effectiveEmail;
    dictSales['effectivecontact'] = objSales.effectivecontact;
    dictSales['createdAt'] = objSales.createdAt;
    dictSales['updatedAt'] = objSales.updatedAt;
    dictSales['orderTotalAmount'] = objSales.orderTotalAmount;
    dictSales['is_offline'] = 1;

    DBHelper.updateData(Strings.tableOutletContacts, objSales.id ?? 0,
        objSales.outletId ?? 0, objSales.projectId ?? 0, dictSales);
    getOutletDetailsFromDB();
  }

  Future<void> changeOutletStatusFromDB(int status) async {
    int visitID = 0;

    if ((widget.objselectedOutlet.visitationId ?? 0) <= 0) {
      visitID = Singleton.instance.randomDigits(4);
    } else {
      visitID = widget.objselectedOutlet.visitationId!;
    }

    Map<String, dynamic> dictOutletDetail = {};
    dictOutletDetail['outletId'] = widget.objselectedOutlet.id;
    dictOutletDetail['projectId'] = widget.objSelectedProject.id;
    dictOutletDetail['totalSold'] =
        outletDetailResponseModel.payload!.totalSold;
    dictOutletDetail['effectiveCount'] =
        outletDetailResponseModel.payload!.effectiveCount;
    dictOutletDetail['visitationId'] = visitID;
    dictOutletDetail['checkInStatus'] = (status == 0) ? "Ongoing" : "Visited";
    dictOutletDetail['is_offline'] = 1;

    if ((widget.objselectedOutlet.visitationId ?? 0) <= 0) {
      await DBHelper.updateOutletDetailData(
          Strings.tableProjectOutletDetail,
          widget.objselectedOutlet.id ?? 0,
          widget.objSelectedProject.id ?? 0,
          dictOutletDetail);
    } else {
      await DBHelper.updateOutletDetailDataWithVisitationID(
          Strings.tableProjectOutletDetail,
          widget.objselectedOutlet.id ?? 0,
          widget.objSelectedProject.id ?? 0,
          visitID.toString(),
          dictOutletDetail);
    }

    isAnyChange = true;
    if (outletDetailResponseModel.payload!.visitationId != null) {
      visitationID = outletDetailResponseModel.payload!.visitationId ?? 0;
      widget.objselectedOutlet.visitationIds = visitationID;
    }

    //UPDATE PROJECT OUTLET STATUS
    Map<String, dynamic> dictOutlet = {};
    dictOutlet['id'] = widget.objselectedOutlet.id;
    dictOutlet['outletUrl'] = widget.objselectedOutlet.outletUrl;
    dictOutlet['address'] = widget.objselectedOutlet.address;
    dictOutlet['outletName'] = widget.objselectedOutlet.outletName;
    dictOutlet['outletEmail'] = widget.objselectedOutlet.outletEmail;
    dictOutlet['outletContact'] = widget.objselectedOutlet.outletContact;
    dictOutlet['ownerName'] = widget.objselectedOutlet.ownerName;
    dictOutlet['ownerEmail'] = widget.objselectedOutlet.ownerEmail;
    dictOutlet['ownerContact'] = widget.objselectedOutlet.ownerContact;
    dictOutlet['personName'] = widget.objselectedOutlet.personName;
    dictOutlet['personEmail'] = widget.objselectedOutlet.personEmail;
    dictOutlet['personContact'] = widget.objselectedOutlet.personContact;
    dictOutlet['status'] = widget.objselectedOutlet.status;
    dictOutlet['createdAt'] = widget.objselectedOutlet.createdAt;
    dictOutlet['updatedAt'] =
        (DateTime.now().toUtc().toString().replaceAll(' ', 'T'));
    dictOutlet['checkInStatus'] = (status == 0) ? "Ongoing" : "Visited";
    dictOutlet['visitationId'] = visitID;
    dictOutlet['day'] = widget.objselectedOutlet.day;
    dictOutlet['projectId'] = widget.objSelectedProject.id;
    dictOutlet['is_offline'] = 1;

    if ((widget.objselectedOutlet.visitationId ?? 0) <= 0) {
      DBHelper.updateProjectOutletData(
          Strings.tableProjectOutlets,
          widget.objselectedOutlet.id ?? 0,
          widget.objSelectedProject.id ?? 0,
          dictOutlet);
    } else {
      DBHelper.updateProjectOutletDataWithVisitationID(
          Strings.tableProjectOutlets,
          widget.objselectedOutlet.id ?? 0,
          widget.objSelectedProject.id ?? 0,
          visitID.toString(),
          dictOutlet);
    }

    if (status == 0) {
      Singleton.instance.showAlertDialogWithOkAction(
          context, Constant.alert, "Check-In successfully!");
    } else {
      Singleton.instance.showAlertDialogWithOkAction(
          context, Constant.alert, "Check-Out successfully!");
    }

    if (dictOutletDetail['checkInStatus'] == "Visited") {
      //ADD NEW OUTLET DETAIL RECORD WITH NEW VISITATION ID

      int number = Singleton.instance.randomDigits(4);
      DBHelper.insert(Strings.tableProjectOutletDetail, {
        DBHelper.outletId: widget.objselectedOutlet.id,
        DBHelper.projectId: widget.objSelectedProject.id,
        DBHelper.totalSold: 0,
        DBHelper.effectiveCount: 0,
        DBHelper.visitationId: number,
        DBHelper.checkInStatus: null,
        DBHelper.isOffline: 1,
        DBHelper.createdAt:
            (DateTime.now().toUtc().toString().replaceAll(' ', 'T')),
        DBHelper.updatedAt:
            (DateTime.now().toUtc().toString().replaceAll(' ', 'T')),
      });

      DBHelper.insert(Strings.tableProjectOutlets, {
        DBHelper.id: widget.objselectedOutlet.id,
        DBHelper.outletUrl: widget.objselectedOutlet.outletUrl,
        DBHelper.address: widget.objselectedOutlet.address,
        DBHelper.outletName: widget.objselectedOutlet.outletName,
        DBHelper.outletEmail: widget.objselectedOutlet.outletEmail,
        DBHelper.outletContact: widget.objselectedOutlet.outletContact,
        DBHelper.ownerName: widget.objselectedOutlet.ownerName,
        DBHelper.ownerEmail: widget.objselectedOutlet.ownerEmail,
        DBHelper.ownerContact: widget.objselectedOutlet.ownerContact,
        DBHelper.personName: widget.objselectedOutlet.personName,
        DBHelper.personEmail: widget.objselectedOutlet.personEmail,
        DBHelper.personContact: widget.objselectedOutlet.personContact,
        DBHelper.status: widget.objselectedOutlet.status,
        DBHelper.createdAt:
            (DateTime.now().toUtc().toString().replaceAll(' ', 'T')),
        DBHelper.updatedAt:
            (DateTime.now().toUtc().toString().replaceAll(' ', 'T')),
        DBHelper.projectId: widget.objSelectedProject.id,
        DBHelper.checkInStatus: "Visited",
        DBHelper.visitationId: number,
        DBHelper.day: widget.objselectedOutlet.day,
        DBHelper.isOffline: 1,
      });
    }

    getOutletDetailsFromDB();
  }

  // ******** API CALL ********
  Future<void> getOutletDetails(bool isWantToShowProgress) async {
    late Map<String, String> header;
    header = {
      HttpHeaders.authorizationHeader: Singleton.instance.authToken,
    };

    late Map<String, String> body;
    if (visitationID <= 0) {
      body = {
        ApiParamters.projectID: widget.objSelectedProject.id.toString(),
        ApiParamters.outletId: widget.objselectedOutlet.id.toString(),
        ApiParamters.day: widget.objselectedOutlet.day ?? "",
      };
    } else {
      body = {
        ApiParamters.projectID: widget.objSelectedProject.id.toString(),
        ApiParamters.outletId: widget.objselectedOutlet.id.toString(),
        ApiParamters.visitationId: visitationID.toString(),
        ApiParamters.day: widget.objselectedOutlet.day ?? "",
      };
    }

    final url = Uri.parse(ApiConstants.baseUrl +
        ApiConstants.baseUrlHost +
        ApiConstants.outletDetail);
    if (kDebugMode) {
      print("url$url");
    }

    if (isWantToShowProgress) {
      Singleton.instance.showDefaultProgress();
    }
    ApiService.postCallwithHeader(url, body, header, context).then((response) {
      final responseData = json.decode(response.body);
      try {
        if (kDebugMode) {
          print(responseData);
          print("statuscode ${response.statusCode}");
        }
        Singleton.instance.hideProgress();
        if (response.statusCode == 200) {
          outletDetailResponseModel =
              OutletDetailModel.fromJson(json.decode(response.body));

          if (outletDetailResponseModel.payload!.checkInStatus == null ||
              outletDetailResponseModel.payload!.checkInStatus == "Visited") {
            isCheckedIn = false;
          } else {
            isCheckedIn = true;
          }

          if (outletDetailResponseModel.payload!.visitationId == null) {
            visitationID = 0;
          } else {
            visitationID = outletDetailResponseModel.payload!.visitationId!;
          }

          arrEffectiveData.clear();
          arrNonEffectiveData.clear();

          if (outletDetailResponseModel.payload!.arrEffectiveData!.isEmpty) {
            arrEffectiveData = [];
          } else {
            arrEffectiveData =
                outletDetailResponseModel.payload!.arrEffectiveData!;
          }

          if (outletDetailResponseModel.payload!.arrNonEffectiveData!.isEmpty) {
            arrNonEffectiveData = [];
          } else {
            arrNonEffectiveData =
                outletDetailResponseModel.payload!.arrNonEffectiveData!;
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

  Future<void> changeOutletStatus(
      int status, bool isPastDate, String reason) async {
    late Map<String, String> header;
    header = {
      HttpHeaders.authorizationHeader: Singleton.instance.authToken,
    };

    late Map<String, String> body;
    if (outletDetailResponseModel.payload!.checkInStatus == null ||
        outletDetailResponseModel.payload!.checkInStatus == "Visited") {
      body = {
        ApiParamters.projectID: widget.objSelectedProject.id.toString(),
        ApiParamters.outletId: widget.objselectedOutlet.id.toString(),
        ApiParamters.type: status.toString(),
        if (isPastDate) ApiParamters.reason: reason,
        ApiParamters.day: widget.outletDay.trim(),
      };
    } else {
      body = {
        ApiParamters.projectID: widget.objSelectedProject.id.toString(),
        ApiParamters.outletId: widget.objselectedOutlet.id.toString(),
        ApiParamters.visitationId:
            outletDetailResponseModel.payload!.visitationId.toString(),
        ApiParamters.type: status.toString(),
        ApiParamters.day: widget.outletDay.trim(),
      };
    }

    final url = Uri.parse(ApiConstants.baseUrl +
        ApiConstants.baseUrlHost +
        ApiConstants.checkInOut);
    if (kDebugMode) {
      print("url$url");
    }

    Singleton.instance.showDefaultProgress();
    ApiService.postCallwithHeader(url, body, header, context).then((response) {
      final responseData = json.decode(response.body);
      try {
        if (kDebugMode) {
          print(responseData);
          print("statuscode ${response.statusCode}");
        }

        if (response.statusCode == 200) {
          isAnyChange = true;
          var data = json.decode(response.body)["payload"];
          visitationID = data["visitationId"];
          widget.objselectedOutlet.visitationIds = visitationID;

          Singleton.instance.showAlertDialogWithOkAction(
              context, Constant.alert, responseData["message"]);
          getOutletDetails(false);
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

  Future<void> cancelSales(String orderID) async {
    late Map<String, String> header;
    header = {
      HttpHeaders.authorizationHeader: Singleton.instance.authToken,
    };

    late Map<String, String> body;
    body = {
      ApiParamters.projectID: widget.objSelectedProject.id.toString(),
      ApiParamters.orderId: orderID,
    };

    final url = Uri.parse(ApiConstants.baseUrl +
        ApiConstants.baseUrlHost +
        ApiConstants.cancelOrder);
    if (kDebugMode) {
      print("url$url");
    }

    Singleton.instance.showDefaultProgress();
    ApiService.postCallwithHeader(url, body, header, context).then((response) {
      final responseData = json.decode(response.body);
      try {
        if (kDebugMode) {
          print(responseData);
          print("statuscode ${response.statusCode}");
        }

        if (response.statusCode == 200) {
          Singleton.instance.showAlertDialogWithOkAction(
              context, Constant.alert, responseData["message"]);
          getOutletDetails(false);
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
