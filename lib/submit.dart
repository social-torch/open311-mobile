import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'page.dart';
import 'data.dart';
import 'bottom_app_bar.dart';

class SubmitPage extends Page {
  SubmitPage() : super(const Icon(Icons.map), 'Submit Report');

  @override
  Widget build(BuildContext context) {
    return const SubmitBody();
  }
}

class SubmitBody extends StatefulWidget {
  const SubmitBody();

  @override
  State<StatefulWidget> createState() => SubmitBodyState();
}

class SubmitBodyState extends State<SubmitBody> {
  SubmitBodyState();

  void _apiGateway()
  {
    var url = "http://example.com/whatsit/create";
    http.post(url, body: {"name": "doodle", "color": "blue"})
    .then((response) {
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
    });

    http.read("http://example.com/foobar.txt").then(print);
  }
  
  @override
  Widget build(BuildContext context) {
    return new Scaffold (
      appBar: AppBar(title: Text(APP_NAME)),
      bottomNavigationBar: commonBottomBar(context),
      body: new ListView(
        children: [
          new Column(
            children: <Widget>[
              new Text(
                '${ReportData()}',
              ),
              new RaisedButton(
                onPressed: () {
                    _apiGateway();
                    Navigator.popUntil(context, ModalRoute.withName("/home"));
                },
                child: new Text( 
                "Submit", 
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
