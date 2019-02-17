import 'package:latlong/latlong.dart';
import 'services.dart';
import 'requests.dart';

const String APP_NAME = "Social Torch";

class AddressData {
  String street;
  String city;
  String state;
  String zip;
}

//Singleton report data structure for easy passing between pages
class ReportData{
  static final ReportData _rds = new ReportData._internal();

  String type;
  String type_code;
  String description;
  LatLng latlng;
  AddressData address;
  String addr;

  factory ReportData() {
    return _rds;
  }
  toString() {
    String retval = "\n";
    retval += "Type: ${type}\n";
    retval += "TypeCode: ${type_code}\n";
    retval += "Description: ${description}\n";
    if ( latlng != null) {
      retval += "Location:\n";
      retval += "  Latitude: ${latlng?.latitude}\n";
      retval += "  Longitude: ${latlng?.longitude}\n";
    }
    if ( address != null) {
      retval += "Address:\n";
      retval += "  Street: ${address?.street}\n";
      retval += "  City: ${address?.city}\n";
      retval += "  State: ${address?.state}\n";
      retval += "  Zip: ${address?.zip}\n";
    }
    return retval;
  }
  ReportData._internal();
}

class CityData{

  static final CityData _rds = new CityData._internal();

  List<String> issues;
  ServicesResponse serv_resp;
  RequestsResponse req_resp;

  factory CityData() {
    return _rds;
  }
  toString() {
    String retval = "\n";
    retval += "issues: ${issues}\n";
    return retval;
  }
  CityData._internal();
}

class PreviousSubmittedData{

  static final PreviousSubmittedData _rds = new PreviousSubmittedData._internal();

  List<String> issues;

  factory PreviousSubmittedData() {
    return _rds;
  }
  toString() {
    String retval = "\n";
    retval += "issues: ${issues}\n";
    return retval;
  }
  PreviousSubmittedData._internal();
}

class DeviceData{

  static final DeviceData _rds = new DeviceData._internal();

  double ButtonHeight;
  double DeviceWidth;

  factory DeviceData() {
    return _rds;
  }
  toString() {
    String retval = "\n";
    retval += "ButtonHeight: ${ButtonHeight}\n";
    retval += "DeviceWidth: ${DeviceWidth}\n";
    return retval;
  }
  DeviceData._internal();
}
