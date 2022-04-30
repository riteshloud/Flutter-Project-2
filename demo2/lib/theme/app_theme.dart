import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../helpers/constant.dart';
import '../helpers/colors.dart';
import 'text_styles.dart';

// Theme override for the light theme

class AppTheme {
  AppTheme();

  static ThemeData buildAppTheme() {
    final ThemeData base = ThemeData.light();

    return base.copyWith(
      brightness: Brightness.dark,

      primaryColor: Colors.blue,
      primaryColorLight: Colors.black,
      primaryColorDark: Colors.black, //NAVIGATION COLOR

      scaffoldBackgroundColor: Colors.white,

      textTheme: _buildTextTheme(base.textTheme),

      // Defining the colorScheme
      colorScheme: base.colorScheme.copyWith(
        onPrimary: Colors.white,
        onSecondary: ColorCodes.black,
      ),

      tabBarTheme: base.tabBarTheme.copyWith(
        labelStyle: const TextStyle(
          color: ColorCodes.red,
        ),
        unselectedLabelColor: Colors.yellow,
      ),
      // By default takes the primaryColor and TextTheme headline6 style
      appBarTheme: base.appBarTheme.copyWith(
        color: ColorCodes.black,
        toolbarTextStyle: const TextStyle(
          fontFamily: Constant.latoFontFamily,
          fontSize: TextSize.text_17,
          fontWeight: FontWeight.bold,
        ),
      ),

      //Override for the default Card theme
      cardTheme: base.cardTheme.copyWith(
        //color: kSecondaryAmber,
        elevation: 1.0,
      ),

      // Override for the default light button theme
      buttonTheme: base.buttonTheme.copyWith(
        buttonColor: Colors.deepPurple,
        textTheme: ButtonTextTheme.primary,
        //Color to start filling the Buttons when pressed.
        splashColor: Colors.pink,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          onPrimary: Colors.white,
          primary: Colors.green,
        ),
      ),

      // Override for the default Textfield style
      inputDecorationTheme: base.inputDecorationTheme.copyWith(
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.black,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        hintStyle: kTextHintStyle,
      ),

      // Overiding the icon theme
      iconTheme: base.iconTheme.copyWith(
        color: Colors.black,
        size: 26.0,
      ),
    );
  }

  static CupertinoThemeData buildCupertinoAppTheme() {
    return const CupertinoThemeData(
      primaryColor: Colors.black,
      scaffoldBackgroundColor: Colors.white,
      barBackgroundColor: Colors.black,
      brightness: Brightness.dark,
      textTheme: CupertinoTextThemeData(
        textStyle: TextStyle(
          color: Colors.black,
          fontSize: TextSize.text_13,
        ),
        navTitleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: TextSize.text_18,
          fontWeight: FontWeight.w600,
        ),
        navLargeTitleTextStyle: kHeadline6Style,
        actionTextStyle: TextStyle(
          color: Colors.black,
          fontSize: TextSize.text_15,
          fontWeight: FontWeight.w600,
        ),
        dateTimePickerTextStyle: TextStyle(
          color: Colors.black,
          fontSize: TextSize.text_15,
        ),
        navActionTextStyle: TextStyle(
          color: Colors.black,
          fontSize: TextSize.text_15,
        ),
        pickerTextStyle: TextStyle(
          color: Colors.black,
          fontSize: TextSize.text_15,
        ),
        tabLabelTextStyle: TextStyle(
          color: Colors.yellow,
          // fontSize: 17.0,
        ),
      ),
    );
  }

  // Method to create and return the text styles
  static _buildTextTheme(TextTheme base) {
    return base
        .copyWith(
          headline6: kHeadline6Style,
          headline5: kHeadline5TextStyle,
          headline4: kHeadline4TextStyle,
          headline3: kHeadline3TextStyle,
          bodyText1: kBodyText1Style,
          bodyText2: const TextStyle(
            color: Colors.black,
            fontSize: TextSize.text_15,
            fontWeight: FontWeight.w600,
          ),
          button: kButtonTextStyle,
          caption: kCaptionStyle,
        )
        .apply(
          // This will override and apply to all.
          fontFamily: Constant.latoFontFamily,
        );
  }
}
