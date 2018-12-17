import 'package:latlong/latlong.dart';

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
  String description;
  LatLng latlng;
  AddressData address;

  factory ReportData() {
    return _rds;
  }
  toString() {
    String retval = "\n";
    retval += "Type: ${type}\n";
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
