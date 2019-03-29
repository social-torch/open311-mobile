import 'package:flutter/material.dart';
import 'custom_colors.dart';

Color getStatusColor(status) {
  var retval = CustomColors.salmon;
  if (status == "closed") {
    retval = CustomColors.appBarColor;
  }
  return retval;
}

String getTimeString(timestr) {
  var retval = "XXXX/XX/XX, 12:00am";
  var timeAmPm = "12:00am";
  if (int.tryParse(timestr.substring(11,13)) > 12)
  {
    timeAmPm = (int.tryParse(timestr.substring(11,13)) - 12).toString() + ":" + timestr.substring(14,16) + "pm";
  }
  else
  {
    timeAmPm = timestr.substring(11,13) + ":" + timestr.substring(14,16) + "am";
  }
  retval = timestr.substring(0,4) + "/" + timestr.substring(5,7) + "/" + timestr.substring(8,10) + ", " + timeAmPm;
  return retval;
}

String getBasicAddress(inputstr) {
  var retval = inputstr;
  RegExp regExp = new RegExp(
  r"^.*?,",
  caseSensitive: false,
  multiLine: false,
  );
  String addr = regExp.firstMatch(inputstr).toString();
  if (addr != "null") {
    //retval = regExp.firstMatch(inputstr).group(0);
    retval = regExp.stringMatch(inputstr);
    retval = retval.substring(0,retval.length-1);
  }
  return retval;
}

String getLatestDateString(datestr1, datestr2) {
  //2019-03-03T18:50:43Z
  var retval = datestr1;
  if (int.tryParse(retval.substring(0,4)) < int.tryParse(datestr2.substring(0,4))) {
    retval = datestr2;
  }
  else if (int.tryParse(retval.substring(5,7)) < int.tryParse(datestr2.substring(5,7))) {
    retval = datestr2;
  }
  else if (int.tryParse(retval.substring(8,10)) < int.tryParse(datestr2.substring(8,10))) {
    retval = datestr2;
  }
  else if (int.tryParse(retval.substring(11,13)) < int.tryParse(datestr2.substring(11,13))) {
    retval = datestr2;
  }
  else if (int.tryParse(retval.substring(14,16)) < int.tryParse(datestr2.substring(14,16))) {
    retval = datestr2;
  }
  else if (int.tryParse(retval.substring(17,19)) < int.tryParse(datestr2.substring(17,19))) {
    retval = datestr2;
  }
  return retval;
}
