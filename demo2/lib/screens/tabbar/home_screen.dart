import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:demo2/database/db_helper.dart';
import 'package:demo2/models/general_config_model.dart';
import 'package:demo2/models/offline_object_model.dart';
import 'package:demo2/models/user_model.dart';
import 'package:intl/intl.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../screens/achievement/project_achievement_screen.dart';
import '../../screens/outlet/outletlist_screen.dart';
import '../../screens/stock/stock_balance_screen.dart';
import '../../screens/tabbar/profile/profile_screen.dart';

import '../../helpers/api_constant.dart';
import '../../helpers/colors.dart';
import '../../helpers/constant.dart';
import '../../helpers/singleton.dart';
import '../../helpers/strings.dart';

import '../../models/get_project_list_model.dart';

import '../../service/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int counter = 0;
  GetProjectListModel? getProjectResponse;
  List<Rows> projectList = [];

  @override
  void initState() {
    if (kDebugMode) {
      print("HOME INIT STATE CALLED");
    }

    Singleton.instance.connectivity.initialise();
    Singleton.instance.connectivity.myStream.listen((source) {
      switch (source.keys.toList()[0]) {
        case ConnectivityResult.mobile:
          Singleton.instance.isInternet = true;
          if (kDebugMode) {
            print("**** CONNECTED ****");
          }
          break;
        case ConnectivityResult.wifi:
          Singleton.instance.isInternet = true;

          if (kDebugMode) {
            print("**** CONNECTED ****");
          }
          break;
        case ConnectivityResult.none:
        default:
          Singleton.instance.isInternet = false;
          if (kDebugMode) {
            print("**** DIS CONNECTED ****");
          }
      }
    });

    Singleton.instance.isInternetConnected().then((intenet) async {
      if (intenet) {
        bool isAnyRecordPendingForSync = false;

        List<Map<String, dynamic>> arrOutlets = [];
        // CHECK IF ANY OUTLET IS PENDING TO SYNC
        final arrOutletsDB = await getOutletListFromDB();
        if (arrOutletsDB.isNotEmpty) {
          for (int i = 0; i < arrOutletsDB.length; i++) {
            var objOutlet = arrOutletsDB[i];
            Map<String, dynamic> dictOutlet = {};

            dictOutlet['id'] = objOutlet.id;
            dictOutlet['outletName'] = objOutlet.outletName;
            dictOutlet['outletEmail'] = objOutlet.outletEmail;
            dictOutlet['status'] = objOutlet.status;
            dictOutlet['createdAt'] = objOutlet.createdAt;
            dictOutlet['updatedAt'] = objOutlet.updatedAt;
            dictOutlet['projectId'] = objOutlet.projectId;
            dictOutlet['checkInStatus'] = objOutlet.checkInStatus;
            dictOutlet['visitationId'] =
                (objOutlet.visitationId == null) ? 0 : objOutlet.visitationId;
            dictOutlet['day'] = objOutlet.day;

            arrOutlets.add(dictOutlet);
          }
          isAnyRecordPendingForSync = true;
        }

        if (!isAnyRecordPendingForSync) {
          List<Map<String, dynamic>> arrExecutionPhotos = [];

          // CHECK IF ANY OUTLET EXECUTION PHOTO IS PENDING TO SYNC
          final arrExecutionPhotoDB = await getOutletExecutionPhotosDB();
          if (arrExecutionPhotoDB.isNotEmpty) {
            //CALL EXECUITON PHOTO SYNC API

            for (int i = 0; i < arrExecutionPhotoDB.length; i++) {
              var objExecutionPhoto = arrExecutionPhotoDB[i];
              Map<String, dynamic> dictExecutionPhoto = {};

              dictExecutionPhoto['visitationId'] =
                  objExecutionPhoto.visitationId;
              dictExecutionPhoto['projectId'] = objExecutionPhoto.projectId;
              dictExecutionPhoto['outletId'] = objExecutionPhoto.outletId;

              List<Map<String, dynamic>> arrbase64 = [];

              if (objExecutionPhoto.arrImages != null) {
                for (int j = 0; j < objExecutionPhoto.arrImages!.length; j++) {
                  Map<String, dynamic> dictBase64 = {};
                  String url = objExecutionPhoto.arrImages![j];
                  dictBase64['base64image'] = url;
                  arrbase64.add(dictBase64);
                }
              }

              dictExecutionPhoto['base64'] = arrbase64;
              arrExecutionPhotos.add(dictExecutionPhoto);
            }
          }

          if (arrExecutionPhotos.isNotEmpty) {
            syncExecutionPhotos(arrExecutionPhotos);
          } else {
            DBHelper.clearAllTableData();

            await getGeneralConfiguration(true);
          }
        } else {
          //CALL SYNC API
          callSyncAPI(arrOutlets, [], [], true);
        }
      } else {
        getProjectListFromDB();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
      child: Builder(builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              // alignment: Alignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 3.5,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(""),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: Container(
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.035,
                        left: 20,
                        right: 20),
                    color: Colors.transparent,
                    alignment: Alignment.center,
                    child: headerRowUsername(),
                  ),
                ),
                // stockBalanceView(),
              ],
            ),
            Flexible(
              child: Container(
                margin: const EdgeInsets.all(0),
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                color: ColorCodes.backgroundColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 18,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 6),
                      child: Text(
                        "ONGOING",
                        style: Singleton.instance.setTextStyle(
                            fontSize: TextSize.text_13,
                            fontWeight: FontWeight.w900,
                            textColor: Colors.black.withOpacity(0.7)),
                      ),
                    ),
                    Expanded(child: listViewStock(context)),
                  ],
                ),
              ),
            )
          ],
        );
      }),
    );
  }

  Widget headerRowUsername() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Row(
            children: [
              GestureDetector(
                child: Container(
                  width: 41,
                  height: 43,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: ColorCodes.grayBgcolor.withOpacity(0.4)),
                  child: Image.asset(
                    "",
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
                onTap: () {
                  if (Singleton.instance.isInternet) {
                    Singleton.instance.showAlertDialogWithTWOAction(
                        context,
                        Constant.appName,
                        "Are you sure want to logout?",
                        positiveButtonCLicked);
                  }
                },
              ),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      Strings.welcomeBack,
                      maxLines: 2,
                      style: Singleton.instance.setTextStyle(
                          fontFamily: Constant.latoFontFamily,
                          fontSize: TextSize.text_12,
                          textColor: Colors.white),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      Singleton.instance.name,
                      style: Singleton.instance.setTextStyle(
                          fontFamily: Constant.latoFontFamily,
                          fontSize: TextSize.text_25,
                          textColor: Colors.white),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      Strings.userId + Singleton.instance.userId,
                      style: Singleton.instance.setTextStyle(
                          fontFamily: Constant.latoFontFamily,
                          fontSize: TextSize.text_12,
                          textColor: Colors.white),
                    )
                  ],
                ),
              ),
              const SizedBox(
                width: 10,
              ),
            ],
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () async {},
              child: Stack(
                children: <Widget>[
                  Image.asset(
                    "",
                    width: 30,
                    height: 25,
                  ),
                  Visibility(
                    visible: (counter <= 0) ? false : true,
                    child: Positioned(
                      right: 0,
                      top: 2,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 14,
                          minHeight: 14,
                        ),
                        child: Text(
                          '$counter',
                          style: Singleton.instance.setTextStyle(
                              fontSize: 9,
                              textColor: ColorCodes.tabSelectedColor,
                              fontFamily: Constant.latoFontFamily),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            GestureDetector(
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => ProfileScreen(false)),
                // ).then((value) {
                //   getProjectList(false);
                // });

                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ProfileScreen(false)),
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Singleton.instance.profile.isEmpty ||
                        (!Singleton.instance.isInternet)
                    ? Singleton.instance.placeholderWidget(41, 41)
                    : CachedNetworkImage(
                        imageUrl: Singleton.instance.profile,
                        height: 41,
                        width: 41,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            Singleton.instance.placeholderWidget(41, 41),
                        errorWidget: (context, url, error) =>
                            Singleton.instance.placeholderWidget(41, 41),
                      ),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget listViewStock(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 16, left: 0, right: 0, bottom: 0),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return GestureDetector(
            onTap: () {
              showModalBottomSheet<dynamic>(
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25)),
                ),
                backgroundColor: ColorCodes.primary,
                context: context,
                builder: (BuildContext bc) {
                  return Wrap(children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(0),
                      margin: const EdgeInsets.all(0),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(25.0),
                          topRight: Radius.circular(25.0),
                        ),
                      ),
                      child: bottomDialog(context, projectList[index]),
                    )
                  ]);
                },
              ).then((value) {});
            },
            child: dashboardWidget(context, index));
      },
      itemCount: projectList.length,
    );
  }

  Widget dashboardWidget(BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: SizedBox(
        //  height: MediaQuery.of(context).size.height * 0.25,
        child: Card(
          color: ColorCodes.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: Colors.white.withOpacity(0.1)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 16, bottom: 45),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  projectList[index].title! +
                                      " (${projectList[index].campaignId ?? ""})",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Singleton.instance.setTextStyle(
                                      fontWeight: FontWeight.w600,
                                      textColor: Colors.white,
                                      fontSize: TextSize.text_16),
                                ),
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Total Outlet",
                                style: Singleton.instance.setTextStyle(
                                    fontWeight: FontWeight.w400,
                                    textColor: Colors.white,
                                    fontSize: TextSize.text_12),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                DateFormat("dd MMM yyyy").format(DateTime.parse(
                                        projectList[index].startDate!)) +
                                    " - " +
                                    DateFormat("dd MMM yyyy").format(
                                        DateTime.parse(
                                            projectList[index].endDate!)),
                                maxLines: 2,
                                style: Singleton.instance.setTextStyle(
                                    fontWeight: FontWeight.w400,
                                    textColor: ColorCodes.lightTextColor,
                                    fontSize: TextSize.text_14),
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                              Text(
                                projectList[index].totalOutlet.toString(),
                                style: Singleton.instance.setTextStyle(
                                    fontWeight: FontWeight.w400,
                                    textColor: Colors.white,
                                    fontSize: TextSize.text_21),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        color: Colors.white.withOpacity(0.2)),
                    child: Row(
                      children: [
                        Image.asset(
                          "",
                          width: 24,
                          height: 24,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Container(
                          width: 1,
                          height: MediaQuery.of(context).size.height * 0.038,
                          color: Colors.white,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Flexible(
                            child: Container(
                                padding: const EdgeInsets.all(0),
                                margin: const EdgeInsets.all(0),
                                height: 36,
                                child: teamMemberList(index))),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget teamMemberList(int index) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(top: 0, left: 0, right: 0, bottom: 0),
      itemBuilder: (context, i) {
        return i != 2
            ? Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: projectList[index].arrUsers![i].profilePicture ==
                              null ||
                          (!Singleton.instance.isInternet)
                      ? Singleton.instance.placeholderWidget(36, 36)
                      : CachedNetworkImage(
                          memCacheHeight: null,
                          memCacheWidth: 150,
                          imageUrl:
                              projectList[index].arrUsers![i].profilePicture ??
                                  "",
                          height: 36,
                          width: 36,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              Singleton.instance.placeholderWidget(36, 36),
                          errorWidget: (context, url, error) =>
                              Singleton.instance.placeholderWidget(36, 36),
                        ),
                ),
              )
            : Container(
                height: 36,
                width: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: ColorCodes.dashBGColor,
                ),
                child: Text(
                  "3+",
                  textAlign: TextAlign.center,
                  style: Singleton.instance.setTextStyle(
                      fontFamily: Constant.latoFontFamily,
                      fontWeight: FontWeight.w900,
                      fontSize: TextSize.text_14),
                ),
              );
      },
      itemCount: (projectList[index].totalUsersCount! <= 2)
          ? projectList[index].totalUsersCount
          : 3,
    );
  }

  Widget bottomDialog(BuildContext context, Rows objSelectedProject) {
    return Padding(
      padding:
          const EdgeInsets.only(top: 16.0, left: 25, right: 25, bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 5,
            child: Align(
              alignment: Alignment.center,
              child: Container(
                width: 65,
                height: 5,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2.5),
                    color: ColorCodes.lightTextColor),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        (objSelectedProject.title ?? "") +
                            " (${objSelectedProject.campaignId ?? ""})",
                        maxLines: 2,
                        style: Singleton.instance.setTextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: TextSize.text_16),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Text(
                        DateFormat("dd MMM yyyy").format(
                                DateTime.parse(objSelectedProject.startDate!)) +
                            " - " +
                            DateFormat("dd MMM yyyy").format(
                                DateTime.parse(objSelectedProject.endDate!)),
                        maxLines: 2,
                        style: Singleton.instance.setTextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: TextSize.text_14,
                            textColor: ColorCodes.lightTextColor),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                Container(
                  width: 120,
                  decoration: BoxDecoration(
                    color: ColorCodes.buttonColor,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          objSelectedProject.categoryName!.isEmpty
                              ? "-"
                              : objSelectedProject.categoryName ?? "",
                          textAlign: TextAlign.center,
                          maxLines: 3,
                          style: Singleton.instance.setTextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: TextSize.text_14,
                              textColor: ColorCodes.buttonTextColor,
                              fontFamily: Constant.latoFontFamily),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Image.asset(
                        "",
                        width: 24,
                        height: 24,
                        color: ColorCodes.buttonTextColor,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      Strings.totalSale,
                      maxLines: 2,
                      style: Singleton.instance.setTextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: TextSize.text_14,
                          textColor: ColorCodes.lightTextColor),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Text(
                      objSelectedProject.totalSales.toString(),
                      maxLines: 1,
                      style: Singleton.instance.setTextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: TextSize.text_16),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      Strings.totalAmount,
                      style: Singleton.instance.setTextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: TextSize.text_14,
                          textColor: ColorCodes.lightTextColor),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Text(
                      "RM ${objSelectedProject.totalAmount}",
                      maxLines: 1,
                      style: Singleton.instance.setTextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: TextSize.text_16),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                Strings.teamMembers.toUpperCase(),
                style: Singleton.instance.setTextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: TextSize.text_14,
                    textColor: ColorCodes.lightTextColor),
              ),
              const SizedBox(
                height: 8,
              ),
              SizedBox(
                height: 60, //MediaQuery.of(context).size.height * 0.1,
                child: wholeTeamMemberList(objSelectedProject),
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Singleton.instance.divider(),
          const SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => OutletScreen(
                                objSelectedProject: objSelectedProject,
                              )),
                    );
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 16, horizontal: 5),
                    //width: MediaQuery.of(context).size.width / 4.4,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white),
                    child: Column(
                      children: [
                        Image.asset(
                          "",
                          width: 21,
                          height: 21,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        FittedBox(
                          fit: BoxFit.cover,
                          child: Text(
                            Strings.coverage,
                            textAlign: TextAlign.center,
                            style: Singleton.instance.setTextStyle(
                                fontSize: TextSize.text_14,
                                fontWeight: FontWeight.w600,
                                textColor: ColorCodes.tabSelectedColor),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GestureDetector(
                    onTap: () {
                      if (Singleton.instance.isInternet) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => StockbalanceScreen(
                                  false, objSelectedProject)),
                        );
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 5),
                      //width: MediaQuery.of(context).size.width / 4.4,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white),
                      child: Column(
                        children: [
                          Image.asset(
                            "",
                            width: 21,
                            height: 21,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          FittedBox(
                            fit: BoxFit.cover,
                            child: Text(
                              Strings.stock,
                              textAlign: TextAlign.center,
                              style: Singleton.instance.setTextStyle(
                                  fontSize: TextSize.text_14,
                                  fontWeight: FontWeight.w600,
                                  textColor: ColorCodes.tabSelectedColor),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (Singleton.instance.isInternet) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProjectAchievementScreen(
                                  objSelectedProject: objSelectedProject,
                                )),
                      );
                    }
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 16, horizontal: 5),
                    //width: MediaQuery.of(context).size.width / 4.4,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white),
                    child: Column(
                      children: [
                        Image.asset(
                          "",
                          width: 21,
                          height: 21,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        FittedBox(
                          fit: BoxFit.cover,
                          child: Text(
                            Strings.achievement,
                            textAlign: TextAlign.center,
                            style: Singleton.instance.setTextStyle(
                                fontSize: TextSize.text_14,
                                fontWeight: FontWeight.w600,
                                textColor: ColorCodes.tabSelectedColor),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget wholeTeamMemberList(Rows projectList) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      padding: const EdgeInsets.only(top: 0, left: 0, right: 0, bottom: 0),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: projectList.arrUsers![index].profilePicture == null ||
                        (!Singleton.instance.isInternet)
                    ? Singleton.instance.placeholderWidget(36, 36)
                    : CachedNetworkImage(
                        memCacheHeight: null,
                        memCacheWidth: 150,
                        imageUrl:
                            projectList.arrUsers![index].profilePicture ?? "",
                        height: 36,
                        width: 36,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            Singleton.instance.placeholderWidget(36, 36),
                        errorWidget: (context, url, error) =>
                            Singleton.instance.placeholderWidget(36, 36),
                      ),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                projectList.arrUsers![index].username ?? "",
                maxLines: 1,
                style: Singleton.instance.setTextStyle(
                    fontWeight: FontWeight.w600, fontSize: TextSize.text_11),
              ),
            ],
          ),
        );
      },
      itemCount: projectList.arrUsers!.length,
    );
  }

  positiveButtonCLicked() async {}

  // ******** API CALL ********
  Future<void> getLogoutCall() async {
    late Map<String, String> header;
    late Map<String, String> param;

    header = {
      HttpHeaders.authorizationHeader: Singleton.instance.authToken,
    };
    param = {
      ApiParamters.deviceToken: Singleton.instance.fcmToken,
      ApiParamters.deviceTypeAuth: Singleton.instance.deviceType(),
    };
    final url = Uri.parse(
        ApiConstants.baseUrl + ApiConstants.baseUrlHost + ApiConstants.logout);
    if (kDebugMode) {
      print("url$url");
    }

    Singleton.instance.showDefaultProgress();
    ApiService.postCallwithHeader(url, param, header, context).then((response) {
      final responseData = json.decode(response.body);
      try {
        if (kDebugMode) {
          print(responseData);
          print("statuscode ${response.statusCode}");
        }

        Singleton.instance.hideProgress();
        if (response.statusCode == 200) {
          Singleton.instance.logoutUser(context);
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

  void getProjectListFromDB() async {
    List<Map<String, dynamic>> arrProjectsDB =
        await DBHelper.getData(Strings.tableProjects);

    projectList.clear();
    if (arrProjectsDB.isEmpty) {
      projectList = [];
    } else {
      for (int i = 0; i < arrProjectsDB.length; i++) {
        var projectMap = arrProjectsDB[i];

        List<Users> arrUsers = [];

        if (projectMap['users'] != null) {
          arrUsers = [];

          List<Map<String, dynamic>> newData =
              List<Map<String, dynamic>>.from(json.decode(projectMap['users']));
          for (var v in newData) {
            arrUsers.add(Users.fromJson(v));
          }
        }

        Rows objProject = Rows(
          id: projectMap['id'],
          title: projectMap['title'],
          campaignId: projectMap['campaignId'],
          description: projectMap['description'],
          categoryId: projectMap['category_id'],
          status: projectMap['status'],
          isCompleted: projectMap['isCompleted'],
          startDate: projectMap['start_date'],
          endDate: projectMap['end_date'],
          deletedAt: projectMap['deletedAt'],
          createdAt: projectMap['createdAt'],
          updatedAt: projectMap['updatedAt'],
          categoryName: (projectMap['category_name'] != null)
              ? projectMap['category_name']
              : "",
          totalUsersCount: projectMap['totalUsersCount'],
          totalSales: projectMap['total_sales'],
          totalQuantity: projectMap['total_quantity'],
          totalAmount: (projectMap['totalAmount'] is int)
              ? projectMap['totalAmount'].toDouble()
              : projectMap['totalAmount'],
          totalOutlet: projectMap['total_outlet'],
          arrUsers: arrUsers,
        );
        projectList.add(objProject);
        projectList.sort((a, b) => DateTime.parse(b.createdAt!)
            .compareTo(DateTime.parse(a.createdAt!)));
      }
    }

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> getProjectList(bool isWantToShowProgress) async {
    late Map<String, String> header;
    header = {
      HttpHeaders.authorizationHeader: Singleton.instance.authToken,
    };

    final url = Uri.parse(ApiConstants.baseUrl +
        ApiConstants.baseUrlHost +
        ApiConstants.getProjectList);
    if (kDebugMode) {
      print("url$url");
    }

    if (isWantToShowProgress) {
      Singleton.instance.showDefaultProgress();
    }

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
          projectList.clear();
          getProjectResponse =
              GetProjectListModel.fromJson(json.decode(response.body));
          projectList.addAll(getProjectResponse!.payload!.data!.rows!);
          if (kDebugMode) {
            print(getProjectResponse);
          }

          counter = getProjectResponse!.payload!.data!.notificationCount!;
          Singleton.instance.isDataCall = false;
          if (mounted) {
            setState(() {});
          }
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

  Future<void> callSyncAPI(
    List<Map<String, dynamic>> arrOutlets,
    List<Map<String, dynamic>> arrOrderData,
    List<Map<String, dynamic>> arrOrderDetails,
    bool isWantToShowProgress,
  ) async {
    late Map<String, String> header;
    header = {
      HttpHeaders.authorizationHeader: Singleton.instance.authToken,
    };

    final url = Uri.parse(ApiConstants.baseUrl +
        ApiConstants.baseUrlHost +
        ApiConstants.syncData);
    if (kDebugMode) {
      print("url$url");
    }

    late Map<String, String> body;
    body = {
      if (arrOutlets.isNotEmpty) ApiParamters.outlets: jsonEncode(arrOutlets),
      if (arrOrderData.isNotEmpty)
        ApiParamters.orderData: jsonEncode(arrOrderData),
      if (arrOrderDetails.isNotEmpty)
        ApiParamters.orderDetails: jsonEncode(arrOrderDetails),
    };

    if (kDebugMode) {
      print("SYNC API PARAMS: ==> $body");
    }

    if (isWantToShowProgress) {
      Singleton.instance.showDefaultProgress();
    }

    ApiService.postCallwithHeader(url, body, header, context)
        .then((response) async {
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
          await getGeneralConfiguration(true);
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

  Future<void> syncExecutionPhotos(
    List<Map<String, dynamic>> arrExecution,
  ) async {
    late Map<String, String> header;
    header = {
      HttpHeaders.authorizationHeader: Singleton.instance.authToken,
    };

    final url = Uri.parse(ApiConstants.baseUrl +
        ApiConstants.baseUrlHost +
        ApiConstants.syncOutletExecutionPhotos);
    if (kDebugMode) {
      print("url$url");
    }

    late Map<String, String> body;
    body = {
      ApiParamters.executionURL: jsonEncode(arrExecution),
    };

    if (kDebugMode) {
      print("SYNC EXECUTION PHOTO API PARAMS: ==> $body");
    }

    Singleton.instance.showDefaultProgress();
    ApiService.postCallwithHeader(url, body, header, context)
        .then((response) async {
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
          DBHelper.clearAllTableData();

          await getGeneralConfiguration(true);
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

  Future<void> getGeneralConfiguration(bool isNeedToShowProgress) async {
    late Map<String, String> header;
    header = {
      HttpHeaders.authorizationHeader: Singleton.instance.authToken,
    };

    GeneralConfigModel configModel;

    final url = Uri.parse(ApiConstants.baseUrl +
        ApiConstants.baseUrlHost +
        ApiConstants.generalConfiguration);
    if (kDebugMode) {
      print("url$url");
    }

    if (isNeedToShowProgress) {
      Singleton.instance.showDefaultProgress();
    }
    ApiService.getCallwithHeader(url, header, context).then((response) async {
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

            if (Singleton.instance.objGeneralConfig.arrGender != null) {
              for (int i = 0;
                  i < Singleton.instance.objGeneralConfig.arrGender!.length;
                  i++) {
                var objProject =
                    Singleton.instance.objGeneralConfig.arrGender![i];
                await DBHelper.insert(Strings.tableGender, {
                  DBHelper.id: (i + 1).toString(),
                  DBHelper.value: objProject.value,
                });
              }
            }

            if (Singleton.instance.objGeneralConfig.arrAgeGroup != null) {
              for (int i = 0;
                  i < Singleton.instance.objGeneralConfig.arrAgeGroup!.length;
                  i++) {
                var objProject =
                    Singleton.instance.objGeneralConfig.arrAgeGroup![i];
                await DBHelper.insert(Strings.tableAgeGroup, {
                  DBHelper.id: (i + 1).toString(),
                  DBHelper.value: objProject.value,
                });
              }
            }

            if (Singleton.instance.objGeneralConfig.arrGroupSegment != null) {
              for (int i = 0;
                  i <
                      Singleton
                          .instance.objGeneralConfig.arrGroupSegment!.length;
                  i++) {
                var objProject =
                    Singleton.instance.objGeneralConfig.arrGroupSegment![i];
                await DBHelper.insert(Strings.tableGroupSegment, {
                  DBHelper.id: (i + 1).toString(),
                  DBHelper.value: objProject.value,
                });
              }
            }

            if (Singleton.instance.objGeneralConfig.arrBrandVarient != null) {
              for (int i = 0;
                  i <
                      Singleton
                          .instance.objGeneralConfig.arrBrandVarient!.length;
                  i++) {
                var objProject =
                    Singleton.instance.objGeneralConfig.arrBrandVarient![i];
                for (int j = 0; j < objProject.arrBrandVariants!.length; j++) {
                  var objBrand = objProject.arrBrandVariants![j];

                  await DBHelper.insert(Strings.tableBrandVariant, {
                    DBHelper.id: Singleton.instance.randomDigits(6).toString(),
                    DBHelper.brand: objProject.brands,
                    DBHelper.value: objBrand.value,
                  });
                }
              }
            }

            await getDataToStoreInDB(isNeedToShowProgress);
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

  Future<void> getDataToStoreInDB(bool isNeedToShowProgress) async {
    late Map<String, String> header;
    header = {
      HttpHeaders.authorizationHeader: Singleton.instance.authToken,
    };

    OfflineDataModel offlineModel;

    final url = Uri.parse(ApiConstants.baseUrl +
        ApiConstants.baseUrlHost +
        ApiConstants.projectsWithOutlets);
    if (kDebugMode) {
      print("url$url");
    }

    if (isNeedToShowProgress) {
      Singleton.instance.showDefaultProgress();
    }
    ApiService.getCallwithHeader(url, header, context).then((response) async {
      if (kDebugMode) {
        print(response);
      }
      if (response.body.isNotEmpty) {
        final responseData = json.decode(response.body);
        try {
          Singleton.instance.hideProgress();
          if (response.statusCode == 200) {
            var data = json.decode(response.body);

            offlineModel = OfflineDataModel.fromJson(data);
            if (kDebugMode) {
              print(offlineModel);
            }

            getProjectList(isNeedToShowProgress);
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

  Future<List<OutletObject>> getOutletListFromDB() async {
    List<Map<String, dynamic>> arrOutletsDB =
        await DBHelper.getData(Strings.tableProjectOutlets);

    List<OutletObject> arrCovOutlets = [];
    if (arrOutletsDB.isEmpty) {
    } else {
      for (int i = 0; i < arrOutletsDB.length; i++) {
        var outletMap = arrOutletsDB[i];

        OutletObject objOutlet = OutletObject(
          outletUrl: outletMap['outletUrl'],
          id: outletMap['id'],
          outletName: outletMap['outletName'],
          outletEmail: outletMap['outletEmail'],
          outletContact: outletMap['outletContact'],
          address: outletMap['address'],
          ownerName: outletMap['ownerName'],
          ownerEmail: outletMap['ownerEmail'],
          ownerContact: outletMap['ownerContact'],
          personName: outletMap['personName'],
          personEmail: outletMap['personEmail'],
          personContact: outletMap['personContact'],
          status: outletMap['status'],
          feedback: outletMap['feedback'],
          deletedAt: outletMap['deletedAt'],
          createdAt: outletMap['createdAt'],
          updatedAt: outletMap['updatedAt'],
          projectId: outletMap['projectId'],
          checkInStatus: outletMap['checkInStatus'],
          visitationId: outletMap['visitationId'],
          day: outletMap['day'],
        );

        if (outletMap['is_offline'] == 1) {
          arrCovOutlets.add(objOutlet);
        }
      }
    }
    return arrCovOutlets;
  }

  //GET OUTLET EFFECTIVE/NON EFFECTIVE DATA
  Future<List<EffectiveNonEffectiveDataObject>>
      getOutletOrderDataFromDB() async {
    //OUTLET CONTACT DATA
    List<Map<String, dynamic>> arrOutletContactsDataDB =
        await DBHelper.getData(Strings.tableOutletContacts);

    List<EffectiveNonEffectiveDataObject> arrEffectiveNonEffectiveDataDB = [];

    for (int i = 0; i < arrOutletContactsDataDB.length; i++) {
      Map<String, dynamic> dictContact = arrOutletContactsDataDB[i];

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
        effectiveContact: dictContact['effectivecontact'],
        createdAt: dictContact['createdAt'],
        updatedAt: dictContact['updatedAt'],
        orderTotalAmount: (dictContact['orderTotalAmount'] is int)
            ? dictContact['orderTotalAmount'].toDouble()
            : dictContact['orderTotalAmount'],
        isNextDay: false,
        // arrProducts: arrProducts,
      );

      if (dictContact['is_offline'] == 1) {
        arrEffectiveNonEffectiveDataDB.add(objEffectiveContact);
      }
    }

    return arrEffectiveNonEffectiveDataDB;
  }

  //GET OUTLET CONTACT SALES DATA
  Future<List<ProductDataObject>> getOutletContactsSalesFromDB() async {
    //OUTLET CONTACT SALES DATA
    List<Map<String, dynamic>> arrOutletContactSalesDB =
        await DBHelper.getData(Strings.tableOutletContactSales);

    List<ProductDataObject> arrProducts = [];

    for (int i = 0; i < arrOutletContactSalesDB.length; i++) {
      Map<String, dynamic> dictContactSales = arrOutletContactSalesDB[i];
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

      if (dictContactSales['is_offline'] == 1) {
        arrProducts.add(objProduct);
      }
    }

    return arrProducts;
  }

  //GET OUTLET EXECUTION PHOTO DATA
  Future<List<ExecutionPhoto>> getOutletExecutionPhotosDB() async {
    List<Map<String, dynamic>> arrExecutionPhotoDB =
        await DBHelper.getData(Strings.tableOutletExecutionPhotos);

    List<ExecutionPhoto> arrExecutionPhotos = [];

    for (int i = 0; i < arrExecutionPhotoDB.length; i++) {
      Map<String, dynamic> dictExecutionPhoto = arrExecutionPhotoDB[i];

      ExecutionPhoto objExecutionPhoto = ExecutionPhoto(
        id: dictExecutionPhoto['id'],
        url: dictExecutionPhoto['imageUrl'],
        isDeleted: dictExecutionPhoto['is_deleted'],
        isOffline: dictExecutionPhoto['is_offline'],
        outletId: dictExecutionPhoto['outletId'],
        projectId: dictExecutionPhoto['projectId'],
        visitationId: dictExecutionPhoto['visitationId'],
      );

      if (dictExecutionPhoto['is_deleted'] == 1 ||
          dictExecutionPhoto['is_offline'] == 1) {
        var count = arrExecutionPhotos
            .where((c) => (c.projectId == objExecutionPhoto.projectId &&
                c.outletId == objExecutionPhoto.outletId &&
                c.visitationId == objExecutionPhoto.visitationId))
            .toList()
            .length;

        if (count <= 0) {
          objExecutionPhoto.arrImagesData = [];
          objExecutionPhoto.arrImages?.add(objExecutionPhoto.url ?? "");
          arrExecutionPhotos.add(objExecutionPhoto);
        } else {
          var objData = arrExecutionPhotos.firstWhere((c) =>
              (c.projectId == objExecutionPhoto.projectId &&
                  c.outletId == objExecutionPhoto.outletId &&
                  c.visitationId == objExecutionPhoto.visitationId));
          objData.arrImages?.add(objExecutionPhoto.url ?? "");
          if (kDebugMode) {
            print(objData.arrImages);
          }
        }
      }
    }
    return arrExecutionPhotos;
  }
}
