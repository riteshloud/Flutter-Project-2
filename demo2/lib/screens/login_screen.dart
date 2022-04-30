import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'tabbar/tabbar.dart';

import '../models/login_response_model.dart';
import '../models/user_model.dart';
import '../service/api_service.dart';

import '../helpers/api_constant.dart';
import '../helpers/colors.dart';
import '../helpers/constant.dart';
import '../helpers/singleton.dart';
import '../helpers/strings.dart';

import '../widgets/common_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final FocusNode emailNode = FocusNode();
  final FocusNode passwordNode = FocusNode();

  clearTextInputs() {
    emailController.clear();
    passwordController.clear();
  }

  void _submitLoginRequest() {
    FocusScope.of(context).unfocus();

    if (emailController.text.trim().isEmpty) {
      Singleton.instance.showAlertDialogWithOkAction(
          context, Constant.alert, Strings.pleaseEnterName);
    } else if (!Singleton.isValidEmail(emailController.text.trim())) {
      Singleton.instance.showAlertDialogWithOkAction(
          context, Constant.alert, "Please enter valid email.");
    } else if (passwordController.text.trim().isEmpty) {
      Singleton.instance.showAlertDialogWithOkAction(
          context, Constant.alert, "Please enter password.");
    } else {
      Singleton.instance.isInternetConnected().then((intenet) {
        if (intenet) {
          callLoginAPI(emailController.text.trim().toString(),
              passwordController.text.toString());
        } else {
          Singleton.instance.showAlertDialogWithOkAction(
              context, Constant.appName, Constant.noInternet);
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
        value: SystemUiOverlayStyle.dark,
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(""),
              fit: BoxFit.fill,
            ),
          ),
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.transparent,
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
              child: Center(
                child: Form(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          Strings.welcome,
                          style: Singleton.instance.setTextStyle(
                              fontFamily: Constant.latoFontFamily,
                              fontSize: TextSize.text_12),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Text(
                          Strings.field,
                          style: Singleton.instance.setTextStyle(
                              fontFamily: Constant.latoFontFamily,
                              fontSize: TextSize.text_35),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Text(
                          Strings.usernameEmail,
                          style: Singleton.instance.setTextStyle(
                              fontFamily: Constant.latoFontFamily,
                              fontSize: TextSize.text_14),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: ColorCodes.editBGColor.withOpacity(0.85)),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Singleton.instance.addTextField(
                                emailNode,
                                emailController,
                                TextInputType.emailAddress,
                                false,
                                Strings.enterUsername,
                                TextInputAction.next),
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Text(
                          Strings.password,
                          style: Singleton.instance.setTextStyle(
                              fontFamily: Constant.latoFontFamily,
                              fontSize: TextSize.text_14),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: ColorCodes.editBGColor.withOpacity(0.85)),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white.withOpacity(0.1)),
                            child: Singleton.instance.addTextField(
                                passwordNode,
                                passwordController,
                                TextInputType.visiblePassword,
                                true,
                                Strings.enterPassword,
                                TextInputAction.done),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        CommonButton(
                          onPressed: () {
                            _submitLoginRequest();
                          },
                          title: Strings.login,
                          setFillColor: true,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  // ******** API CALL ********
  Future<void> callLoginAPI(String email, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    LoginResponseModel loginResponseModel;

    late Map<String, String> body;
    body = {
      ApiParamters.username: email,
      ApiParamters.password: password,
      ApiParamters.deviceToken: Singleton.instance.fcmToken,
      ApiParamters.deviceTypeAuth: Singleton.instance.deviceType(),
    };

    final url = Uri.parse(
        ApiConstants.baseUrl + ApiConstants.baseUrlHost + ApiConstants.login);
    if (kDebugMode) {
      print("url$url $body");
    }

    Singleton.instance.showDefaultProgress();
    ApiService.postCall(url, body, context).then((response) {
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

          if (kDebugMode) {
            print("AuthToekn ${Singleton.instance.authToken}");
            print("userJson payload ${loginResponseModel.message}");
          }

          Singleton.instance.getLoggedInUser().then((user) {
            if ((user.id ?? 0) <= 0) {
              Singleton.instance.objLoginUser = user;
              prefs.setBool(Constant.isLoggedIn, true);
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => const DynamicTabbedPage()),
                  (Route<dynamic> route) => false);
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
