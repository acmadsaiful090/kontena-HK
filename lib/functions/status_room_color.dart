import 'package:flutter/material.dart';
import 'package:jc_housekeeping/utils/theme.helper.dart';

Color getColorForLabel(String label) {
  if (label == "OC") return theme.colorScheme.onError;
  if (label == "OD") return theme.colorScheme.onError;
  if (label == "VD") return theme.colorScheme.onSecondary;
  if (label == "VC") return theme.colorScheme.onSecondary;
  if (label == "VR") return theme.colorScheme.primary;
  return Colors.transparent;
}

String getStatus(paramStatus) {
  switch (paramStatus) {
    case "OD":
      return "OCCUPIED DIRTY";
    case "OC":
      return "OCCUPIED CLEANING";
    case "VD":
      return "VACANT DIRTY";
    case "VC":
      return "VACANT CLEANING";
    case "VR":
      return "VACANT READY";
    default:
      return paramStatus;
  }
}
