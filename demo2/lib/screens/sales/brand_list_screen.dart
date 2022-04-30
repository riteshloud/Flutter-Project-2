import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../helpers/colors.dart';
import '../../helpers/constant.dart';
import '../../helpers/singleton.dart';
import '../../helpers/strings.dart';
import '../../models/general_config_model.dart';

class BrandListScreen extends StatefulWidget {
  final List<BrandVariantMainObject> arrBrandVarient;
  const BrandListScreen({Key? key, required this.arrBrandVarient})
      : super(key: key);

  @override
  _BrandListScreenState createState() => _BrandListScreenState();
}

class _BrandListScreenState extends State<BrandListScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, widget.arrBrandVarient);
        return true;
      },
      child: AnnotatedRegion(
        value: SystemUiOverlayStyle.dark,
        child: Scaffold(
          backgroundColor: ColorCodes.backgroundColor,
          appBar: Singleton.instance.commonAppbar(
              appbarText: Strings.brandListScreen,
              leadingClickEvent: () {
                Navigator.pop(context, widget.arrBrandVarient);
              },
              hideBackbutton: true,
              backgroundColor: Colors.white,
              iconColor: Colors.black,
              endText: "",
              search: false,
              endTextClickEvent: () {}),
          body: Container(
              padding: const EdgeInsets.all(16), child: listBrandDays(context)),
        ),
      ),
    );
  }

  Widget listBrandDays(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.zero,
      child: Container(
        margin: EdgeInsets.zero,
        color: ColorCodes.backgroundColor,
        child: ListView.separated(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                    initiallyExpanded: false,
                    tilePadding: EdgeInsets.zero,
                    textColor: ColorCodes.lightBlack,
                    key: PageStorageKey<BrandVariantMainObject>(
                        widget.arrBrandVarient[index]),
                    title: Text(
                      (widget.arrBrandVarient[index].brands ?? "")
                          .toUpperCase(),
                      style: Singleton.instance.setTextStyle(
                          fontSize: TextSize.text_13,
                          fontWeight: FontWeight.w700,
                          textColor: ColorCodes.lightBlack),
                    ),
                    children: List<Widget>.generate(
                      widget.arrBrandVarient[index].arrBrandVariants!.length,
                      (indx) => outletTile(widget
                          .arrBrandVarient[index].arrBrandVariants![indx]),
                    )),
              );
            },
            separatorBuilder: (context, index) {
              return Singleton.instance.dividerWTOPAC();
            },
            itemCount: widget.arrBrandVarient.length),
      ),
    );
  }

  Widget outletTile(BrandVarientObject objBrandVariant) {
    return GestureDetector(
      onTap: () async {
        setState(() {
          for (int i = 0; i < widget.arrBrandVarient.length; i++) {
            var objMain = widget.arrBrandVarient[i];
            objMain.arrBrandVariants?.forEach((element) {
              element.isSelected = false;
            });
          }

          objBrandVariant.isSelected = !objBrandVariant.isSelected;

          bool isAnyobjectSelected = false;
          for (int i = 0; i < widget.arrBrandVarient.length; i++) {
            var objMain = widget.arrBrandVarient[i];
            var count = objMain.arrBrandVariants
                ?.where((c) => c.isSelected == true)
                .toList()
                .length;

            if (count! > 0) {
              isAnyobjectSelected = true;
              break;
            } else {
              isAnyobjectSelected = false;
            }
          }

          if (isAnyobjectSelected) {
            Navigator.pop(context, widget.arrBrandVarient);
          }
        });
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(18)),
        margin: const EdgeInsets.only(bottom: 5),
        child: Container(
          color: Colors.transparent,
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                objBrandVariant.value.toUpperCase(),
                style: Singleton.instance.setTextStyle(
                    fontSize: TextSize.text_13,
                    fontWeight: FontWeight.w700,
                    textColor: objBrandVariant.isSelected
                        ? ColorCodes.primary
                        : ColorCodes.lightBlack),
              ),
              Visibility(
                child: objBrandVariant.isSelected
                    ? Image.asset(
                        "",
                        width: 40,
                        height: 40,
                      )
                    : const SizedBox(
                        width: 40,
                        height: 40,
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
