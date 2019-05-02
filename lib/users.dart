class Users {
  final String account_id;
  final List<dynamic> submitted_request_ids;
  final List<dynamic> watched_request_ids;


  Users(this.account_id,
    this.submitted_request_ids,
    this.watched_request_ids);

  Users.fromJson(Map<String, dynamic> json)
  : account_id = json["account_id"],
    submitted_request_ids = json["submitted_request_ids"],
    watched_request_ids = json["watched_request_ids"];
}
