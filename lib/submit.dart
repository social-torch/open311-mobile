import 'package:flutter/material.dart';
import 'page.dart';
import 'data.dart';

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

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new ListView(
        children: [
          new Column(
            children: <Widget>[
              new Text(
                '${ReportData()}',
              ),
              new RaisedButton(
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
