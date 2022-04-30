import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:demo2/database/db_helper.dart';
import 'package:demo2/screens/login_screen.dart';

import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/general_config_model.dart';
import '../models/user_model.dart';
import '../widgets/common_button.dart';

import 'api_constant.dart';
import 'colors.dart';
import 'constant.dart';
import 'strings.dart';

class Singleton {
  Singleton._privateConstructor();

  static final Singleton _instance = Singleton._privateConstructor();

  static Singleton get instance => _instance;
  UserModel objLoginUser = UserModel.fromJson({});
  GeneralConfigModel objGeneralConfig = GeneralConfigModel();
  bool isDarkMode = false;
  double screenWidth = 0.0;
  String token = "";
  String authToken = "";
  String fcmToken = "";
  String userId = "";
  String name = "";
  String profile = "";
  RegExp regex = RegExp(r"([.]*0)(?!.*\d)");
  bool isInternet = false;
  bool isDataCall = false;
  final MyConnectivity connectivity = MyConnectivity.instance;

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> setAuthToken() async {
    final SharedPreferences prefs = await _prefs;
    authToken = prefs.getString(Constant.authToken) ?? "";

    if (Singleton.instance.authToken.isEmpty) {
      Singleton.instance.authToken = authToken;
    }
  }

  static bool isValidatePassword(String value) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(value);
  }

  static bool isValidEmail(String value) {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(value);
  }

  bool validateStructure(String value) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(value);
  }

  Future<void> setUserModel(String user) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString(Constant.user, user);
  }

  Future<String?> getUserModel() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString(Constant.user);
  }

  Future<UserModel> getLoggedInUser() async {
    final SharedPreferences prefs = await _prefs;
    Map<String, dynamic> json =
        jsonDecode(prefs.getString(Constant.user) ?? "");
    var user = UserModel.fromJson(json);
    return user;
  }

