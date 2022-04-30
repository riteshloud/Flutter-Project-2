import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../screens/sales/purchase_product_screen.dart';

import '../../helpers/api_constant.dart';
import '../../helpers/colors.dart';
import '../../helpers/constant.dart';
import '../../helpers/singleton.dart';
import '../../helpers/strings.dart';

import '../../models/get_project_list_model.dart';
import '../../models/stock_balance_model.dart';

import '../../service/api_service.dart';

import '../../widgets/common_button.dart';

class TradeStockScreen extends StatefulWidget {
  final Rows objSelectedProject;
  const TradeStockScreen({Key? key, required this.objSelectedProject})
      : super(key: key);

  @override
  _TradeStockScreenState createState() => _TradeStockScreenState();
}

class _TradeStockScreenState extends State<TradeStockScreen> {
  final campaignIdController = TextEditingController();

  final descController = TextEditingController();
  final FocusNode campaignIdNode = FocusNode();
  final FocusNode descriptionNode = FocusNode();

  List<StockRowProduct> arrSelectedProducts = [];

  File? _image;
  @override
  void initState() {
    _image = null;
    super.initState();
  }

  void pickedImage(ImageSource imageSource) {
    Singleton.instance.pickImage(imageSource).then(
          (value) => setState(
            () {
              if (value == null) {
              } else {
                _image = value;
                setState(() {});
              }
            },
          ),
        );
  }

