import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

import '../../helpers/api_constant.dart';
import '../../helpers/colors.dart';
import '../../helpers/constant.dart';
import '../../helpers/singleton.dart';
import '../../helpers/strings.dart';

import '../../models/get_project_list_model.dart';
import '../../models/stock_balance_model.dart';

import '../../screens/stock/trade_stock_screen.dart';
import '../../screens/stock/update_stock_screen.dart';

import '../../service/api_service.dart';

import '../../widgets/searchbar_widget.dart';

class StockbalanceScreen extends StatefulWidget {
  final bool fromBottom;
  final Rows objSelectedProject;

  const StockbalanceScreen(this.fromBottom, this.objSelectedProject, {Key? key})
      : super(key: key);

  @override
  _StockbalanceScreenState createState() => _StockbalanceScreenState();
}

class _StockbalanceScreenState extends State<StockbalanceScreen> {
  final TextEditingController _controller = TextEditingController();
  List<TradeLogsObject> arrTradeLogs = [];
  List<TradeLogsObject> arrTradeRequests = [];
  List<StockRow> arrStockList = [];
  StockBalanceModel stockBalanceResponseModel = StockBalanceModel();

  void handleSearch(bool search) {
    // print("====");
  }

  void clearSearch(bool search) {
    // print("====");
  }

  void searchFunction(String search) {
    // print("====search");
  }

