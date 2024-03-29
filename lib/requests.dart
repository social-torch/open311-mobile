class Requests {
  final String service_request_id;
  final String status;
  final String status_notes;
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
  final String media_url;

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
    this.media_url);

  Requests.fromJson(Map<String, dynamic> json)
  : service_request_id = json["service_request_id"],
    status = json["status"],
    status_notes = json["status_notes"],
    service_name = json["service_name"],
    service_code = json["service_code"],
    description = json["description"],
    agency_responsible = json["agency_responsible"],
    service_notice = json["service_notice"],
    requested_datetime = json["requested_datetime"],
    update_datetime = json["update_datetime"],
    expected_datetime = json["expected_datetime"],
    address = json["address"],
    address_id = json["address_id"],
    zipcode = json["zipcode"],
    lat = json["lat"] + 0.0,
    lon = json["lon"] + 0.0,
    media_url = json["media_url"];

  Map<String, dynamic> toJson() =>
  {
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
    'lat':lat + 0.0,
    'lon':lon + 0.0,
    'media_url':media_url,
  };
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
