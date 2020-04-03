import 'package:flutter/material.dart';
import 'custom_colors.dart';
import 'dart:io';
import 'package:latlong/latlong.dart';
import 'package:geocoder/geocoder.dart';

Color getStatusColor(status) {
  var retval = CustomColors.salmon;
  if (status == "closed") {
    retval = CustomColors.appBarColor;
  }
  return retval;
}

String getTimeString(timestr) {
  var retval = "XXXX/XX/XX, 12:00am";
  var tsdt = DateTime.parse(timestr);
  var timestr_local = tsdt.toLocal().toString();
  var timeAmPm = "12:00am";
  if (int.tryParse(timestr_local.substring(11,13)) >= 12)
  {
    var hours_pm = (int.tryParse(timestr_local.substring(11,13)) - 12).toString();
    if (hours_pm == "0") { hours_pm = "12"; }
    timeAmPm = hours_pm + ":" + timestr_local.substring(14,16) + "pm";
  }
  else
  {
    var hours_am = timestr_local.substring(11,13);
    if (hours_am == "00") { hours_am = "12"; }
    timeAmPm = hours_am + ":" + timestr_local.substring(14,16) + "am";
  }
  retval = timestr_local.substring(0,4) + "/" + timestr_local.substring(5,7) + "/" + timestr_local.substring(8,10) + ", " + timeAmPm;
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

  var ds1dt = DateTime.parse(datestr1);
  var ds2dt = DateTime.parse(datestr2);

  if (ds1dt.isBefore(ds2dt)) {
    retval = datestr2;
  }

  return retval;
}

int sleepThread(int input) {
  sleep(const Duration(seconds: 1));
  return input;
}

Future<LatLng> addressToLatLng(String address) async {
  LatLng retval = LatLng(0,0);
  try {
    var addresses = await Geocoder.local.findAddressesFromQuery(address);
    if (addresses.length > 0) {
      var first = addresses.first;
      assert(() {
        //Using assert here for debug only prints
        print("${first.addressLine} : ${first.coordinates}");
        return true;
      } ());
      retval = LatLng(first.coordinates.latitude, first.coordinates.longitude);
    }
  } catch (error, stacktrace) {
    assert(() {
      //Using assert here for debug only prints
      print("addressToLatLng Exception occured: $error stackTrace: $stacktrace");
      return true;
    }());
  }
  return retval;
}

Future<String> latLngToAddress(LatLng latLng) async {
  String retval = "";
  try {
    var addresses = await Geocoder.local.findAddressesFromCoordinates(new Coordinates(latLng.latitude, latLng.longitude));
    if (addresses.length > 0) {
      var first = addresses.first;
      assert(() {
        //Using assert here for debug only prints
        print("${first.addressLine} : ${first.coordinates}");
        return true;
      } ());
      retval = addresses.first?.addressLine ?? "";
    }
  } catch (error, stacktrace) {
    assert(() {
      //Using assert here for debug only prints
      print("latLngToAddress Exception occured: $error stackTrace: $stacktrace");
      return true;
    }());
  }
  return retval;
}
