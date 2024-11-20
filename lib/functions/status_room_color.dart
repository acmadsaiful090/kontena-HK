import 'package:flutter/material.dart';
import 'package:jc_housekeeping/app_state.dart';
import 'package:jc_housekeeping/utils/theme.helper.dart';

Color getColorForLabel(String status) {
  switch (status) {
    case 'OOO':
    case 'OOS':
      return theme.colorScheme.onPrimaryContainer;
    case 'OC':
    case 'OD':
      return theme.colorScheme.onError;
    case 'VD':
    case 'VC':
      return theme.colorScheme.onSecondary;
    case 'VR':
      return theme.colorScheme.primary;
    default:
      return Colors.transparent;
  }
  // if (label == "OC") return theme.colorScheme.onError;
  // if (label == "OD") return theme.colorScheme.onError;
  // if (label == "VD") return theme.colorScheme.onSecondary;
  // if (label == "VC") return theme.colorScheme.onSecondary;
  // if (label == "VR") return theme.colorScheme.primary;
  // if (label == "OOS") return theme.colorScheme.onPrimaryContainer;
  // if (label == "OOO") return theme.colorScheme.onPrimaryContainer;
  // return Colors.transparent;
}

String getStatus(paramStatus) {
  String status = '';
  if (AppState().roomStatus.isNotEmpty) {
    for (var stat in AppState().roomStatus) {
      if (stat['name'] == paramStatus) {
        status = stat['status_name'];
      }
    }
  }
  return status;
  // print('check , ${AppState().roomStatus}');
  // switch (paramStatus) {
  //   case "OD":
  //     return "OCCUPIED DIRTY";
  //   case "OC":
  //     return "OCCUPIED CLEANING";
  //   case "VD":
  //     return "VACANT DIRTY";
  //   case "VC":
  //     return "VACANT CLEANING";
  //   case "VR":
  //     return "VACANT READY";
  //   default:
  //     return paramStatus;
  // }
}
