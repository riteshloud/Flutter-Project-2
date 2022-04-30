import 'package:flutter/material.dart';

class CoverageDays {
  String day;
  bool isSelected;
  TimeOfDay startTime;
  String startTimeInString;
  TimeOfDay endTime;
  String endTimeInString;
  CoverageDays({
    required this.day,
    required this.isSelected,
    required this.startTime,
    required this.startTimeInString,
    required this.endTime,
    required this.endTimeInString,
  });
}
