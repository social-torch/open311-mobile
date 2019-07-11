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

class RequestAddCity {
  final String city;
  final String state;
  final String first_name;
  final String last_name;
  final String email;
  final String feedback;

  RequestAddCity(this.city,
    this.state,
    this.first_name,
    this.last_name,
    this.email,
    this.feedback);

  RequestAddCity.fromJson(Map<String, dynamic> json)
  : city = json["city"],
    state = json["state"],
    first_name = json["first_name"],
    last_name = json["last_name"],
    email = json["email"],
    feedback = json["feedback"];

  Map<String, dynamic> toJson() =>
  {
    'city':city,
    'state':state,
    'first_name':first_name,
    'last_name':last_name,
    'email':email,
    'feedback':feedback,
  };
}

