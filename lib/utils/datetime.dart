import 'package:intl/intl.dart';

String? dateTimeFormat(
  String type,
  String? param,
) {
  DateTime now = DateTime.now();
  String result;
  // date for send API

  try {
    if (type == 'date') {
      if (param != null) {
        DateTime parse = DateTime.parse(param);
        result = DateFormat('yyyy-MM-dd').format(parse);
      } else {
        result = DateFormat('yyyy-MM-dd').format(now);
      }
      return result;
    }
    // date for UI
    else if (type == 'dateui') {
      if (param != null) {
        DateTime parse = DateTime.parse(param);
        result = DateFormat('dd-MM-yyyy').format(parse);
      } else {
        result = DateFormat('dd-MM-yyyy').format(now);
      }
    } else if (type == 'time') {
      if (param != null) {
        DateTime parse = DateTime.parse(param);
        result = DateFormat('HH:mm:ss').format(parse);
      } else {
        result = DateFormat('HH:mm:ss').format(now);
      }
      return result;
    } else if (type == 'datetime') {
      if (param != null) {
        DateTime parse = DateTime.parse(param);
        result = DateFormat('dd-MM-yyyy [HH:mm]').format(parse);
      } else {
        result = DateFormat('dd-MM-yyyy [HH:mm]').format(now);
      }
      return result;
    } else if ((type == 'dateFirstMonth') || (type == 'dateFirstMonthui')) {
      String frm = '';
      if (type == 'dateFirstMonthui') {
        frm = 'dd-MM-yyyy';
      } else {
        frm = 'yyyy-MM-dd';
      }
      if (param != null) {
        DateTime parse = DateTime.parse(param);
        DateTime date = DateTime(parse.year, parse.month, 1);
        result = DateFormat(frm).format(date);
      } else {
        DateTime date = DateTime(now.year, now.month, 1);
        result = DateFormat(frm).format(date);
      }
      return result;
    } else if (type == 'dateLastMonth') {
      String frm = '';
      if (type == 'dateLastMonthui') {
        frm = 'dd-MM-yyyy';
      } else {
        frm = 'yyyy-MM-dd';
      }
      if (param != null) {
        DateTime parse = DateTime.parse(param);
        DateTime date = DateTime(parse.year, parse.month + 1, 0);
        result = DateFormat(frm).format(date);
      } else {
        DateTime date = DateTime(now.year, now.month + 1, 0);
        result = DateFormat(frm).format(date);
      }
      return result;
    } else if ((type == 'dateFirstDay') || (type == 'dateFirstDayui')) {
      String frm = '';

      if (type == 'dateFirstDayui') {
        frm = 'dd-MM-yyyy HH:mm:ss';
      } else {
        frm = 'yyyy-MM-dd HH:mm:ss';
      }

      if (param != null) {
        DateTime parse = DateTime.parse(param);
        DateTime date =
            DateTime(parse.year, parse.month, parse.day, 00, 00, 00);
        result = DateFormat(frm).format(date);
      } else {
        DateTime date = DateTime(now.year, now.month, now.day, 00, 00, 00);
        result = DateFormat(frm).format(date);
      }
    } else if ((type == 'dateEndDay') || (type == 'dateEndDayui')) {
      String frm = '';

      if (type == 'dateEndDayui') {
        frm = 'dd-MM-yyyy HH:mm:ss';
      } else {
        frm = 'yyyy-MM-dd HH:mm:ss';
      }

      if (param != null) {
        DateTime parse = DateTime.parse(param);
        DateTime date =
            DateTime(parse.year, parse.month, parse.day, 23, 59, 59);
        result = DateFormat(frm).format(date);
      } else {
        DateTime date = DateTime(now.year, now.month, now.day, 23, 59, 59);
        result = DateFormat(frm).format(date);
      }
    } else if (type == 'dateMonthComplete') {
      if (param != null) {
        DateTime parse = DateTime.parse(param);
        result = DateFormat('dd MMMM yyyy').format(parse);
      } else {
        result = DateFormat('dd MMMM yyyy').format(now);
      }
      return result;
    }

    // Day
    else if (type == 'd') {
      if (param != null) {
        DateTime parse = DateTime.parse(param);
        result = DateFormat('d').format(parse);
      } else {
        result = DateFormat('d').format(now);
      }
    } else if (type == 'dd') {
      if (param != null) {
        DateTime parse = DateTime.parse(param);
        result = DateFormat('dd').format(parse);
      } else {
        result = DateFormat('dd').format(now);
      }
    }
    // End Day
    // Month
    else if (type == 'M') {
      if (param != null) {
        DateTime parse = DateTime.parse(param);
        result = DateFormat('M').format(parse);
      } else {
        result = DateFormat('M').format(now);
      }
    } else if (type == 'MM') {
      if (param != null) {
        DateTime parse = DateTime.parse(param);
        result = DateFormat('MM').format(parse);
      } else {
        result = DateFormat('MM').format(now);
      }
    }
    // End Month
    // Years
    else if (type == 'yy') {
      if (param != null) {
        DateTime parse = DateTime.parse(param);
        result = DateFormat('yy').format(parse);
      } else {
        result = DateFormat('yy').format(now);
      }
    } else if (type == 'yyyy') {
      if (param != null) {
        DateTime parse = DateTime.parse(param);
        result = DateFormat('yyyy').format(parse);
      } else {
        result = DateFormat('yyyy').format(now);
      }
    }
    // End Years
    else {
      result = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    }
  } catch (e) {
    result = 'format parse date error';
  }
  return result;
}

String timeFormat(String type, String? time) {
  DateTime now = DateTime.now();
  // DateTime parsed = time == 'now' ? now : DateFormat('H:m:s').parse(time!);
  String result = '';

  switch (type) {
    case 'time_simple':
      if (time != null) {
        DateTime parse = DateFormat('H:m:s').parse(time);
        result = DateFormat('HH:mm').format(parse);
      } else {
        result = DateFormat('HH:mm').format(now);
      }
      break;

    case 'time_full':
      if (time != null) {
        DateTime parse = DateFormat('H:m:s').parse(time);
        result = DateFormat('HH:mm:ss').format(parse);
      } else {
        result = DateFormat('HH:mm:ss').format(now);
      }
      break;
    default:
  }
  return result;
}
