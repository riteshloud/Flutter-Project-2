import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../helpers/colors.dart';
import '../../helpers/constant.dart';
import '../../helpers/singleton.dart';
import '../../helpers/strings.dart';

import '../../models/coverage_days_model.dart';
import '../../widgets/common_button.dart';

class CoverageDaysScreen extends StatefulWidget {
  final List<CoverageDays> arrCoverageDays;
  const CoverageDaysScreen({Key? key, required this.arrCoverageDays})
      : super(key: key);

  @override
  _CoverageDaysScreenState createState() => _CoverageDaysScreenState();
}

class _CoverageDaysScreenState extends State<CoverageDaysScreen> {
  List<CoverageDays> arrCoverageDays = [];
  List<CoverageDays> arrFilledCoverageDays = [];

  @override
  void initState() {
    fillCoverageDaysData();
    super.initState();
  }

  fillCoverageDaysData() {
    arrCoverageDays.clear();

    TimeOfDay initialTime = TimeOfDay.now();
    arrCoverageDays.add(CoverageDays(
      day: "Monday",
      isSelected: false,
      startTime: initialTime,
      startTimeInString: "-",
      endTime: initialTime,
      endTimeInString: "-",
    ));
    arrCoverageDays.add(CoverageDays(
      day: "Tuesday",
      isSelected: false,
      startTime: initialTime,
      startTimeInString: "-",
      endTime: initialTime,
      endTimeInString: "-",
    ));
    arrCoverageDays.add(CoverageDays(
      day: "Wednesday",
      isSelected: false,
      startTime: initialTime,
      startTimeInString: "-",
      endTime: initialTime,
      endTimeInString: "-",
    ));
    arrCoverageDays.add(CoverageDays(
      day: "Thursday",
      isSelected: false,
      startTime: initialTime,
      startTimeInString: "-",
      endTime: initialTime,
      endTimeInString: "-",
    ));
    arrCoverageDays.add(CoverageDays(
      day: "Friday",
      isSelected: false,
      startTime: initialTime,
      startTimeInString: "-",
      endTime: initialTime,
      endTimeInString: "-",
    ));
    arrCoverageDays.add(CoverageDays(
      day: "Saturday",
      isSelected: false,
      startTime: initialTime,
      startTimeInString: "-",
      endTime: initialTime,
      endTimeInString: "-",
    ));

    if (widget.arrCoverageDays.isNotEmpty) {
      for (int i = 0; i < arrCoverageDays.length; i++) {
        var objCoverageDay = arrCoverageDays[i];

        for (int j = 0; j < widget.arrCoverageDays.length; j++) {
          var objSelectedCoverageDay = widget.arrCoverageDays[j];

          if (objCoverageDay.day == objSelectedCoverageDay.day) {
            objCoverageDay.isSelected = true;
            objCoverageDay.startTime = objSelectedCoverageDay.startTime;
            objCoverageDay.startTimeInString =
                objSelectedCoverageDay.startTimeInString;
            objCoverageDay.endTime = objSelectedCoverageDay.endTime;
            objCoverageDay.endTimeInString =
                objSelectedCoverageDay.endTimeInString;
          }
        }
      }
    }
  }

  void _submitCoverageDays() {
    var count =
        arrCoverageDays.where((c) => (c.isSelected == true)).toList().length;

    if (count <= 0) {
      Singleton.instance.showAlertDialogWithOkAction(
          context, Constant.alert, "Please select atlease 1 covrage day.");
      return;
    } else {
      arrFilledCoverageDays.clear();
      for (int i = 0; i < arrCoverageDays.length; i++) {
        var objCoverageDay = arrCoverageDays[i];

        if (objCoverageDay.isSelected == true) {
          arrFilledCoverageDays.add(objCoverageDay);
        }
      }
    }

    Navigator.pop(context, arrFilledCoverageDays);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: AnnotatedRegion(
        value: SystemUiOverlayStyle.dark,
        child: Scaffold(
          backgroundColor: ColorCodes.backgroundColor,
          appBar: Singleton.instance.commonAppbar(
              appbarText: Strings.coverageDays,
              leadingClickEvent: () {
                Navigator.pop(context, widget.arrCoverageDays);
              },
              hideBackbutton: true,
              backgroundColor: Colors.white,
              iconColor: Colors.black,
              endText: "",
              search: false,
              endTextClickEvent: () {}),
          body: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 16),
              child: listcoverageDays()),
        ),
      ),
    );
  }

  Widget listcoverageDays() {
    return SingleChildScrollView(
      child: Column(
        children: [
          ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return listTile(context, arrCoverageDays[index]);
              },
              separatorBuilder: (context, index) {
                return Singleton.instance.dividerWTOPAC();
              },
              itemCount: arrCoverageDays.length),
          Container(
            alignment: Alignment.center,
            child: CommonButton(
              width: MediaQuery.of(context).size.width / 2,
              onPressed: () {
                _submitCoverageDays();
              },
              title: Strings.confirm,
              setFillColor: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget listTile(BuildContext context, CoverageDays objCoverageDay) {
    return GestureDetector(
      onTap: () async {
        objCoverageDay.isSelected = !objCoverageDay.isSelected;
        setState(() {});
      },
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  objCoverageDay.day.toUpperCase(),
                  style: Singleton.instance.setTextStyle(
                      fontSize: TextSize.text_13,
                      fontWeight: FontWeight.w700,
                      textColor: objCoverageDay.isSelected
                          ? ColorCodes.primary
                          : ColorCodes.lightBlack),
                ),
                Visibility(
                  child: objCoverageDay.isSelected
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
          ],
        ),
      ),
    );
  }
}
