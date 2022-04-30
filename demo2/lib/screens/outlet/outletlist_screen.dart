import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:demo2/database/db_helper.dart';
import 'package:intl/intl.dart';

import 'add_outlet_screen.dart';
import 'outlet_detail_screen.dart';

import '../../helpers/api_constant.dart';
import '../../helpers/colors.dart';
import '../../helpers/constant.dart';
import '../../helpers/singleton.dart';
import '../../helpers/strings.dart';

import '../../models/coverage_model.dart';
import '../../models/get_project_list_model.dart';
import '../../service/api_service.dart';

import '../../widgets/searchbar_widget.dart';

class OutletScreen extends StatefulWidget {
  final Rows objSelectedProject;
  const OutletScreen({Key? key, required this.objSelectedProject})
      : super(key: key);

  @override
  _OutletScreenState createState() => _OutletScreenState();
}

class _OutletScreenState extends State<OutletScreen> {
  final TextEditingController _controller = TextEditingController();

  CoverageModel coverageDaysResponseModel = CoverageModel();
  List<CoverageDaysObject> arrCoverageDays = [];
  String searchKeyword = "";

  int currentDayObjectIndex = -1;

  void handleSearch(bool search) {}

  void clearSearch(String search) {
    if (search.isNotEmpty) {
      searchKeyword = "";
      getOutletList(
          widget.objSelectedProject.id.toString(), true, searchKeyword);
    }
  }

  void searchFunction(String search) {
    searchKeyword = search;
    if (search.isEmpty) {
      getOutletList(
          widget.objSelectedProject.id.toString(), false, searchKeyword);
    } else {
      getOutletList(
          widget.objSelectedProject.id.toString(), true, searchKeyword);
    }
  }

  @override
  void initState() {
    if (widget.objSelectedProject.id != null) {
      Singleton.instance.isInternetConnected().then((intenet) {
        if (intenet) {
          getOutletList(widget.objSelectedProject.id.toString(), true, "");
        } else {
          getOutletListFromDB();
        }
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: ColorCodes.backgroundColor,
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: !Singleton.instance.isInternet
            ? Container()
            : FloatingActionButton(
                heroTag: Singleton.instance.getRandString(4),
                backgroundColor: ColorCodes.lightRed,
                //Floating action button on Scaffold
                onPressed: () async {
                  bool isNeedToRefresh = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddOutletScreen(
                              objSelectedProject: widget.objSelectedProject,
                            )),
                  );

                  if (isNeedToRefresh) {
                    Singleton.instance.isInternetConnected().then((intenet) {
                      if (intenet) {
                        getOutletList(widget.objSelectedProject.id.toString(),
                            false, searchKeyword);
                      } else {
                        getOutletListFromDB();
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
        body: Column(
          children: [
            SearchbarWidget(
                Strings.outletListScreen,
                _leadingClickEvent,
                Colors.black,
                Colors.black,
                (Singleton.instance.isInternet) ? true : false,
                true,
                _controller,
                searchFunction,
                handleSearch,
                clearSearch),
            arrCoverageDays.isEmpty
                ? Container(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: Text(
                      "No data available",
                      style: Singleton.instance.setTextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: TextSize.text_14,
                          textColor: ColorCodes.black),
                    ),
                  )
                : outletMainList(context),
          ],
        ),
      ),
    );
  }

  Widget outletMainList(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        padding: EdgeInsets.zero,
        child: Container(
          margin: EdgeInsets.zero,
          color: ColorCodes.backgroundColor,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView.separated(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Theme(
                  data: Theme.of(context)
                      .copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                      initiallyExpanded: searchKeyword.isEmpty
                          ? ((index == currentDayObjectIndex) ? true : false)
                          : true,
                      tilePadding: EdgeInsets.zero,
                      textColor: ColorCodes.lightBlack,
                      key: PageStorageKey<CoverageDaysObject>(
                          arrCoverageDays[index]),
                      title: Text(
                        (arrCoverageDays[index].day ?? "").toUpperCase(),
                        style: Singleton.instance.setTextStyle(
                            fontSize: TextSize.text_13,
                            fontWeight: FontWeight.w700,
                            textColor: ColorCodes.lightBlack),
                      ),
                      children: List<Widget>.generate(
                        arrCoverageDays[index].arrCoverageOutlets!.length,
                        (indx) => outletTile(
                            arrCoverageDays[index].arrCoverageOutlets![indx],
                            (arrCoverageDays[index].date ?? "")),
                      )),
                );
              },
              separatorBuilder: (context, index) {
                return Singleton.instance.dividerWTOPAC();
              },
              itemCount: arrCoverageDays.length),
        ),
      ),
    );
  }

