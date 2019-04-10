class S3endpoint {
  final String media_url;

  S3endpoint(
    this.media_url);

  S3endpoint.fromJson(Map<String, dynamic> json)
  :  media_url = json["media_url"];

  Map<String, dynamic> toJson() =>
  {
    'media_url':media_url,
  };
  
}

class S3endpointResponse {
  final List<S3endpoint> requests;
  final String error;

  S3endpointResponse(this.requests, this.error);

  S3endpointResponse.fromJson(List<dynamic> json)
      : requests =
            json.map((i) => new S3endpoint.fromJson(i)).toList(),
        error = "";

  S3endpointResponse.withError(String errorValue)
      : requests = List(),
        error = errorValue;
}
