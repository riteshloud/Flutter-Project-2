import 'package:flutter/material.dart';
import '../../helpers/colors.dart';
import '../../helpers/constant.dart';
import '../../helpers/singleton.dart';

class CommonButton extends StatefulWidget {
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
  const CommonButton({
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
  _CommonButtonState createState() => _CommonButtonState();
}

class _CommonButtonState extends State<CommonButton> {
  @override
  Widget build(BuildContext context) {
    var _theme = Theme.of(context);
    EdgeInsetsGeometry edgeInsects = const EdgeInsets.all(8);
    if (widget.width == null || widget.height == null) {
      edgeInsects = const EdgeInsets.symmetric(horizontal: 12, vertical: 8);
    }
    return GestureDetector(
      onTap: () => widget.onPressed!(),
      child: Container(
        // margin: EdgeInsets.symmetric(horizontal: 50),
        height: widget.height,
        width: widget.width,
        padding: edgeInsects,
        decoration: BoxDecoration(
          color: widget.backgroundColor ?? ColorCodes.buttonColor,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Align(alignment: Alignment.center, child: _buildTitle(_theme)),
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
          textColor: widget.textColor ?? ColorCodes.buttonTextColor,
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
          ));
    }
    return const SizedBox();
  }
}
