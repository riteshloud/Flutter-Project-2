import 'package:flutter/material.dart';
import '../../helpers/colors.dart';
import '../../helpers/constant.dart';
import '../../helpers/singleton.dart';

class CommonRoundedWidget extends StatefulWidget {
  final double? width;
  final double? height;
  final Function? onPressed;
  final String? title;
  final String? icon;
  final double? iconSize;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final FontWeight? fontWeight;
  final bool? setFillColor;
  const CommonRoundedWidget({
    Key? key,
    this.width,
    this.height,
    @required this.onPressed,
    @required this.title,
    this.icon,
    this.iconSize,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.fontWeight,
    this.setFillColor = false,
  }) : super(key: key);

  @override
  _CommonRoundedWidgetState createState() => _CommonRoundedWidgetState();
}

class _CommonRoundedWidgetState extends State<CommonRoundedWidget> {
  @override
  Widget build(BuildContext context) {
    var _theme = Theme.of(context);
    EdgeInsetsGeometry edgeInsects =
        const EdgeInsets.symmetric(horizontal: 8, vertical: 4);
    if (widget.width == null || widget.height == null) {
      edgeInsects = const EdgeInsets.symmetric(horizontal: 8, vertical: 4);
    }
    return GestureDetector(
      onTap: () => widget.onPressed!(),
      child: Container(
        // margin: EdgeInsets.symmetric(horizontal: 50),
        height: widget.height,
        width: widget.width,
        padding: edgeInsects,
        decoration: BoxDecoration(
          color: ColorCodes.buttonColor,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 6.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Align(
                  alignment: Alignment.centerLeft, child: _buildTitle(_theme)),
              Align(
                  alignment: Alignment.centerRight, child: _buildIcon(_theme)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(ThemeData theme) {
    return Text(
      widget.title!,
      style: Singleton.instance.setTextStyle(
          fontWeight: FontWeight.w600,
          fontSize: TextSize.text_14,
          textColor: ColorCodes.buttonTextColor,
          fontFamily: Constant.latoFontFamily),
    );
  }

  Widget _buildIcon(ThemeData theme) {
    if (widget.icon != null) {
      return Padding(
          padding: const EdgeInsets.only(
            right: 0.0,
          ),
          child: Image.asset(
            widget.icon!,
            width: widget.iconSize,
            height: widget.iconSize,
            color: ColorCodes.buttonTextColor,
          ));
    }
    return const SizedBox();
  }
}
