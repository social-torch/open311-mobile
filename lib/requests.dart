import 'dart:convert';

List<String> statusTypes = ["open", "accepted", "inProgress", "closed"];

class AuditEntry{
  final String change_note;
  final String account_id;
  final String timestamp;
  
  AuditEntry(
    this.change_note,
    this.account_id,
    this.timestamp
  );

  factory AuditEntry.fromJson(dynamic json) {
    return AuditEntry(
      json['change_note'] as String,
      json['account_id'] as String, 
      json['timestamp'] as String
    );
  }

  Map toJson()
  {
    return {
      'change_note':change_note,
      'account_id':account_id,
      'timestamp':timestamp
    };
  }
}

class Requests {
  final String service_request_id;
  String status;
  String status_notes;
  final String service_name;
  final String service_code;
  final String description;
  final String agency_responsible;
  final String service_notice;
  final String requested_datetime;
  final String update_datetime;
  final String expected_datetime;
  final String address;
  final String address_id;
  final int zipcode;
  final double lat;
  final double lon;
  String media_url;
  List<AuditEntry> audit_log;

  Requests(
    this.service_request_id,
    this.status,
    this.status_notes,
    this.service_name,
    this.service_code,
    this.description,
    this.agency_responsible,
    this.service_notice,
    this.requested_datetime,
    this.update_datetime,
    this.expected_datetime,
    this.address,
    this.address_id,
    this.zipcode,
    this.lat,
    this.lon,
    this.media_url,
    this.audit_log);

  factory Requests.fromJson(dynamic json) {
    print("1");
    if ( (json['audit_log'] != null) && (json['audit_log'] != "[]") ) {
      print("2");
      var objsJson = json['audit_log'] as List;
      print("3");
      List<AuditEntry> _ae = objsJson.map((aeJson) => AuditEntry.fromJson(aeJson)).toList();
      print("4");
      return Requests(
        json['service_request_id'] as String,
        json['status'] as String,
        json['status_notes'] as String,
        json['service_name'] as String,
        json['service_code'] as String,
        json['description'] as String,
        json['agency_responsible'] as String,
        json['service_notice'] as String,
        json['requested_datetime'] as String,
        json['update_datetime'] as String,
        json['expected_datetime'] as String,
        json['address'] as String,
        json['address_id'] as String,
        json['zipcode'] as int,
        json['lat'] as double,
        json['lon'] as double,
        json['media_url'] as String,
        _ae
      );
    } else {
      print("5");
      return Requests(
        json['service_request_id'] as String,
        json['status'] as String,
        json['status_notes'] as String,
        json['service_name'] as String,
        json['service_code'] as String,
        json['description'] as String,
        json['agency_responsible'] as String,
        json['service_notice'] as String,
        json['requested_datetime'] as String,
        json['update_datetime'] as String,
        json['expected_datetime'] as String,
        json['address'] as String,
        json['address_id'] as String,
        json['zipcode'] as int,
        json['lat'] as double,
        json['lon'] as double,
        json['media_url'] as String,
        List()
      );
    }
  }

  Map toJson() {
    List<Map> ae = this.audit_log != null ? this.audit_log.map((i) => i.toJson()).toList() : null;
    return {
      'service_request_id':service_request_id,
      'status':status,
      'status_notes':status_notes,
      'service_name':service_name,
      'service_code':service_code,
      'description':description,
      'agency_responsible':agency_responsible,
      'service_notice':service_notice,
      'requested_datetime':requested_datetime,
      'update_datetime':update_datetime,
      'expected_datetime':expected_datetime,
      'address':address,
      'address_id':address_id,
      'zipcode':zipcode,
      'lat':lat,
      'lon':lon,
      'media_url':media_url,
      'audit_log':ae,
    };
  }
}

class RequestsResponse {
  final List<Requests> requests;
  final String error;

  RequestsResponse(this.requests, this.error);

  RequestsResponse.fromJson(List<dynamic> json)
      : requests =
            json.map((i) => new Requests.fromJson(i)).toList(),
        error = "";

  RequestsResponse.withError(String errorValue)
      : requests = List(),
        error = errorValue;
}

class RequestsReturn {
  final String service_request_id;
  final String service_notice;
  final String account_id;

  RequestsReturn(
    this.service_request_id,
    this.service_notice,
    this.account_id);

  RequestsReturn.fromJson(Map<String, dynamic> json)
  : service_request_id = json["service_request_id"],
    service_notice = json["service_notice"],
    account_id = json["account_id"];
}