//SVPROGRESS HUD
  void customizationSVProgressHUD() {
    SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.custom);
    SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.light);
    SVProgressHUD.setBackgroundLayerColor(Colors.black54);
    SVProgressHUD.setBackgroundColor(Colors.white);
    SVProgressHUD.setForegroundColor(Colors.black);
    SVProgressHUD.setRingRadius(18);
    SVProgressHUD.setRingThickness(2.5);
    SVProgressHUD.setCornerRadius(10);
  }

  void showDefaultProgress() {
    SVProgressHUD.show();
  }

  void showProgressWithTitle(String title) {
    SVProgressHUD.show(status: title);
  }

  void hideProgress() {
    SVProgressHUD.dismiss();
  }

  //TEXTFIELD DECORATION
  InputDecoration setTextFieldDecoration(String hintText) {
    return InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      focusedBorder: InputBorder.none,
      enabledBorder: InputBorder.none,
      errorBorder: InputBorder.none,
      disabledBorder: InputBorder.none,
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      hintText: hintText,
      hintStyle: const TextStyle(
        color: ColorCodes.editTextColor,
      ),
    );
  }

  //TEXTSTYLE
  TextStyle setTextStyle({
    double fontSize = 15,
    Color textColor = Colors.white,
    FontWeight fontWeight = FontWeight.normal,
    String fontFamily = Constant.latoFontFamily,
    double height = 1.25,
    TextDecoration textDecoration = TextDecoration.none,
  }) {
    return TextStyle(
      fontSize: fontSize,
      color: textColor,
      fontWeight: fontWeight,
      fontFamily: fontFamily,
      height: height,
      decoration: textDecoration,
    );
  }

  TextField addTextField(
      FocusNode node,
      TextEditingController controller,
      TextInputType inputType,
      bool isPassword,
      String hint,
      TextInputAction textInputAction) {
    return TextField(
      textInputAction: textInputAction,
      scrollPadding: Constant.textFieldInset,
      focusNode: node,
      controller: controller,
      cursorColor: Colors.white,
      autocorrect: false,
      keyboardType: inputType,
      textAlign: TextAlign.center,
      obscureText: isPassword,
      decoration: Singleton.instance.setTextFieldDecoration(hint),
      style: Singleton.instance.setTextStyle(
        fontFamily: Constant.latoFontFamily,
        fontWeight: FontWeight.normal,
        fontSize: TextSize.text_14,
        textColor: ColorCodes.editTextColor,
      ),
    );
  }

  TextField addGreyTextField(
      FocusNode node,
      TextEditingController controller,
      TextInputType inputType,
      bool isPassword,
      String hint,
      TextInputAction textInputAction) {
    return TextField(
      textInputAction: textInputAction,
      scrollPadding: Constant.textFieldInset,
      focusNode: node,
      controller: controller,
      cursorColor: ColorCodes.lightBlack,
      autocorrect: false,
      keyboardType: inputType,
      textAlign: TextAlign.left,
      obscureText: isPassword,
      decoration: Singleton.instance.setTextFieldDecoration(hint),
      style: Singleton.instance.setTextStyle(
        fontFamily: Constant.latoFontFamily,
        fontWeight: FontWeight.normal,
        fontSize: TextSize.text_14,
        textColor: ColorCodes.lightBlack,
      ),
    );
  }

  TextField addmultiLineGreyTextField(
      FocusNode node,
      TextEditingController controller,
      TextInputType inputType,
      bool isPassword,
      String hint,
      int minLines,
      bool enable) {
    return TextField(
      scrollPadding: Constant.textFieldInset,
      focusNode: node,
      controller: controller,
      cursorColor: ColorCodes.lightBlack,
      autocorrect: false,
      maxLines: 5,
      minLines: minLines,
      keyboardType: inputType,
      textAlign: TextAlign.left,
      obscureText: isPassword,
      enabled: enable,
      decoration: Singleton.instance.setTextFieldDecoration(hint),
      style: Singleton.instance.setTextStyle(
        fontFamily: Constant.latoFontFamily,
        fontWeight: FontWeight.normal,
        fontSize: TextSize.text_14,
        textColor: ColorCodes.lightBlack,
      ),
    );
  }

  Widget placeholderWidget(double height, double width) {
    return Image.asset(
      "",
      height: height,
      width: width,
      fit: BoxFit.cover,
    );
  }

  Widget qrPlaceholderWidget(double height, double width) {
    return Image.asset(
      "",
      height: height,
      width: width,
      fit: BoxFit.cover,
    );
  }

  //DATEPICKER
  Future<TimeOfDay?> presentTimePicker(BuildContext context) async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    return pickedTime;
  }

  Future<bool> isIOS() async {
    if (Platform.isIOS) {
      return true;
    } else {
      return false;
    }
  }

  String getRandString(int len) {
    var random = Random.secure();
    var values = List<int>.generate(len, (i) => random.nextInt(255));
    return base64UrlEncode(values);
  }

  int randomDigits(int digitCount) {
    var rng = Random();
    var code = rng.nextInt(900000) + 100000;
    return code;
  }

  Future<bool> isInternetConnected() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    } else if (connectivityResult == ConnectivityResult.none) {
      return false;
    } else {
      return false;
    }
  }

  Future<bool?> showAlertDialogWithOptions(
      BuildContext context,
      String title,
      String message,
      String positiveOption,
      String negativeOption,
      TextEditingController controller,
      FocusNode focusNode,
      Function positivebutton) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: ThemeData.light(),
          child: AlertDialog(
            backgroundColor: ColorCodes.subtitleColor,
            title: Column(
              children: [
                Text(
                  title,
                  style: Constant.alertTitleStyle,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  message,
                  style: Constant.alertBodyStyle,
                ),
              ],
            ),
            content: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: ColorCodes.black, width: 0.5),
                  color: Colors.white),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: ColorCodes.black, width: 0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  maxLength: 4,
                  textInputAction: TextInputAction.done,
                  scrollPadding: Constant.textFieldInset,
                  focusNode: focusNode,
                  controller: controller,
                  cursorColor: ColorCodes.lightBlack,
                  autocorrect: false,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.left,
                  obscureText: false,
                  decoration: Singleton.instance
                      .setTextFieldDecoration(Strings.enterOtpText),
                  style: Singleton.instance.setTextStyle(
                    fontFamily: Constant.latoFontFamily,
                    fontWeight: FontWeight.normal,
                    fontSize: TextSize.text_14,
                    textColor: ColorCodes.lightBlack,
                  ),
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  negativeOption,
                  style: Theme.of(context).textTheme.subtitle2,
                ),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              TextButton(
                child: Text(
                  positiveOption,
                  style: Theme.of(context).textTheme.subtitle2,
                ),
                onPressed: () {
                  positivebutton();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  showAlertDialogWithReasonInput(
      BuildContext context,
      String title,
      String message,
      String positiveOption,
      String negativeOption,
      TextEditingController controller,
      FocusNode focusNode,
      Function positivebutton) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: ThemeData.light(),
          child: AlertDialog(
            backgroundColor: ColorCodes.subtitleColor,
            title: Column(
              children: [
                // Text(
                //   title,
                //   style: Constant.alertTitleStyle,
                // ),
                // const SizedBox(
                //   height: 10,
                // ),
                Text(
                  message,
                  style: Constant.alertBodyStyle,
                ),
              ],
            ),
            content: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: ColorCodes.black, width: 0.5),
                  color: Colors.white),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: ColorCodes.black, width: 0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  textInputAction: TextInputAction.done,
                  scrollPadding: Constant.textFieldInset,
                  focusNode: focusNode,
                  controller: controller,
                  cursorColor: ColorCodes.lightBlack,
                  autocorrect: false,
                  keyboardType: TextInputType.text,
                  textAlign: TextAlign.left,
                  maxLines: 3,
                  decoration:
                      Singleton.instance.setTextFieldDecoration('Reason'),
                  style: Singleton.instance.setTextStyle(
                    fontFamily: Constant.latoFontFamily,
                    fontWeight: FontWeight.normal,
                    fontSize: TextSize.text_14,
                    textColor: ColorCodes.lightBlack,
                  ),
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  negativeOption,
                  style: Theme.of(context).textTheme.subtitle2,
                ),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              TextButton(
                child: Text(
                  positiveOption,
                  style: Theme.of(context).textTheme.subtitle2,
                ),
                onPressed: () {
                  positivebutton();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<bool?> showAlertDialogWithTwoOptions(
      BuildContext context,
      String title,
      String message,
      String positiveOption,
      String negativeOption) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: ThemeData.light(),
          child: AlertDialog(
            title: Text(
              title,
              style: Constant.alertTitleStyle,
            ),
            content: Text(
              message,
              style: Constant.alertBodyStyle,
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  negativeOption,
                  style: Theme.of(context).textTheme.subtitle2,
                ),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              TextButton(
                child: Text(
                  positiveOption,
                  style: Theme.of(context).textTheme.subtitle2,
                ),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<bool?> showAlertDialogWithGoPreviousOptions(
    BuildContext context,
    String title,
    String message,
    String positiveOption,
  ) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: ThemeData.light(),
          child: AlertDialog(
            title: Text(
              title,
              style: Constant.alertTitleStyle,
            ),
            content: Text(
              message,
              style: Constant.alertBodyStyle,
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  positiveOption,
                  style: Theme.of(context).textTheme.subtitle2,
                ),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  //SNACK DIALOG
  Future<void> showSnackBar(BuildContext context, String message) async {
    SnackBar snackbar = SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Text(
        message,
        style: Singleton.instance.setTextStyle(textColor: Colors.white),
      ),
    );
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  //ALERT DIALOG
  Future<void> showAlertDialogWithOkAction(
      BuildContext context, String title, String content) async {
    showDialog(
      context: context,
      builder: (ctx) {
        return Theme(
          data: ThemeData.light(),
          child: AlertDialog(
            title: Text(
              title,
              style: Singleton.instance.setTextStyle(
                  fontSize: TextSize.text_16,
                  fontWeight: FontWeight.bold,
                  textColor: ColorCodes.black),
            ),
            content: Text(
              content,
              style: Singleton.instance.setTextStyle(
                  fontSize: TextSize.text_16, textColor: ColorCodes.black),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  "Ok",
                  style: Singleton.instance.setTextStyle(
                      fontWeight: FontWeight.bold, textColor: ColorCodes.black),
                ),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  //ALERT DIALOG
  Future<void> showAlertDialogWithTWOAction(BuildContext context, String title,
      String content, Function positiveButtonCLicked) async {
    showDialog(
      context: context,
      builder: (ctx) {
        return Theme(
          data: ThemeData.light(),
          child: AlertDialog(
            title: Text(
              title,
              style: Singleton.instance.setTextStyle(
                  fontSize: TextSize.text_16,
                  fontWeight: FontWeight.bold,
                  textColor: ColorCodes.black),
            ),
            content: Text(
              content,
              style: Singleton.instance.setTextStyle(
                  fontSize: TextSize.text_16, textColor: ColorCodes.black),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  "Logout",
                  style: Singleton.instance.setTextStyle(
                      fontWeight: FontWeight.bold, textColor: ColorCodes.black),
                ),
                onPressed: () {
                  positiveButtonCLicked();
                },
              ),
              TextButton(
                child: Text(
                  "Cancel",
                  style: Singleton.instance.setTextStyle(
                      fontWeight: FontWeight.bold, textColor: ColorCodes.black),
                ),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  //ALERT DIALOG
  Future<void> showAInvalidTokenAlert(
      BuildContext context, String title, String content) async {
    showDialog(
      context: context,
      builder: (ctx) {
        return Theme(
          data: ThemeData.light(),
          child: AlertDialog(
            title: Text(
              title,
              style: Singleton.instance.setTextStyle(
                  fontSize: TextSize.text_16,
                  fontWeight: FontWeight.bold,
                  textColor: ColorCodes.black),
            ),
            content: Text(
              content,
              style: Singleton.instance.setTextStyle(
                  fontSize: TextSize.text_16, textColor: ColorCodes.black),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  "Ok",
                  style: Singleton.instance.setTextStyle(
                      fontWeight: FontWeight.bold, textColor: ColorCodes.black),
                ),
                onPressed: () {
                  //FORCEFULLY LOGOUT USER
                  Navigator.of(ctx).pop();
                  logoutUser(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void logoutUser(BuildContext context) async {
    //CLEAR ALL DATA BEFORE LOGOUT
    DBHelper.clearAllTableData();

    // Singleton.instance.fcmToken = "";
    // Singleton.instance.connectivity.disposeStream();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (Route<dynamic> route) => false);
  }

  AppBar commonAppbar(
      {String? appbarText,
      Function? leadingClickEvent,
      String? endText,
      Function? endTextClickEvent,
      Color? backgroundColor,
      Color? iconColor,
      Color? appbarTextColor,
      Color? endTextColor,
      bool? search,
      bool? hideBackbutton,
      bool? isWantToSetBackgroud}) {
    return AppBar(
      backgroundColor: backgroundColor ?? ColorCodes.appbar,
      elevation: 5,
      leading: null,
      actions: const [],
      title: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Visibility(
                visible: hideBackbutton ?? true,
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    padding: const EdgeInsets.only(right: 16),
                    onPressed: () => leadingClickEvent!(),
                    icon: Image.asset(
                      "",
                      width: 36,
                      height: 36,
                      color: iconColor ?? Colors.black,
                    ),
                  ),
                ),
              ),
              Text(
                appbarText!,
                textAlign: TextAlign.left,
                style: Singleton.instance.setTextStyle(
                    fontFamily: Constant.latoFontFamily,
                    fontWeight: FontWeight.bold,
                    textColor:
                        appbarTextColor ?? ColorCodes.black.withOpacity(0.8),
                    fontSize: TextSize.text_16),
              ),
            ],
          ),
          Visibility(
            visible: search ?? false,
            child: Image.asset(
              "",
              width: 21,
              height: 21,
              color: ColorCodes.primary,
            ),
          ),
          if (endText!.isNotEmpty)
            Visibility(
              child: Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 5, left: 10),
                child: CommonButton(
                  onPressed: () => endTextClickEvent!(),
                  title: endText,
                  setFillColor: true,
                  backgroundColor: (isWantToSetBackgroud == null)
                      ? ColorCodes.buttonColor
                      : Colors.white,
                ),
              ),
            ),
        ],
      ),
      automaticallyImplyLeading: false,
    );
  }

  Widget divider() {
    return Divider(
      height: 1,
      color: ColorCodes.dividerShade.withOpacity(0.7),
    );
  }

  Future<File?> pickImage(ImageSource pickImage) async {
    var imagePicker = ImagePicker();

    try {
      final pickedFile = await imagePicker.pickImage(
        source: pickImage,
        imageQuality: 60,
      );

      return File(pickedFile!.path);
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return File("");
    }
  }

  void showPicker(context, Function pickedImage, bool isWantToShowChoosePhoto) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            color: Colors.white,
            child: SafeArea(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                // color: Colors.pink,
                child: Wrap(
                  children: <Widget>[
                    isWantToShowChoosePhoto
                        ? GestureDetector(
                            onTap: () {
                              pickedImage(ImageSource.gallery);
                              Navigator.of(context).pop();
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Icon(Icons.photo_library,
                                      color: ColorCodes.navbar),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Choose image",
                                    style: setTextStyle(
                                        fontWeight: FontWeight.bold,
                                        textColor: ColorCodes.navbar),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Container(),
                    GestureDetector(
                      onTap: () {
                        pickedImage(ImageSource.camera);
                        Navigator.of(context).pop();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Icon(Icons.photo_camera,
                                color: ColorCodes.navbar),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Take a photo",
                              style: setTextStyle(
                                  fontWeight: FontWeight.bold,
                                  textColor: ColorCodes.navbar),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Icon(Icons.close, color: Colors.black),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Cancel",
                              style: setTextStyle(
                                  fontWeight: FontWeight.bold,
                                  textColor: ColorCodes.navbar),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  String deviceType() {
    String deviceType;
    if (Platform.isIOS) {
      deviceType = ApiParamters.ios;
    } else {
      deviceType = ApiParamters.android;
    }

    return deviceType;
  }

  Widget dividerWTOPAC() {
    return const Divider(
      thickness: 2,
      height: 2,
      color: ColorCodes.dividerShade,
    );
  }
}

extension Ex on double {
  double toPrecision(int n) => double.parse(toStringAsFixed(n));
}

class MyConnectivity {
  MyConnectivity._();

  static final _instance = MyConnectivity._();
  static MyConnectivity get instance => _instance;
  final _connectivity = Connectivity();
  final _controller = StreamController.broadcast();
  Stream get myStream => _controller.stream;

  void initialise() async {
    ConnectivityResult result = await _connectivity.checkConnectivity();
    _checkStatus(result);
    _connectivity.onConnectivityChanged.listen((result) {
      _checkStatus(result);
    });
  }

  void _checkStatus(ConnectivityResult result) async {
    bool isOnline = false;
    try {
      final result = await InternetAddress.lookup('example.com');
      isOnline = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      isOnline = false;
    }
    _controller.sink.add({result: isOnline});
  }

  void disposeStream() => _controller.close();
}
