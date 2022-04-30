import 'package:flutter/material.dart';
import 'colors.dart';

class Constant {
  static const String latoFontFamily = "Lato";
  static const String lucidaGrande = "LucidaGrande";

  static SizedBox sideMenuWidthBox = const SizedBox(width: 16.0);
  static SizedBox sideMenuHeightBox = const SizedBox(height: 8.0);
  static String isLoggedIn = "isLoggedIn";

  static String privacyURL = "https://www.google.com";
  static String termsURL = "https://www.apple.com";

  static String appName = "Demo2";
  static String pleaseWait = "please Wait";
  static String fetchingData = "fetching Data";
  static String authToken = "AuthToken";
  static String user = "user";

  static String alert = "Alert";
  static String noInternet =
      "Please check your internet connection and try again.";
  static String failureError =
      "Sorry we are unable to connect with the server, please try again later";

  static TextStyle alertTitleStyle = TextStyle(
      fontSize: TextSize.text_18,
      fontWeight: FontWeight.bold,
      color: ColorCodes.black);
  static TextStyle alertBodyStyle = TextStyle(
      fontSize: TextSize.text_16,
      fontWeight: FontWeight.normal,
      color: ColorCodes.black);

  static EdgeInsets textFieldInset = const EdgeInsets.symmetric(vertical: 60);

  static BoxDecoration gradientDecoration = const BoxDecoration(
      gradient: LinearGradient(
          colors: [Color(0xFF1C66E0), ColorCodes.titleBar],
          begin: FractionalOffset(0.25, 0.0),
          end: FractionalOffset(1.0, 0.0),
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp));
}

//**** GLOBAL STYLE AND DECORATION ****

class GlobalStyleAndDecoration {
  static TextStyle authButtonTextStyle = const TextStyle(
    fontSize: TextSize.text_15,
    fontWeight: FontWeight.bold,
    // color: AppColors.primary,
    fontFamily: Constant.latoFontFamily,
    color: Color(0xff696969),
  );

  static BoxDecoration commenttextFieldBoxDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(8),
    color: ColorCodes.unselectedColor,
  );

  static SizedBox spaceBetweenLabelText = const SizedBox(
    height: 6,
  );

  static BoxDecoration textFieldBoxDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      color: Colors.white,
      border: Border.all(color: ColorCodes.lightBlack));

  static BoxShadow boxShadow = BoxShadow(
    color: Colors.grey.withOpacity(0.2),
    spreadRadius: 5,
    blurRadius: 7,
    offset: const Offset(0, 3), // changes position of shadow
  );

  static BoxDecoration bottomShadowDecoration = BoxDecoration(
    color: Colors.white,
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.2),
        spreadRadius: 5,
        blurRadius: 7,
        offset: const Offset(0, 3), // changes position of shadow
      ),
    ],
    borderRadius: const BorderRadius.only(
      bottomLeft: Radius.circular(12),
      bottomRight: Radius.circular(12),
    ),
  );

  static BoxDecoration shadowDecoration = BoxDecoration(
    color: Colors.white,
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.2),
        spreadRadius: 5,
        blurRadius: 7,
        offset: const Offset(0, 3), // changes position of shadow
      ),
    ],
    borderRadius: BorderRadius.circular(12),
  );

  //TEXT STYLE
  static TextStyle navigationTitleStyle = TextStyle(
    fontSize: TextSize.text_18,
    fontWeight: FontWeight.w700,
    color: ColorCodes.black,
    fontFamily: Constant.latoFontFamily,
  );

  static InputDecoration textFieldDecoration = const InputDecoration(
      border: InputBorder.none,
      focusedBorder: InputBorder.none,
      enabledBorder: InputBorder.none,
      errorBorder: InputBorder.none,
      disabledBorder: InputBorder.none,
      contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
      hintText: "Enter full name");
}

class TextSize {
  static const double text_8 = 8;

  static const double text_10 = 10;
  static const double text_11 = 11;
  static const double text_12 = 12;
  static const double text_13 = 13;
  static const double text_14 = 14;
  static const double text_15 = 15;
  static const double text_16 = 16;
  static const double text_17 = 17;
  static const double text_18 = 18;
  static const double text_19 = 19;
  static const double text_20 = 20;
  static const double text_21 = 21;
  static const double text_22 = 22;
  static const double text_23 = 23;
  static const double text_24 = 24;
  static const double text_25 = 25;
  static const double text_26 = 26;
  static const double text_27 = 27;
  static const double text_28 = 28;
  static const double text_29 = 29;
  static const double text_30 = 30;
  static const double text_35 = 35;
}
