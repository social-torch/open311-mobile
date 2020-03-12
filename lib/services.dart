class Services {
  final String service_code;
  final String service_name;
  final String description;
  final bool metadata;
  final String type;
  final List<dynamic> keywords;
  final String group;


  Services(this.service_code,
    this.service_name,
    this.description,
    this.metadata,
    this.type,
    this.keywords,
    this.group);

  Services.fromJson(Map<String, dynamic> json)
  : service_code = json["service_code"],
    service_name = json["service_name"],
    description = json["description"],
    metadata = json["metadata"],
    type = json["type"],
    keywords = json["keywords"],
    group = json["group"];
}

class ServicesResponse {
  final List<Services> services;
  final String error;

  ServicesResponse(this.services, this.error);

  // Takes a json of the services from the Dynamo query,
  // For each item in the List, turns that into a Services object,
  // Creates a list from the map of objects
  // Then sorts the list based on service_name
  ServicesResponse.fromJson(List<dynamic> json)
      : services =
            json.map((i) => new Services.fromJson(i)).toList(),
        error = ""
  {
    services.sort((a,b) => a.service_name.compareTo(b.service_name));
  }

  ServicesResponse.withError(String errorValue)
      : services = List(),
        error = errorValue;
}
