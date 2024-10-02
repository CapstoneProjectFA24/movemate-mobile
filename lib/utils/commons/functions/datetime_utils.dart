import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../constants/asset_constant.dart';

Future<String> dateTimePicker(BuildContext context) async {
  final DateTime? dateTime = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(1970),
    lastDate: DateTime(2500),
    builder: (BuildContext context, Widget? child) {
      return Theme(
        data: ThemeData.light().copyWith(
          colorScheme:
              const ColorScheme.light(primary: AssetsConstants.primaryLight),
        ),
        child: child!,
      );
    },
  );

  if (dateTime != null) {
    return DateFormat('dd/MM/yyyy').format(dateTime);
  }

  return '';
}

DateTime stringToDateTime(String time) {
  try {
    DateFormat format = DateFormat('dd-MM-yyyy');
    return format.parse(time);
  } catch (ex) {
    throw Exception('Exception when parsing from String to Datetime');
  }
}

String formatDateTime(String time) {
  try {
    DateTime dateTime = DateTime.parse(time);
    String formattedDate = DateFormat("HH:mm:ss dd/MM/yyyy").format(dateTime);
    return formattedDate;
  } catch (ex) {
    throw Exception('Exception when parsing from String to Datetime');
  }
}

String getDateTimeNow() {
  DateTime now = DateTime.now();
  DateFormat formatter = DateFormat('dd/MM/yyyy');
  return formatter.format(now);
}
