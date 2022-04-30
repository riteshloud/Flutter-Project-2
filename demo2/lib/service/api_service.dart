import 'dart:io';
import 'package:flutter/foundation.dart';

import '../helpers/api_constant.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../helpers/singleton.dart';
import '../helpers/constant.dart';

class ApiService {
  static Future<dynamic> getCall(Uri url, BuildContext context) async {
    try {
      final response = await http.get(url);
      return response;
    } on HttpException catch (error) {
      Singleton.instance.hideProgress();
      Singleton.instance.showAlertDialogWithOkAction(
          context, Constant.alert, error.toString());
    } catch (error) {
      Singleton.instance.hideProgress();
      Singleton.instance.showAlertDialogWithOkAction(
          context, Constant.alert, Constant.failureError);
    }
  }

  static Future<dynamic> getCallwithHeader(
      Uri url, Map<String, String> headerParam, BuildContext context) async {
    try {
      final response = await http.get(url, headers: headerParam);
      return response;
    } on HttpException catch (error) {
      Singleton.instance.hideProgress();
      Singleton.instance.showAlertDialogWithOkAction(
          context, Constant.alert, error.toString());
    } catch (error) {
      Singleton.instance.hideProgress();
      Singleton.instance.showAlertDialogWithOkAction(
          context, Constant.alert, Constant.failureError);
    }
  }

  static Future<dynamic> postCall(
      Uri url, Map<String, String> params, BuildContext context) async {
    try {
      final response = await http.post(url, body: params);
      return response;
    } on HttpException catch (error) {
      Singleton.instance.hideProgress();
      Singleton.instance.showAlertDialogWithOkAction(
          context, Constant.alert, error.toString());
    } catch (error) {
      Singleton.instance.hideProgress();
      Singleton.instance.showAlertDialogWithOkAction(
          context, Constant.alert, Constant.failureError);
    }
  }

  static Future<dynamic> postCallwithHeader(Uri url, Map<String, String> params,
      Map<String, String> headerParam, BuildContext context) async {
    try {
      final response = await http.post(url, body: params, headers: headerParam);

      if (kDebugMode) {
        print("response in service $response");
      }
      return response;
    } on HttpException catch (error) {
      Singleton.instance.hideProgress();
      Singleton.instance.showAlertDialogWithOkAction(
          context, Constant.alert, error.toString());
    } catch (error) {
      Singleton.instance.hideProgress();
      Singleton.instance.showAlertDialogWithOkAction(
          context, Constant.alert, Constant.failureError);
    }
  }

  static Future<dynamic> multipartCall(
      Uri url, Map<String, String> params, BuildContext context) async {
    var request = http.MultipartRequest("POST", url)
      ..fields['user'] = 'nweiz@google.com'
      ..files.add(await http.MultipartFile.fromPath(
          /*field*/ ApiParamters.profileImage,
          /*filepath*/ 'build/package.tar.gz',
          filename: ""));
    request.send().then((response) {
      if (response.statusCode == 200) {}
    });

    try {
      final response = await http.post(url, body: params);
      return response;
    } on HttpException catch (error) {
      Singleton.instance.hideProgress();
      Singleton.instance.showAlertDialogWithOkAction(
          context, Constant.alert, error.toString());
    } catch (error) {
      Singleton.instance.hideProgress();
      Singleton.instance.showAlertDialogWithOkAction(
          context, Constant.alert, Constant.failureError);
    }
  }
}