  Widget outletTile(OutletObject objOutlet, String outletDate) {
    return GestureDetector(
      onTap: () async {
        bool isNeedToRefresh = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => OutletDetailScreen(
                    objSelectedProject: widget.objSelectedProject,
                    objselectedOutlet: objOutlet,
                    outletDate: outletDate,
                    outletDay: objOutlet.day ?? "",
                  )),
        );

        if (isNeedToRefresh) {
          Singleton.instance.isInternetConnected().then((intenet) {
            if (intenet) {
              getOutletList(widget.objSelectedProject.id.toString(), false,
                  searchKeyword);
            } else {
              getOutletListFromDB();
            }
          });
        }
      },
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
                    (objOutlet.outletUrl ?? "").isEmpty ||
                            (!Singleton.instance.isInternet)
                        ? SizedBox(
                            height: 40,
                            width: 40,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                "",
                                width: 24,
                                height: 24,
                              ),
                            ),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: CachedNetworkImage(
                              memCacheHeight: null,
                              memCacheWidth: 200,
                              imageUrl: objOutlet.outletUrl ?? "",
                              height: 40,
                              width: 40,
                              fit: BoxFit.cover,
                              placeholder: (context, url) =>
                                  Singleton.instance.placeholderWidget(40, 40),
                              errorWidget: (context, url, error) =>
                                  Singleton.instance.placeholderWidget(40, 40),
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
                            objOutlet.outletName ?? "",
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
                              objOutlet.address ?? "",
                              style: Singleton.instance.setTextStyle(
                                  fontSize: TextSize.text_11,
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
              Text(
                objOutlet.checkInStatus ?? "",
                style: Singleton.instance.setTextStyle(
                    fontSize: TextSize.text_11,
                    fontWeight: FontWeight.w400,
                    textColor: objOutlet.checkInStatus == "visited"
                        ? ColorCodes.primary
                        : ColorCodes.buttonTextColor),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _leadingClickEvent() {
    Navigator.pop(context);
  }

  void getOutletListFromDB() async {
    List<Map<String, dynamic>> arrOutletsDB =
        await DBHelper.getUniqueOutletData(Strings.tableProjectOutlets);

    String currentDay = DateFormat('EEEE').format(DateTime.now());

    if (arrOutletsDB.isEmpty) {
      arrCoverageDays = [];
    } else {
      List<OutletObject> arrCovOutlets = [];
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

        if ((objOutlet.day == currentDay.toLowerCase() ||
                objOutlet.day == "others") &&
            objOutlet.projectId == widget.objSelectedProject.id) {
          arrCovOutlets.add(objOutlet);
        }
      }

      arrCovOutlets.sort((a, b) =>
          DateTime.parse(a.createdAt!).compareTo(DateTime.parse(b.createdAt!)));
      arrCoverageDays.clear();

      if (arrCovOutlets.isNotEmpty) {
        var objCoverageDay = CoverageDaysObject(
            day: currentDay, arrCoverageOutlets: arrCovOutlets);
        arrCoverageDays.add(objCoverageDay);
      }
    }
    currentDayObjectIndex = 0;
    setState(() {});
  }

  // ******** API CALL ********
  Future<void> getOutletList(
      String projectID, bool isWantToShowProgress, String searchKeyword) async {
    late Map<String, String> header;
    header = {
      HttpHeaders.authorizationHeader: Singleton.instance.authToken,
    };

    late Map<String, String> body;
    body = {
      ApiParamters.projectID: projectID,
      ApiParamters.search: searchKeyword,
    };

    final url = Uri.parse(ApiConstants.baseUrl +
        ApiConstants.baseUrlHost +
        ApiConstants.outlets +
        "?" +
        Uri(queryParameters: body).query);
    if (kDebugMode) {
      print("url$url");
    }

    if (isWantToShowProgress) {
      Singleton.instance.showDefaultProgress();
    }
    ApiService.getCallwithHeader(url, header, context).then((response) {
      final responseData = json.decode(response.body);
      try {
        if (kDebugMode) {
          print(responseData);
          print("statuscode ${response.statusCode}");
        }
        Singleton.instance.hideProgress();
        if (response.statusCode == 200) {
          coverageDaysResponseModel =
              CoverageModel.fromJson(json.decode(response.body));

          arrCoverageDays.clear();

          if (coverageDaysResponseModel.arrCoverageDays!.isEmpty) {
            arrCoverageDays = [];
          } else {
            arrCoverageDays = coverageDaysResponseModel.arrCoverageDays!;

            String currentDay = DateFormat('EEEE').format(DateTime.now());
            final index = arrCoverageDays.indexWhere(
                (element) => element.day == currentDay.toLowerCase());
            currentDayObjectIndex = index;
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
