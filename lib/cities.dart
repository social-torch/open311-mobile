class Cities {
  final String city_name;
  final String endpoint;


  Cities(this.city_name,
    this.endpoint);

  Cities.fromJson(Map<String, dynamic> json)
  : city_name = json["city_name"],
    endpoint= json["endpoint"];
}

class CitiesResponse {
  final List<Cities> cities;
  final String error;

  CitiesResponse(this.cities, this.error);

  CitiesResponse.fromJson(List<dynamic> json)
      : cities =
            json.map((i) => new Cities.fromJson(i)).toList(),
        error = "";

  CitiesResponse.withError(String errorValue)
      : cities = List(),
        error = errorValue;
}
