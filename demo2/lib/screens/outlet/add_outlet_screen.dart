import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

import '../../screens/outlet/coverage_days_screen.dart';

import '../../helpers/api_constant.dart';
import '../../helpers/colors.dart';
import '../../helpers/constant.dart';
import '../../helpers/singleton.dart';
import '../../helpers/strings.dart';

import '../../models/coverage_model.dart';
import '../../models/coverage_days_model.dart';
import '../../models/get_project_list_model.dart';

import '../../service/api_service.dart';
import '../../widgets/common_button.dart';

class AddOutletScreen extends StatefulWidget {
  final Rows objSelectedProject;
  const AddOutletScreen({Key? key, required this.objSelectedProject})
      : super(key: key);

  @override
  _AddOutletScreenState createState() => _AddOutletScreenState();
}

class _AddOutletScreenState extends State<AddOutletScreen> {
  File? _image;
  bool isOwnerContactClicked = true;
  final emailController = TextEditingController();
  final nameController = TextEditingController();

  final contactController = TextEditingController();
  final FocusNode emailNode = FocusNode();
  final FocusNode contactNode = FocusNode();
  final FocusNode nameNode = FocusNode();

  bool isPersonanInchargeClicked = true;
  final personemailController = TextEditingController();
  final personnameController = TextEditingController();

  final personcontactController = TextEditingController();
  final FocusNode personemailNode = FocusNode();
  final FocusNode personcontactNode = FocusNode();
  final FocusNode personnameNode = FocusNode();
  LocationData? _currentPosition;
  Location location = Location();

  List<CoverageDays> arrSelectedCoverageDays = [];

  OutletLocationObject objOutletLocation = OutletLocationObject(
      outletName: "",
      outletEmail: "",
      outletContact: "",
      outletAddress: "",
      outletPostalCode: "",
      outletCity: "",
      outletState: "");

