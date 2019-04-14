class S3endpoint {
  final String url;

  S3endpoint(
    this.url,
  );

  S3endpoint.fromJson(Map<String, dynamic> json)
  :  url = json["url"];

  Map<String, dynamic> toJson() =>
  {
    'url':url,
  };
  
}