  @override
  void initState() {
    if (kDebugMode) {
      print("STOCK INIT STATE CALLED");
    }
    Singleton.instance.isInternetConnected().then((intenet) {
      if (intenet) {
        getStockBalance(true);
      } else {
        // Singleton.instance.showAlertDialogWithOkAction(
        //     context, Constant.appName, Constant.noInternet);
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
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(8.0),
          child: widget.fromBottom
              ? Container()
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    FloatingActionButton(
                      heroTag: Singleton.instance.getRandString(5),
                      backgroundColor: ColorCodes.lightRed,
                      //Floating action button on Scaffold
                      onPressed: () {
                        //code to execute on button press

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TradeStockScreen(
                                    objSelectedProject:
                                        widget.objSelectedProject,
                                  )),
                        ).then((value) {
                          getStockBalance(false);
                        });
                      },
                      child: Image.asset(
                        "",
                        width: 20,
                        height: 20,
                      ), //icon inside button
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    FloatingActionButton(
                      heroTag: Singleton.instance.getRandString(6),
                      backgroundColor: ColorCodes.lightRed,
                      //Floating action button on Scaffold
                      onPressed: () async {
                        //code to execute on button press

                        bool isNeedToReload = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UpdateStockScreen(
                                    projectID:
                                        widget.objSelectedProject.id ?? 0,
                                  )),
                        );

                        if (isNeedToReload) {
                          getStockBalance(false);
                        }
                      },
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 24,
                      ), //icon inside button
                    )
                  ],
                ),
        ),
        body: Container(
          color: ColorCodes.backgroundColor,
          child: Column(
            children: [
              SearchbarWidget(
                  Strings.stockBalanceScreen,
                  _leadingClickEvent,
                  Colors.black,
                  ColorCodes.lightBlack,
                  false,
                  !widget.fromBottom,
                  _controller,
                  searchFunction,
                  handleSearch,
                  clearSearch),
              stockdata(),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    color: ColorCodes.backgroundColor,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        productMainList(context),
                        const SizedBox(
                          height: 10,
                        ),
                        // Singleton.instance.dividerWTOPAC(),
                        // const SizedBox(
                        //   height: 20,
                        // ),
                        Visibility(
                          visible: arrTradeRequests.isEmpty ? false : true,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                Strings.tradeRequest.toUpperCase(),
                                style: Singleton.instance.setTextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: TextSize.text_13,
                                    textColor: ColorCodes.lightBlack),
                              ),
                              GestureDetector(
                                onTap: () {},
                                child: Text(
                                  Strings.viewAll,
                                  style: Singleton.instance.setTextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: TextSize.text_13,
                                      textColor: ColorCodes.primary),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Visibility(
                            visible: arrTradeRequests.isEmpty ? false : true,
                            child: tradeRequestListview()),
                        const SizedBox(
                          height: 20,
                        ),
                        Visibility(
                          visible: arrTradeLogs.isEmpty ? false : true,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                Strings.tradeLog.toUpperCase(),
                                style: Singleton.instance.setTextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: TextSize.text_13,
                                    textColor: ColorCodes.lightBlack),
                              ),
                              GestureDetector(
                                onTap: () {},
                                child: Text(
                                  Strings.viewAll,
                                  style: Singleton.instance.setTextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: TextSize.text_13,
                                      textColor: ColorCodes.primary),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Visibility(
                            visible: arrTradeLogs.isEmpty ? false : true,
                            child: tradeLogsListview()),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _leadingClickEvent() {
    Navigator.pop(context);
  }

  Widget stockdata() {
    return Card(
      margin: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.2),
      elevation: 8,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.only(top: 16, bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                Strings.stockOverview.toUpperCase(),
                style: Singleton.instance.setTextStyle(
                    fontSize: TextSize.text_13,
                    fontWeight: FontWeight.w700,
                    textColor: ColorCodes.lightBlack),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.only(top: 16, bottom: 16),
                    width: MediaQuery.of(context).size.width / 4.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: ColorCodes.primary.withOpacity(0.09)),
                    child: Column(
                      children: [
                        Text(
                          Strings.open.toUpperCase(),
                          style: Singleton.instance.setTextStyle(
                              fontSize: TextSize.text_10,
                              fontWeight: FontWeight.w400,
                              textColor: ColorCodes.primary.withOpacity(0.6)),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          (stockBalanceResponseModel.payload == null)
                              ? "0"
                              : stockBalanceResponseModel
                                  .payload!.data!.objStockHistory!.openStock
                                  .toString(),
                          style: Singleton.instance.setTextStyle(
                              fontSize: TextSize.text_22,
                              fontWeight: FontWeight.w700,
                              textColor: ColorCodes.primary),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 16, bottom: 16),
                  width: MediaQuery.of(context).size.width / 4.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: ColorCodes.primary.withOpacity(0.09)),
                  child: Column(
                    children: [
                      Text(
                        Strings.close.toUpperCase(),
                        style: Singleton.instance.setTextStyle(
                            fontSize: TextSize.text_10,
                            fontWeight: FontWeight.w400,
                            textColor: ColorCodes.primary.withOpacity(0.6)),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        (stockBalanceResponseModel.payload == null)
                            ? "0"
                            : stockBalanceResponseModel
                                .payload!.data!.objStockHistory!.closeStock
                                .toString(),
                        style: Singleton.instance.setTextStyle(
                            fontSize: TextSize.text_22,
                            fontWeight: FontWeight.w700,
                            textColor: ColorCodes.primary),
                      )
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.only(top: 16, bottom: 16),
                    width: MediaQuery.of(context).size.width / 4.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: ColorCodes.lightYellowColor),
                    child: Column(
                      children: [
                        Text(
                          Strings.balance.toUpperCase(),
                          style: Singleton.instance.setTextStyle(
                              fontSize: TextSize.text_10,
                              fontWeight: FontWeight.w400,
                              textColor: ColorCodes.buttonTextColor),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          (stockBalanceResponseModel.payload == null)
                              ? "0"
                              : (stockBalanceResponseModel.payload!.data!
                                          .objStockHistory!.balanceStock ??
                                      0)
                                  .toString(),
                          // (stockBalanceResponseModel.payload == null)
                          //     ? "0"
                          //     : ((stockBalanceResponseModel.payload!.data!
                          //                     .objStockHistory!.openStock ??
                          //                 0) -
                          //             (stockBalanceResponseModel.payload!.data!
                          //                     .objStockHistory!.closeStock ??
                          //                 0))
                          //         .toString(),
                          style: Singleton.instance.setTextStyle(
                              fontSize: TextSize.text_22,
                              fontWeight: FontWeight.w700,
                              textColor: ColorCodes.buttonTextColor),
                        )
                      ],
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget productMainList(BuildContext context) {
    return Container(
      margin: EdgeInsets.zero,
      child: ListView.separated(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return listtile(arrStockList[index]);
          },
          separatorBuilder: (context, index) {
            return Singleton.instance.dividerWTOPAC();
          },
          itemCount: arrStockList.length),
    );
  }

  Widget listtile(StockRow objStockRow) {
    // if (root.children.isEmpty) return ListTile(title: Text(root.title));
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
          tilePadding: EdgeInsets.zero,
          childrenPadding: EdgeInsets.zero,
          textColor: ColorCodes.lightBlack,
          key: PageStorageKey<StockRow>(objStockRow),
          title: Text(
            (objStockRow.name ?? ""),
            style: Singleton.instance.setTextStyle(
                fontSize: TextSize.text_13,
                fontWeight: FontWeight.w700,
                textColor: ColorCodes.lightBlack),
          ),
          children: List<Widget>.generate(
            objStockRow.arrProducts!.length,
            (index) => productTile(objStockRow.arrProducts![index]),
          )),
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
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: (objProduct.imageUrl ?? "").isEmpty
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
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        Strings.balance.toUpperCase(),
                        style: Singleton.instance.setTextStyle(
                            fontSize: TextSize.text_11,
                            fontWeight: FontWeight.w400,
                            textColor: ColorCodes.lightBlack),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Text(
                        objProduct.balance.toString(),
                        style: Singleton.instance.setTextStyle(
                            fontSize: TextSize.text_22,
                            fontWeight: FontWeight.w700,
                            textColor: ColorCodes.primary),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget tradeRequestListview() {
    return Container(
      color: Colors.white,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return effectiveListTile(arrTradeRequests[index]);
        },
        itemCount: arrTradeRequests.length,
      ),
    );
  }

  Widget effectiveListTile(TradeLogsObject objTradeRequest) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18), color: Colors.white),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    var objTradeLogProduct =
                        objTradeRequest.arrTradeLogProduct![index];
                    return Text(
                      (objTradeLogProduct.productName ?? "") +
                          " x " +
                          objTradeLogProduct.quantity.toString(),
                      style: Singleton.instance.setTextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: TextSize.text_12,
                          textColor: ColorCodes.black),
                    );
                  },
                  itemCount: objTradeRequest.arrTradeLogProduct!.length,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    DateFormat("dd/MM/yyyy").format(
                        DateTime.parse(objTradeRequest.createdAt ?? "")),
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
                            .parse(objTradeRequest.createdAt!, true)
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total: " + objTradeRequest.totalQuantity.toString(),
                style: Singleton.instance.setTextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: TextSize.text_13,
                    textColor: ColorCodes.primary),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Singleton.instance.dividerWTOPAC(),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    objTradeRequest.username ?? "",
                    style: Singleton.instance.setTextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: TextSize.text_13,
                        textColor: ColorCodes.lightBlack),
                  ),
                  Text(
                    objTradeRequest.systemId ?? "",
                    style: Singleton.instance.setTextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: TextSize.text_13,
                        textColor: ColorCodes.lightBlack),
                  ),
                ],
              ),
              (objTradeRequest.acceptRequest == 1)
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            var isConfirmed = await Singleton.instance
                                .showAlertDialogWithTwoOptions(
                                    context,
                                    Constant.appName,
                                    "Are you sure you want to confirm this Trade request?",
                                    "Yes",
                                    "No");

                            if (isConfirmed == true) {
                              updateTradeRequest(objTradeRequest, 1);
                            }
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width / 5.5,
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24),
                                color: ColorCodes.lightYellowColor),
                            child: Text(
                              "Confirm",
                              style: Singleton.instance.setTextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: TextSize.text_10,
                                  textColor: ColorCodes.buttonTextColor),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        GestureDetector(
                          onTap: () async {
                            var isReject = await Singleton.instance
                                .showAlertDialogWithTwoOptions(
                                    context,
                                    Constant.appName,
                                    "Are you sure you want to reject this Trade request?",
                                    "Yes",
                                    "No");

                            if (isReject == true) {
                              updateTradeRequest(objTradeRequest, 2);
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
                              "Reject",
                              style: Singleton.instance.setTextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: TextSize.text_10,
                                  textColor: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Container(),
            ],
          )
        ],
      ),
    );
  }

  Widget tradeLogsListview() {
    return Container(
      color: Colors.white,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return tradeLogListTile(arrTradeLogs[index]);
        },
        itemCount: arrTradeLogs.length,
      ),
    );
  }

  Widget tradeLogListTile(TradeLogsObject objTradeLog) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18), color: Colors.white),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    var objTradeLogProduct =
                        objTradeLog.arrTradeLogProduct![index];
                    return Text(
                      (objTradeLogProduct.productName ?? "") +
                          " x " +
                          objTradeLogProduct.quantity.toString(),
                      style: Singleton.instance.setTextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: TextSize.text_12,
                          textColor: ColorCodes.black),
                    );
                  },
                  itemCount: objTradeLog.arrTradeLogProduct!.length,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    DateFormat("dd/MM/yyyy")
                        .format(DateTime.parse(objTradeLog.createdAt ?? "")),
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
                            .parse(objTradeLog.createdAt!, true)
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total: " + objTradeLog.totalQuantity.toString(),
                style: Singleton.instance.setTextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: TextSize.text_13,
                    textColor: ColorCodes.primary),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Singleton.instance.dividerWTOPAC(),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    objTradeLog.username ?? "",
                    style: Singleton.instance.setTextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: TextSize.text_13,
                        textColor: ColorCodes.lightBlack),
                  ),
                  Text(
                    objTradeLog.systemId ?? "",
                    style: Singleton.instance.setTextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: TextSize.text_13,
                        textColor: ColorCodes.lightBlack),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width / 5.5,
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        color: (objTradeLog.status == 1)
                            ? ColorCodes.primary
                            : ColorCodes.red),
                    child: Text(
                      (objTradeLog.status == 0)
                          ? "Pending"
                          : (objTradeLog.status == 1)
                              ? "Complete"
                              : (objTradeLog.status == 2)
                                  ? "Rejected"
                                  : "",
                      style: Singleton.instance.setTextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: TextSize.text_10,
                          textColor: Colors.white),
                    ),
                  ),
                  // const SizedBox(
                  //   width: 8,
                  // ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  // ******** API CALL ********
  Future<void> getStockBalance(bool isWantToShowProgress) async {
    late Map<String, String> header;
    header = {
      HttpHeaders.authorizationHeader: Singleton.instance.authToken,
    };

    late Map<String, String> body;
    Uri url = Uri.parse("");

    if (widget.objSelectedProject.id != null) {
      body = {
        ApiParamters.projectID: widget.objSelectedProject.id.toString(),
      };

      url = Uri.parse(ApiConstants.baseUrl +
          ApiConstants.baseUrlHost +
          ApiConstants.getStock +
          "?" +
          Uri(queryParameters: body).query);
    } else {
      url = Uri.parse(ApiConstants.baseUrl +
          ApiConstants.baseUrlHost +
          ApiConstants.getStock);
    }

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
          stockBalanceResponseModel =
              StockBalanceModel.fromJson(json.decode(response.body));

          arrTradeRequests.clear();
          arrTradeLogs.clear();

          if (stockBalanceResponseModel
              .payload!.data!.arrTradeRequest!.isEmpty) {
            arrTradeRequests = [];
          } else {
            arrTradeRequests =
                stockBalanceResponseModel.payload!.data!.arrTradeRequest!;
          }

          if (stockBalanceResponseModel.payload!.data!.arrTradeLogs!.isEmpty) {
            arrTradeLogs = [];
          } else {
            arrTradeLogs =
                stockBalanceResponseModel.payload!.data!.arrTradeLogs!;
          }

          arrStockList.clear();
          arrStockList = stockBalanceResponseModel.payload!.data!.arrRows!;
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

  Future<void> updateTradeRequest(
      TradeLogsObject objTradeLog, int status) async {
    late Map<String, String> header;
    header = {
      HttpHeaders.authorizationHeader: Singleton.instance.authToken,
    };

    late Map<String, String> body;

    body = {
      ApiParamters.tradeID: objTradeLog.id.toString(),
      ApiParamters.status: status.toString(),
      ApiParamters.projectID: objTradeLog.projectId.toString(),
    };

    if (kDebugMode) {
      print(body);
    }

    final url = Uri.parse(ApiConstants.baseUrl +
        ApiConstants.baseUrlHost +
        ApiConstants.updateTradeRequest);
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
          getStockBalance(false);
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
