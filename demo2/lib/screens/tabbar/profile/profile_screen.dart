import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

import '../../../helpers/api_constant.dart';
import '../../../helpers/colors.dart';
import '../../../helpers/constant.dart';
import '../../../helpers/singleton.dart';
import '../../../helpers/strings.dart';

import '../../../models/login_response_model.dart';
import '../../../models/user_model.dart';

import '../../../service/api_service.dart';

class ProfileScreen extends StatefulWidget {
  final bool frombottomMenu;

  const ProfileScreen(this.frombottomMenu, {Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<Notifications> arrNotification = [];
  List<LoginHistory> arrLoginHistory = [];
  List<QRCode> arrQRCodes = [];
  int ongoingProject = 0;
  String strLastLogin = "";

  @override
  void initState() {
    if (kDebugMode) {
      print("PROFILE SCREEN INIT STATE CALLED");
    }
    Singleton.instance.isInternetConnected().then((intenet) {
      if (intenet) {
        getUserProfile(true);
      }
    });
    super.initState();
  }

  var imageUploaded = false;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
      child: Container(
        color: ColorCodes.backgroundColor,
        child: Column(
          children: [
            headerLayout(),
            Expanded(
              child: SingleChildScrollView(
                  child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 8,
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Upload QR code".toUpperCase(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Singleton.instance.setTextStyle(
                                fontSize: TextSize.text_13,
                                fontWeight: FontWeight.w700,
                                textColor: ColorCodes.lightBlack),
                          ),
                          const Icon(
                            Icons.arrow_right,
                            color: Colors.black,
                            size: 32.0,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Singleton.instance.dividerWTOPAC(),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(children: [
                      Text(
                        Strings.notification.toUpperCase(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Singleton.instance.setTextStyle(
                            fontSize: TextSize.text_13,
                            fontWeight: FontWeight.w700,
                            textColor: ColorCodes.lightBlack),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Text(
                          Strings.viewAll,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Singleton.instance.setTextStyle(
                              fontSize: TextSize.text_14,
                              fontWeight: FontWeight.w600,
                              textColor: ColorCodes.primary),
                        ),
                      ),
                    ], mainAxisAlignment: MainAxisAlignment.spaceBetween),
                    const SizedBox(
                      height: 8,
                    ),
                    notificationList(context),
                    const SizedBox(
                      height: 8,
                    ),
                    Singleton.instance.dividerWTOPAC(),
                    const SizedBox(
                      height: 16,
                    ),
                    Row(children: [
                      Text(
                        Strings.loginLogs.toUpperCase(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Singleton.instance.setTextStyle(
                            fontSize: TextSize.text_13,
                            fontWeight: FontWeight.w700,
                            textColor: ColorCodes.lightBlack),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Text(
                          Strings.viewAll,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Singleton.instance.setTextStyle(
                              fontSize: TextSize.text_14,
                              fontWeight: FontWeight.w600,
                              textColor: ColorCodes.primary),
                        ),
                      ),
                    ], mainAxisAlignment: MainAxisAlignment.spaceBetween),
                    const SizedBox(
                      height: 8,
                    ),
                    logsList(context),
                  ],
                ),
              )),
            )
          ],
        ),
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
                      visible: !widget.frombottomMenu,
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
                    !widget.frombottomMenu
                        ? const SizedBox(
                            width: 8,
                          )
                        : const SizedBox(
                            width: 16,
                          ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Singleton.instance.profile.isEmpty ||
                              (!Singleton.instance.isInternet)
                          ? Singleton.instance.placeholderWidget(48, 48)
                          : CachedNetworkImage(
                              imageUrl: Singleton.instance.profile,
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
                          Singleton.instance.objLoginUser.username ?? "",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Singleton.instance.setTextStyle(
                              fontSize: TextSize.text_16,
                              fontWeight: FontWeight.w600,
                              textColor: ColorCodes.black),
                        ),
                        Text(
                          "Supervisor",
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
                Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        child: Icon(
                          Icons.edit,
                          color: ColorCodes.black,
                          size: 21,
                        ),
                      )),
                ),
              ],
            ),
            const SizedBox(
              height: 24,
            ),
            Padding(
              padding: !widget.frombottomMenu
                  ? const EdgeInsets.only(left: 45)
                  : const EdgeInsets.only(left: 20),
              child: Singleton.instance.dividerWTOPAC(),
            ),
            Padding(
              padding: !widget.frombottomMenu
                  ? const EdgeInsets.only(left: 45)
                  : const EdgeInsets.only(left: 20),
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
                                    Strings.lastLogin.toUpperCase(),
                                    style: Singleton.instance.setTextStyle(
                                        fontSize: TextSize.text_12,
                                        fontWeight: FontWeight.w700,
                                        textColor: ColorCodes.lightBlack),
                                  ),
                                ),
                                const SizedBox(
                                  height: 2,
                                ),
                                FittedBox(
                                  fit: BoxFit.cover,
                                  child: Text(
                                    strLastLogin.isEmpty ? "-" : strLastLogin,
                                    style: Singleton.instance.setTextStyle(
                                        fontSize: TextSize.text_24,
                                        fontWeight: FontWeight.w600,
                                        textColor: ColorCodes.primary),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
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
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FittedBox(
                                  fit: BoxFit.cover,
                                  child: Text(
                                    Strings.ongoing.toUpperCase(),
                                    style: Singleton.instance.setTextStyle(
                                        fontSize: TextSize.text_12,
                                        fontWeight: FontWeight.w700,
                                        textColor: ColorCodes.lightBlack),
                                  ),
                                ),
                                const SizedBox(
                                  height: 2,
                                ),
                                FittedBox(
                                  fit: BoxFit.cover,
                                  child: Text(
                                    ongoingProject.toString(),
                                    style: Singleton.instance.setTextStyle(
                                        fontSize: TextSize.text_24,
                                        fontWeight: FontWeight.w600,
                                        textColor: ColorCodes.black),
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

  Widget listTileWidget(BuildContext context, int index) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  arrNotification[index].title ?? "",
                  //overflow: TextOverflow.ellipsis,
                  style: Singleton.instance.setTextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: TextSize.text_16,
                      textColor: ColorCodes.black),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  arrNotification[index].data ?? "",
                  //overflow: TextOverflow.ellipsis,
                  style: Singleton.instance.setTextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: TextSize.text_14,
                      textColor: Colors.black.withOpacity(0.5)),
                )
              ],
            ),
          ),
          const SizedBox(
            width: 16,
          ),
          Text(
            DateFormat("dd/MM/yyyy").format(DateTime.parse(
                arrNotification[index].createdAt ?? "".toString())),
            style: Singleton.instance.setTextStyle(
                fontWeight: FontWeight.w600,
                fontSize: TextSize.text_12,
                textColor: ColorCodes.black),
          )
        ],
      ),
    );
  }

  Widget notificationList(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(top: 0, left: 0, right: 0, bottom: 0),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {},
          child: listTileWidget(context, index),
        );
      },
      itemCount: arrNotification.length,
    );
  }

  Widget listTileLogsWidget(BuildContext context, int index) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                  child: Text(
                arrLoginHistory[index].type ?? "",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Singleton.instance.setTextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: TextSize.text_16,
                    textColor: ColorCodes.black),
              )),
              Text(
                DateFormat("dd/MM/yyyy").format(DateTime.parse(
                    arrLoginHistory[index].createdAt ?? "".toString())),
                style: Singleton.instance.setTextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: TextSize.text_12,
                    textColor: ColorCodes.lightBlack),
              )
            ],
          ),
          Text(
            DateFormat("hh:mm a").format(DateTime.parse(
                DateFormat("yyyy-MM-ddTHH:mm:ssZ")
                    .parse(arrLoginHistory[index].createdAt!, true)
                    .toLocal()
                    .toString())),
            style: Singleton.instance.setTextStyle(
                fontWeight: FontWeight.w600,
                fontSize: TextSize.text_12,
                textColor: ColorCodes.black),
          )
        ],
      ),
    );
  }

  Widget logsList(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(top: 0, left: 0, right: 0, bottom: 0),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {},
          child: listTileLogsWidget(context, index),
        );
      },
      itemCount: arrLoginHistory.length,
    );
  }

  // ******** API CALL ********
  Future<void> getUserProfile(bool isWantToShowProgress) async {
    LoginResponseModel loginResponseModel;

    late Map<String, String> header;
    header = {
      HttpHeaders.authorizationHeader: Singleton.instance.authToken,
    };

    final url = Uri.parse(ApiConstants.baseUrl +
        ApiConstants.baseUrlHost +
        ApiConstants.userProfile);
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
          loginResponseModel =
              LoginResponseModel.fromJson(json.decode(response.body));

          if (loginResponseModel.payload!.projectsCount == null) {
            ongoingProject = 0;
          } else {
            ongoingProject = loginResponseModel.payload!.projectsCount!;
          }

          arrNotification = loginResponseModel.payload!.arrNotifications!;
          arrLoginHistory = loginResponseModel.payload!.arrLoginHistory!;

          if (loginResponseModel.payload!.arrQRCode == null) {
            arrQRCodes.clear();
          } else {
            arrQRCodes = loginResponseModel.payload!.arrQRCode!;
          }

          if (arrLoginHistory.isNotEmpty) {
            strLastLogin = DateFormat("dd/MM/yyyy")
                .format(DateTime.parse(arrLoginHistory[0].createdAt ?? ""));
          }
          String userData = jsonEncode(
              UserModel.fromJson(json.decode(response.body)['payload']));
          if (kDebugMode) {
            print("user $userData");
          }

          Singleton.instance.setUserModel(userData);

          Singleton.instance.authToken = loginResponseModel.payload!.token!;

          Singleton.instance.name = loginResponseModel.payload!.username!;
          Singleton.instance.userId = loginResponseModel.payload!.systemId!;
          if (loginResponseModel.payload!.profilePicture == null) {
            Singleton.instance.profile = "";
          } else {
            Singleton.instance.profile =
                loginResponseModel.payload!.profilePicture!;
          }

          Singleton.instance.getLoggedInUser().then((user) {
            if ((user.id ?? 0) <= 0) {
              Singleton.instance.objLoginUser = user;
              setState(() {});
            }
          });
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
