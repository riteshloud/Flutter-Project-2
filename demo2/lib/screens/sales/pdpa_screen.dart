import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:demo2/helpers/api_constant.dart';
import 'package:demo2/models/general_config_model.dart';
import 'package:demo2/service/api_service.dart';

import '../../helpers/colors.dart';
import '../../helpers/constant.dart';
import '../../helpers/singleton.dart';
import '../../helpers/strings.dart';

import '../../widgets/common_button.dart';

class PDPAScreen extends StatefulWidget {
  final String contactNo;
  const PDPAScreen({Key? key, required this.contactNo}) : super(key: key);

  @override
  _PDPAScreenState createState() => _PDPAScreenState();
}

class _PDPAScreenState extends State<PDPAScreen> {
  bool _checkvalue = false;
  final controller = TextEditingController();
  final node = FocusNode();
  int languageIndex = 0;

  PDPAObject objPDPABM = Singleton.instance.objGeneralConfig.arrPDPA![0];
  PDPAObject objPDPAEnglish = Singleton.instance.objGeneralConfig.arrPDPA![1];

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
              appbarText: Strings.pdpaScreen,
              leadingClickEvent: () {
                Navigator.pop(context, false);
              },
              hideBackbutton: true,
              backgroundColor: Colors.white,
              iconColor: Colors.black,
              endText: "",
              search: false,
              endTextClickEvent: () {}),
          body: Container(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            languageIndex = 0;
                          });
                        },
                        child: Text(
                          "ENG",
                          style: TextStyle(
                              color: (languageIndex == 0)
                                  ? Colors.blue
                                  : Colors.black),
                        ),
                      ),
                      const Text("|"),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            languageIndex = 1;
                          });
                        },
                        child: Text(
                          "BM",
                          style: TextStyle(
                              color: (languageIndex == 1)
                                  ? Colors.blue
                                  : Colors.black),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    (languageIndex == 0)
                        ? objPDPAEnglish.title!.toUpperCase()
                        : objPDPABM.title!.toUpperCase(),
                    style: Singleton.instance.setTextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: TextSize.text_14,
                        textColor: ColorCodes.black,
                        textDecoration: TextDecoration.underline),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    (languageIndex == 0)
                        ? objPDPAEnglish.description!.replaceAll('\\n', '\n')
                        : objPDPABM.description!.replaceAll('\\n', '\n'),
                    style: Singleton.instance.setTextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: TextSize.text_12,
                      textColor: ColorCodes.black,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _checkvalue = !_checkvalue;
                      });
                    },
                    child: Row(
                      children: [
                        _checkvalue
                            ? Image.asset(
                                "",
                                width: 24,
                                height: 24,
                              )
                            : Image.asset(
                                "",
                                width: 24,
                                height: 24,
                              ),
                        const SizedBox(
                          width: 8,
                        ),
                        Flexible(
                          child: Text(
                            (languageIndex == 0)
                                ? objPDPAEnglish.radioText!
                                : objPDPABM.radioText!,
                            style: Singleton.instance.setTextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: TextSize.text_13,
                              textColor: ColorCodes.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    (languageIndex == 0)
                        ? objPDPAEnglish.confirmText!.toUpperCase()
                        : objPDPABM.confirmText!.toUpperCase(),
                    style: Singleton.instance.setTextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: TextSize.text_14,
                      textColor: ColorCodes.black,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(bottom: 16),
                    child: CommonButton(
                      width: MediaQuery.of(context).size.width / 2,
                      onPressed: () {
                        if (_checkvalue) {
                          sendOTP();
                        } else {
                          Singleton.instance.showAlertDialogWithOkAction(
                              context,
                              Constant.appName,
                              "Please accept consent");
                        }
                      },
                      title: Strings.sendOtp,
                      textColor: Colors.white,
                      backgroundColor: ColorCodes.primary,
                      setFillColor: true,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void positiveButtonClicked() {
    if (controller.text.isEmpty) {
      Singleton.instance.showAlertDialogWithOkAction(
          context, Constant.alert, Strings.enterOtp);
    } else {
      verifyOTP(controller.text);
    }
  }

  Future<void> sendOTP() async {
    late Map<String, String> header;
    header = {
      HttpHeaders.authorizationHeader: Singleton.instance.authToken,
    };

    late Map<String, String> body;
    body = {
      ApiParamters.number: widget.contactNo.trim().toString(),
    };

    final url = Uri.parse(
        ApiConstants.baseUrl + ApiConstants.baseUrlHost + ApiConstants.sendOPT);
    if (kDebugMode) {
      print("url$url");
    }

    Singleton.instance.showDefaultProgress();
    ApiService.postCallwithHeader(url, body, header, context)
        .then((response) async {
      if (response.body.isNotEmpty) {
        final responseData = json.decode(response.body);
        try {
          if (kDebugMode) {
            print(responseData);
            print("statuscode ${response.statusCode}");
          }
          Singleton.instance.hideProgress();
          if (response.statusCode == 200) {
            Singleton.instance.showSnackBar(context, responseData["message"]);

            controller.text = "";
            Singleton.instance.showAlertDialogWithOptions(
                context,
                "OTP",
                "Enter OTP received by customer",
                "OK",
                "Cancel",
                controller,
                node,
                positiveButtonClicked);
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

  Future<void> verifyOTP(String otp) async {
    late Map<String, String> header;
    header = {
      HttpHeaders.authorizationHeader: Singleton.instance.authToken,
    };

    late Map<String, String> body;
    body = {
      ApiParamters.number: widget.contactNo.trim().toString(),
      ApiParamters.otp: otp,
    };

    final url = Uri.parse(ApiConstants.baseUrl +
        ApiConstants.baseUrlHost +
        ApiConstants.verifyOTP);
    if (kDebugMode) {
      print("url$url");
    }

    Singleton.instance.showDefaultProgress();
    ApiService.postCallwithHeader(url, body, header, context)
        .then((response) async {
      if (response.body.isNotEmpty) {
        final responseData = json.decode(response.body);
        try {
          if (kDebugMode) {
            print(responseData);
            print("statuscode ${response.statusCode}");
          }
          Singleton.instance.hideProgress();
          if (response.statusCode == 200) {
            Singleton.instance.showSnackBar(context, responseData["message"]);
            Navigator.pop(context, true);
            Navigator.pop(context, true);
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
      }
    });
  }
}