  void _submitOutletRequest() {
    FocusScope.of(context).unfocus();

    if (campaignIdController.text.trim().isEmpty) {
      Singleton.instance.showAlertDialogWithOkAction(
          context, Constant.alert, Strings.pleaseCampId);
    } else if (descController.text.trim().isEmpty) {
      Singleton.instance.showAlertDialogWithOkAction(
          context, Constant.alert, Strings.pleaseDescription);
    } else if (arrSelectedProducts.isEmpty) {
      Singleton.instance.showAlertDialogWithOkAction(
          context, Constant.alert, Strings.pleaseProductImage);
    } else {
      // String strProducts = jsonEncode(arrSelectedProducts);

      List<Map<String, dynamic>> arrProducts = [];

      for (int j = 0; j < arrSelectedProducts.length; j++) {
        var objProduct = arrSelectedProducts[j];

        Map<String, dynamic> dictProduct = {};

        dictProduct["productId"] = objProduct.id;
        dictProduct["quantity"] = "${objProduct.updatedBalance}";
        arrProducts.add(dictProduct);
      }
      String strProducts = jsonEncode(arrProducts);

      if (_image == null) {
        createTradeRequest(strProducts, "");
      } else {
        createTradeRequest(strProducts, _image!.absolute.path);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: ColorCodes.backgroundColor,
        appBar: Singleton.instance.commonAppbar(
            appbarText: Strings.tradeStockScreen,
            leadingClickEvent: () {
              Navigator.pop(context, false);
            },
            hideBackbutton: true,
            backgroundColor: Colors.white,
            iconColor: Colors.black,
            endText: "",
            search: false,
            endTextClickEvent: () {
              _submitOutletRequest();
            }),
        body: SingleChildScrollView(
          child: Container(
            color: ColorCodes.backgroundColor,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: ColorCodes.black.withOpacity(0.07)),
                  child: Container(
                    decoration: BoxDecoration(
                      // color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Singleton.instance.addGreyTextField(
                        campaignIdNode,
                        campaignIdController,
                        TextInputType.text,
                        false,
                        Strings.enterCampId,
                        TextInputAction.next),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: ColorCodes.black.withOpacity(0.07)),
                  child: Container(
                    decoration: BoxDecoration(
                      // color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Singleton.instance.addmultiLineGreyTextField(
                        descriptionNode,
                        descController,
                        TextInputType.multiline,
                        false,
                        Strings.enterDescription,
                        5,
                        true),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      Strings.productList.toUpperCase(),
                      style: Singleton.instance.setTextStyle(
                          fontSize: TextSize.text_13,
                          fontWeight: FontWeight.w700,
                          textColor: ColorCodes.lightBlack),
                    ),
                    GestureDetector(
                        onTap: () async {
                          arrSelectedProducts = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PurchaseProductScreen(
                                      objSelectedProject:
                                          widget.objSelectedProject,
                                      arrSelectedProducts: arrSelectedProducts,
                                    )),
                          );

                          if (arrSelectedProducts.isNotEmpty) {
                            setState(() {});
                          }
                        },
                        child: Image.asset(
                          "",
                          width: 24,
                          height: 24,
                        ))
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                Singleton.instance.dividerWTOPAC(),
                const SizedBox(
                  height: 4,
                ),
                productListview(),
                const SizedBox(
                  height: 16,
                ),
                uploadScreenShot(),
                const SizedBox(
                  height: 16,
                ),
                Container(
                  alignment: Alignment.center,
                  //width: MediaQuery.of(context).size.width/2.5,
                  child: CommonButton(
                    width: MediaQuery.of(context).size.width / 2,
                    onPressed: () {
                      _submitOutletRequest();
                    },
                    title: Strings.confirm,
                    setFillColor: true,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                /*
                Text(
                  Strings.desclaimer,
                  style: Singleton.instance.setTextStyle(
                      fontSize: TextSize.text_12,
                      fontWeight: FontWeight.w700,
                      textColor: ColorCodes.lightBlack),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  Strings.desclaimer_desc,
                  style: Singleton.instance.setTextStyle(
                      fontSize: TextSize.text_10,
                      fontWeight: FontWeight.w700,
                      textColor: ColorCodes.lightBlack),
                ),
                */
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget productListview() {
    return ListView.builder(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return productTile(arrSelectedProducts[index]);
      },
      itemCount: arrSelectedProducts.length,
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
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
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
                              memCacheHeight: null,
                              memCacheWidth: 200,
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
                          const SizedBox(
                            height: 2,
                          ),
                          Flexible(
                            child: Text(
                              (objProduct.updatedBalance == null)
                                  ? "RM: -"
                                  : "RM: ${((objProduct.updatedBalance!).toDouble() * (objProduct.amount ?? 1)).toPrecision(2)}"
                                      .replaceAll(Singleton.instance.regex, ""),
                              style: Singleton.instance.setTextStyle(
                                  fontSize: TextSize.text_12,
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
              Row(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        objProduct.updatedBalance.toString(),
                        style: Singleton.instance.setTextStyle(
                            fontSize: TextSize.text_20,
                            fontWeight: FontWeight.w400,
                            textColor: ColorCodes.primary),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  GestureDetector(
                      onTap: () {
                        arrSelectedProducts.removeWhere(
                            (element) => element.id == objProduct.id);
                        if (kDebugMode) {
                          print(arrSelectedProducts.length);
                          setState(() {});
                          print("REMOVE PRODUCT TAPPED");
                        }
                      },
                      child: const Icon(
                        Icons.close,
                        size: 20,
                        color: Colors.red,
                      )),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget uploadScreenShot() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          Strings.attcthedScreenshot.toUpperCase(),
          style: Singleton.instance.setTextStyle(
              fontSize: TextSize.text_13,
              fontWeight: FontWeight.w700,
              textColor: ColorCodes.lightBlack),
        ),
        const SizedBox(
          height: 8,
        ),
        Singleton.instance.dividerWTOPAC(),
        const SizedBox(
          height: 10,
        ),
        GestureDetector(
          onTap: () {
            Singleton.instance.showPicker(context, pickedImage, true);
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            alignment: Alignment.center,
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: ColorCodes.selectedBackgroundColor),
            child: Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.camera_alt_outlined,
                        size: 40, color: Colors.white),
                    Text(
                      Strings.uploadImage,
                      style: Singleton.instance.setTextStyle(
                          fontSize: TextSize.text_10,
                          fontWeight: FontWeight.w700,
                          textColor: ColorCodes.lightBlack),
                    ),
                  ],
                ),
                if (_image != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.file(
                      _image!,
                      fit: BoxFit.cover,
                      height: 150,
                      width: double.infinity,
                    ),
                  ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Future<void> createTradeRequest(String products, String imagepath) async {
    late Map<String, String> header;
    header = {
      HttpHeaders.authorizationHeader: Singleton.instance.authToken,
    };

    final url = Uri.parse(ApiConstants.baseUrl +
        ApiConstants.baseUrlHost +
        ApiConstants.createTradeRequest);
    if (kDebugMode) {
      print("url$url");
    }

    if (imagepath.isEmpty) {
      late Map<String, String> body;

      body = {
        ApiParamters.campaignId: campaignIdController.text,
        ApiParamters.description: descController.text,
        ApiParamters.products: products,
        ApiParamters.projectID: widget.objSelectedProject.id.toString(),
      };

      Singleton.instance.showDefaultProgress();
      ApiService.postCallwithHeader(url, body, header, context)
          .then((response) {
        final responseData = json.decode(response.body);
        try {
          if (kDebugMode) {
            print(responseData);
            print("statuscode ${response.statusCode}");
          }

          Singleton.instance.hideProgress();
          if (response.statusCode == 200) {
            Singleton.instance.showAlertDialogWithOkAction(
                context, Constant.alert, responseData["message"]);
          } else if (response.statusCode == 401) {
            Singleton.instance.showAInvalidTokenAlert(
                context, Constant.alert, responseData["message"]);
          } else {
            Singleton.instance.showAlertDialogWithOkAction(
                context, Constant.alert, responseData["message"]);
          }
        } on SocketException catch (e) {
          if (kDebugMode) {
            print(e.message);
          }
          response.success = false;
          response.message = "Please check internet connection";
        } catch (e) {
          response.success = responseData['success'];
          response.message = responseData['message'];
          response.code = responseData['code'];
        }
      });
    } else {
      Singleton.instance.showDefaultProgress();
      var request = http.MultipartRequest('POST', url);
      request.headers.addAll({
        HttpHeaders.authorizationHeader: Singleton.instance.authToken,
      });
      request.fields[ApiParamters.campaignId] = campaignIdController.text;
      request.fields[ApiParamters.description] = descController.text;
      request.fields[ApiParamters.products] = products;
      request.fields[ApiParamters.projectID] =
          widget.objSelectedProject.id.toString();

      var multipartFile =
          await MultipartFile.fromPath(ApiParamters.file, imagepath);
      request.files.add(multipartFile);
      var response = await request.send();

      if (kDebugMode) {
        print("response $response");
      }
      try {
        var responsed = await http.Response.fromStream(response);
        final responseData = json.decode(responsed.body);
        Singleton.instance.hideProgress();
        if (kDebugMode) {
          print("responseData $responseData");
          print("statusCode ${response.statusCode}");
        }

        if (response.statusCode == 200) {
          Singleton.instance.showAlertDialogWithOkAction(
              context, Constant.alert, responseData["message"]);
        } else if (response.statusCode == 401) {
          Singleton.instance.showAInvalidTokenAlert(
              context, Constant.alert, responseData["message"]);
        } else {
          Singleton.instance.showAlertDialogWithOkAction(
              context, Constant.alert, responseData["message"]);
        }
      } catch (e) {
        if (kDebugMode) {
          print("Exception $e");
        }
      }
    }
  }
}