  @override
  void initState() {
    _image = null;
    getLoc(false);
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
    if (arrSelectedCoverageDays.isEmpty) {
      Singleton.instance.showAlertDialogWithOkAction(
          context, Constant.alert, Strings.pleaseSelectCoverageDays);
    } else if (_currentPosition == null) {
      Singleton.instance.showAlertDialogWithOkAction(
          context, Constant.alert, Strings.pleaseEnterCurrentLocation);
    } else if (nameController.text.trim().isEmpty) {
      Singleton.instance.showAlertDialogWithOkAction(
          context, Constant.alert, "Please enter owner name");
    } else if (objOutletLocation.outletName.trim().isEmpty) {
      Singleton.instance.showAlertDialogWithOkAction(
          context, Constant.alert, "Please enter outlet name");
    } else if (objOutletLocation.outletEmail.trim().isEmpty) {
      Singleton.instance.showAlertDialogWithOkAction(
          context, Constant.alert, "Please enter outlet email");
    } else if (!Singleton.isValidEmail(objOutletLocation.outletEmail.trim())) {
      Singleton.instance.showAlertDialogWithOkAction(
          context, Constant.alert, "Please enter valid outlet email");
    } else if (objOutletLocation.outletContact.trim().isEmpty) {
      Singleton.instance.showAlertDialogWithOkAction(
          context, Constant.alert, "Please enter outlet contact no");
    } else if (objOutletLocation.outletContact.trim().length < 8) {
      Singleton.instance.showAlertDialogWithOkAction(
          context, Constant.alert, "Please enter outlet valid contact no");
    } else if (objOutletLocation.outletContact.trim().length > 12) {
      Singleton.instance.showAlertDialogWithOkAction(
          context, Constant.alert, "Please enter outlet valid contact no");
    } else if (objOutletLocation.outletAddress.trim().isEmpty) {
      Singleton.instance.showAlertDialogWithOkAction(context, Constant.alert,
          "Please press the \"Get the current location\" button to get the address.");
    } else if (objOutletLocation.outletPostalCode.trim().isEmpty) {
      Singleton.instance.showAlertDialogWithOkAction(context, Constant.alert,
          "Please press the \"Get the current location\" button to get the postal code.");
    } else if (objOutletLocation.outletCity.trim().isEmpty) {
      Singleton.instance.showAlertDialogWithOkAction(context, Constant.alert,
          "Please press the \"Get the current location\" button to get the city.");
    } else if (objOutletLocation.outletState.trim().isEmpty) {
      Singleton.instance.showAlertDialogWithOkAction(context, Constant.alert,
          "Please press the \"Get the current location\" button to get the state.");
    } else if (emailController.text.trim().isEmpty) {
      Singleton.instance.showAlertDialogWithOkAction(
          context, Constant.alert, Strings.pleaseEnterOwnerEmail);
    } else if (!Singleton.isValidEmail(emailController.text.trim())) {
      Singleton.instance.showAlertDialogWithOkAction(
          context, Constant.alert, "Please enter valid owner email");
    } else if (contactController.text.trim().isEmpty) {
      Singleton.instance.showAlertDialogWithOkAction(
          context, Constant.alert, Strings.pleaseEnterOwnerContactNo);
    } else if (contactController.text.trim().length < 8) {
      Singleton.instance.showAlertDialogWithOkAction(
          context, Constant.alert, "Please enter owner valid contact no");
    } else if (contactController.text.trim().length > 12) {
      Singleton.instance.showAlertDialogWithOkAction(
          context, Constant.alert, "Please enter owner valid contact no");
    } else {
      bool isValid = true;
      if (personemailController.text.trim().isNotEmpty) {
        if (!Singleton.isValidEmail(personemailController.text.trim())) {
          isValid = false;
          Singleton.instance.showAlertDialogWithOkAction(context,
              Constant.alert, "Please enter valid personal incharge email");
        }
      } else if (personcontactController.text.trim().isNotEmpty) {
        if (personcontactController.text.trim().length < 8) {
          isValid = false;
          Singleton.instance.showAlertDialogWithOkAction(context,
              Constant.alert, "Please enter personal valid contact no");
        } else if (personcontactController.text.trim().length > 12) {
          isValid = false;
          Singleton.instance.showAlertDialogWithOkAction(context,
              Constant.alert, "Please enter personal valid contact no");
        }
      }

      if (isValid) {
        List<Map<String, String>> arrCovDays = [];

        for (int i = 0; i < arrSelectedCoverageDays.length; i++) {
          var objCoverageDay = arrSelectedCoverageDays[i];

          Map<String, String> dictCovDays = {};
          dictCovDays["days"] = objCoverageDay.day;

          arrCovDays.add(dictCovDays);
        }

        String strCoverageDays = jsonEncode(arrCovDays);
        if (kDebugMode) {
          print(strCoverageDays);
        }

        if (_image == null) {
          createOutletAPI("", strCoverageDays);
        } else {
          createOutletAPI(_image!.absolute.path, strCoverageDays);
        }
      }
    }
  }

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
              appbarText: Strings.addNewOutlet,
              leadingClickEvent: () {
                Navigator.pop(context, false);
              },
              hideBackbutton: true,
              backgroundColor: Colors.white,
              iconColor: Colors.black,
              endText: Strings.confirm,
              search: false,
              endTextClickEvent: () {
                _submitOutletRequest();
              }),
          body: SingleChildScrollView(
            child: Container(
              color: ColorCodes.backgroundColor,
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  coverageDays(),
                  const SizedBox(
                    height: 6,
                  ),
                  outletName(),
                  const SizedBox(
                    height: 8,
                  ),
                  ownerContact(),
                  const SizedBox(
                    height: 16,
                  ),
                  personIncharge(),
                  const SizedBox(
                    height: 16,
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: CommonButton(
                      width: MediaQuery.of(context).size.width / 2,
                      onPressed: () {
                        _submitOutletRequest();
                      },
                      title: Strings.confirm,
                      setFillColor: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget coverageDays() {
    return Column(
      children: [
        GestureDetector(
          onTap: () async {
            arrSelectedCoverageDays = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CoverageDaysScreen(
                        arrCoverageDays: arrSelectedCoverageDays,
                      )),
            );

            if (arrSelectedCoverageDays.isNotEmpty) {
              setState(() {});
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                Strings.coverageDays.toUpperCase(),
                style: Singleton.instance.setTextStyle(
                    fontSize: TextSize.text_13,
                    fontWeight: FontWeight.w700,
                    textColor: ColorCodes.lightBlack),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: Colors.white),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      arrSelectedCoverageDays.isEmpty
                          ? Strings.clickToSelect
                          : (arrSelectedCoverageDays.length.toString() +
                              " " +
                              (arrSelectedCoverageDays.length.toString() == "1"
                                  ? "Day"
                                  : "Days")),
                      style: Singleton.instance.setTextStyle(
                          fontSize: TextSize.text_12,
                          fontWeight: FontWeight.w400,
                          textColor: ColorCodes.lightBlack),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 21,
                      color: ColorCodes.primary,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Singleton.instance.dividerWTOPAC()
      ],
    );
  }

  Widget outletName() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () async {},
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      Strings.enterOutletName.toUpperCase(),
                      style: Singleton.instance.setTextStyle(
                          fontSize: TextSize.text_13,
                          fontWeight: FontWeight.w700,
                          textColor: ColorCodes.lightBlack),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Icon(
                      Icons.edit,
                      size: 16,
                      color: ColorCodes.lightBlack,
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              GestureDetector(
                onTap: () {
                  Singleton.instance.showDefaultProgress();
                  getLoc(true);
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      "",
                      width: 18,
                      height: 18,
                    ),
                    Text(
                      Strings.getTheCurrentLoc,
                      style: Singleton.instance.setTextStyle(
                          fontSize: TextSize.text_12,
                          fontWeight: FontWeight.w600,
                          textColor: ColorCodes.primary,
                          textDecoration: TextDecoration.underline),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            Singleton.instance.showPicker(context, pickedImage, true);
          },
          child: Container(
            alignment: Alignment.center,
            width: 100,
            height: 100,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: ColorCodes.selectedBackgroundColor),
            child: Stack(children: [
              (_image == null)
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.camera_alt_outlined,
                            size: 30, color: Colors.white),
                        Text(
                          Strings.uploadImage,
                          style: Singleton.instance.setTextStyle(
                              fontSize: TextSize.text_8,
                              fontWeight: FontWeight.w700,
                              textColor: Colors.white),
                        ),
                      ],
                    )
                  : Container(),
              if (_image != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.file(
                    _image!,
                    fit: BoxFit.cover,
                    height: 100,
                    width: double.infinity,
                  ),
                ),
            ]),
          ),
        )
      ],
    );
  }

  Widget addProfile() {
    return SizedBox(
      // color: Colors.green,
      height: 100,
      child: Stack(
        children: [
          Positioned.fill(
            child: Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                width: 100,
                height: 100,
                child: Stack(
                  children: [
                    if (_image != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(50.0),
                        child: Image.file(
                          _image!,
                          fit: BoxFit.cover,
                          height: 100,
                          width: 100,
                        ),
                      ),
                    Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,

                        // color: Colors.yellow,
                      ),
                      height: 100,
                      width: 100,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                width: 100,
                height: 100,
                child: GestureDetector(
                  onTap: () {
                    Singleton.instance.showPicker(context, pickedImage, true);
                  },
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.camera_alt_outlined,
                          size: 21,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget ownerContact() {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              isOwnerContactClicked = !isOwnerContactClicked;
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                Strings.ownerContact.toUpperCase(),
                style: Singleton.instance.setTextStyle(
                    fontSize: TextSize.text_13,
                    fontWeight: FontWeight.w700,
                    textColor: ColorCodes.lightBlack),
              ),
              isOwnerContactClicked
                  ? const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 21,
                      color: ColorCodes.primary,
                    )
                  : const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 14,
                      color: ColorCodes.primary,
                    )
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Singleton.instance.dividerWTOPAC(),
        const SizedBox(
          height: 10,
        ),
        Visibility(
            visible: isOwnerContactClicked,
            child: Column(
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
                        nameNode,
                        nameController,
                        TextInputType.text,
                        false,
                        Strings.enterName,
                        TextInputAction.next),
                  ),
                ),
                const SizedBox(
                  height: 4,
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
                    child: Singleton.instance.addGreyTextField(
                        emailNode,
                        emailController,
                        TextInputType.emailAddress,
                        false,
                        Strings.enterEmail,
                        TextInputAction.next),
                  ),
                ),
                const SizedBox(
                  height: 4,
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
                    child: TextField(
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      textInputAction: TextInputAction.done,
                      scrollPadding: Constant.textFieldInset,
                      focusNode: contactNode,
                      controller: contactController,
                      cursorColor: ColorCodes.lightBlack,
                      autocorrect: false,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.left,
                      obscureText: false,
                      decoration: Singleton.instance
                          .setTextFieldDecoration(Strings.enterContactNo),
                      style: Singleton.instance.setTextStyle(
                        fontFamily: Constant.latoFontFamily,
                        fontWeight: FontWeight.normal,
                        fontSize: TextSize.text_14,
                        textColor: ColorCodes.lightBlack,
                      ),
                    ),
                  ),
                ),
              ],
            ))
      ],
    );
  }

  Widget personIncharge() {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              isPersonanInchargeClicked = !isPersonanInchargeClicked;
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                Strings.personalIncharge.toUpperCase(),
                style: Singleton.instance.setTextStyle(
                    fontSize: TextSize.text_13,
                    fontWeight: FontWeight.w700,
                    textColor: ColorCodes.lightBlack),
              ),
              isPersonanInchargeClicked
                  ? const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 21,
                      color: ColorCodes.primary,
                    )
                  : const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 14,
                      color: ColorCodes.primary,
                    )
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Singleton.instance.dividerWTOPAC(),
        const SizedBox(
          height: 10,
        ),
        Visibility(
            visible: isPersonanInchargeClicked,
            child: Column(
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
                        personnameNode,
                        personnameController,
                        TextInputType.text,
                        false,
                        Strings.enterName,
                        TextInputAction.next),
                  ),
                ),
                const SizedBox(
                  height: 4,
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
                    child: Singleton.instance.addGreyTextField(
                        personemailNode,
                        personemailController,
                        TextInputType.emailAddress,
                        false,
                        Strings.enterEmail,
                        TextInputAction.next),
                  ),
                ),
                const SizedBox(
                  height: 4,
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
                    child: TextField(
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      textInputAction: TextInputAction.done,
                      scrollPadding: Constant.textFieldInset,
                      focusNode: personcontactNode,
                      controller: personcontactController,
                      cursorColor: ColorCodes.lightBlack,
                      autocorrect: false,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.left,
                      obscureText: false,
                      decoration: Singleton.instance
                          .setTextFieldDecoration(Strings.enterContactNo),
                      style: Singleton.instance.setTextStyle(
                        fontFamily: Constant.latoFontFamily,
                        fontWeight: FontWeight.normal,
                        fontSize: TextSize.text_14,
                        textColor: ColorCodes.lightBlack,
                      ),
                    ),
                  ),
                ),
              ],
            ))
      ],
    );
  }

  getLoc(bool isGetButtonTapped) async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _currentPosition = await location.getLocation();
    if (isGetButtonTapped) {
      if (_currentPosition != null) {
        getOutletAddress(_currentPosition!.latitude.toString(),
            _currentPosition!.longitude.toString());
      }
    }
  }

  Future<void> createOutletAPI(String imagepath, String coverageDays) async {
    final url = Uri.parse(ApiConstants.baseUrl +
        ApiConstants.baseUrlHost +
        ApiConstants.createOutlet);
    if (kDebugMode) {
      print("url$url");
    }

    if (_image == null) {
      late Map<String, String> header;
      header = {
        HttpHeaders.authorizationHeader: Singleton.instance.authToken,
      };

      late Map<String, String> body;
      body = {
        ApiParamters.projectID: widget.objSelectedProject.id.toString(),
        ApiParamters.ownerName: nameController.text.trim(),
        ApiParamters.ownerEmail: emailController.text.trim(),
        ApiParamters.ownerContact: contactController.text.trim(),
        ApiParamters.personName: personnameController.text.trim(),
        ApiParamters.personEmail: personemailController.text.trim(),
        ApiParamters.personContact: personcontactController.text.trim(),
        ApiParamters.coverageDays: coverageDays,
        ApiParamters.outletName: objOutletLocation.outletName.trim(),
        ApiParamters.outletEmail: objOutletLocation.outletEmail.trim(),
        ApiParamters.outletContact: objOutletLocation.outletContact,
        ApiParamters.address: objOutletLocation.outletAddress.trim(),
        ApiParamters.postalCode: objOutletLocation.outletPostalCode.trim(),
        ApiParamters.city: objOutletLocation.outletCity.trim(),
        ApiParamters.state: objOutletLocation.outletState.trim(),
      };

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
              _image = null;

              var isWantToUpdate = await Singleton.instance
                  .showAlertDialogWithGoPreviousOptions(
                      context, Constant.appName, responseData["message"], "Ok");

              if (isWantToUpdate == true) {
                Navigator.pop(context, true);
              }
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
    } else {
      Singleton.instance.showDefaultProgress();
      var request = http.MultipartRequest('POST', url);
      request.headers.addAll({
        HttpHeaders.authorizationHeader: Singleton.instance.authToken,
      });
      request.fields[ApiParamters.projectID] =
          widget.objSelectedProject.id.toString();
      request.fields[ApiParamters.ownerName] = nameController.text;
      request.fields[ApiParamters.ownerEmail] = emailController.text;
      request.fields[ApiParamters.ownerContact] = contactController.text;
      request.fields[ApiParamters.personName] = personnameController.text;
      request.fields[ApiParamters.personEmail] = personemailController.text;
      request.fields[ApiParamters.personContact] = personcontactController.text;
      request.fields[ApiParamters.coverageDays] = coverageDays;

      request.fields[ApiParamters.outletName] = objOutletLocation.outletName;
      request.fields[ApiParamters.outletEmail] = objOutletLocation.outletEmail;
      request.fields[ApiParamters.outletContact] =
          objOutletLocation.outletContact;
      request.fields[ApiParamters.address] = objOutletLocation.outletAddress;
      request.fields[ApiParamters.postalCode] =
          objOutletLocation.outletPostalCode;
      request.fields[ApiParamters.city] = objOutletLocation.outletCity;
      request.fields[ApiParamters.state] = objOutletLocation.outletState;

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
          _image = null;

          var isWantToUpdate = await Singleton.instance
              .showAlertDialogWithGoPreviousOptions(
                  context, Constant.appName, responseData["message"], "Ok");

          if (isWantToUpdate == true) {
            Navigator.pop(context, true);
          }
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

  Future<void> getOutletAddress(String latitude, String longitude) async {
    final url = Uri.parse(ApiConstants.baseUrl +
        ApiConstants.baseUrlHost +
        ApiConstants.getAddress);
    if (kDebugMode) {
      print("url$url");
    }

    late Map<String, String> header;
    header = {
      HttpHeaders.authorizationHeader: Singleton.instance.authToken,
    };

    late Map<String, String> body;
    body = {
      ApiParamters.lat: latitude,
      ApiParamters.long: longitude,
    };

    if (kDebugMode) {
      print("url$url");
    }

    Singleton.instance.showDefaultProgress();
    ApiService.postCallwithHeader(url, body, header, context).then((response) {
      if (response.body.isNotEmpty) {
        final responseData = json.decode(response.body);
        try {
          if (kDebugMode) {
            print(responseData);
            print("statuscode ${response.statusCode}");
          }
          Singleton.instance.hideProgress();
          if (response.statusCode == 200) {
            var data = json.decode(response.body)["payload"];

            objOutletLocation.outletAddress = data["address"];
            objOutletLocation.outletPostalCode = data["postal_code"];
            objOutletLocation.outletCity = data["city"];
            objOutletLocation.outletState = data["state"];

            Singleton.instance.showAlertDialogWithOkAction(
                context, Constant.appName, responseData["message"]);
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
}
