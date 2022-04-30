import 'dart:core';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../helpers/colors.dart';
import '../../../helpers/constant.dart';
import '../../../helpers/singleton.dart';

class SearchbarWidget extends StatefulWidget {
  final String appbarText;
  final Function? leadingClickEvent;
  final String? endText;
  final Function? endTextClickEvent;
  final Color? backgroundColor;
  final Color? iconColor;
  final Color? appbarTextColor;
  final Color? endTextColor;
  final bool search;
  final bool? hideBackbutton;
  final TextEditingController? controller;
  final Function? searchOperation;
  final Function? handleSearch;
  final Function? clearSearch;

  const SearchbarWidget(
      this.appbarText,
      this.leadingClickEvent,
      this.iconColor,
      this.appbarTextColor,
      this.search,
      this.hideBackbutton,
      this.controller,
      this.searchOperation,
      this.handleSearch,
      this.clearSearch,
      {Key? key,
      this.endText,
      this.endTextClickEvent,
      this.backgroundColor,
      this.endTextColor})
      : super(key: key);

  @override
  _SearchbarWidgetState createState() => _SearchbarWidgetState();
}

class _SearchbarWidgetState extends State<SearchbarWidget> {
  Icon icon = const Icon(
    Icons.search,
    color: ColorCodes.primary,
  );
  var appBarTitle;

  @override
  void initState() {
    appBarTitle = Text(widget.appbarText,
        textAlign: TextAlign.left,
        style: Singleton.instance.setTextStyle(
            fontFamily: Constant.latoFontFamily,
            fontWeight: FontWeight.bold,
            textColor: ColorCodes.black.withOpacity(0.8),
            fontSize: TextSize.text_16));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
        leadingWidth: !widget.hideBackbutton! ? 10 : 50,
        backgroundColor: Colors.white,
        leading: Visibility(
          visible: widget.hideBackbutton!,
          child: Container(
            margin: const EdgeInsets.only(left: 2),
            alignment: Alignment.centerLeft,
            child: IconButton(
              // padding: const EdgeInsets.only(right: 10),
              onPressed: () => widget.leadingClickEvent!(),
              icon: Image.asset(
                "",
                width: 36,
                height: 36,
                color: widget.iconColor ?? ColorCodes.primary,
              ),
            ),
          ),
        ),
        centerTitle: false,
        title: appBarTitle,
        actions: <Widget>[
          widget.search
              ? IconButton(
                  icon: icon,
                  onPressed: () {
                    setState(() {
                      if (icon.icon == Icons.search) {
                        icon = const Icon(
                          Icons.close,
                          color: ColorCodes.primary,
                        );
                        appBarTitle = Container(
                          height: 40,
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          decoration:
                              GlobalStyleAndDecoration.textFieldBoxDecoration,
                          child: TextFormField(
                            onFieldSubmitted: (value) {
                              if (kDebugMode) {
                                print("Final Value === $value");
                              }
                              widget.searchOperation!(
                                  widget.controller!.text.toString());
                            },
                            controller: widget.controller,
                            style: Singleton.instance.setTextStyle(
                                fontFamily: Constant.latoFontFamily,
                                fontWeight: FontWeight.bold,
                                textColor: widget.appbarTextColor ??
                                    ColorCodes.lightBlack,
                                fontSize: TextSize.text_14),
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                hintText: "Search",
                                hintStyle: Singleton.instance.setTextStyle(
                                    fontFamily: Constant.latoFontFamily,
                                    fontWeight: FontWeight.bold,
                                    textColor: widget.appbarTextColor ??
                                        ColorCodes.black.withOpacity(0.8),
                                    fontSize: TextSize.text_14)),
                            onChanged: widget.searchOperation!(
                                widget.controller!.text.toString()),
                          ),
                        );
                        widget.handleSearch!(true);
                      } else {
                        widget.handleSearch!(false);
                        widget.clearSearch!(widget.controller!.text);
                        widget.controller!.text = "";
                        setState(() {
                          icon = const Icon(
                            Icons.search,
                            color: ColorCodes.primary,
                          );
                          appBarTitle = Text(widget.appbarText,
                              textAlign: TextAlign.left,
                              style: Singleton.instance.setTextStyle(
                                  fontFamily: Constant.latoFontFamily,
                                  fontWeight: FontWeight.bold,
                                  textColor: ColorCodes.black.withOpacity(0.8),
                                  fontSize: TextSize.text_16));
                        });
                      }
                    });
                  },
                )
              : const SizedBox(
                  width: 1,
                ),
        ]);
  }
}
